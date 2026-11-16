import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_app/bloc/orderbloc.dart';
import 'package:food_order_app/bloc/orderevent.dart';
import 'package:food_order_app/bloc/orderstate.dart';

class OrderDetailPage extends StatefulWidget {
  final String guid;
  final String phoneNumber;

  const OrderDetailPage({
    super.key,
    required this.guid,
    required this.phoneNumber,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();

    context.read<Orderbloc>().add(GetOrderInfoEvent(guid: widget.guid));
  }

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Color(0xFF6BAE9D);
    const Color textColor = Color(0xFF676767);
    const Color lineColor = Color(0xFFE3E3E3);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade300,
        surfaceTintColor: Colors.white,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: greenColor, size: 24),
        ),

        titleSpacing: 0,

        title: Row(
          children: [
            const Icon(Icons.phone, color: greenColor, size: 22),

            const SizedBox(width: 6),

            Text(
              widget.phoneNumber,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.text_decrease, color: Color(0xFFB6D1CA)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.text_increase, color: Color(0xFFB6D1CA)),
          ),
        ],
      ),

      body: BlocBuilder<Orderbloc, OrderState>(
        builder: (context, state) {
          if (state.orderInfoStatus == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.orderInfoStatus == OrderStatus.failure) {
            return Center(child: Text(state.errorMessage));
          }

          final order = state.selectedOrder;

          if (order == null) {
            return const Center(child: Text('Order details not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order No : ${order.orderNumber}',
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 34),

                const Text(
                  'Order Details :',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                ...order.orderDetails.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.quantity}-${item.productName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              if (item.portionName.isNotEmpty) ...[
                                const SizedBox(height: 7),

                                Text(
                                  'Portion : ${item.portionName}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                  ),
                                ),
                              ],

                              if (item.toppings.isNotEmpty) ...[
                                const SizedBox(height: 10),

                                const Text(
                                  'Extras Added :',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 7),

                                ...item.toppings.asMap().entries.map((entry) {
                                  final topping = entry.value;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      '${entry.key + 1}-${topping.productName}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: textColor,
                                      ),
                                    ),
                                  );
                                }),
                              ],

                              if (item.spiceName.isNotEmpty) ...[
                                const SizedBox(height: 7),

                                Text(
                                  'Spice Level : ${item.spiceName}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                  ),
                                ),
                              ],

                              if (item.notes.isNotEmpty) ...[
                                const SizedBox(height: 7),

                                Text(
                                  'Notes : ${item.notes}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(width: 15),

                        Text(
                          '\$${item.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: Container(width: 120, height: 1, color: lineColor),
                ),

                const SizedBox(height: 35),

                PriceRow(
                  title: 'Item Total',
                  amount: '\$${order.orderSubtotal.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 32),

                PriceRow(
                  title: 'Discount',
                  amount: '\$${order.orderDiscount.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 32),

                PriceRow(
                  title: order.taxRates.isNotEmpty
                      ? order.taxRates.first.taxName
                      : 'Tax',
                  amount: '\$${order.orderTax.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 42),

                Align(
                  alignment: Alignment.centerRight,
                  child: Container(width: 120, height: 1, color: lineColor),
                ),

                const SizedBox(height: 42),

                PriceRow(
                  title: 'Total',
                  amount: '\$${order.orderTotal.toStringAsFixed(2)}',
                  bold: true,
                ),

                const SizedBox(height: 42),

                Align(
                  alignment: Alignment.centerRight,
                  child: Container(width: 120, height: 1, color: lineColor),
                ),

                const SizedBox(height: 30),

                // Text(
                //   'Date : ${order.bookingDateFormat}',
                //   style: const TextStyle(color: textColor, fontSize: 15),
                // ),

                // const SizedBox(height: 8),

                // Text(
                //   'Time : ${order.bookingTimeFormat}',
                //   style: const TextStyle(color: textColor, fontSize: 15),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool bold;

  const PriceRow({
    super.key,
    required this.title,
    required this.amount,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF676767),
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),

        Text(
          amount,
          style: TextStyle(
            fontSize: bold ? 18 : 16,
            color: const Color(0xFF676767),
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
