class ReviewModel {
  final int orderId;
  final int rating;
  final String comment;
  final String nickName;
  final int userId;
  final int storeId;
  final List menuList;
  final List replies;

  ReviewModel({
    required this.orderId,
    required this.rating,
    required this.comment,
    required this.nickName,
    required this.userId,
    required this.storeId,
    required this.menuList,
    required this.replies,
  });

  ReviewModel.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'] ?? 0,
        rating = json['rating'] ?? 0,
        comment = json['comment'] ?? '',
        nickName = json['nickName'] ?? '',
        userId = json['userId'] ?? 0,
        storeId = json['storeId'] ?? 0,
        menuList = json['nickName'] ?? [],
        replies = json['nickName'] ?? [];

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'rating': rating,
      'comment': comment,
      'nickName': nickName,
      'userId': userId,
      'storeId': storeId,
      'menuList': menuList,
      'replise': replies,
    };
  }
}
