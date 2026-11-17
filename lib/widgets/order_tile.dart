import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final expired = order.statusLabel.toLowerCase() == 'expiré';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x0F1B2A63), blurRadius: 22, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: AppColors.cyanSoft, borderRadius: BorderRadius.circular(15)),
                child: const Icon(Icons.shopping_bag_outlined, color: AppColors.cyanDeep, size: 25),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.price,
                    style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.payment_rounded, color: AppColors.orange, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        order.paidLabel,
                        style: const TextStyle(
                          color: AppColors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                order.id,
                style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.event_busy_rounded, size: 15, color: AppColors.red),
                  const SizedBox(width: 4),
                  Text(
                    order.statusLabel,
                    style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 15, color: AppColors.red),
                  const SizedBox(width: 4),
                  Text(
                    fmtDateShort(order.expiryDate),
                    style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 15, color: AppColors.muted),
              const SizedBox(width: 4),
              Text(timeAgo(order.createdAt), style: AppText.bodyMuted.copyWith(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.place_rounded, size: 15, color: AppColors.green),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order.agency,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 13.5),
                ),
              ),
              if (expired)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
