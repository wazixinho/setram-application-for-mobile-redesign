import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/design.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
            title: text('notifications'),
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
            trailing: IconButton(
              onPressed: app.unreadCount == 0 ? null : app.markAllNotificationsRead,
              icon: const Icon(Icons.done_all_rounded, color: Colors.white, size: 24),
            ),
          ),
          Expanded(
            child: app.notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.notifications_off_outlined, color: AppColors.muted, size: 54),
                        const SizedBox(height: 12),
                        Text(text('no_notifications'), style: AppText.h2.copyWith(color: AppColors.muted)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: app.notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notification = app.notifications[index];
                      return GestureDetector(
                        onTap: () => app.markNotificationRead(notification.id),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: notification.read ? Colors.white : AppColors.cyanSoft.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: notification.read ? Colors.transparent : AppColors.cyan.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _background(notification.kind),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(_icon(notification.kind), color: _color(notification.kind), size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.navy,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        if (!notification.read)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.cyanDeep,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(notification.body, style: AppText.bodyMuted.copyWith(fontSize: 13.5)),
                                    const SizedBox(height: 6),
                                    Text(
                                      timeAgo(notification.date),
                                      style: AppText.bodyMuted.copyWith(fontSize: 11.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _icon(NotificationKind kind) => switch (kind) {
        NotificationKind.info => Icons.info_outline_rounded,
        NotificationKind.warning => Icons.warning_amber_rounded,
        NotificationKind.success => Icons.check_circle_outline_rounded,
        NotificationKind.promo => Icons.campaign_outlined,
      };

  Color _color(NotificationKind kind) => switch (kind) {
        NotificationKind.info => AppColors.cyanDeep,
        NotificationKind.warning => AppColors.orange,
        NotificationKind.success => AppColors.green,
        NotificationKind.promo => AppColors.navy,
      };

  Color _background(NotificationKind kind) => switch (kind) {
        NotificationKind.info => AppColors.cyanSoft,
        NotificationKind.warning => AppColors.orangeSoft,
        NotificationKind.success => AppColors.greenSoft,
        NotificationKind.promo => AppColors.field,
      };
}
