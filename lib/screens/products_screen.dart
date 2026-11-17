import 'package:flutter/material.dart';

import '../app_lang.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/design.dart';
import 'order_request_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int _type = 0;
  int _agency = 0;
  late PageController _plans;
  int _plan = 1;

  static const _types = [
    (nameKey: 'classic', subtitleKey: 'classic_sub', color: Color(0xFF1FBDE9)),
    (nameKey: 'junior', subtitleKey: 'junior_sub', color: Color(0xFFE8731B)),
    (nameKey: 'senior', subtitleKey: 'senior_sub', color: Color(0xFFD9A916)),
    (nameKey: 'student', subtitleKey: 'student_sub', color: Color(0xFF2F9E44)),
  ];

  static const _plansByType = [
    [
      (labelKey: 'weekly', days: 7, price: '350 DA'),
      (labelKey: 'monthly', days: 30, price: '1200 DA'),
      (labelKey: 'quarterly', days: 90, price: '3000 DA'),
    ],
    [
      (labelKey: 'weekly', days: 7, price: '250 DA'),
      (labelKey: 'monthly', days: 30, price: '900 DA'),
      (labelKey: 'quarterly', days: 90, price: '2400 DA'),
    ],
    [
      (labelKey: 'weekly', days: 7, price: '250 DA'),
      (labelKey: 'monthly', days: 30, price: '900 DA'),
      (labelKey: 'quarterly', days: 90, price: '2400 DA'),
    ],
    [
      (labelKey: 'weekly', days: 7, price: '250 DA'),
      (labelKey: 'monthly', days: 30, price: '900 DA'),
      (labelKey: 'quarterly', days: 90, price: '1800 DA'),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _plans = PageController(viewportFraction: 0.68, initialPage: 1);
  }

  @override
  void dispose() {
    _plans.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    final text = lang.t;
    final type = _types[_type];
    final plans = _plansByType[_type];
    final plan = plans[_plan];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          NavyHeader(
            title: text('products'),
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
            trailing: IconButton(
              onPressed: () => _showContact(context),
              icon: const Icon(Icons.call_outlined, color: Colors.white, size: 24),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              children: [
                const Center(child: Icon(Icons.tram_rounded, color: AppColors.cyan, size: 44)),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    text(type.nameKey),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    text(type.subtitleKey),
                    textAlign: TextAlign.center,
                    style: AppText.bodyMuted.copyWith(fontSize: 14.5),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 46,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _types.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final selected = index == _type;
                      final color = _types[index].color;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _type = index;
                          _plan = 1;
                          _plans.jumpToPage(1);
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? color : Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: color, width: 1.6),
                          ),
                          child: Text(
                            text(index == 0 ? 'classic_chip' : _types[index].nameKey),
                            style: TextStyle(
                              color: selected ? Colors.white : AppColors.navy,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  height: 64,
                  color: AppColors.navyDeep,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    itemCount: kAgencies.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final selected = index == _agency;
                      return GestureDetector(
                        onTap: () => setState(() => _agency = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: selected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: const Color(0x88FFFFFF), width: 1.3),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.place_rounded, size: 17, color: selected ? AppColors.cyanDeep : Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                kAgencies[index],
                                style: TextStyle(
                                  color: selected ? AppColors.navy : Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 296,
                  child: PageView.builder(
                    controller: _plans,
                    itemCount: plans.length,
                    onPageChanged: (index) => setState(() => _plan = index),
                    itemBuilder: (context, index) {
                      final item = plans[index];
                      final selected = index == _plan;
                      final label = index == 1 ? '${text(item.labelKey)} · ${text('monthly_demanded').split('·').last.trim()}' : text(item.labelKey);
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: selected ? AppColors.cyan : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: const [BoxShadow(color: Color(0x121B2A63), blurRadius: 20, offset: Offset(0, 8))],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                decoration: const BoxDecoration(color: Color(0xFF25367F)),
                                child: Text(
                                  label,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${item.days}',
                                      style: const TextStyle(
                                        color: AppColors.navy,
                                        fontSize: 70,
                                        fontWeight: FontWeight.w800,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      text('days').toLowerCase(),
                                      style: const TextStyle(
                                        color: AppColors.navy,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item.price,
                                      style: const TextStyle(
                                        color: AppColors.navy,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                      ),
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
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < plans.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _plan ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _plan ? AppColors.cyan : const Color(0xFFCBD3E6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppPrimaryButton(
                    label: '${text('order')} • ${plan.price}',
                    icon: Icons.send_rounded,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => OrderRequestScreen(
                          typeName: text(type.nameKey),
                          planLabel: text(plan.labelKey),
                          days: plan.days,
                          price: plan.price,
                          agency: kAgencies[_agency],
                        ),
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

  void _showContact(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Service client', style: AppText.h3),
        content: const Text('021 45 45 45\ncontact@setram.dz', style: AppText.body),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.appLang.t('close'))),
        ],
      ),
    );
  }
}
