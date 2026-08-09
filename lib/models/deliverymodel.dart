import 'package:food_order_app/pages/delivery.dart';

class DeliveredOrderModel {
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
}

final List<DeliveredOrderModel> orders = [
  const DeliveredOrderModel(
    orderNo: '#3269341722',
    customerName: 'Michal Krynski',
    phoneNumber: '647-839-0443',
    itemName: 'Chicken Tikka Masala Roti',
    quantity: 1,
    extras: ['Green peas'],
    spiceLevel: 'Mild to Medium',
    itemTotal: 16.49,
    discount: 0.00,
    tax: 2.01,
    total: 18.50,
  ),

  const DeliveredOrderModel(
    orderNo: '#4126088913',
    customerName: 'Matthew',
    phoneNumber: '647-466-4656',
    itemName: 'Saag Paneer Roti',
    quantity: 1,
    extras: ['Extra cheese'],
    spiceLevel: 'Mild',
    itemTotal: 14.99,
    discount: 0.00,
    tax: 1.95,
    total: 16.94,
  ),

  const DeliveredOrderModel(
    orderNo: '#307864602',
    customerName: 'Mary',
    phoneNumber: '204-960-9533',
    itemName: 'Butter Chicken Roti',
    quantity: 2,
    extras: ['Green peppers', 'Onion'],
    spiceLevel: 'Medium',
    itemTotal: 32.00,
    discount: 2.00,
    tax: 3.90,
    total: 33.90,
  ),

  const DeliveredOrderModel(
    orderNo: '#2199779491',
    customerName: 'Russell Cousins',
    phoneNumber: '647-292-8118',
    itemName: 'Paneer Tikka Roti',
    quantity: 1,
    extras: ['Mushroom', 'Green peas'],
    spiceLevel: 'Medium to Hot',
    itemTotal: 15.49,
    discount: 0.00,
    tax: 2.01,
    total: 17.50,
  ),

  const DeliveredOrderModel(
    orderNo: '#2413444171',
    customerName: 'Glen Brazier',
    phoneNumber: '416-882-8870',
    itemName: 'Chicken Curry Roti',
    quantity: 1,
    extras: [],
    spiceLevel: 'Mild to Medium',
    itemTotal: 14.99,
    discount: 0.00,
    tax: 1.95,
    total: 16.94,
  ),

  const DeliveredOrderModel(
    orderNo: '#2499549845',
    customerName: 'Jason',
    phoneNumber: '647-741-7572',
    itemName: 'Lamb Curry Roti',
    quantity: 2,
    extras: ['Extra meat', 'Green peppers'],
    spiceLevel: 'Hot',
    itemTotal: 36.00,
    discount: 3.00,
    tax: 4.29,
    total: 37.29,
  ),

  const DeliveredOrderModel(
    orderNo: '#3847562109',
    customerName: 'David Miller',
    phoneNumber: '647-230-7228',
    itemName: 'Chana Masala Roti',
    quantity: 1,
    extras: ['Onion'],
    spiceLevel: 'Medium',
    itemTotal: 13.99,
    discount: 0.00,
    tax: 1.82,
    total: 15.81,
  ),

  const DeliveredOrderModel(
    orderNo: '#5638291740',
    customerName: 'Sarah Wilson',
    phoneNumber: '416-555-2387',
    itemName: 'Beef Curry Roti',
    quantity: 1,
    extras: ['Extra gravy'],
    spiceLevel: 'Medium to Hot',
    itemTotal: 17.49,
    discount: 1.00,
    tax: 2.14,
    total: 18.63,
  ),

  const DeliveredOrderModel(
    orderNo: '#6753219084',
    customerName: 'Robert Smith',
    phoneNumber: '905-441-7788',
    itemName: 'Vegetable Roti',
    quantity: 2,
    extras: ['Green peas', 'Mushroom', 'Onion'],
    spiceLevel: 'Mild',
    itemTotal: 27.98,
    discount: 2.00,
    tax: 3.38,
    total: 29.36,
  ),

  const DeliveredOrderModel(
    orderNo: '#7824516390',
    customerName: 'Jennifer Brown',
    phoneNumber: '647-555-9012',
    itemName: 'Chicken Vindaloo Roti',
    quantity: 1,
    extras: [],
    spiceLevel: 'Hot',
    itemTotal: 16.99,
    discount: 0.00,
    tax: 2.21,
    total: 19.20,
  ),
];
