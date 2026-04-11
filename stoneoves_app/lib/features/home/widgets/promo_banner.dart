import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final PageController _controller = PageController();
  int _current = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'image': 'assets/images/mighty_meat_pizza.jpg',
      'title': '50% OFF',
      'subtitle': 'On all Pizzas today!',
      'tag': 'LIMITED TIME',
    },
    {
      'image': 'assets/images/stone_burger.jpg',
      'title': 'Stone Burger',
      'subtitle': 'Juicy & Fresh — Rs. 599 only!',
      'tag': 'NEW',
    },
    {
      'image': 'assets/images/family_deal.jpg',
      'title': 'Family Deal',
      'subtitle': '2 Pizzas + 4 Drinks',
      'tag': 'BEST VALUE',
    },
    {
      'image': 'assets/images/zinger_burger.jpg',
      'title': 'Zinger Burger',
      'subtitle': 'Crispy & Spicy — Order Now!',
      'tag': 'HOT 🔥',
    },
    {
      'image': 'assets/images/bbq_chicken_pizza.jpg',
      'title': 'Free Delivery',
      'subtitle': 'On orders above Rs. 1000',
      'tag': 'TODAY ONLY',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto slide every 3 seconds
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    if (!mounted) return;
    final next = (_current + 1) % _banners.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary,
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    // ── Background Image ──
                    Positioned.fill(
                      child: Image.asset(
                        banner['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          color: AppColors.secondary,
                          child: const Icon(
                            Icons.fastfood,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),

                    // ── Dark Gradient ──
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.75),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Text ──
                    Positioned(
                      left: 16,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              banner['tag'],
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['title'],
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            banner['subtitle'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // ── Dot Indicators ──
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _current == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _current == i
                    ? AppColors.primary
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}