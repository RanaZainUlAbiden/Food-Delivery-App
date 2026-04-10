import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HeroVideoPlayer extends StatefulWidget {
  const HeroVideoPlayer({super.key});

  @override
  State<HeroVideoPlayer> createState() => _HeroVideoPlayerState();
}

class _HeroVideoPlayerState extends State<HeroVideoPlayer> {
  final List<String> _assetVideos = [
    'assets/images/video1.mp4',
    'assets/images/video2.mp4',
    'assets/images/video3.mp4',
    'assets/images/video4.mp4',
    'assets/images/video5.mp4',
  ];

  final List<Map<String, String>> _overlays = [
    {'title': '50% OFF', 'subtitle': 'On all Pizzas today!', 'tag': 'LIMITED TIME'},
    {'title': 'Fresh & Hot', 'subtitle': 'Made with love in Lahore', 'tag': 'QUALITY'},
    {'title': 'Free Delivery', 'subtitle': 'On orders above Rs. 1000', 'tag': 'TODAY ONLY'},
    {'title': 'Family Deal', 'subtitle': '2 Pizzas + 4 Drinks', 'tag': 'BEST VALUE'},
    {'title': 'Order Now', 'subtitle': 'Fast delivery at your door', 'tag': 'HOT 🔥'},
  ];

  int _currentIndex = 0;
  late Player _player;
  late VideoController _controller;
  List<String> _tempPaths = [];
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    _player.setVolume(0);

    _player.stream.completed.listen((completed) {
      if (completed && mounted) _playNext();
    });

    _player.stream.error.listen((e) {
      debugPrint('Video error: $e');
    });

    _extractAndPlay();
  }

  // Asset videos ko temp folder mein copy karo
  Future<void> _extractAndPlay() async {
    try {
      final dir = await getTemporaryDirectory();
      final paths = <String>[];

      for (int i = 0; i < _assetVideos.length; i++) {
        final asset = _assetVideos[i];
        final fileName = 'stoneoves_video_$i.mp4';
        final file = File('${dir.path}/$fileName');

        if (!await file.exists()) {
          final data = await rootBundle.load(asset);
          await file.writeAsBytes(data.buffer.asUint8List());
        }
        paths.add(file.path);
      }

      _tempPaths = paths;

      if (mounted) {
        setState(() => _ready = true);
        await _playVideo(0);
      }
    } catch (e) {
      debugPrint('Video extract error: $e');
    }
  }

  Future<void> _playVideo(int index) async {
    if (_tempPaths.isEmpty || index >= _tempPaths.length) return;
    try {
      await _player.open(
        Media(_tempPaths[index]),
        play: true,
      );
    } catch (e) {
      debugPrint('Play error: $e');
    }
  }

  void _playNext() {
    final next = (_currentIndex + 1) % _assetVideos.length;
    setState(() => _currentIndex = next);
    _playVideo(next);
  }

  void _playPrev() {
    final prev = (_currentIndex - 1 + _assetVideos.length) % _assetVideos.length;
    setState(() => _currentIndex = prev);
    _playVideo(prev);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // ── Video ──
          Positioned.fill(
            child: _ready
                ? Video(
                    controller: _controller,
                    controls: NoVideoControls,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
          ),

          // ── Dark Gradient ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // ── Text Overlay ──
          Positioned(
            bottom: 40,
            left: 16,
            right: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _overlays[_currentIndex]['tag']!,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _overlays[_currentIndex]['title']!,
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
                Text(
                  _overlays[_currentIndex]['subtitle']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // ── Prev ──
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: GestureDetector(
              onTap: _playPrev,
              child: Container(width: 60, color: Colors.transparent),
            ),
          ),

          // ── Next ──
          Positioned(
            right: 0, top: 0, bottom: 0,
            child: GestureDetector(
              onTap: _playNext,
              child: Container(width: 60, color: Colors.transparent),
            ),
          ),

          // ── Dots ──
          Positioned(
            bottom: 12, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _assetVideos.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentIndex == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == i
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}