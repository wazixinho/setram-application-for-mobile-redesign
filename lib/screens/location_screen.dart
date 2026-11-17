import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/design.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _sheetOpen = true;
  bool _route = false;
  int _station = 0;

  static const _stations = [
    (name: 'MAGHARIA', labelKey: 'closest', distance: '4.5 km', car: '5 min', walk: '39 min', trip: '2.9 km'),
    (name: 'CAROUBIER', labelKey: 'second_closest', distance: '3.0 km', car: '7 min', walk: '1h 2min', trip: '4.5 km'),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    final text = lang.t;
    final station = _stations[_station];
    final sheetHeight = _sheetOpen ? (_route ? 316.0 : 318.0) : 0.0;

    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/map_demo.jpg', fit: BoxFit.cover)),
        if (_route)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _RoutePainter(station: _station)),
            ),
          ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: NavyHeader(
            title: text('position'),
            trailing: IconButton(
              onPressed: () => _showContact(context),
              icon: const Icon(Icons.call_outlined, color: Colors.white, size: 24),
            ),
          ),
        ),
        Positioned(
          top: 130,
          right: 16,
          child: Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 14)],
            ),
            child: const Icon(Icons.layers_outlined, color: AppColors.navy, size: 24),
          ),
        ),
        if (!_route) ...[
          Positioned(left: 90, top: 190, child: _StationMarker(label: 'MACHARIA')),
          Positioned(left: 200, top: 218, child: _StationMarker(label: 'CAROUBIER')),
        ],
        Positioned(
          left: 130,
          bottom: sheetHeight + 120,
          child: _MyPosition(),
        ),
        if (_sheetOpen)
          Positioned(
            right: 16,
            bottom: sheetHeight + 16,
            child: GestureDetector(
              onTap: () => setState(() {
                _route = true;
                _station = 0;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.navyDeep,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 18, offset: Offset(0, 8))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.navigation_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      text('explore'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (!_sheetOpen)
          Positioned(
            right: 16,
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.navy,
              onPressed: () => setState(() => _sheetOpen = true),
              child: const Icon(Icons.place_rounded),
            ),
          ),
        if (_sheetOpen)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _route
                ? _RouteSheet(
                    station: station,
                    onBack: () => setState(() => _route = false),
                    onClose: () => setState(() => _sheetOpen = false),
                    onGo: () => showAppSnack(context, '${text('itinerary')} — ${station.name} (démo)'),
                  )
                : _StationsSheet(
                    stations: _stations,
                    onClose: () => setState(() => _sheetOpen = false),
                    onSelect: (index) => setState(() {
                      _station = index;
                      _route = true;
                    }),
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

class _StationsSheet extends StatelessWidget {
  const _StationsSheet({required this.stations, required this.onClose, required this.onSelect});

  final List<({String name, String labelKey, String distance, String car, String walk, String trip})> stations;
  final VoidCallback onClose;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final text = context.appLang.t;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 20, offset: Offset(0, -6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: Text(text('nearby_stations'), style: AppText.h2.copyWith(fontSize: 22))),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close_rounded, color: AppColors.muted, size: 26),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(text('stations_hint'), style: AppText.bodyMuted.copyWith(fontSize: 14)),
          const SizedBox(height: 16),
          for (var i = 0; i < stations.length; i++) ...[
            GestureDetector(
              onTap: () => onSelect(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.place_rounded, color: AppColors.red, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text(stations[i].labelKey),
                            style: const TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                          Text(
                            stations[i].name,
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          stations[i].distance,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              text('itinerary'),
                              style: const TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.navigation_rounded, color: AppColors.navy, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (i != stations.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _RouteSheet extends StatefulWidget {
  const _RouteSheet({
    required this.station,
    required this.onBack,
    required this.onClose,
    required this.onGo,
  });

  final ({String name, String labelKey, String distance, String car, String walk, String trip}) station;
  final VoidCallback onBack;
  final VoidCallback onClose;
  final VoidCallback onGo;

  @override
  State<_RouteSheet> createState() => _RouteSheetState();
}

class _RouteSheetState extends State<_RouteSheet> {
  bool _car = true;

  @override
  Widget build(BuildContext context) {
    final text = context.appLang.t;
    final duration = _car ? widget.station.car : widget.station.walk;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 20, offset: Offset(0, -6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(onTap: widget.onBack, child: const Icon(Icons.arrow_back_rounded, size: 26)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text('car'), style: AppText.h1.copyWith(fontSize: 26)),
                    Text(
                      widget.station.name,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.onClose,
                child: const Icon(Icons.close_rounded, color: AppColors.muted, size: 26),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _car = true),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, bottom: 6),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car_filled_rounded,
                            size: 22,
                            color: _car ? AppColors.cyanDeep : AppColors.muted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.station.car,
                            style: TextStyle(
                              color: _car ? AppColors.cyanDeep : AppColors.muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 76,
                        height: 3,
                        color: _car ? AppColors.cyanDeep : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _car = false),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_walk_rounded,
                      size: 24,
                      color: !_car ? AppColors.cyanDeep : AppColors.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.station.walk,
                      style: TextStyle(
                        color: !_car ? AppColors.cyanDeep : AppColors.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(duration, style: AppText.h1.copyWith(fontSize: 30)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '(${widget.station.trip})',
                  style: const TextStyle(color: AppColors.muted, fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            label: text('itinerary'),
            icon: Icons.navigation_rounded,
            onPressed: widget.onGo,
            color: AppColors.navy,
          ),
        ],
      ),
    );
  }
}

class _StationMarker extends StatelessWidget {
  const _StationMarker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.red, width: 1.6),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.red,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const Icon(Icons.location_on, color: AppColors.red, size: 34),
      ],
    );
  }
}

class _MyPosition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x55F7A21B), blurRadius: 18)],
          ),
          child: const Icon(Icons.my_location_rounded, color: Colors.white, size: 28),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(6)),
          child: Text(
            context.appLang.t('my_position'),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _RoutePainter extends CustomPainter {
  _RoutePainter({required this.station});

  final int station;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.navyDeep
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final start = Offset(size.width * 0.5, size.height * 0.2);
    final end = Offset(size.width * 0.38, size.height * 0.56);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(size.width * 0.62, size.height * 0.27)
      ..lineTo(size.width * 0.6, size.height * 0.36)
      ..lineTo(size.width * 0.46, size.height * 0.45)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(end.dx, end.dy);
    final shadow = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, shadow);
    canvas.drawPath(path, paint);
    canvas.drawCircle(start, 8, Paint()..color = AppColors.red);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) => oldDelegate.station != station;
}
