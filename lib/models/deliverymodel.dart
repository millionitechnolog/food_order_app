import 'dart:convert';

class DeliveredOrderModel {
  final String guid;
  final String orderNo;
  final String customerName;
  final String phoneNumber;
  final String itemName;
  final int quantity;
  final List<String> extras;
  final String spiceLevel;
  final double itemTotal;
  final double discount;
  final double tax;
  final double total;

  const DeliveredOrderModel({
    required this.guid,
    required this.orderNo,
    required this.customerName,
    required this.phoneNumber,
    required this.itemName,
    required this.quantity,
    required this.extras,
    required this.spiceLevel,
    required this.itemTotal,
    required this.discount,
    required this.tax,
    required this.total,
  });

  factory DeliveredOrderModel.fromJson(Map<String, dynamic> json) {
    final orderDetails = _convertToList(json['orderDetails']);

    final Map<String, dynamic> firstItem =
        orderDetails.isNotEmpty && orderDetails.first is Map
        ? Map<String, dynamic>.from(orderDetails.first)
        : {};

    final toppings = _convertToList(firstItem['toppings']);

    return DeliveredOrderModel(
      guid: json['rowGuid']?.toString() ?? json['guid']?.toString() ?? '',

      orderNo: json['orderNumber']?.toString() ?? '',

      customerName: json['customerName']?.toString() ?? '',

      phoneNumber:
          json['customerMobile']?.toString() ??
          json['customerNumber']?.toString() ??
          json['phoneNumber']?.toString() ??
          '',

      itemName: firstItem['productName']?.toString() ?? '',

      quantity: int.tryParse(firstItem['quantity']?.toString() ?? '0') ?? 0,

      extras: toppings
          .map((e) => e is Map ? e['productName']?.toString() ?? '' : '')
          .where((name) => name.isNotEmpty)
          .toList(),

      spiceLevel: firstItem['spiceName']?.toString() ?? '',

      itemTotal:
          double.tryParse(json['orderSubtotal']?.toString() ?? '0') ?? 0.0,

      discount:
          double.tryParse(json['orderDiscount']?.toString() ?? '0') ?? 0.0,

      tax: double.tryParse(json['orderTax']?.toString() ?? '0') ?? 0.0,

      total:
          double.tryParse(
            json['totalAmount']?.toString() ??
                json['orderTotal']?.toString() ??
                '0',
          ) ??
          0.0,
    );
  }
}

class OrderInfoModel {
  final String rowGuid;
  final String orderNumber;
  final double orderTax;
  final double orderTotal;
  final double orderSubtotal;
  final double orderDiscount;
  final String orderDate;
  final String orderModifyDate;
  final String orderViewDate;
  final int orderStatus;
  final List<TaxRateModel> taxRates;
  final List<OrderDetailModel> orderDetails;
  final String bookingDateFormat;
  final String bookingTimeFormat;
  final int id;

  const OrderInfoModel({
    required this.rowGuid,
    required this.orderNumber,
    required this.orderTax,
    required this.orderTotal,
    required this.orderSubtotal,
    required this.orderDiscount,
    required this.orderDate,
    required this.orderModifyDate,
    required this.orderViewDate,
    required this.orderStatus,
    required this.taxRates,
    required this.orderDetails,
    required this.bookingDateFormat,
    required this.bookingTimeFormat,
    required this.id,
  });

  factory OrderInfoModel.fromJson(Map<String, dynamic> json) {
    return OrderInfoModel(
      rowGuid: json['rowGuid']?.toString() ?? '',

      orderNumber: json['orderNumber']?.toString() ?? '',

      orderTax: double.tryParse(json['orderTax']?.toString() ?? '0') ?? 0.0,

      orderTotal: double.tryParse(json['orderTotal']?.toString() ?? '0') ?? 0.0,

      orderSubtotal:
          double.tryParse(json['orderSubtotal']?.toString() ?? '0') ?? 0.0,

      orderDiscount:
          double.tryParse(json['orderDiscount']?.toString() ?? '0') ?? 0.0,

      orderDate: json['orderDate']?.toString() ?? '',

      orderModifyDate: json['orderModifyDate']?.toString() ?? '',

      orderViewDate: json['orderViewDate']?.toString() ?? '',

      orderStatus: int.tryParse(json['orderStatus']?.toString() ?? '0') ?? 0,

      taxRates: _convertToList(json['taxRates'])
          .whereType<Map>()
          .map((e) => TaxRateModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),

      orderDetails: _convertToList(json['orderDetails'])
          .whereType<Map>()
          .map((e) => OrderDetailModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),

      bookingDateFormat: json['bookingDateFormat']?.toString() ?? '',

      bookingTimeFormat: json['bookingTimeFormat']?.toString() ?? '',

      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
    );
  }
}

