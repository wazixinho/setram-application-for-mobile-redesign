import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_lang.dart';
import '../app_state.dart';
import '../theme.dart';

class WhiteCard extends StatelessWidget {
  const WhiteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 22,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Color(0x0F1B2A63), blurRadius: 22, offset: Offset(0, 8)),
        ],
      ),
      child: child,
    );
    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: content);
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.accent = AppColors.cyan,
    this.action,
    this.onAction,
  });

  final String title;
  final Color accent;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(title, style: AppText.h2.copyWith(fontSize: 19), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(action!, style: const TextStyle(color: AppColors.cyanDeep, fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.cyanDeep),
              ],
            ),
          ),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.text,
    this.color = AppColors.green,
    this.background = AppColors.greenSoft,
    this.dot = false,
    this.icon,
  });

  final String text;
  final Color color;
  final Color background;
  final bool dot;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 5),
          ],
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(text, style: AppText.pill.copyWith(color: color)),
        ],
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 44,
    this.background = const Color(0x22FFFFFF),
    this.color = Colors.white,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: size * 0.46),
      ),
    );
  }
}

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = AppColors.navy,
    this.icon,
    this.height = 52,
    this.shadow = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  final double height;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: shadow
              ? [BoxShadow(color: color.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8))]
              : null,
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 19, color: Colors.white), const SizedBox(width: 8)],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientOutlineButton extends StatelessWidget {
  const GradientOutlineButton({super.key, required this.child, this.onTap, this.radius = 40});

  final Widget child;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(1.6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: const LinearGradient(colors: [AppColors.orange, AppColors.cyan]),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.navyDeep,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: child,
        ),
      ),
    );
  }
}

class NavyHeader extends StatelessWidget {
  const NavyHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.bottom,
    this.minHeight = 118,
    this.rounded = true,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? bottom;
  final double minHeight;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: rounded ? const BorderRadius.vertical(bottom: Radius.circular(34)) : BorderRadius.zero,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navyDeep, AppColors.navyHeader],
          ),
        ),
        child: CustomPaint(
          painter: _HeaderDecorationPainter(),
          child: SafeArea(
            bottom: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                    child: Row(
                      children: [
                        SizedBox(width: 44, child: Align(alignment: Alignment.centerLeft, child: leading)),
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                            ),
                          ),
                        ),
                        SizedBox(width: 44, child: Align(alignment: Alignment.centerRight, child: trailing)),
                      ],
                    ),
                  ),
                  if (bottom != null) bottom!,
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.075);
    final r1 = RRect.fromRectAndRadius(Rect.fromLTWH(-40, 20, size.width * 0.55, 96), const Radius.circular(34));
    canvas.drawRRect(r1, stroke);
    final r2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.52, -40, size.width * 0.6, 110),
      const Radius.circular(34),
    );
    canvas.drawRRect(r2, stroke);
    canvas.drawCircle(Offset(size.width * 0.08, 52), 26, stroke);
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.1),
      Offset(size.width * 0.72, size.height * 0.62),
      stroke,
    );
    canvas.drawLine(Offset(0, size.height * 0.82), Offset(size.width, size.height * 0.55), stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.index,
    required this.onSelect,
    required this.onStore,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onStore;

  @override
  Widget build(BuildContext context) {
    final text = context.appLang.t;
    final items = [
      (Icons.home_rounded, text('home')),
      (Icons.place_rounded, text('location')),
      (Icons.schedule_rounded, text('schedule')),
      (Icons.person_rounded, text('profile')),
    ];
    Widget item(int i) {
      final active = index == i;
      final color = active ? AppColors.cyanDeep : const Color(0xFF9AA3B9);
      return Expanded(
        child: GestureDetector(
          onTap: () => onSelect(i),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(items[i].$1, size: 25, color: color),
              const SizedBox(height: 4),
              Text(
                items[i].$2,
                style: TextStyle(
                  fontSize: 11.5,
                  color: color,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: active ? AppColors.cyanDeep : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: 100 + bottomInset,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 24,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Color(0x1A1B2A63), blurRadius: 24, offset: Offset(0, -6))],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 24,
            bottom: bottomInset,
            child: Row(
              children: [
                item(0),
                item(1),
                const SizedBox(width: 84),
                item(2),
                item(3),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: onStore,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFF46C8EE), AppColors.cyanDeep]),
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: const [
                      BoxShadow(color: Color(0x5521BDE9), blurRadius: 18, offset: Offset(0, 6)),
                    ],
                  ),
                  child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 27),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrView extends StatelessWidget {
  const QrView({super.key, required this.size, this.seed = 7, this.quiet = false});

  final double size;
  final int seed;
  final bool quiet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(quiet ? 0 : size * 0.07),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.16),
      ),
      child: CustomPaint(painter: QrPatternPainter(seed: seed)),
    );
  }
}

