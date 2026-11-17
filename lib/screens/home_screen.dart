import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_lang.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/design.dart';
import 'card_detail_screen.dart';
import 'doleance_screen.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onOpenProfile});

  final VoidCallback onOpenProfile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(viewportFraction: 0.92);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final lang = app.lang;
    final text = lang.t;
    final cards = app.cards;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141C4E), Color(0xFF1D2B68), Color(0xFF20336F)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 26),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/E-TWASSEL-enclr.svg',
                      width: constraints.maxWidth * 0.54,
                    ),
                    const Spacer(),
                    _TopAction(
                      icon: Icons.language_rounded,
                      onTap: () => showLanguageSheet(context),
                    ),
                    const SizedBox(width: 8),
                    _TopAction(icon: Icons.call_outlined, onTap: () => _showContact(context)),
                    const SizedBox(width: 8),
                    _TopAction(
                      icon: Icons.notifications_none_rounded,
                      dot: app.unreadCount > 0,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onOpenProfile,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(color: Color(0x14FFFFFF), shape: BoxShape.circle),
                      child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text('hello'),
                          style: TextStyle(
                            color: AppColors.cyan,
                            fontSize: lang.isArabic ? 14 : 12.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: lang.isArabic ? 0 : 1.4,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          app.profile.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _logout(context),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.logout_rounded, color: Colors.white, size: 25),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (cards.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: WhiteCard(
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card_off_rounded, color: AppColors.muted, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${text('no_cards')} — ${text('no_cards_hint')}',
                          style: AppText.bodyMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 226,
                child: PageView.builder(
                  controller: _pageController,
                  padEnds: false,
                  itemCount: cards.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 16, right: index == cards.length - 1 ? 16 : 8),
                    child: _PassCard(
                      card: cards[index],
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => CardDetailScreen(initialIndex: index)),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
                decoration: BoxDecoration(
                  color: const Color(0x14FFFFFF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0x26FFFFFF)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.check_circle_outline_rounded, color: AppColors.green, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text('traffic_alert'),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            text('traffic_ok'),
                            style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GradientOutlineButton(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const DoleanceScreen()),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        text('submit_doleance'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.error_outline_rounded, color: AppColors.orange, size: 24),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward_rounded, color: AppColors.cyan, size: 22),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    text('featured'),
                    style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 176,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _NewsCard(
                    title: text('news_title'),
                    date: text('news_date'),
                    onTap: () => _showNews(context),
                  ),
                  const SizedBox(width: 12),
                  _NewsCard(
                    title: text('featured'),
                    date: '05/09/2026',
                    onTap: () => _showNews(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final lang = context.appLang;
    final ok = await confirmDialog(
      context,
      title: lang.t('logout'),
      message: lang.t('logout') + ' ?',
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

  void _showContact(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Service client', style: AppText.h3),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('021 45 45 45', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            SizedBox(height: 4),
            Text('contact@setram.dz', style: AppText.bodyMuted),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.appLang.t('close'))),
        ],
      ),
    );
  }

  void _showNews(BuildContext context) {
    final lang = context.appLang;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset('assets/images/news_demo.jpg', height: 170, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Text(lang.t('news_date'), style: AppText.bodyMuted),
              const SizedBox(height: 6),
              Text(lang.t('news_title'), style: AppText.h2),
              const SizedBox(height: 8),
              const Text(
                "SETRAM participe à la Foire d'Alger pour présenter ses services et ses abonnements.",
                style: AppText.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopAction extends StatelessWidget {
  const _TopAction({required this.icon, this.onTap, this.dot = false});

  final IconData icon;
  final VoidCallback? onTap;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: Color(0x10FFFFFF), shape: BoxShape.circle),
        child: Stack(
          children: [
            Center(child: Icon(icon, color: Colors.white, size: 20)),
            if (dot)
              Positioned(
                top: 9,
                right: 10,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.cyan,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.navyDeep, width: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PassCard extends StatelessWidget {
  const _PassCard({required this.card, required this.onTap});

  final CardModel card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5ACBEA), Color(0xFF3F9FD6)],
          ),
          boxShadow: const [BoxShadow(color: Color(0x4021BDE9), blurRadius: 24, offset: Offset(0, 12))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -30,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                card.isActive ? lang.t('active') : card.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (card.showQr)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: QrView(size: 72, seed: card.id.hashCode),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        card.product,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ),
                    Container(height: 1, color: Colors.white.withValues(alpha: 0.3)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              '${lang.t('il_vous_reste')} ${card.remainingDays} ${lang.t('days')}',
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 24),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.title, required this.date, required this.onTap});

  final String title;
  final String date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 292,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/news_demo.jpg', fit: BoxFit.cover),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0x99101830),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    date,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
