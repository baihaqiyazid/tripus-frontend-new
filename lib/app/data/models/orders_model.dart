class Orders {
  String? id;
  String? feedId;
  String? name;
  String? email;
  dynamic address;
  dynamic phone;
  int? qty;
  String? bank;
  String? vaNumber;
  int? fee;
  int? adminPrice;
  int? totalPrice;
  String? status;
  String? responseMidtrans;
  String? expireTime;
  String? createdAt;
  String? updatedAt;
  Feeds? feeds;

  Orders(
      {this.id,
      this.feedId,
      this.name,
      this.email,
      this.address,
      this.phone,
      this.qty,
      this.bank,
      this.vaNumber,
      this.fee,
      this.adminPrice,
      this.totalPrice,
      this.status,
      this.responseMidtrans,
      this.expireTime,
      this.createdAt,
      this.updatedAt,
      this.feeds});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString() : null;
    feedId = json['feed_id'] != null ? json['feed_id'].toString() : null;
    name = json['name'];
    email = json['email'];
    address = json['address'];
    phone = json['phone'];
    qty = json['qty'];
    bank = json['bank'];
    vaNumber = json['va_number'];
    fee = json['fee'];
    adminPrice = json['admin_price'];
    totalPrice = json['total_price'];
    status = json['status'];
    responseMidtrans = json['response_midtrans'];
    expireTime = json['expire_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    feeds = json['feeds'] != null ? Feeds?.fromJson(json['feeds']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['feed_id'] = feedId;
    data['name'] = name;
    data['email'] = email;
    data['address'] = address;
    data['phone'] = phone;
    data['qty'] = qty;
    data['bank'] = bank;
    data['va_number'] = vaNumber;
    data['fee'] = fee;
    data['admin_price'] = adminPrice;
    data['total_price'] = totalPrice;
    data['status'] = status;
    data['response_midtrans'] = responseMidtrans;
    data['expire_time'] = expireTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (feeds != null) {
      data['feeds'] = feeds?.toJson();
    }
    return data;
  }
}

class Feeds {
  int? id;
  int? userId;
  String? agentName;
  String? description;
  String? location;
  String? meetingPoint;
  String? type;
  String? title;
  String? paymentAccount;
  int? maxPerson;
  String? dateEnd;
  String? dateStart;
  String? categoryId;
  String? others;
  String? exclude;
  String? include;

  Feeds(
      {this.id,
      this.userId,
        this.agentName,
      this.description,
      this.location,
      this.meetingPoint,
      this.type,
      this.title,
      this.paymentAccount,
      this.maxPerson,
      this.dateEnd,
      this.dateStart,
      this.categoryId,
      this.others,
      this.exclude,
      this.include});

  Feeds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    agentName = json['name'];
    description = json['description'];
    location = json['location'];
    meetingPoint = json['meeting_point'];
    type = json['type'];
    title = json['title'];
    paymentAccount = json['payment_account'];
    maxPerson = json['max_person'];
    dateEnd = json['date_end'];
    dateStart = json['date_start'];
    categoryId = json['category_id'];
    others = json['others'];
    exclude = json['exclude'];
    include = json['include'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = agentName;
    data['description'] = description;
    data['location'] = location;
    data['meeting_point'] = meetingPoint;
    data['type'] = type;
    data['title'] = title;
    data['payment_account'] = paymentAccount;
    data['max_person'] = maxPerson;
    data['date_end'] = dateEnd;
    data['date_start'] = dateStart;
    data['category_id'] = categoryId;
    data['others'] = others;
    data['exclude'] = exclude;
    data['include'] = include;
    return data;
  }
}
