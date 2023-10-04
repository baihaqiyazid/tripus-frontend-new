class Feed {
  int? id;
  int? userId;
  String? description;
  String? location;
  String? createdAt;
  String? updatedAt;
  List<FeedImage>? feedImage;

  Feed(
      {this.id,
      this.userId,
      this.description,
      this.location,
      this.createdAt,
      this.updatedAt,
      this.feedImage});

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    userId = json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null;
    description = json['description'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['feed_image'] != null) {
      feedImage = <FeedImage>[];
      json['feed_image'].forEach((v) {
        feedImage?.add(FeedImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['description'] = description;
    data['location'] = location;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (feedImage != null) {
      data['feed_image'] = feedImage?.map((v) => v.toJson()).toList();
    }
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
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    feedId = json['feed_id'] != null ? int.tryParse(json['feed_id'].toString()) : null;
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
