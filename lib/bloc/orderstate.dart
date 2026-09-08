import 'package:food_order_app/models/deliverymodel.dart';
import 'package:food_order_app/models/generalsetting.dart';
import 'package:food_order_app/models/menuitenmodel.dart';

enum OrderStatus { initial, loading, success, failure }

class OrderState {
  final OrderStatus status;
  final OrderStatus deliveryOrderStatus;
  final OrderStatus acceptedOrderStatus;
  final OrderStatus rejectedOrderStatus;
  final OrderStatus updateGeneralSettingsStatus;
  final OrderStatus generalSettingsStatus;
  final OrderStatus menuItemStatusListStatus;
  final List<DeliveredOrderModel> newOrderList;
  final List<DeliveredOrderModel> acceptedOrderList;
  final List<DeliveredOrderModel> deliveryorderList;
  final List<DeliveredOrderModel> rejectedOrderList;
  final DeliveredOrderModel? orderInfo;
  final List<GeneralSettingsModel> generalSettings;
  final List<MenuItemStatusModel> menuItemStatusList;

  final String errorMessage;

  const OrderState({
    this.status = OrderStatus.initial,
    this.deliveryOrderStatus = OrderStatus.initial,
    this.acceptedOrderStatus = OrderStatus.initial,
    this.rejectedOrderStatus = OrderStatus.initial,
    this.updateGeneralSettingsStatus = OrderStatus.initial,
    this.generalSettingsStatus = OrderStatus.initial,
    this.menuItemStatusListStatus = OrderStatus.initial,
    this.newOrderList = const [],
    this.acceptedOrderList = const [],
    this.deliveryorderList = const [],
    this.rejectedOrderList = const [],
    this.errorMessage = '',
    this.orderInfo,
    this.generalSettings = const [],
    this.menuItemStatusList = const [],
  });

  OrderState copyWith({
    OrderStatus? status,
    OrderStatus? deliveryOrderStatus,
    OrderStatus? acceptedOrderStatus,
    OrderStatus? rejectedOrderStatus,
    OrderStatus? updateGeneralSettingsStatus,
    OrderStatus? generalSettingsStatus,
    OrderStatus? menuItemStatusListStatus,
    List<DeliveredOrderModel>? newOrderList,
    List<DeliveredOrderModel>? acceptedOrderList,
    List<DeliveredOrderModel>? deliveryorderList,
    List<DeliveredOrderModel>? rejectedOrderList,
    String? errorMessage,
    DeliveredOrderModel? orderInfo,
    List<GeneralSettingsModel>? generalSettings,
    List<MenuItemStatusModel>? menuItemStatusList,
  }) {
    return OrderState(
      status: status ?? this.status,
      deliveryOrderStatus: deliveryOrderStatus ?? this.deliveryOrderStatus,
      acceptedOrderStatus: acceptedOrderStatus ?? this.acceptedOrderStatus,
      rejectedOrderStatus: rejectedOrderStatus ?? this.rejectedOrderStatus,
      updateGeneralSettingsStatus:
          updateGeneralSettingsStatus ?? this.updateGeneralSettingsStatus,
      generalSettingsStatus:
          generalSettingsStatus ?? this.generalSettingsStatus,
      menuItemStatusListStatus:
          menuItemStatusListStatus ?? this.menuItemStatusListStatus,
      newOrderList: newOrderList ?? this.newOrderList,
      acceptedOrderList: acceptedOrderList ?? this.acceptedOrderList,
      deliveryorderList: deliveryorderList ?? this.deliveryorderList,
      rejectedOrderList: rejectedOrderList ?? this.rejectedOrderList,
      errorMessage: errorMessage ?? this.errorMessage,
      orderInfo: orderInfo ?? this.orderInfo,
      generalSettings: generalSettings ?? this.generalSettings,
      menuItemStatusList: menuItemStatusList ?? this.menuItemStatusList,
    );
  }
}
