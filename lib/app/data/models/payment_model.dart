class Payment {
  int? userId;
  String? paymentMethodId;
  int? number;
  String? updatedAt;
  String? createdAt;
  int? id;

  Payment(
      {this.userId,
      this.paymentMethodId,
      this.number,
      this.updatedAt,
      this.createdAt,
      this.id});

  Payment.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null;
    paymentMethodId = json['payment_method_id'];
    number = int.parse(json['number']);
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['payment_method_id'] = paymentMethodId;
    data['number'] = number;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
