import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/design.dart';
import '../widgets/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final lang = app.lang;
    final text = lang.t;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          NavyHeader(
            title: text('my_orders'),
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: app.orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => OrderTile(order: app.orders[index]),
            ),
          ),
        ],
      ),
    );
  }
}
