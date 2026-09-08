// import 'package:flutter/material.dart';
// import 'package:food_order_app/models/deliverymodel.dart';
// import 'package:food_order_app/services/appconfic.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:dio/dio.dart';

// class AuthService {
//   final Dio dio;
//   final FlutterSecureStorage storage;

//   AuthService({required this.dio, required this.storage});

//   Future<bool> login({
//     required String userName,
//     required String password,
//   }) async {
//     try {
//       final response = await dio.post(
//         '${AppConfig.apiUrl}auth/token',
//         data: {'userName': userName, 'password': password},
//       );

//       if (response.statusCode == 200) {
//         final accessToken = response.data['accessToken'];

//         await storage.write(key: 'AccessToken', value: accessToken);

//         return true;
//       }

//       return false;
//     } on DioException catch (e) {
//       debugPrint("STATUS CODE: ${e.response?.statusCode}");
//       debugPrint("ERROR RESPONSE: ${e.response?.data}");
//       debugPrint("ERROR MESSAGE: ${e.message}");
//       debugPrint("REQUEST URL: ${e.requestOptions.uri}");
//       debugPrint("REQUEST DATA: ${e.requestOptions.data}");

//       if (e.response?.statusCode == 401) {
//         throw Exception('Invalid credentials');
//       }

//       throw Exception(
//         e.response?.data?.toString() ?? e.message ?? 'Login request failed',
//       );
//     }
//   }

//   // Future<bool> isLoggedIn() async {
//   //   final token = await storage.read(key: 'AccessToken');

//   //   return token != null && token.isNotEmpty;
//   // }

//   Future<void> logout() async {
//     try {
//       await storage.delete(key: 'AccessToken');
//       await storage.delete(key: 'PrinterName');

//       debugPrint('Logout successful');
//     } catch (e) {
//       debugPrint('Logout error: $e');
//       throw Exception('Logout failed');
//     }
//   }

//   Future<List<DeliveredOrderModel>> getAcceptedOrders() async {
//     try {
//       final token = await storage.read(key: 'AccessToken');

//       debugPrint('ACCESS TOKEN: $token');

//       if (token == null || token.isEmpty) {
//         throw Exception('Token not found');
//       }

//       final response = await dio.get(
//         '${AppConfig.apiUrl}orders/accept',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       debugPrint('ACCEPT ORDER STATUS: ${response.statusCode}');

//       debugPrint('ACCEPT ORDER DATA: ${response.data}');

//       if (response.statusCode == 200) {
//         if (response.data is List) {
//           return response.data;
//         }

//         return [];
//       }

//       return [];
//     } on DioException catch (e) {
//       debugPrint('ACCEPT ORDER ERROR STATUS: ${e.response?.statusCode}');

//       debugPrint('ACCEPT ORDER ERROR DATA: ${e.response?.data}');

//       if (e.response?.statusCode == 401) {
//         throw Exception('Unauthorized');
//       }

//       throw Exception(
//         e.response?.data?.toString() ?? e.message ?? 'Something went wrong',
//       );
//     }
//   }

//   Future<List<DeliveredOrderModel>> getRejectedOrders() async {
//     try {
//       final token = await storage.read(key: 'AccessToken');

//       if (token!.isEmpty) {
//         throw Exception('Token not found');
//       }

//       final response = await dio.get(
//         '${AppConfig.apiUrl}orders/reject',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       debugPrint('REJECT ORDER STATUS: ${response.statusCode}');

//       debugPrint('REJECT ORDER DATA: ${response.data}');

//       if (response.statusCode == 200) {
//         if (response.data is List) {
//           return response.data;
//         }

//         return [];
//       }

//       return [];
//     } on DioException catch (e) {
//       debugPrint('REJECT ORDER ERROR STATUS: ${e.response?.statusCode}');

//       debugPrint('REJECT ORDER ERROR DATA: ${e.response?.data}');

//       if (e.response?.statusCode == 401) {
//         throw Exception('Unauthorized');
//       }

