import 'package:flutter/material.dart';

import '../app_lang.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/design.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _agency = 0;

  static const _stationsByAgency = [
    (first: 'Ruisseau', firstTime: '05:30 - 23:20', second: 'Dergana', secondTime: '05:30 - 22:00'),
    (first: 'Ben Abdelmalek', firstTime: '05:00 - 22:30', second: 'Ali Mendjeli', secondTime: '05:15 - 22:00'),
    (first: 'Gare de Sétif', firstTime: '05:30 - 22:30', second: 'Université', secondTime: '05:30 - 22:00'),
    (first: 'Gare routière', firstTime: '05:30 - 22:00', second: 'Université', secondTime: '05:30 - 21:30'),
    (first: 'Gare', firstTime: '05:00 - 22:30', second: 'Université', secondTime: '05:15 - 22:00'),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    final text = lang.t;
    final stations = _stationsByAgency[_agency];

    return Column(
      children: [
        NavyHeader(
          title: text('schedule'),
          minHeight: 168,
          trailing: IconButton(
            onPressed: () => _showContact(context),
            icon: const Icon(Icons.call_outlined, color: Colors.white, size: 24),
          ),
          bottom: SizedBox(
            height: 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              itemCount: kAgencies.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final selected = index == _agency;
                return GestureDetector(
                  onTap: () => setState(() => _agency = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: const Color(0x88FFFFFF), width: 1.4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.place_rounded, size: 18, color: selected ? AppColors.cyanDeep : Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          kAgencies[index],
                          style: TextStyle(
                            color: selected ? AppColors.navy : Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            children: [
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            text('exploitation'),
                            style: const TextStyle(
                              color: AppColors.orangeDeep,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(color: AppColors.orangeSoft, shape: BoxShape.circle),
                          child: const Icon(Icons.tram_rounded, color: AppColors.orange, size: 25),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _StationRow(
                      dotColor: AppColors.cyan,
                      name: stations.first,
                      nameColor: AppColors.cyanDeep,
                      time: stations.firstTime,
                    ),
                    const SizedBox(height: 12),
                    _StationRow(
                      dotColor: AppColors.green,
                      name: stations.second,
                      nameColor: AppColors.green,
                      time: stations.secondTime,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            text('interval'),
                            style: const TextStyle(
                              color: AppColors.orangeDeep,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(color: AppColors.orangeSoft, shape: BoxShape.circle),
                          child: const Icon(Icons.timer_outlined, color: AppColors.orange, size: 25),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: Text(text('thursday_saturday'), style: AppText.body.copyWith(fontSize: 15))),
                        _IntervalPill(value: '04 min - 08 min'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Text(text('friday'), style: AppText.body.copyWith(fontSize: 15))),
                        _IntervalPill(value: '08 min - 10 min'),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

class _StationRow extends StatelessWidget {
  const _StationRow({
    required this.dotColor,
    required this.name,
    required this.nameColor,
    required this.time,
  });

  final Color dotColor;
  final String name;
  final Color nameColor;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: TextStyle(color: nameColor, fontWeight: FontWeight.w700, fontSize: 17),
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

class _IntervalPill extends StatelessWidget {
  const _IntervalPill({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(color: AppColors.cyanSoft, borderRadius: BorderRadius.circular(30)),
      child: Text(
        value,
        style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
