import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/card_face.dart';
import '../widgets/design.dart';
import 'card_detail_screen.dart';
import 'card_edit_screen.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

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
            title: text('my_cards'),
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
            trailing: CircleIconButton(
              icon: Icons.add_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CardEditScreen()),
              ),
            ),
          ),
          Expanded(
            child: app.cards.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.credit_card_off_rounded, color: AppColors.muted, size: 54),
                          const SizedBox(height: 12),
                          Text(text('no_cards'), style: AppText.h2),
                          const SizedBox(height: 6),
                          Text(text('no_cards_hint'), style: AppText.bodyMuted, textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          AppPrimaryButton(
                            label: text('add_card'),
                            icon: Icons.add_rounded,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (_) => const CardEditScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: app.cards.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final card = app.cards[index];
                      return WhiteCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) => GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => CardDetailScreen(initialIndex: index),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CardFace(card: card, width: constraints.maxWidth),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.product,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.navy,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${card.durationLabel} · ${card.remainingDays} ${text('days')}',
                                        style: AppText.bodyMuted.copyWith(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.greenSoft,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    card.isActive ? text('active') : card.status,
                                    style: AppText.pill.copyWith(color: AppColors.green),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(builder: (_) => CardEditScreen(card: card)),
                                  ),
                                  icon: const Icon(Icons.edit_outlined, color: AppColors.cyanDeep, size: 21),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