//       throw Exception(
//         e.response?.data?.toString() ?? e.message ?? 'Something went wrong',
//       );
//     }
//   }
//   //Future<List<dynamic>> getDeliveredOrders() async {
//   //   try {
//   //    final token = await storage.read(
//   //         key: 'AccessToken',
//   //       );

//   //     if (token!.isEmpty) {
//   //       throw Exception('Token not found');
//   //     }

//   //     final response = await dio.get(
//   //       '${AppConfig.apiUrl}orders/deliver',
//   //       options: Options(
//   //         headers: {
//   //           'Authorization': 'Bearer $token',
//   //           'Content-Type': 'application/json',
//   //         },
//   //       ),
//   //     );

//   //     debugPrint(
//   //       'DELIVER ORDER STATUS: ${response.statusCode}',
//   //     );

//   //     debugPrint(
//   //       'DELIVER ORDER DATA: ${response.data}',
//   //     );

//   //     if (response.statusCode == 200) {
//   //       if (response.data is List) {
//   //         return response.data;
//   //       }

//   //       return [];
//   //     }

//   //     return [];
//   //   } on DioException catch (e) {
//   //     debugPrint(
//   //       'DELIVER ORDER ERROR STATUS: ${e.response?.statusCode}',
//   //     );

//   //     debugPrint(
//   //       'DELIVER ORDER ERROR DATA: ${e.response?.data}',
//   //     );

//   //     if (e.response?.statusCode == 401) {
//   //       throw Exception('Unauthorized');
//   //     }

//   //     throw Exception(
//   //       e.response?.data?.toString() ??
//   //           e.message ??
//   //           'Something went wrong',
//   //     );
//   //   }
//   // }
//   Future<Map<String, dynamic>?> getOrderInfo(String guid) async {
//     try {
//       final token = await storage.read(key: 'AccessToken');

//       if (token == null || token.isEmpty) {
//         throw Exception('Access token not found');
//       }

//       final response = await dio.get(
//         '${AppConfig.apiUrl}orders/$guid',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       debugPrint('ORDER INFO STATUS: ${response.statusCode}');

//       debugPrint('ORDER INFO DATA: ${response.data}');

//       if (response.statusCode == 200 && response.data != null) {
//         return Map<String, dynamic>.from(response.data);
//       }

//       return null;
//     } on DioException catch (e) {
//       debugPrint('ORDER INFO ERROR STATUS: ${e.response?.statusCode}');

//       debugPrint('ORDER INFO ERROR DATA: ${e.response?.data}');

//       if (e.response?.statusCode == 401) {
//         throw Exception('Unauthorized');
//       }

//       throw Exception(
//         e.response?.data?.toString() ?? e.message ?? 'Something went wrong',
//       );
//     }
//   }

//   Future<List<DeliveredOrderModel>> getDeliveredOrders() async {
//     try {
//       final token = await storage.read(key: 'AccessToken');

//       if (token == null || token.isEmpty) {
//         throw Exception('Access token not found');
//       }

//       final response = await dio.get(
//         '${AppConfig.apiUrl}orders/deliver',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       debugPrint('DELIVER ORDER STATUS: ${response.statusCode}');

//       debugPrint('DELIVER ORDER DATA: ${response.data}');

//       if (response.statusCode == 200 && response.data is List) {
//         return (response.data as List)
//             .map(
//               (e) => DeliveredOrderModel.fromJson(Map<String, dynamic>.from(e)),
//             )
//             .toList();
//       }

//       return [];
//     } on DioException catch (e) {
//       debugPrint('DELIVER ORDER ERROR STATUS: ${e.response?.statusCode}');

//       debugPrint('DELIVER ORDER ERROR DATA: ${e.response?.data}');

//       if (e.response?.statusCode == 401) {
//         throw Exception('Unauthorized');
//       }

//       throw Exception(
//         e.response?.data?.toString() ?? e.message ?? 'Something went wrong',
//       );
//     }
//   }

//   Future<bool> updateSwipeOrderStatus({
//     required String guid,
//     required String orderStatus,
//   }) async {
//     try {
//       final token = await storage.read(key: 'AccessToken');