class QrPatternPainter extends CustomPainter {
  QrPatternPainter({this.seed = 7});

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    const modules = 45;
    final cell = size.width / modules;
    final paint = Paint()..color = const Color(0xFF101731);
    final white = Paint()..color = Colors.white;
    final random = math.Random(seed);

    final reserved = List.generate(modules, (_) => List.filled(modules, false));
    void reserve(int x, int y, int w, int h) {
      for (var yy = y; yy < y + h; yy++) {
        for (var xx = x; xx < x + w; xx++) {
          if (xx >= 0 && yy >= 0 && xx < modules && yy < modules) reserved[yy][xx] = true;
        }
      }
    }

    reserve(0, 0, 8, 8);
    reserve(modules - 8, 0, 8, 8);
    reserve(0, modules - 8, 8, 8);
    for (var i = 8; i < modules - 8; i++) {
      reserved[6][i] = true;
      reserved[i][6] = true;
    }
    final ax = modules - 9;
    final ay = modules - 9;
    reserve(ax - 2, ay - 2, 5, 5);

    for (var y = 0; y < modules; y++) {
      for (var x = 0; x < modules; x++) {
        if (reserved[y][x]) continue;
        if (random.nextDouble() > 0.47) continue;
        canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell + 0.4, cell + 0.4), paint);
      }
    }

    for (var i = 8; i < modules - 8; i++) {
      if (i.isEven) {
        canvas.drawRect(Rect.fromLTWH(i * cell, 6 * cell, cell + 0.4, cell + 0.4), paint);
        canvas.drawRect(Rect.fromLTWH(6 * cell, i * cell, cell + 0.4, cell + 0.4), paint);
      }
    }

    void finder(int ox, int oy) {
      canvas.drawRect(Rect.fromLTWH(ox * cell, oy * cell, 7 * cell, 7 * cell), paint);
      canvas.drawRect(Rect.fromLTWH((ox + 1) * cell, (oy + 1) * cell, 5 * cell, 5 * cell), white);
      canvas.drawRect(Rect.fromLTWH((ox + 2) * cell, (oy + 2) * cell, 3 * cell, 3 * cell), paint);
    }

    finder(0, 0);
    finder(modules - 7, 0);
    finder(0, modules - 7);

    canvas.drawRect(Rect.fromLTWH((ax - 2) * cell, (ay - 2) * cell, 5 * cell, 5 * cell), paint);
    canvas.drawRect(Rect.fromLTWH((ax - 1) * cell, (ay - 1) * cell, 3 * cell, 3 * cell), white);
    canvas.drawRect(Rect.fromLTWH(ax * cell, ay * cell, cell + 0.4, cell + 0.4), paint);
  }

  @override
  bool shouldRepaint(covariant QrPatternPainter oldDelegate) => oldDelegate.seed != seed;
}

Future<void> showLanguageSheet(BuildContext context) async {
  final app = AppScope.of(context);
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Langue', style: AppText.h2),
              const SizedBox(height: 10),
              for (final lang in AppLang.values)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    app.setLang(lang);
                    Navigator.of(context).pop();
                  },
                  leading: CircleAvatar(
                    backgroundColor: lang == app.lang ? AppColors.cyanSoft : AppColors.field,
                    child: Icon(Icons.language_rounded,
                        color: lang == app.lang ? AppColors.cyanDeep : AppColors.muted, size: 20),
                  ),
                  title: Text(lang.label,
                      style: TextStyle(
                        fontWeight: lang == app.lang ? FontWeight.w700 : FontWeight.w500,
                        color: AppColors.navy,
                      )),
                  trailing: lang == app.lang
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.cyanDeep)
                      : null,
                ),
            ],
          ),
        ),
      );
    },
  );
}

void showAppSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? AppColors.red : AppColors.navy,
    ));
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'Confirmer',
  String cancelLabel = 'Annuler',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(title, style: AppText.h3),
      content: message == null ? null : Text(message, style: AppText.body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel, style: const TextStyle(color: AppColors.muted)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: destructive ? AppColors.red : AppColors.navy,
            minimumSize: const Size(100, 44),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
