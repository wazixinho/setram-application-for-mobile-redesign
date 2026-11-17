import 'app_lang.dart';

enum CardArt { blue, red }

extension CardArtX on CardArt {
  String get asset => switch (this) {
        CardArt.blue => 'assets/cartes/card_alg.png',
        CardArt.red => 'assets/images/CARTE-CSC-ROUGE.png',
      };

  String label(AppLang lang) => switch (this) {
        CardArt.blue => lang == AppLang.ar ? 'أزرق' : 'Bleu SETRAM',
        CardArt.red => lang == AppLang.ar ? 'أحمر' : 'Rouge SETRAM',
      };
}

class CardModel {
  CardModel({
    required this.id,
    required this.product,
    required this.lastName,
    required this.firstName,
    required this.number,
    required this.expiry,
    required this.agency,
    this.durationLabel = '90 Jours',
    this.remainingDays = 144,
    this.status = 'ACTIF',
    DateTime? generatedAt,
    this.photoAsset = 'assets/images/card_photo.png',
    this.art = CardArt.blue,
    this.showQr = true,
  }) : generatedAt = generatedAt ?? DateTime(2026, 10, 4, 21, 28, 47);

  final String id;
  String product;
  String lastName;
  String firstName;
  String number;
  DateTime expiry;
  String agency;
  String durationLabel;
  int remainingDays;
  String status;
  DateTime generatedAt;
  String photoAsset;
  CardArt art;
  bool showQr;

  bool get isActive => status.toUpperCase() == 'ACTIF';

  String get fullName => [firstName, lastName].where((e) => e.trim().isNotEmpty).join(' ').trim();

  CardModel copyWith({
    String? product,
    String? lastName,
    String? firstName,
    String? number,
    DateTime? expiry,
    String? agency,
    String? durationLabel,
    int? remainingDays,
    String? status,
    DateTime? generatedAt,
    String? photoAsset,
    CardArt? art,
    bool? showQr,
  }) {
    return CardModel(
      id: id,
      product: product ?? this.product,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      number: number ?? this.number,
      expiry: expiry ?? this.expiry,
      agency: agency ?? this.agency,
      durationLabel: durationLabel ?? this.durationLabel,
      remainingDays: remainingDays ?? this.remainingDays,
      status: status ?? this.status,
      generatedAt: generatedAt ?? this.generatedAt,
      photoAsset: photoAsset ?? this.photoAsset,
      art: art ?? this.art,
      showQr: showQr ?? this.showQr,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product,
        'lastName': lastName,
        'firstName': firstName,
        'number': number,
        'expiry': expiry.toIso8601String(),
        'agency': agency,
        'durationLabel': durationLabel,
        'remainingDays': remainingDays,
        'status': status,
        'generatedAt': generatedAt.toIso8601String(),
        'photoAsset': photoAsset,
        'art': art.name,
        'showQr': showQr,
      };

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        id: json['id'] as String,
        product: json['product'] as String? ?? 'eTWASSEL Étudiant',
        lastName: json['lastName'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        number: json['number'] as String? ?? '',
        expiry: DateTime.tryParse(json['expiry'] as String? ?? '') ?? DateTime(2027, 2, 25),
        agency: json['agency'] as String? ?? 'Tramway de Sidi Bel Abbes',
        durationLabel: json['durationLabel'] as String? ?? '90 Jours',
        remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 144,
        status: json['status'] as String? ?? 'ACTIF',
        generatedAt: DateTime.tryParse(json['generatedAt'] as String? ?? ''),
        photoAsset: json['photoAsset'] as String? ?? 'assets/images/card_photo.png',
        art: CardArt.values.byName(json['art'] as String? ?? 'blue'),
        showQr: json['showQr'] as bool? ?? true,
      );
}

class ProfileModel {
  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.wilaya,
    required this.profession,
    this.memberSince = 2026,
  });

  String firstName;
  String lastName;
  String email;
  String phone;
  String wilaya;
  String profession;
  int memberSince;

  String get fullName => '$firstName $lastName'.trim();

  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'wilaya': wilaya,
        'profession': profession,
        'memberSince': memberSince,
      };

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        wilaya: json['wilaya'] as String? ?? 'Alger',
        profession: json['profession'] as String? ?? '',
        memberSince: (json['memberSince'] as num?)?.toInt() ?? 2026,
      );
}

class Doleance {
  Doleance({
    required this.id,
    required this.subject,
    required this.category,
    required this.message,
    required this.createdAt,
    this.tramway = "Tramway d'Alger",
    this.status = 'En cours',
    this.severity = 'Faible',
  });

  final String id;
  final String subject;
  final String category;
  final String message;
  final DateTime createdAt;
  final String tramway;
  final String status;
  final String severity;

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'category': category,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'tramway': tramway,
        'status': status,
        'severity': severity,
      };

  factory Doleance.fromJson(Map<String, dynamic> json) => Doleance(
        id: json['id'] as String,
        subject: json['subject'] as String? ?? '',
        category: json['category'] as String? ?? '',
        message: json['message'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        tramway: json['tramway'] as String? ?? "Tramway d'Alger",
        status: json['status'] as String? ?? 'En cours',
        severity: json['severity'] as String? ?? 'Faible',
      );
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.title,
    required this.price,
    required this.paidLabel,
    required this.statusLabel,
    required this.expiryDate,
    required this.createdAt,
    required this.agency,
  });

  final String id;
  final String title;
  final String price;
  final String paidLabel;
  final String statusLabel;
  final DateTime expiryDate;
  final DateTime createdAt;
  final String agency;
}

