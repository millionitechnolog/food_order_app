import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_app/bloc/orderbloc.dart';
import 'package:food_order_app/bloc/orderevent.dart';
import 'package:food_order_app/bloc/orderstate.dart';
import 'package:food_order_app/pages/delivery.dart';

class Rejected extends StatefulWidget {
  const Rejected({super.key});

  @override
  State<Rejected> createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<Orderbloc, OrderState>(
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.rejectedOrderStatus == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Empty list
          if (asyncSnapshot.rejectedOrderList.isEmpty) {
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

          return RefreshIndicator(
            onRefresh: () async {
              context.read<Orderbloc>().add(GetRejectedOrdersEvent());

              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: asyncSnapshot.rejectedOrderList.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE8E8E8),
                  );
                },
                itemBuilder: (context, index) {
                  return DeliveryOrderTile(
                    order: asyncSnapshot.rejectedOrderList[index],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
