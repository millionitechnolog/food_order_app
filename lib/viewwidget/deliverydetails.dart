import 'package:flutter/material.dart';
import 'package:food_order_app/models/deliverymodel.dart';

class OrderDetailPage extends StatelessWidget {
  final DeliveredOrderModel model;
  const OrderDetailPage({super.key, required this.model});

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

        title: const Row(
          children: [
            Icon(Icons.phone, color: greenColor, size: 22),
            SizedBox(width: 6),
            Text(
              '647-230-7228',
              style: TextStyle(
                fontSize: 23,
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order No : ${model.orderNo}',
              style: TextStyle(
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

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${model.quantity}-${model.itemName}",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 7),
                      if (model.extras.isNotEmpty) ...[
                        const SizedBox(height: 7),

                        const Text(
                          'Extras Added :',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 7),

                        ...model.extras.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '${entry.key + 1}-${entry.value}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }),
                      ],

                      SizedBox(height: 7),
                      Text(
                        'Spice Level : ${model.spiceLevel}',
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                Text(
                  '\$${model.itemTotal}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 120, height: 1, color: lineColor),
            ),

            const SizedBox(height: 45),

            PriceRow(title: 'Item Total', amount: '\$${model.total}'),

            const SizedBox(height: 32),

            PriceRow(title: 'Discount', amount: '\$${model.discount}'),

            const SizedBox(height: 32),

            PriceRow(title: 'HST', amount: '\$${model.tax}'),

            const SizedBox(height: 42),

            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 120, height: 1, color: lineColor),
            ),

            const SizedBox(height: 42),

            PriceRow(title: 'Total', amount: '\$${model.total}', bold: true),

            const SizedBox(height: 42),

            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 120, height: 1, color: lineColor),
            ),
          ],
        ),
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
