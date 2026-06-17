import 'payment_record.dart';

class Player {
  final String id;
  final String name;
  final int? jerseyNumber;
  final String? position;
  final int? age;
  final String? phone;
  final String? email;
  final double? monthlyFee;
  final List<PaymentRecord> payments;

  Player({
    required this.id,
    required this.name,
    this.jerseyNumber,
    this.position,
    this.age,
    this.phone,
    this.email,
    this.monthlyFee,
    this.payments = const [],
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      jerseyNumber: json['jerseyNumber'] as int?,
      position: json['position'] as String?,
      age: json['age'] as int?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      monthlyFee: json['monthlyFee'] != null ? (json['monthlyFee'] as num).toDouble() : null,
      payments: json['payments'] != null
          ? (json['payments'] as List<dynamic>)
              .map((e) => PaymentRecord.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'jerseyNumber': jerseyNumber,
      'position': position,
      'age': age,
      'phone': phone,
      'email': email,
      'monthlyFee': monthlyFee,
      'payments': payments.map((e) => e.toJson()).toList(),
    };
  }

  Player copyWith({
    String? id,
    String? name,
    int? jerseyNumber,
    String? position,
    int? age,
    String? phone,
    String? email,
    double? monthlyFee,
    List<PaymentRecord>? payments,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      position: position ?? this.position,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      payments: payments ?? this.payments,
    );
  }
}

