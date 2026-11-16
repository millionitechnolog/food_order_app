import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_order_app/models/deliverymodel.dart';
import 'package:food_order_app/models/generalsetting.dart';
import 'package:food_order_app/models/menuitenmodel.dart';
import 'package:food_order_app/services/appconfic.dart';

class AuthService {
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthService({required this.dio, required this.storage});

  // =========================================================
  // TOKEN
  // =========================================================

  Future<String> _getToken() async {
    final token = await storage.read(key: 'AccessToken');

    if (token == null || token.isEmpty) {
      throw Exception('Access token not found');
    }

    return token;
  }

  Future<Options> _authOptions() async {
    final token = await _getToken();

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  // =========================================================
  // LOGIN
  // POST auth/token
  // =========================================================

  Future<bool> login({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}auth/token',
        data: {'userName': userName, 'password': password},
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken']?.toString();
        print("accesstoken $accessToken");
        if (accessToken == null || accessToken.isEmpty) {
          throw Exception('Access token not found in response');
        }

        await storage.write(key: 'AccessToken', value: accessToken);

        return true;
      }

      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid credentials');
      }

      throw Exception(
        e.response?.data?.toString() ?? e.message ?? 'Login failed',
      );
    }
  }

  // =========================================================
  // ACCEPTED ORDERS
  // GET orders/accept
  // =========================================================

  Future<List<DeliveredOrderModel>> getAcceptedOrders() async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}orders/accept',
        options: await _authOptions(),
      );
      final token = await storage.read(key: 'AccessToken');

      print('===== STORED TOKEN =====');
      print(token);
      print('========================');
      debugPrint('ACCEPT STATUS: ${response.statusCode}');
      debugPrint('ACCEPT DATA: ${response.data}');

      if (response.statusCode == 200 && response.data is List) {
        return List<DeliveredOrderModel>.from(
          response.data.map((e) => DeliveredOrderModel.fromJson(e)),
        );
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // REJECTED ORDERS
  // GET orders/reject
  // =========================================================

  Future<List<DeliveredOrderModel>> getRejectedOrders() async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}orders/reject',
        options: await _authOptions(),
      );

      if (response.statusCode == 200 && response.data is List) {
        return List<DeliveredOrderModel>.from(
          response.data.map((e) => DeliveredOrderModel.fromJson(e)),
        );
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<List<DeliveredOrderModel>> getDeliveredOrders() async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}orders/deliver',
        options: await _authOptions(),
      );

      if (response.statusCode == 200 && response.data is List) {
        return List<DeliveredOrderModel>.from(
          response.data.map((e) => DeliveredOrderModel.fromJson(e)),
        );
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<List<DeliveredOrderModel>> getNewOrders() async {
    print('🔥🔥🔥 GET NEW ORDERS FUNCTION CALLED 🔥🔥🔥');

    try {
      final url = '${AppConfig.apiUrl}orders/new';

      print('NEW ORDER URL = $url');

      final response = await dio.get(url, options: await _authOptions());

      print('NEW ORDER STATUS = ${response.statusCode}');
      print('NEW ORDER RESPONSE = ${response.data}');

      if (response.statusCode == 200 && response.data is List) {
        final orders = (response.data as List)
            .map(
              (e) => DeliveredOrderModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();

        print('NEW ORDER COUNT = ${orders.length}');

        return orders;
      }

      return [];
    } on DioException catch (e) {
      print('❌ NEW ORDER DIO ERROR');
      print('STATUS = ${e.response?.statusCode}');
      print('DATA = ${e.response?.data}');
      print('MESSAGE = ${e.message}');
      print('URL = ${e.requestOptions.uri}');

      rethrow;
    } catch (e) {
      print('❌ NEW ORDER OTHER ERROR = $e');
      rethrow;
    }
  }
  // Future<List<DeliveredOrderModel>> getNewOrders() async {
  //   try {
  //     final response = await dio.get(
  //       '${AppConfig.apiUrl}orders/order',
  //       options: await _authOptions(),
  //     );

  //     if (response.statusCode == 200 && response.data is List) {
  //       return List<DeliveredOrderModel>.from(
  //         response.data.map((e) => DeliveredOrderModel.fromJson(e)),
  //       );
  //     }

  //     return [];
  //   } on DioException catch (e) {
  //     _handleDioError(e);
  //   }
  // }
  // =========================================================
  // ORDER DETAILS
  // GET orders/{guid}
  // =========================================================

  Future<OrderInfoModel?> getOrderInfo(String guid) async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}orders/$guid',
        options: await _authOptions(),
      );

      debugPrint('ORDER INFO STATUS: ${response.statusCode}');
      debugPrint('ORDER INFO DATA: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        return OrderInfoModel.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // UPDATE ORDER STATUS
  // POST orders
  // =========================================================

  Future<bool> updateOrderStatus({
    required String guid,
    required String orderStatus,
  }) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}orders',
        data: {'RowGuid': guid, 'OrderStatus': orderStatus},
        options: await _authOptions(),
      );

      debugPrint('UPDATE STATUS: ${response.statusCode}');

      return response.statusCode == 202;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // ORDER REPORT
  // GET orders/report?sDate=
  // =========================================================

  Future<List<OrderDetailModel>> getOrderReport(String date) async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}orders/report',
        queryParameters: {'sDate': date},
        options: await _authOptions(),
      );

      if (response.statusCode == 200 && response.data is List) {
        return List<OrderDetailModel>.from(
          response.data.map((e) => OrderDetailModel.fromJson(e)),
        );
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // GENERAL SETTINGS
  // GET settings/general
  // =========================================================

  Future<List<GeneralSettingsModel>> getGeneralSettings() async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}settings/general',
        options: await _authOptions(),
      );

      if (response.statusCode == 200 && response.data is List) {
        print('GENERAL SETTINGS DATA: ${response.data}');
        return List<GeneralSettingsModel>.from(
          response.data.map((e) => GeneralSettingsModel.fromJson(e)),
        );
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // UPDATE GENERAL SETTINGS
  // POST settings/general/update
  // =========================================================

  Future<bool> updateGeneralSettings(List<dynamic> settings) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}settings/general/update',
        data: settings,
        options: await _authOptions(),
      );

      return response.statusCode == 202;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // BUSINESS HOURS
  // GET settings/business-hour
  // =========================================================

  Future<List<dynamic>> getBusinessHours() async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}settings/business-hour',
        options: await _authOptions(),
      );

      if (response.statusCode == 200 && response.data is List) {
        return List<dynamic>.from(response.data);
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // CREATE / UPDATE BUSINESS HOUR
  // POST settings/business-hour/process
  // =========================================================

  Future<bool> processBusinessHour(dynamic data) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}settings/business-hour/process',
        data: data,
        options: await _authOptions(),
      );

      return response.statusCode == 202;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // DELETE BUSINESS HOUR
  // =========================================================

  Future<bool> removeBusinessHour(String groupGuid) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}settings/business-hour/remove',
        queryParameters: {'GroupGuid': groupGuid},
        data: {},
        options: await _authOptions(),
      );

      return response.statusCode == 202;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // MENU TIMING LIST
  // =========================================================

  Future<List<dynamic>> getMenuTimingList() async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}menu-timing/list',
        options: await _authOptions(),
      );

      if (response.statusCode == 200 && response.data is List) {
        return List<dynamic>.from(response.data);
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // CREATE MENU TIMING
  // =========================================================

  Future<int?> saveMenuTiming(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}menu-timing/insert',
        data: data,
        options: await _authOptions(),
      );

      return response.statusCode;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // UPDATE MENU TIMING
  // =========================================================

  Future<int?> updateMenuTiming(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}menu-timing/update',
        data: data,
        options: await _authOptions(),
      );

      return response.statusCode;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // DELETE MENU TIMING
  // =========================================================

  Future<bool> removeMenuTiming(int id) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}menu-timing/remove',
        queryParameters: {'id': id},
        data: {},
        options: await _authOptions(),
      );

      return response.statusCode == 202;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // MENU ITEM STATUS LIST
  // =========================================================

  Future<List<MenuItemStatusModel>> getMenuItemStatusList() async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}menu-item/status-list',
        options: await _authOptions(),
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => MenuItemStatusModel.fromJson(e))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // UPDATE MENU ITEM STATUS
  // =========================================================

  Future<bool> updateMenuItemStatus(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        '${AppConfig.apiUrl}menu-item/status-update',
        data: data,
        options: await _authOptions(),
      );

      return response.statusCode == 202;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    await storage.delete(key: 'AccessToken');
  }

  // =========================================================
  // COMMON ERROR
  // =========================================================

  Never _handleDioError(DioException e) {
    debugPrint('STATUS: ${e.response?.statusCode}');

    debugPrint('ERROR: ${e.response?.data}');

    if (e.response?.statusCode == 401) {
      throw Exception('Unauthorized');
    }

    throw Exception(
      e.response?.data?.toString() ?? e.message ?? 'Something went wrong',
    );
  }
}