class TaxRateModel {
  final String taxName;
  final double taxRate;

  const TaxRateModel({required this.taxName, required this.taxRate});

  factory TaxRateModel.fromJson(Map<String, dynamic> json) {
    return TaxRateModel(
      taxName: json['TaxName']?.toString() ?? json['taxName']?.toString() ?? '',

      taxRate:
          double.tryParse(
            json['TaxRate']?.toString() ?? json['taxRate']?.toString() ?? '0',
          ) ??
          0.0,
    );
  }
}

class OrderDetailModel {
  final String productName;
  final int quantity;
  final double unitPrice;
  final double price;
  final double discount;
  final double subTotal;
  final double total;
  final String spiceName;
  final String portionName;
  final String notes;
  final bool isExtraPrice;
  final List<ToppingModel> toppings;

  const OrderDetailModel({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.price,
    required this.discount,
    required this.subTotal,
    required this.total,
    required this.spiceName,
    required this.portionName,
    required this.notes,
    required this.isExtraPrice,
    required this.toppings,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      productName: json['productName']?.toString() ?? '',

      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,

      unitPrice: double.tryParse(json['unitPrice']?.toString() ?? '0') ?? 0.0,

      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,

      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,

      subTotal: double.tryParse(json['subTotal']?.toString() ?? '0') ?? 0.0,

      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,

      spiceName: json['spiceName']?.toString() ?? '',

      portionName: json['portionName']?.toString() ?? '',

      notes: json['notes']?.toString() ?? '',

      isExtraPrice: json['isExtraPrice'] == true,

      toppings: _convertToList(json['toppings'])
          .whereType<Map>()
          .map((e) => ToppingModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class ToppingModel {
  final String productName;
  final int quantity;

  const ToppingModel({required this.productName, required this.quantity});

  factory ToppingModel.fromJson(Map<String, dynamic> json) {
    return ToppingModel(
      productName: json['productName']?.toString() ?? '',

      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
    );
  }
}

List<dynamic> _convertToList(dynamic value) {
  if (value == null) {
    return [];
  }

  if (value is List) {
    return value;
  }

  if (value is String) {
    final text = value.trim();

    if (text.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(text);

      if (decoded is List) {
        return decoded;
      }
    } catch (e) {
      print('JSON LIST PARSE ERROR: $e');
    }
  }

  return [];
}

final List<DeliveredOrderModel> dummyNewOrderList = [
  DeliveredOrderModel(
    guid: 'c420d30c-5194-4e69-98d0-3fdbf2a69d3e',
    orderNo: '31688256',
    customerName: 'John Smith',
    phoneNumber: '416-555-1234',
    itemName: 'Butter Chicken Rice',
    quantity: 2,
    extras: ['Extra Cheese', 'Extra Sauce'],
    spiceLevel: 'Medium',
    itemTotal: 31.98,
    discount: 2.00,
    tax: 3.90,
    total: 33.88,
  ),

  DeliveredOrderModel(
    guid: '5d21a10b-3bc2-4a78-9856-111111111111',
    orderNo: '31688257',
    customerName: 'David Miller',
    phoneNumber: '647-555-4567',
    itemName: 'Chicken Biryani',
    quantity: 1,
    extras: ['Raita'],
    spiceLevel: 'Hot',
    itemTotal: 16.99,
    discount: 0.00,
    tax: 2.21,
    total: 19.20,
  ),

  DeliveredOrderModel(
    guid: '7a37b820-aaaa-4f42-bbbb-222222222222',
    orderNo: '31688258',
    customerName: 'Sarah Wilson',
    phoneNumber: '905-555-7890',
    itemName: 'Paneer Tikka Masala',
    quantity: 1,
    extras: ['Extra Paneer', 'Garlic Naan'],
    spiceLevel: 'Mild',
    itemTotal: 18.50,
    discount: 1.50,
    tax: 2.21,
    total: 19.21,
  ),

  DeliveredOrderModel(
    guid: '9f21c450-bbbb-4d21-cccc-333333333333',
    orderNo: '31688259',
    customerName: 'Michael Brown',
    phoneNumber: '289-555-2345',
    itemName: 'Lamb Curry',
    quantity: 2,
    extras: [],
    spiceLevel: 'Medium',
    itemTotal: 35.98,
    discount: 0.00,
    tax: 4.68,
    total: 40.66,
  ),

  DeliveredOrderModel(
    guid: 'ab45d120-cccc-4e67-dddd-444444444444',
    orderNo: '31688260',
    customerName: 'Emily Davis',
    phoneNumber: '437-555-9876',
    itemName: 'Vegetable Biryani',
    quantity: 1,
    extras: ['Extra Raita'],
    spiceLevel: 'Mild',
    itemTotal: 14.99,
    discount: 0.00,
    tax: 1.95,
    total: 16.94,
  ),
];
