class OrdersAgent {
  String? id;
  String? feedId;
  String? name;
  String? email;
  dynamic address;
  String? phone;
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

  OrdersAgent(
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

  OrdersAgent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
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
  String? id;
  String? name;
  int? userId;
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
  RequestWithdrawTrips? requestWithdrawTrips;
  RequestCancelTrips? requestCancelTrips;

  Feeds(
      {this.id,
      this.name,
      this.userId,
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
      this.include,
      this.requestWithdrawTrips,
      this.requestCancelTrips});

  Feeds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
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
    requestWithdrawTrips = json['request_withdraw_trips'] != null
        ? RequestWithdrawTrips?.fromJson(json['request_withdraw_trips'])
        : null;
    requestCancelTrips = json['request_cancel_trips'] != null
        ? RequestCancelTrips?.fromJson(json['request_cancel_trips'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
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
    if (requestWithdrawTrips != null) {
      data['request_withdraw_trips'] = requestWithdrawTrips?.toJson();
    }
    if (requestCancelTrips != null) {
      data['request_cancel_trips'] = requestCancelTrips?.toJson();
    }
    return data;
  }
}

class RequestWithdrawTrips {
  dynamic id;
  dynamic file;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  RequestWithdrawTrips(
      {this.id, this.file, this.status, this.createdAt, this.updatedAt});

  RequestWithdrawTrips.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class RequestCancelTrips {
  dynamic id;
  dynamic reason;
  dynamic file;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  RequestCancelTrips(
      {this.id,
      this.reason,
      this.file,
      this.status,
      this.createdAt,
      this.updatedAt});

  RequestCancelTrips.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    file = json['file'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    data['file'] = file;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
