class FeedsHome {
  int? id;
  int? userId;
  String? description;
  String? location;
  String? meetingPoint;
  String? type;
  String? title;
  String? paymentAccount;
  int? maxPerson;
  int? fee;
  String? dateEnd;
  String? dateStart;
  String? categoryId;
  String? others;
  String? exclude;
  String? include;
  String? createdAt;
  String? updatedAt;
  UserHome? user;
  List<FeedImage>? feedImage;
  List<FeedsHomeLikes>? feedsLikes;
  List<FeedsHomeLikes>? feedsSaves;
  List<FeedsHomeLikes>? feedsJoin;
  List<CancelTrip>? cancelTrip;
  List<WithdrawTrip>? withdrawTrip;

  FeedsHome(
      {this.id,
      this.userId,
      this.description,
      this.location,
      this.meetingPoint,
      this.type,
      this.title,
      this.paymentAccount,
      this.maxPerson,
      this.fee,
      this.dateEnd,
      this.dateStart,
      this.categoryId,
      this.others,
      this.exclude,
      this.include,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.feedImage,
      this.feedsLikes,
      this.feedsSaves,
      this.feedsJoin,
      this.cancelTrip,
      this.withdrawTrip});

  FeedsHome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    description = json['description'];
    location = json['location'];
    meetingPoint = json['meeting_point'];
    type = json['type'];
    title = json['title'];
    paymentAccount = json['payment_account'];
    maxPerson = json['max_person'];
    fee = json['fee'];
    dateEnd = json['date_end'];
    dateStart = json['date_start'];
    categoryId = json['category_id'];
    others = json['others'];
    exclude = json['exclude'];
    include = json['include'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? UserHome?.fromJson(json['user']) : null;
    if (json['feed_image'] != null) {
      feedImage = <FeedImage>[];
      json['feed_image'].forEach((v) {
        feedImage?.add(FeedImage.fromJson(v));
      });
    }
    if (json['feeds_likes'] != null) {
      feedsLikes = <FeedsHomeLikes>[];
      json['feeds_likes'].forEach((v) {
        feedsLikes?.add(FeedsHomeLikes.fromJson(v));
      });
    }
    if (json['feeds_saves'] != null) {
      feedsSaves = <FeedsHomeLikes>[];
      json['feeds_saves'].forEach((v) {
        feedsSaves?.add(FeedsHomeLikes.fromJson(v));
      });
    }
    if (json['feeds_join'] != null) {
      feedsJoin = <FeedsHomeLikes>[];
      json['feeds_join'].forEach((v) {
        feedsJoin?.add(FeedsHomeLikes.fromJson(v));
      });
    }
    if (json['cancel_trip'] != null) {
      cancelTrip = <CancelTrip>[];
      json['cancel_trip'].forEach((v) {
        cancelTrip?.add(CancelTrip.fromJson(v));
      });
    }
    if (json['withdraw_trip'] != null) {
      withdrawTrip = <WithdrawTrip>[];
      json['withdraw_trip'].forEach((v) {
        withdrawTrip?.add(WithdrawTrip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['description'] = description;
    data['location'] = location;
    data['meeting_point'] = meetingPoint;
    data['type'] = type;
    data['title'] = title;
    data['payment_account'] = paymentAccount;
    data['max_person'] = maxPerson;
    data['fee'] = fee;
    data['date_end'] = dateEnd;
    data['date_start'] = dateStart;
    data['category_id'] = categoryId;
    data['others'] = others;
    data['exclude'] = exclude;
    data['include'] = include;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    if (feedImage != null) {
      data['feed_image'] = feedImage?.map((v) => v.toJson()).toList();
    }
    if (feedsLikes != null) {
      data['feeds_likes'] = feedsLikes?.map((v) => v.toJson()).toList();
    }
    if (feedsSaves != null) {
      data['feeds_saves'] = feedsSaves?.map((v) => v.toJson()).toList();
    }
    if (feedsJoin != null) {
      data['feeds_join'] = feedsJoin?.map((v) => v.toJson()).toList();
    }
    if (cancelTrip != null) {
      data['cancel_trip'] = cancelTrip?.map((v) => v.toJson()).toList();
    }
    if (withdrawTrip != null) {
      data['withdraw_trip'] = withdrawTrip?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserHome {
  int? id;
  String? name;
  dynamic username;
  String? email;
  String? emailVerifiedAt;
  String? birthdate;
  String? bio;
  String? links;
  String? phoneNumber;
  String? otpCode;
  dynamic twoFactorConfirmedAt;
  dynamic currentTeamId;
  String? profilePhotoPath;
  String? backgroundImageUrl;
  String? createdAt;
  String? updatedAt;
  String? role;
  String? file;
  String? status;
  String? profilePhotoUrl;

  UserHome(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.emailVerifiedAt,
      this.birthdate,
      this.bio,
      this.links,
      this.phoneNumber,
      this.otpCode,
      this.twoFactorConfirmedAt,
      this.currentTeamId,
      this.profilePhotoPath,
      this.backgroundImageUrl,
      this.createdAt,
      this.updatedAt,
      this.role,
      this.file,
      this.status,
      this.profilePhotoUrl});

  UserHome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    birthdate = json['birthdate'];
    bio = json['bio'];
    links = json['links'];
    phoneNumber = json['phone_number'];
    otpCode = json['otp_code'];
    twoFactorConfirmedAt = json['two_factor_confirmed_at'];
    currentTeamId = json['current_team_id'];
    profilePhotoPath = json['profile_photo_path'];
    backgroundImageUrl = json['background_image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'];
    file = json['file'];
    status = json['status'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['birthdate'] = birthdate;
    data['bio'] = bio;
    data['links'] = links;
    data['phone_number'] = phoneNumber;
    data['otp_code'] = otpCode;
    data['two_factor_confirmed_at'] = twoFactorConfirmedAt;
    data['current_team_id'] = currentTeamId;
    data['profile_photo_path'] = profilePhotoPath;
    data['background_image_url'] = backgroundImageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['role'] = role;
    data['file'] = file;
    data['status'] = status;
    data['profile_photo_url'] = profilePhotoUrl;
    return data;
  }
}

class FeedImage {
  int? id;
  int? feedId;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  FeedImage(
      {this.id, this.feedId, this.imageUrl, this.createdAt, this.updatedAt});

  FeedImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['feed_id'] = feedId;
    data['image_url'] = imageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class FeedsHomeLikes {
  int? id;
  int? feedId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  FeedsHomeLikes(
      {this.id, this.feedId, this.userId, this.createdAt, this.updatedAt});

  FeedsHomeLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['feed_id'] = feedId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CancelTrip {
  int? id;
  int? feedId;
  String? file;
  String? reason;
  String? status;
  String? createdAt;
  String? updatedAt;

  CancelTrip(
      {this.id,
      this.feedId,
      this.file,
      this.reason,
      this.status,
      this.createdAt,
      this.updatedAt});

  CancelTrip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    file = json['file'];
    reason = json['reason'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['feed_id'] = feedId;
    data['file'] = file;
    data['reason'] = reason;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class WithdrawTrip {
  int? id;
  int? feedId;
  String? file;
  String? status;
  String? createdAt;
  String? updatedAt;

  WithdrawTrip(
      {this.id,
      this.feedId,
      this.file,
      this.status,
      this.createdAt,
      this.updatedAt});

  WithdrawTrip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    file = json['file'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['feed_id'] = feedId;
    data['file'] = file;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
