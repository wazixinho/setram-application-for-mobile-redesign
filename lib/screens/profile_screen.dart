import 'package:flutter/material.dart';

import '../app_lang.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/design.dart';
import '../widgets/order_tile.dart';
import 'card_detail_screen.dart';
import 'cards_screen.dart';
import 'doleance_screen.dart';
import 'login_screen.dart';
import 'orders_screen.dart';
import 'password_screen.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final lang = app.lang;
    final text = lang.t;

    return Column(
      children: [
        NavyHeader(
          title: text('my_profile'),
          minHeight: 170,
          trailing: CircleIconButton(
            icon: Icons.logout_rounded,
            background: const Color(0x26FFFFFF),
            onTap: () => _logout(context),
          ),
        ),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -58),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 84),
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const ProfileEditScreen()),
                        ),
                        child: WhiteCard(
                          radius: 26,
                          child: Row(
                            children: [
                              Container(
                                width: 74,
                                height: 74,
                                decoration: const BoxDecoration(color: AppColors.field, shape: BoxShape.circle),
                                child: const Icon(Icons.person_rounded, color: AppColors.cyanDeep, size: 38),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      text('hello'),
                                      style: const TextStyle(
                                        color: AppColors.cyanDeep,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      app.profile.fullName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.ltr,
                                      style: const TextStyle(
                                        color: AppColors.navy,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      app.profile.email,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.bodyMuted,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.field,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${app.profile.memberSince}',
                                      style: const TextStyle(
                                        color: AppColors.navy,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 21,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 58,
                                      child: Text(
                                        text('member_since'),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppColors.muted,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SectionTitle(
                        title: text('my_cards'),
                        action: text('see_all'),
                        onAction: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const CardsScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: app.cards.isEmpty
                          ? WhiteCard(child: Text(text('no_cards_hint'), style: AppText.bodyMuted))
                          : Column(
                              children: [
                                for (var i = 0; i < app.cards.length; i++) ...[
                                  _MiniCard(
                                    card: app.cards[i],
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => CardDetailScreen(initialIndex: i),
                                      ),
                                    ),
                                  ),
                                  if (i != app.cards.length - 1) const SizedBox(height: 12),
                                ],
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SectionTitle(
                        title: text('my_doleances'),
                        accent: AppColors.orange,
                        action: text('see_all'),
                        onAction: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const DoleanceScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: app.doleances.isEmpty
                          ? WhiteCard(child: Text(text('no_doleances'), style: AppText.bodyMuted))
                          : Column(
                              children: [
                                for (var i = 0; i < app.doleances.length; i++) ...[
                                  _DoleanceTile(doleance: app.doleances[i]),
                                  if (i != app.doleances.length - 1) const SizedBox(height: 10),
                                ],
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SectionTitle(
                        title: text('my_orders'),
                        action: text('see_all'),
                        onAction: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const OrdersScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: OrderTile(order: app.orders.first),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SectionTitle(title: text('account')),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: WhiteCard(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          children: [
                            _SettingsTile(
                              icon: Icons.lock_reset_rounded,
                              label: text('change_password'),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (_) => const PasswordScreen()),
                              ),
                            ),
                            _SettingsTile(
                              icon: Icons.language_rounded,
                              label: text('language'),
                              value: lang.label,
                              onTap: () => showLanguageSheet(context),
                            ),
                            _SettingsTile(
                              icon: Icons.edit_rounded,
                              label: text('edit_profile'),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (_) => const ProfileEditScreen()),
                              ),
                            ),
                            _SettingsTile(
                              icon: Icons.restart_alt_rounded,
                              label: text('reset_demo'),
                              onTap: () => _reset(context),
                            ),
                            _SettingsTile(
                              icon: Icons.info_outline_rounded,
                              label: text('about'),
                              value: 'v1.0.0',
                              onTap: () => _about(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    final lang = context.appLang;
    final ok = await confirmDialog(
      context,
      title: lang.t('logout'),
      message: '${lang.t('logout')} ?',
      confirmLabel: lang.t('yes'),
      cancelLabel: lang.t('no'),
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    context.app.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _reset(BuildContext context) async {
    final lang = context.appLang;
    final ok = await confirmDialog(
      context,
      title: lang.t('reset_demo'),
      message: lang.t('reset_demo_confirm'),
      destructive: true,
      confirmLabel: lang.t('yes'),
      cancelLabel: lang.t('no'),
    );
    if (!ok || !context.mounted) return;
    context.app.resetDemo();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _about(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('e-TWASSEL', style: AppText.h2),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0 (démo)', style: AppText.body),
            SizedBox(height: 8),
            Text(
              "Interface de démonstration hors ligne inspirée de l'application e-TWASSEL SETRAM. Aucune donnée n'est envoyée à un serveur.",
              style: AppText.bodyMuted,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.appLang.t('close'))),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.card, required this.onTap});

  final CardModel card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3FC7EA), Color(0xFF2E9BD4)],
          ),
          boxShadow: const [BoxShadow(color: Color(0x3321BDE9), blurRadius: 20, offset: Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.durationLabel,
                        style: const TextStyle(color: Color(0xD9FFFFFF), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.product,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${card.number}',
                        style: const TextStyle(color: Color(0xD9FFFFFF), fontSize: 13.5),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${card.isActive ? lang.t('active') : card.status} · ${card.remainingDays} J',
                    style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
                child: const Icon(Icons.qr_code_2_rounded, color: AppColors.navy, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoleanceTile extends StatelessWidget {
  const _DoleanceTile({required this.doleance});

  final Doleance doleance;

  @override
  Widget build(BuildContext context) {
    final closed = doleance.status.toLowerCase().startsWith('clôtur');
    return WhiteCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.support_agent_rounded, color: AppColors.orange, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doleance.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 3),
                Text(
                  '${doleance.id} · ${fmtDateShort(doleance.createdAt)}',
                  style: AppText.bodyMuted.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            doleance.status,
            style: TextStyle(
              color: closed ? AppColors.orange : AppColors.green,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.label, this.value, this.onTap});

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: AppColors.cyanSoft, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: AppColors.cyanDeep),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w600, fontSize: 14.5),
              ),
            ),
            if (value != null)
              Text(value!, style: AppText.bodyMuted.copyWith(fontSize: 12.5)),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 20),
          ],
        ),
      ),
    );
  }
}
