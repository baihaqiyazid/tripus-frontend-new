class Withdraw {
  int? feedId;
  String? file;
  String? status;
  String? updatedAt;
  String? createdAt;
  int? id;

  Withdraw(
      {this.feedId,
      this.file,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.id});

  Withdraw.fromJson(Map<String, dynamic> json) {
    feedId = json['feed_id'];
    file = json['file'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['feed_id'] = feedId;
    data['file'] = file;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
