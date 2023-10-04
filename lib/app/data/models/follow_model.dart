class Follow {
  int? id;
  int? userId;
  int? followedUserId;
  String? createdAt;
  String? updatedAt;
  UserFollowed? user;
  UserFollowing? userFollowing;

  Follow(
      {this.id,
      this.userId,
      this.followedUserId,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.userFollowing});

  Follow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    followedUserId = json['followed_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? UserFollowed?.fromJson(json['user']) : null;
    userFollowing = json['user_following'] != null
        ? UserFollowing?.fromJson(json['user_following'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['followed_user_id'] = followedUserId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    if (userFollowing != null) {
      data['user_following'] = userFollowing?.toJson();
    }
    return data;
  }
}

class UserFollowed {
  int? id;
  String? name;
  dynamic username;
  String? email;
  String? emailVerifiedAt;
  dynamic birthdate;
  dynamic bio;
  dynamic links;
  dynamic phoneNumber;
  String? otpCode;
  dynamic twoFactorConfirmedAt;
  dynamic currentTeamId;
  dynamic profilePhotoPath;
  dynamic backgroundImageUrl;
  String? createdAt;
  String? updatedAt;
  String? role;
  String? file;
  String? status;
  String? profilePhotoUrl;

  UserFollowed(
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

  UserFollowed.fromJson(Map<String, dynamic> json) {
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

class UserFollowing {
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

  UserFollowing(
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

  UserFollowing.fromJson(Map<String, dynamic> json) {
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
