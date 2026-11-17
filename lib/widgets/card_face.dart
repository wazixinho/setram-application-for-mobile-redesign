import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import 'design.dart';

String cardBackAsset(String agency) {
  switch (agency) {
    case 'Tramway de Constantine':
      return 'assets/cartes/card_2.png';
    case 'Tramway de Sétif':
      return 'assets/cartes/card_6.png';
    case 'Tramway de Ouargla':
      return 'assets/cartes/card_5.png';
    case 'Tramway de Sidi Bel Abbes':
      return 'assets/cartes/card_4.png';
    default:
      return 'assets/cartes/card_1.png';
  }
}

class CardFace extends StatelessWidget {
  const CardFace({super.key, required this.card, required this.width});

  final CardModel card;
  final double width;

  static const double ratio = 1.5925;

  @override
  Widget build(BuildContext context) {
    final w = width;
    final h = w / ratio;
    final radius = w * 0.024;
    final panel = Rect.fromLTWH(w * 0.0246, h * 0.2774, w * 0.9508, h * 0.6708);

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                boxShadow: const [BoxShadow(color: Color(0x26101840), blurRadius: 18, offset: Offset(0, 8))],
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: RotatedBox(
                quarterTurns: 3,
                child: SizedBox(
                  width: h,
                  height: w,
                  child: Image.asset(
                    card.art.asset,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stack) => const ColoredBox(color: Color(0xFF2E418F)),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fromRect(
            rect: panel,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: _CardContent(card: card, width: panel.width, height: panel.height),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.card, required this.width, required this.height});

  final CardModel card;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final w = width;
    final h = height;
    final nameSize = h * 0.06;
    final lineSize = h * 0.055;
    final qrSize = w * 0.183;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: w * 0.059,
          top: h * 0.066,
          bottom: h * 0.089,
          width: w * 0.258,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.01),
            child: _CardPhoto(source: card.photoAsset),
          ),
        ),
        Positioned(
          left: w * 0.452,
          top: h * 0.16,
          width: w * 0.26,
          height: h * 0.223,
          child: Image.asset(
            'assets/images/SETRAM_Logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => const SizedBox.shrink(),
          ),
        ),
        Positioned(
          left: w * 0.364,
          top: h * 0.396,
          right: w * 0.22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.lastName.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: nameSize,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
              SizedBox(height: h * 0.022),
              Text(
                card.firstName.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: nameSize,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: w * 0.364,
          top: h * 0.624,
          right: w * 0.19,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text.rich(
              TextSpan(
                text: "Date d'expiration : ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: lineSize,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: fmtDate(card.expiry),
                    style: const TextStyle(
                      color: Color(0xFFE4231C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
            ),
          ),
        ),
        Positioned(
          left: w * 0.364,
          right: w * 0.19,
          top: h * 0.712,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tram_rounded, color: const Color(0xFF2FA84F), size: lineSize * 1.25),
                  SizedBox(width: w * 0.008),
                  Text(
                    card.agency,
                    style: TextStyle(
                      color: const Color(0xFF2FA84F),
                      fontSize: lineSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: w * 0.364,
          right: w * 0.19,
          top: h * 0.797,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: _LiveTimestamp(
              style: TextStyle(
                color: const Color(0xFF24317E),
                fontSize: lineSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        if (card.showQr)
          Positioned(
            left: w * 0.788,
            top: h * 0.532,
            width: qrSize,
            height: qrSize,
            child: QrView(size: qrSize, seed: card.id.hashCode, quiet: true),
          ),
      ],
    );
  }
}

class _CardPhoto extends StatelessWidget {
  const _CardPhoto({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    Widget fallback(BuildContext context, Object error, StackTrace? stack) => Image.asset(
          'assets/images/defaultImage.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        );

    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: fallback,
      );
    }
    return Image.file(
      File(source),
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: fallback,
    );
  }
}

class _LiveTimestamp extends StatefulWidget {
  const _LiveTimestamp({required this.style});

  final TextStyle style;

  @override
  State<_LiveTimestamp> createState() => _LiveTimestampState();
}

class _LiveTimestampState extends State<_LiveTimestamp> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      fmtDateTime(clock.now()),
      maxLines: 1,
      style: widget.style,
    );
  }
}

class RotatedCard extends StatelessWidget {
  const RotatedCard({super.key, required this.card, required this.width});

  final CardModel card;
  final double width;

  @override
  Widget build(BuildContext context) {
    final portraitHeight = width * CardFace.ratio;
    return SizedBox(
      width: width,
      height: portraitHeight,
      child: RotatedBox(
        quarterTurns: 1,
        child: SizedBox(
          width: portraitHeight,
          height: width,
          child: CardFace(card: card, width: portraitHeight),
        ),
      ),
    );
  }
}

class CardBackFace extends StatelessWidget {
  const CardBackFace({super.key, required this.card, required this.width});

  final CardModel card;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * CardFace.ratio;
    final radius = width * 0.035;
    return SizedBox(
      key: const ValueKey('card-back'),
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          cardBackAsset(card.agency),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => const ColoredBox(color: Color(0xFF22317C)),
        ),
      ),
    );
  }
}

class InteractiveCard extends StatefulWidget {
  const InteractiveCard({super.key, required this.card, required this.width});

  final CardModel card;
  final double width;

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> with TickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void initState() {
    super.initState();
    _spin.forward();
  }

  @override
  void dispose() {
    _spin.dispose();
    _flip.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _flip.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = -details.delta.dx / widget.width;
    _flip.value = (_flip.value + delta).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final flick = -(details.primaryVelocity ?? 0) / 1400;
    final projected = (_flip.value + flick).clamp(0.0, 1.0);
    final target = projected > 0.5 ? 1.0 : 0.0;
    _flip.animateTo(target, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.width * CardFace.ratio;
    return GestureDetector(
      key: const ValueKey('card-flip'),
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: SizedBox(
        width: widget.width,
        height: height,
        child: AnimatedBuilder(
          animation: Listenable.merge([_spin, _flip]),
          builder: (context, child) {
            final spinT = Curves.easeInOutCubic.transform(_spin.value);
            final flipT = Curves.easeInOutCubic.transform(_flip.value);
            final angleZ = (1 - spinT) * -math.pi * 2;
            final scale = 0.86 + 0.14 * spinT;
            final angleY = flipT * math.pi;
            final showBack = angleY > math.pi / 2;
            final face = showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: CardBackFace(card: widget.card, width: widget.width),
                  )
                : RotatedCard(card: widget.card, width: widget.width);
            return Opacity(
              opacity: _spin.value.clamp(0.0, 1.0),
              child: Transform.rotate(
                angle: angleZ,
                child: Transform.scale(
                  scale: scale,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0014)
                      ..rotateY(angleY),
                    child: face,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
