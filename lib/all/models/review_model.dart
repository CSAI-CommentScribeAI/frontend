class ReviewModel {
  final String comment;
  final double rating;

  ReviewModel({
    required this.comment,
    required this.rating,
  });

  ReviewModel.fromJson(Map<String, dynamic> json)
      : comment = json['comment'] ?? '',
        rating = json['rating'] ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'rating': rating,
    };
  }
}