//       if (token == null || token.isEmpty) {
//         throw Exception('Access token not found');
//       }

//       final response = await dio.post(
//         '${AppConfig.apiUrl}orders',
//         data: {'RowGuid': guid, 'OrderStatus': orderStatus},
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       debugPrint('UPDATE ORDER STATUS CODE: ${response.statusCode}');

//       debugPrint('UPDATE ORDER RESPONSE: ${response.data}');

//       if (response.statusCode == 202) {
//         return true;
//       }

//       return false;
//     } on DioException catch (e) {
//       debugPrint('UPDATE ORDER ERROR STATUS: ${e.response?.statusCode}');

//       debugPrint('UPDATE ORDER ERROR DATA: ${e.response?.data}');

//       if (e.response?.statusCode == 401) {
//         throw Exception('Unauthorized');
//       }

//       throw Exception(
//         e.response?.data?.toString() ?? e.message ?? 'Something went wrong',
//       );
//     }
//   }

//   Future<bool> updateOrderStatus({
//     required String guid,
//     required String orderStatus,
//   }) async {
//     try {
//       final token = await storage.read(key: 'AccessToken');

//       if (token == null || token.isEmpty) {
//         throw Exception('Access token not found');
//       }

//       final response = await dio.post(
//         '${AppConfig.apiUrl}orders',
//         data: {'RowGuid': guid, 'OrderStatus': orderStatus},
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       debugPrint('UPDATE ORDER STATUS CODE: ${response.statusCode}');

//       debugPrint('UPDATE ORDER RESPONSE: ${response.data}');

//       return response.statusCode == 202;
//     } on DioException catch (e) {
//       debugPrint('UPDATE ORDER ERROR STATUS: ${e.response?.statusCode}');

//       debugPrint('UPDATE ORDER ERROR DATA: ${e.response?.data}');

//       if (e.response?.statusCode == 401) {
//         throw Exception('Unauthorized');
//       }

//       throw Exception(
//         e.response?.data?.toString() ?? e.message ?? 'Something went wrong',
//       );
//     }
//   }

//   Future<Map<String, dynamic>?> getAcceptOrderInfo({
//     required String guid,
//   }) async {
//     try {
//       final token = await storage.read(key: 'AccessToken');

//       if (token == null || token.isEmpty) {
//         throw Exception('Access token not found');
//       }

//       final response = await dio.get(
//         '${AppConfig.apiUrl}orders/$guid',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       debugPrint('ACCEPT ORDER INFO STATUS: ${response.statusCode}');

//       debugPrint('ACCEPT ORDER INFO DATA: ${response.data}');

//       if (response.statusCode == 200 && response.data != null) {
//         return Map<String, dynamic>.from(response.data);
//       }

//       return null;
//     } on DioException catch (e) {
//       debugPrint('ACCEPT ORDER INFO ERROR STATUS: ${e.response?.statusCode}');

//       debugPrint('ACCEPT ORDER INFO ERROR DATA: ${e.response?.data}');

//       if (e.response?.statusCode == 401) {
//         throw Exception('Unauthorized');
//       }

//       throw Exception(
//         e.response?.data?.toString() ?? e.message ?? 'Something went wrong',
//       );
//     }
//   }
// }
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

  // =========================================================
  // DELIVERED ORDERS
  // GET orders/deliver
  // =========================================================

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

  // =========================================================
  // ORDER DETAILS
  // GET orders/{guid}
  // =========================================================

  Future<DeliveredOrderModel?> getOrderInfo(String guid) async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}orders/$guid',
        options: await _authOptions(),
      );

      debugPrint('ORDER INFO STATUS: ${response.statusCode}');
      debugPrint('ORDER INFO DATA: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        return DeliveredOrderModel.fromJson(response.data);
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

  Future<List<DeliveredOrderModel>> getOrderReport(String date) async {
    try {
      final response = await dio.get(
        '${AppConfig.apiUrl}orders/report',
        queryParameters: {'sDate': date},
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