enum NotificationKind { info, warning, success, promo }

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.kind = NotificationKind.info,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime date;
  final NotificationKind kind;
  bool read;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'date': date.toIso8601String(),
        'kind': kind.name,
        'read': read,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        kind: NotificationKind.values.byName(json['kind'] as String? ?? 'info'),
        read: json['read'] as bool? ?? false,
      );
}

const List<String> kAgencies = [
  "Tramway d'Alger",
  'Tramway de Constantine',
  'Tramway de Sétif',
  'Tramway de Ouargla',
  'Tramway de Sidi Bel Abbes',
];

const List<String> kDoleanceCategories = [
  'Retard',
  'Propreté',
  'Sécurité',
  'Information',
  'Autres',
];

ProfileModel demoProfile() => ProfileModel(
      firstName: 'Setram',
      lastName: 'A.',
      email: 'setramapp@gmail.com',
      phone: '0550 12 34 56',
      wilaya: 'Alger',
      profession: 'Étudiant',
      memberSince: 2026,
    );

List<CardModel> demoCards() => [
      CardModel(
        id: 'card-etudiant',
        product: 'eTWASSEL Étudiant',
        lastName: 'APP',
        firstName: 'SETRAM',
        number: '1262 70',
        expiry: DateTime(2027, 2, 25),
        agency: 'Tramway de Sidi Bel Abbes',
        durationLabel: '90 Jours',
        remainingDays: 144,
        status: 'ACTIF',
        generatedAt: DateTime(2026, 10, 4, 21, 28, 47),
        photoAsset: 'assets/images/card_photo.png',
        art: CardArt.blue,
      ),
    ];

List<OrderModel> demoOrders() => [
      OrderModel(
        id: '#ORD00032151',
        title: 'Abonnement trimestriel étudiant (90 jours)',
        price: '1800 DA',
        paidLabel: 'Payé',
        statusLabel: 'Expiré',
        expiryDate: DateTime(2026, 2, 1),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        agency: 'Tramway de Sidi Bel Abbes',
      ),
      OrderModel(
        id: '#ORD00032874',
        title: 'Abonnement mensuel étudiant (30 jours)',
        price: '400 DA',
        paidLabel: 'Payé',
        statusLabel: 'Actif',
        expiryDate: DateTime(2026, 12, 5),
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        agency: "Tramway d'Alger",
      ),
    ];

List<Doleance> demoDoleances() => [
      Doleance(
        id: '#SET-7882',
        subject: 'test',
        category: 'Autres',
        message: 'test',
        createdAt: DateTime(2026, 5, 25),
        tramway: "Tramway d'Alger",
        status: 'Clôturé',
        severity: 'Faible',
      ),
    ];

List<AppNotification> demoNotifications() {
  final now = DateTime.now();
  return [
    AppNotification(
      id: 'n1',
      title: 'Alerte trafic',
      body: "Trafic normal sur l'ensemble des lignes. Bon voyage !",
      date: now.subtract(const Duration(hours: 1)),
      kind: NotificationKind.success,
    ),
    AppNotification(
      id: 'n2',
      title: 'Votre abonnement est actif',
      body: "Votre carte eTWASSEL Étudiant est valable jusqu'au 25/02/2027.",
      date: now.subtract(const Duration(days: 1)),
      kind: NotificationKind.info,
    ),
    AppNotification(
      id: 'n3',
      title: 'Doléance clôturée',
      body: 'Votre doléance #SET-7882 a été traitée par le service client.',
      date: now.subtract(const Duration(days: 3)),
      kind: NotificationKind.success,
      read: true,
    ),
    AppNotification(
      id: 'n4',
      title: 'Nouveaux horaires',
      body: "Les horaires d'exploitation ont été mis à jour sur les deux lignes.",
      date: now.subtract(const Duration(days: 5)),
      kind: NotificationKind.promo,
      read: true,
    ),
  ];
}

String two(int value) => value.toString().padLeft(2, '0');

String fmtDate(DateTime? date) {
  if (date == null) return '—';
  return '${date.year}-${two(date.month)}-${two(date.day)}';
}

String fmtDateShort(DateTime? date) {
  if (date == null) return '—';
  return '${two(date.day)}/${two(date.month)}/${date.year}';
}

String fmtDateTime(DateTime date) =>
    '${date.year}-${two(date.month)}-${two(date.day)} ${two(date.hour)}:${two(date.minute)}:${two(date.second)}';

String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inDays >= 60) return 'il y a ${(diff.inDays / 30).floor()} mois';
  if (diff.inDays >= 30) return 'il y a 1 mois';
  if (diff.inDays >= 1) return 'il y a ${diff.inDays} j';
  if (diff.inHours >= 1) return 'il y a ${diff.inHours} h';
  return "à l'instant";
}

String fmtMoney(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(text[i]);
  }
  return '${buffer.toString()} DA';
}
