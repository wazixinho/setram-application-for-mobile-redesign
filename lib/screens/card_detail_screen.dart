import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/card_face.dart';
import '../widgets/design.dart';
import 'card_edit_screen.dart';

class CardDetailScreen extends StatefulWidget {
  const CardDetailScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  late PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final lang = app.lang;
    final text = lang.t;
    final cards = app.cards;

    if (cards.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text('no_cards'), style: AppText.h2),
                const SizedBox(height: 10),
                Text(text('no_cards_hint'), style: AppText.bodyMuted),
                const SizedBox(height: 20),
                CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  background: AppColors.field,
                  color: AppColors.navy,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final safeIndex = _index.clamp(0, cards.length - 1);
    final card = cards[safeIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFD),
      body: Column(
        children: [
          NavyHeader(
            title: card.product,
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
            trailing: CircleIconButton(
              icon: Icons.edit_outlined,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => CardEditScreen(card: card)),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * 0.846;
                return PageView.builder(
                  controller: _controller,
                  physics: cards.length > 1 ? null : const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  onPageChanged: (index) => setState(() => _index = index),
                  itemBuilder: (context, index) => Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: InteractiveCard(card: cards[index], width: width),
                    ),
                  ),
                );
              },
            ),
          ),
          if (cards.length > 1)
            Container(
              decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              boxShadow: [BoxShadow(color: Color(0x141B2A63), blurRadius: 24, offset: Offset(0, -6))],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 76,
                child: Row(
                  children: [
                    const SizedBox(width: 6),
                    TextButton(
                      onPressed: safeIndex > 0 ? () => _controller.previousPage(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOut,
                          ) : null,
                      child: Row(
                        children: [
                          Icon(
                            Icons.chevron_left_rounded,
                            size: 22,
                            color: safeIndex > 0 ? AppColors.muted : AppColors.line,
                          ),
                          Text(
                            text('previous'),
                            style: TextStyle(
                              color: safeIndex > 0 ? AppColors.muted : AppColors.line,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${safeIndex + 1} / ${cards.length} ${text('cards_count')}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: safeIndex < cards.length - 1
                          ? () => _controller.nextPage(
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOut,
                              )
                          : null,
                      child: Row(
                        children: [
                          Text(
                            text('next'),
                            style: TextStyle(
                              color: safeIndex < cards.length - 1 ? AppColors.cyanDeep : AppColors.line,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 22,
                            color: safeIndex < cards.length - 1 ? AppColors.cyanDeep : AppColors.line,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
