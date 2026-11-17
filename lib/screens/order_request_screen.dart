import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/design.dart';

class OrderRequestScreen extends StatefulWidget {
  const OrderRequestScreen({
    super.key,
    required this.typeName,
    required this.planLabel,
    required this.days,
    required this.price,
    required this.agency,
  });

  final String typeName;
  final String planLabel;
  final int days;
  final String price;
  final String agency;

  @override
  State<OrderRequestScreen> createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends State<OrderRequestScreen> {
  bool _photo = false;
  bool _id = false;

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    final text = lang.t;
    final description =
        'Abonnement ${widget.planLabel.toLowerCase()} ${widget.typeName.toLowerCase()} (${widget.days} ${text('days').toLowerCase()})';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          NavyHeader(
            title: text('create_request'),
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
            minHeight: 138,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0E6BB5), Color(0xFF143C9B)],
                    ),
                    boxShadow: const [BoxShadow(color: Color(0x330E6BB5), blurRadius: 22, offset: Offset(0, 10))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'eTWASSEL\n${widget.typeName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.planLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          _SummaryItem(icon: Icons.calendar_month_outlined, label: '${widget.days} ${text('days')}'),
                          _SummaryItem(icon: Icons.confirmation_number_outlined, label: widget.price),
                          _SummaryItem(icon: Icons.all_inclusive_rounded, label: text('unlimited')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 22),
                Center(
                  child: Text(
                    text('required_docs'),
                    style: const TextStyle(
                      color: AppColors.orangeDeep,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.tram_rounded, color: AppColors.green, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        '${text('line')}: ${widget.agency}',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(text('personal_photo'), style: AppText.h3),
                const SizedBox(height: 10),
                _PickFileButton(
                  selected: _photo,
                  label: text('choose_photo'),
                  onTap: () {
                    setState(() => _photo = true);
                    showAppSnack(context, text('file_selected'));
                  },
                ),
                const SizedBox(height: 20),
                Text(text('id_copy'), style: AppText.h3),
                const SizedBox(height: 10),
                _PickFileButton(
                  selected: _id,
                  label: text('choose_photo'),
                  onTap: () {
                    setState(() => _id = true);
                    showAppSnack(context, text('file_selected'));
                  },
                ),
                const SizedBox(height: 26),
                SizedBox(
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(colors: [Color(0xFFF9B23C), Color(0xFFF08A2E)]),
                      boxShadow: const [BoxShadow(color: Color(0x33F08A2E), blurRadius: 18, offset: Offset(0, 8))],
                    ),
                    child: TextButton.icon(
                      onPressed: _send,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 21),
                      label: Text(
                        text('send'),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _send() {
    if (!_photo || !_id) {
      showAppSnack(context, context.appLang.t('choose_photo'), error: true);
      return;
    }
    showAppSnack(context, context.appLang.t('request_sent'));
    Navigator.of(context).pop();
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: Color(0x33FFFFFF), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 23),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _PickFileButton extends StatelessWidget {
  const _PickFileButton({required this.selected, required this.label, required this.onTap});

  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: selected ? AppColors.green : AppColors.cyanDeep, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? Icons.check_circle_rounded : Icons.attach_file_rounded,
                color: selected ? AppColors.green : AppColors.cyanDeep, size: 21),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.green : AppColors.cyanDeep,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
