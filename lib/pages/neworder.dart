import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_app/bloc/orderbloc.dart';
import 'package:food_order_app/bloc/orderevent.dart';
import 'package:food_order_app/bloc/orderstate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:food_order_app/pages/delivery.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  Timer? _timer;

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isBeepPlaying = false;

  // ------------------------------------------------
  // PAGE START
  // ------------------------------------------------
  @override
  void initState() {
    super.initState();

    // First API call
    context.read<Orderbloc>().add(GetNewOrdersEvent());

    // Check new orders every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (!mounted) return;

      context.read<Orderbloc>().add(GetNewOrdersEvent());
    });
  }

  // ------------------------------------------------
  // START BEEP - LOOP UNTIL ACCEPT / REJECT
  // ------------------------------------------------
  Future<void> _startBeep() async {
    if (_isBeepPlaying) {
      return;
    }

    _isBeepPlaying = true;

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      await _audioPlayer.play(AssetSource('sound/beep.mp3'));

      debugPrint('🔊 NEW ORDER BEEP STARTED');
    } catch (e) {
      _isBeepPlaying = false;

      debugPrint('BEEP ERROR: $e');
    }
  }

  // ------------------------------------------------
  // STOP BEEP
  // ------------------------------------------------
  Future<void> _stopBeep() async {
    if (!_isBeepPlaying) {
      return;
    }

    await _audioPlayer.stop();

    _isBeepPlaying = false;

    debugPrint('🔇 NEW ORDER BEEP STOPPED');
  }

  // ------------------------------------------------
  // MANUAL REFRESH
  // ------------------------------------------------
  Future<void> _refreshNewOrders() async {
    context.read<Orderbloc>().add(GetNewOrdersEvent());

    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _timer?.cancel();

    _audioPlayer.stop();
    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<Orderbloc, OrderState>(
            listenWhen: (previous, current) {
              return previous.status != current.status ||
                  previous.newOrderList != current.newOrderList;
            },

            listener: (context, state) {
              if (state.status == OrderStatus.success) {
                debugPrint('NEW ORDER COUNT: ${state.newOrderList.length}');

                if (state.newOrderList.isNotEmpty) {
                  _startBeep();
                } else {
                  _stopBeep();
                }
              }
            },
          ),

          // =========================================
          // ACCEPT / REJECT SNACKBAR LISTENER
          // =========================================
          BlocListener<Orderbloc, OrderState>(
            listenWhen: (previous, current) {
              return previous.updateOrderStatus != current.updateOrderStatus &&
                  (current.updateOrderStatus == OrderStatus.success ||
                      current.updateOrderStatus == OrderStatus.failure);
            },

            listener: (context, state) {
              if (state.updateOrderStatus == OrderStatus.success) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.updateOrderMessage),
                      backgroundColor: Colors.green,
                    ),
                  );
              } else if (state.updateOrderStatus == OrderStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.updateOrderMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<Orderbloc, OrderState>(
          builder: (context, state) {
            if (state.status == OrderStatus.loading &&
                state.newOrderList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // ------------------------------------------
            // EMPTY
            // ------------------------------------------
            if (state.newOrderList.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refreshNewOrders,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 180),
                    Icon(Icons.shopping_cart, color: Colors.grey, size: 100),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Order is Empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            }

            // ------------------------------------------
            // NEW ORDER LIST
            // ------------------------------------------
            return RefreshIndicator(
              onRefresh: _refreshNewOrders,
              child: Container(
                color: Colors.white,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: state.newOrderList.length,

                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE8E8E8),
                    );
                  },

                  itemBuilder: (context, index) {
                    final order = state.newOrderList[index];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ORDER DETAILS
                        Expanded(child: DeliveryOrderTile(order: order)),

                        Padding(
                          padding: const EdgeInsets.only(right: 12, left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // =========================
                              // ACCEPT
                              // =========================
                              SizedBox(
                                width: 90,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<Orderbloc>().add(
                                      UpdateOrderStatusEvent(
                                        guid: order.guid,
                                        orderStatus: 'Accepted',
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // =========================
                              // REJECT
                              // =========================
                              SizedBox(
                                width: 90,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<Orderbloc>().add(
                                      UpdateOrderStatusEvent(
                                        guid: order.guid,
                                        orderStatus: 'Rejected',
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //       listener: (BuildContext context, OrderState state) {
  //         if (state.status == OrderStatus.success) {
  //           final currentGuids = state.newOrderList
  //               .map((order) => order.guid)
  //               .toSet();

  //           // First API load
  //           if (_firstLoad) {
  //             _previousOrderGuids = currentGuids;
  //             _firstLoad = false;

  //             debugPrint('Initial orders: ${currentGuids.length}');

  //             return;
  //           }

  //           // Find only newly arrived orders
  //           final newGuids = currentGuids.difference(_previousOrderGuids);

  //           if (newGuids.isNotEmpty) {
  //             debugPrint('🔥 NEW ORDER FOUND: $newGuids');

  //             // Play sound only once
  //             _playNewOrderSound();
  //           }

  //           // Save current list
  //           _previousOrderGuids = currentGuids;
  //         }

  //         if (state.updateOrderStatus == OrderStatus.success) {
  //           ScaffoldMessenger.of(
  //             context,
  //           ).showSnackBar(SnackBar(content: Text(state.updateOrderMessage)));
  //         }

  //         if (state.updateOrderStatus == OrderStatus.failure) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(state.updateOrderMessage),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }
}
// import 'package:flutter/material.dart';
// import 'package:food_order_app/models/deliverymodel.dart';
// import 'package:food_order_app/pages/delivery.dart';

// class NewOrder extends StatefulWidget {
//   const NewOrder({super.key});

//   @override
//   State<NewOrder> createState() => _NewOrderState();
// }

// class _NewOrderState extends State<NewOrder> {
//   @override
//   Widget build(BuildContext context) {
//     final List<DeliveredOrderModel> newList = dummyNewOrderList;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ListView.separated(
//         padding: EdgeInsets.zero,
//         itemCount: newList.length,

//         separatorBuilder: (context, index) {
//           return const Divider(
//             height: 1,
//             thickness: 1,
//             color: Color(0xFFE8E8E8),
//           );
//         },

//         itemBuilder: (context, index) {
//           final order = newList[index];

//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // LEFT - ORDER DETAILS
//               Expanded(child: DeliveryOrderTile(order: order)),

//               // RIGHT - BUTTONS
//               Padding(
//                 padding: const EdgeInsets.only(right: 12, left: 8),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // ACCEPT
//                     SizedBox(
//                       width: 95,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           print('Accept Order: ${order.guid}');
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         child: const Text(
//                           'Accept',
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     // REJECT
//                     SizedBox(
//                       width: 95,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           print('Reject Order: ${order.guid}');
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         child: const Text(
//                           'Reject',
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
