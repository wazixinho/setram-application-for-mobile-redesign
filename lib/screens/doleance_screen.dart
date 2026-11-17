import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_lang.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/design.dart';

class DoleanceScreen extends StatefulWidget {
  const DoleanceScreen({super.key});

  @override
  State<DoleanceScreen> createState() => _DoleanceScreenState();
}

class _DoleanceScreenState extends State<DoleanceScreen> {
  final _subject = TextEditingController();
  final _message = TextEditingController();
  String _category = kDoleanceCategories.last;
  String _tramway = kAgencies.first;
  bool _attached = false;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  void _send() {
    final lang = context.appLang;
    if (_subject.text.trim().isEmpty || _message.text.trim().isEmpty) {
      showAppSnack(context, lang.t('required_field'), error: true);
      return;
    }
    final random = math.Random();
    context.app.addDoleance(
      Doleance(
        id: '#SET-${1000 + random.nextInt(9000)}',
        subject: _subject.text.trim(),
        category: _category,
        message: _message.text.trim(),
        createdAt: DateTime.now(),
        tramway: _tramway,
        status: 'En cours',
        severity: 'Faible',
      ),
    );
    setState(() {
      _subject.clear();
      _message.clear();
      _attached = false;
    });
    showAppSnack(context, lang.t('doleance_sent'));
  }

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
            title: text('doleance'),
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
            minHeight: 130,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              children: [
                WhiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FormLabel(text('subject')),
                      TextField(
                        controller: _subject,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(hintText: text('subject_hint')),
                      ),
                      const SizedBox(height: 16),
                      _FormLabel(text('object')),
                      _Dropdown(
                        value: _category,
                        placeholder: text('category'),
                        items: kDoleanceCategories,
                        onChanged: (value) => setState(() => _category = value),
                      ),
                      const SizedBox(height: 16),
                      _FormLabel(text('tramway')),
                      _Dropdown(
                        value: _tramway,
                        placeholder: text('tramway'),
                        items: kAgencies,
                        onChanged: (value) => setState(() => _tramway = value),
                      ),
                      const SizedBox(height: 16),
                      _FormLabel(text('description')),
                      TextField(
                        controller: _message,
                        minLines: 4,
                        maxLines: 6,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(hintText: text('description_hint')),
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () {
                          setState(() => _attached = true);
                          showAppSnack(context, text('file_selected'));
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            Icon(
                              _attached ? Icons.check_circle_rounded : Icons.attach_file_rounded,
                              color: _attached ? AppColors.green : AppColors.cyanDeep,
                              size: 21,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _attached ? text('file_selected') : text('attach'),
                                style: TextStyle(
                                  color: _attached ? AppColors.green : AppColors.cyanDeep,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 54,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: const LinearGradient(colors: [Color(0xFFF7C08A), Color(0xFFF08A63)]),
                          ),
                          child: TextButton(
                            onPressed: _send,
                            style: TextButton.styleFrom(shape: const StadiumBorder()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  text('send_doleance'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 22,
                      decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        text('history'),
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (app.doleances.isEmpty)
                  WhiteCard(child: Text(text('no_doleances'), style: AppText.bodyMuted))
                else
                  for (final doleance in app.doleances) ...[
                    WhiteCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.confirmation_number_outlined, color: AppColors.navy, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  doleance.subject,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.5,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: doleance.status.toLowerCase().startsWith('clôtur')
                                      ? AppColors.greenSoft
                                      : AppColors.orangeSoft,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  doleance.status,
                                  style: AppText.pill.copyWith(
                                    color: doleance.status.toLowerCase().startsWith('clôtur')
                                        ? AppColors.green
                                        : AppColors.orangeDeep,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(doleance.message, style: AppText.bodyMuted.copyWith(fontSize: 14)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                doleance.id,
                                style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.circle, color: AppColors.green, size: 9),
                                  const SizedBox(width: 5),
                                  Text(
                                    doleance.severity,
                                    style: const TextStyle(
                                      color: AppColors.green,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.grid_view_rounded, color: AppColors.navy, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    doleance.category,
                                    style: const TextStyle(
                                      color: AppColors.navy,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.schedule_rounded, color: AppColors.muted, size: 13),
                                  const SizedBox(width: 4),
                                  Text(timeAgo(doleance.createdAt), style: AppText.bodyMuted.copyWith(fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.placeholder,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final String placeholder;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(14)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(16),
          hint: Text(
            placeholder,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.muted, fontSize: 14.5),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.cyanDeep),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.navy,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
          items: [for (final item in items) DropdownMenuItem(value: item, child: Text(item))],
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }
}
