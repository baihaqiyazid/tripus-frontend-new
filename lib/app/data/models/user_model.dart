class User {
  int? id;
  String? name;
  dynamic username;
  String? email;
  String? address;
  String? token;
  dynamic emailVerifiedAt;
  dynamic birthdate;
  dynamic bio;
  dynamic links;
  dynamic phoneNumber;
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
  List<ChatUser>? chats;


  User({this.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.token,
    this.emailVerifiedAt,
    this.birthdate,
    this.bio,
    this.links,
    this.phoneNumber,
    this.otpCode,
    this.twoFactorConfirmedAt,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.file,
    this.status,
    this.profilePhotoUrl,
    this.chats,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    name = json['name'];
    username = json['username'];
    email = json['email'];
    address = json['address'];
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
    data['role'] = role;
    data['username'] = username;
    data['email'] = email;
    data['address'] = address;
    data['token'] = token;
    data['email_verified_at'] = emailVerifiedAt;
    data['birthdate'] = birthdate;
    data['bio'] = bio;
    data['links'] = links;
    data['file'] = file;
    data['status'] = status;
    data['phone_number'] = phoneNumber;
    data['otp_code'] = otpCode;
    data['profile_photo_path'] = profilePhotoPath;
    data['background_image_url'] = backgroundImageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['profile_photo_url'] = profilePhotoUrl;
    return data;
  }
}

class ChatUser {
  ChatUser({
    this.connection,
    this.chatId,
    this.lastTime,
    this.total_unread,
  });

  String? connection;
  String? chatId;
  String? lastTime;
  int? total_unread;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
    connection: json["connection"],
    chatId: json["chat_id"],
    lastTime: json["lastTime"],
    total_unread: json["total_unread"],
  );

  Map<String, dynamic> toJson() => {
    "connection": connection,
    "chat_id": chatId,
    "lastTime": lastTime,
    "total_unread": total_unread,
  };
}
