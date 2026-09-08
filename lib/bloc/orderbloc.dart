import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_order_app/bloc/orderstate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:food_order_app/bloc/orderevent.dart";
import 'package:food_order_app/models/deliverymodel.dart';
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
        final result = await authService.getOrderInfo(event.guid);

        emit(state.copyWith(status: OrderStatus.success, orderInfo: result));
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
    on<GetAcceptedOrdersEvent>((event, emit) async {
      emit(
        state.copyWith(
          acceptedOrderStatus: OrderStatus.loading,
          errorMessage: '',
        ),
      );

      try {
        final result = await authService.getAcceptedOrders();

        emit(
          state.copyWith(
            acceptedOrderStatus: OrderStatus.success,
            acceptedOrderList: result,
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
      emit(
        state.copyWith(
          acceptedOrderStatus: OrderStatus.initial,
          errorMessage: '',
        ),
      );
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
  }
}
