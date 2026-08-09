import 'package:flutter/material.dart';

class AcceptedOreder extends StatefulWidget {
  const AcceptedOreder({super.key});

  @override
  State<AcceptedOreder> createState() => _AcceptedOrederState();
}

class _AcceptedOrederState extends State<AcceptedOreder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
      ),
    );
  }
}
