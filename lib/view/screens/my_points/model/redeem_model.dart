class RedeemModel {
  final int id;
  final String title;
  final String points;
  final String value;

  RedeemModel({
    required this.id,
    required this.title,
    required this.points,
    required this.value,
  });

  factory RedeemModel.fromJson(Map<String, dynamic> json) {
    return RedeemModel(
      id: json['id'],
      title: json['title'],
      points: json['points'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'points': points,
      'value': value,
    };
  }
}
