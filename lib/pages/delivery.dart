import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_app/bloc/orderbloc.dart';
import 'package:food_order_app/bloc/orderevent.dart';
import 'package:food_order_app/bloc/orderstate.dart';
import 'package:food_order_app/models/deliverymodel.dart';
import 'package:food_order_app/viewwidget/deliverydetails.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  @override
  void initState() {
    super.initState();

    context.read<Orderbloc>().add(GetDeliveredOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Orderbloc, OrderState>(
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.deliveryOrderStatus == OrderStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Empty list
        if (asyncSnapshot.deliveryorderList.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 3,
              children: [
                Icon(Icons.shopping_cart, color: Colors.grey, size: 100),
                Text("Order is Empty"),
              ],
            ),
          );
        }

        return Container(
          color: Colors.white,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: asyncSnapshot.acceptedOrderList.length,
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE8E8E8),
              );
            },
            itemBuilder: (context, index) {
              return DeliveryOrderTile(
                isAcceptedOrder: true,
                order: asyncSnapshot.acceptedOrderList[index],
              );
            },
          ),
        );
      },
    );
  }
}

class DeliveryOrderTile extends StatelessWidget {
  final DeliveredOrderModel order;
  final bool isAcceptedOrder;

  const DeliveryOrderTile({
    super.key,
    required this.order,
    this.isAcceptedOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF54A896);
    const Color red = Color(0xFFD87983);
    const Color grey = Color(0xFF8A8A8A);

    return InkWell(
      onTap: isAcceptedOrder
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(model: order),
                ),
              );
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.phoneNumber,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: green,
                height: 1.2,
              ),
            ),

            if (order.customerName != null &&
                order.customerName!.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                order.customerName!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: green,
                  height: 1.2,
                ),
              ),
            ],

            const SizedBox(height: 5),

            Text(
              "\$${order.total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: red,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              order.orderNo,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: grey,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
