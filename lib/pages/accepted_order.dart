import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_app/bloc/orderbloc.dart';
import 'package:food_order_app/bloc/orderevent.dart';
import 'package:food_order_app/bloc/orderstate.dart';
import 'package:food_order_app/pages/delivery.dart';

class AcceptedOreder extends StatefulWidget {
  const AcceptedOreder({super.key});

  @override
  State<AcceptedOreder> createState() => _AcceptedOrederState();
}

class _AcceptedOrederState extends State<AcceptedOreder> {
  @override
  // void initState() {
  //   super.initState();
  //   debugPrint('ACCEPTED PAGE INIT CALLED');
  //   context.read<Orderbloc>().add(GetAcceptedOrdersEvent());
  // }
  Future<void> _refreshAcceptedOrders() async {
    context.read<Orderbloc>().add(GetAcceptedOrdersEvent());

    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<Orderbloc, OrderState>(
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.acceptedOrderStatus == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Empty list
          if (asyncSnapshot.acceptedOrderList.isEmpty) {
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
          print(asyncSnapshot.acceptedOrderList.length);
          return RefreshIndicator(
            onRefresh: _refreshAcceptedOrders,
            child: Container(
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
                    order: asyncSnapshot.acceptedOrderList[index],
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
