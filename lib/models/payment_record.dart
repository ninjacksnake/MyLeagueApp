class PaymentRecord {
  final String id;
  final double amount;
  final DateTime date;
  final String notes;

  PaymentRecord({
    required this.id,
    required this.amount,
    required this.date,
    required this.notes,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  PaymentRecord copyWith({
    String? id,
    double? amount,
    DateTime? date,
    String? notes,
  }) {
    return PaymentRecord(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}
