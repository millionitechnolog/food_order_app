import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_order_app/bloc/orderstate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:food_order_app/bloc/orderevent.dart";

import 'package:food_order_app/services/services.dart';

class Orderbloc extends Bloc<Orderevent, OrderState> {
  Orderbloc() : super(OrderState()) {
    final AuthService authService = AuthService(
      dio: Dio(),
      storage: FlutterSecureStorage(),
    );
    on<GetNewOrdersEvent>((event, emit) async {
      emit(state.copyWith(status: OrderStatus.loading, errorMessage: ''));

      try {
        final result = await authService.getNewOrders();

        emit(state.copyWith(status: OrderStatus.success, newOrderList: result));
      } catch (e) {
        emit(
          state.copyWith(
            status: OrderStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
      emit(state.copyWith(status: OrderStatus.initial, errorMessage: ''));
    });
    on<GetDeliveredOrdersEvent>((event, emit) async {
      emit(state.copyWith(deliveryOrderStatus: OrderStatus.loading));
      try {
        final orders = await authService.getDeliveredOrders();

        emit(
          state.copyWith(
            deliveryOrderStatus: OrderStatus.success,
            deliveryorderList: orders,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            deliveryOrderStatus: OrderStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
      emit(state.copyWith(deliveryOrderStatus: OrderStatus.initial));
    });
    // on<GetAcceptedOrdersEvent>((event, emit) async {
    //   emit(
    //     state.copyWith(
    //       acceptedOrderStatus: OrderStatus.loading,
    //       errorMessage: '',
    //     ),
    //   );

    //   try {
    //     final result = await authService.getAcceptedOrders();
    //     debugPrint('ACCEPTED RESULT COUNT: ${result.length}');

    //     for (final item in result) {
    //       debugPrint('ORDER => ${item.orderNo} / ${item.customerName}');
    //     }
    //     emit(
    //       state.copyWith(
    //         acceptedOrderStatus: OrderStatus.success,
    //         acceptedOrderList: result,
    //       ),
    //     );
    //   } catch (e) {
    //     emit(
    //       state.copyWith(
    //         acceptedOrderStatus: OrderStatus.failure,
    //         errorMessage: e.toString(),
    //       ),
    //     );
    //   }
    //   emit(
    //     state.copyWith(
    //       acceptedOrderStatus: OrderStatus.initial,
    //       errorMessage: '',
    //     ),
    //   );
    // });
    on<GetAcceptedOrdersEvent>((event, emit) async {
      debugPrint('GET ACCEPTED ORDERS EVENT CALLED');
      emit(
        state.copyWith(
          acceptedOrderStatus: OrderStatus.loading,
          errorMessage: '',
        ),
      );

      try {
        final result = await authService.getAcceptedOrders();

        debugPrint('ACCEPTED RESULT COUNT: ${result.length}');

        // for (final item in result) {
        //   debugPrint('ORDER => ${item.} / ${item.customerName}');
        // }

        emit(
          state.copyWith(
            acceptedOrderStatus: OrderStatus.success,
            acceptedOrderList: result,
            errorMessage: '',
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            acceptedOrderStatus: OrderStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
    on<GetRejectedOrdersEvent>((event, emit) async {
      emit(
        state.copyWith(
          rejectedOrderStatus: OrderStatus.loading,
          errorMessage: '',
        ),
      );

      try {
        final result = await authService.getRejectedOrders();

        emit(
          state.copyWith(
            rejectedOrderStatus: OrderStatus.success,
            rejectedOrderList: result,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            rejectedOrderStatus: OrderStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
      emit(
        state.copyWith(
          rejectedOrderStatus: OrderStatus.initial,
          errorMessage: '',
        ),
      );
    });
    on<GetGeneralSettingsEvent>((event, emit) async {
      emit(
        state.copyWith(
          generalSettingsStatus: OrderStatus.loading,
          errorMessage: '',
        ),
      );

      try {
        final result = await authService.getGeneralSettings();

        emit(
          state.copyWith(
            generalSettingsStatus: OrderStatus.success,
            generalSettings: result,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            generalSettingsStatus: OrderStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
      emit(state.copyWith(generalSettingsStatus: OrderStatus.initial));
    });
    on<UpdateGeneralSettingsEvent>((event, emit) async {
      emit(
        state.copyWith(
          updateGeneralSettingsStatus: OrderStatus.loading,
          errorMessage: '',
        ),
      );

      try {
        final settingsJson = event.settings.map((e) => e.toJson()).toList();

        final success = await authService.updateGeneralSettings(settingsJson);

        if (success) {
          emit(
            state.copyWith(updateGeneralSettingsStatus: OrderStatus.success),
          );
        } else {
          emit(
            state.copyWith(
              updateGeneralSettingsStatus: OrderStatus.failure,
              errorMessage: 'Failed to update settings',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            updateGeneralSettingsStatus: OrderStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
      emit(state.copyWith(updateGeneralSettingsStatus: OrderStatus.initial));
    });
    on<GetMenuItemStatusListEvent>((event, emit) async {
      emit(
        state.copyWith(
          menuItemStatusListStatus: OrderStatus.loading,
          errorMessage: '',
        ),
      );

      try {
        final result = await authService.getMenuItemStatusList();

        debugPrint('MENU ITEM STATUS COUNT: ${result.length}');

        emit(
          state.copyWith(
            menuItemStatusListStatus: OrderStatus.success,
            menuItemStatusList: result,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            menuItemStatusListStatus: OrderStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
      emit(state.copyWith(menuItemStatusListStatus: OrderStatus.initial));
    });
    on<GetOrderInfoEvent>((event, emit) async {
      debugPrint('GET ORDER INFO EVENT CALLED: ${event.guid}');

      emit(
        state.copyWith(orderInfoStatus: OrderStatus.loading, errorMessage: ''),
      );

      try {
        final result = await authService.getOrderInfo(event.guid);

        if (result != null) {
          emit(
            state.copyWith(
              orderInfoStatus: OrderStatus.success,
              selectedOrder: result,
              errorMessage: '',
            ),
          );
        } else {
          emit(
            state.copyWith(
              orderInfoStatus: OrderStatus.failure,
              errorMessage: 'Order details not found',
            ),
          );
        }
      } catch (e) {
        debugPrint('GET ORDER INFO ERROR: $e');

        emit(
          state.copyWith(
            orderInfoStatus: OrderStatus.failure,
            errorMessage: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    });
    on<UpdateOrderStatusEvent>((event, emit) async {
      emit(
        state.copyWith(
          updateOrderStatus: OrderStatus.loading,
          updateOrderMessage: '',
        ),
      );

      try {
        final bool success = await authService.updateOrderStatus(
          guid: event.guid,
          orderStatus: event.orderStatus,
        );

        if (success) {
          emit(
            state.copyWith(
              updateOrderStatus: OrderStatus.success,
              updateOrderMessage: 'Order ${event.orderStatus} successfully',
            ),
          );

          // Refresh New Orders
          add(GetNewOrdersEvent());
        } else {
          emit(
            state.copyWith(
              updateOrderStatus: OrderStatus.failure,
              updateOrderMessage: 'Failed to update order',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            updateOrderStatus: OrderStatus.failure,
            updateOrderMessage: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    });
  }
}
