import 'package:flutter/material.dart';
import 'package:food_order_app/pages/accepted_order.dart';
import 'package:food_order_app/pages/delivery.dart';
import 'package:food_order_app/pages/neworder.dart';
import 'package:food_order_app/pages/rejected.dart';
import 'package:food_order_app/viewwidget/drawer.dart';

class OrderHomePage extends StatefulWidget {
  const OrderHomePage({super.key});

  @override
  State<OrderHomePage> createState() => _OrderHomePageState();
}

class _OrderHomePageState extends State<OrderHomePage> {
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> pages = const [
    NewOrder(),
    AcceptedOreder(),
    Delivery(),
    Rejected(),
  ];

  final List<String> titles = const [
    'New Order',
    'Accepted Order',
    'Delivered Order',
    'Rejected Order',
  ];

  final List<Color> colors = const [
    Color(0xFF2196F3),
    Color(0xFF66C985),
    Color(0xFF26A69A),
    Color(0xFFE85A67),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade300,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: Color(0xFF73A7A5), size: 25),
        ),
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(
            color: Color(0xFF444444),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      body: IndexedStack(index: selectedIndex, children: pages),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        children: [
          _bottomItem(index: 0, icon: Icons.visibility, label: 'NEW'),
          _bottomItem(index: 1, icon: Icons.done_all, label: 'ACCEPTED'),
          _bottomItem(index: 2, icon: Icons.room_service, label: 'DELIVERED'),
          _bottomItem(index: 3, icon: Icons.block, label: 'REJECTED'),
        ],
      ),
    );
  }

  Widget _bottomItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;
    final Color itemColor = colors[index];

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Column(
          children: [
            // Selected indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2.5,
              width: double.infinity,
              color: isSelected ? Colors.teal : Colors.transparent,
            ),

            const SizedBox(height: 8),

            Icon(
              icon,
              size: 24,
              color: isSelected ? itemColor : itemColor.withOpacity(0.65),
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? itemColor : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
