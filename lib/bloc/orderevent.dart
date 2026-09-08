import 'package:food_order_app/models/generalsetting.dart';

class Orderevent {}

class GetNewOrdersEvent extends Orderevent {
  final String guid;

  GetNewOrdersEvent({required this.guid});
}

class GetDeliveredOrdersEvent extends Orderevent {}

class GetAcceptedOrdersEvent extends Orderevent {}

class GetRejectedOrdersEvent extends Orderevent {}

class GetGeneralSettingsEvent extends Orderevent {}

class UpdateGeneralSettingsEvent extends Orderevent {
  final List<GeneralSettingsModel> settings;

  UpdateGeneralSettingsEvent({required this.settings});
}

class GetMenuItemStatusListEvent extends Orderevent {}
