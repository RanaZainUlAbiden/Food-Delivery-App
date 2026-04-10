import 'package:dio/dio.dart';

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android emulator
  static const String baseUrl = 'http://localhost:3000/api'; // Windows run

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // ── Categories ──
  static Future<List<dynamic>> getCategories() async {
    final response = await _dio.get('/categories');
    return response.data['data'];
  }

  // ── Menu Items ──
  static Future<List<dynamic>> getMenuItems({String? category}) async {
    final response = await _dio.get(
      '/menu',
      queryParameters: category != null ? {'category': category} : null,
    );
    return response.data['data'];
  }

  // ── Orders ──
  static Future<dynamic> createOrder(Map<String, dynamic> orderData) async {
    final response = await _dio.post('/orders', data: orderData);
    return response.data['data'];
  }

  static Future<List<dynamic>> getOrdersByPhone(String phone) async {
    final response = await _dio.get('/orders/phone/$phone');
    return response.data['data'];
  }
}