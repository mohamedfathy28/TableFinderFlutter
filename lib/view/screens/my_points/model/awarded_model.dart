// ignore_for_file: non_constant_identifier_names

class AwardedModel {
  final int id;
  final String order_number;
  final String date;
  final String points;
  final String exp_date;
  final String title;

  AwardedModel({
    required this.id,
    required this.order_number,
    required this.date,
    required this.points,
    required this.exp_date,
    required this.title,
  });

  factory AwardedModel.fromJson(Map<String, dynamic> json) {
    return AwardedModel(
      id: json['id'],
      order_number: json['order_number'],
      date: json['date'],
      points: json['points'],
      exp_date: json['exp_date'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': order_number,
      'date': date,
      'points': points,
      'exp_date': exp_date,
      'title': title,
    };
  }
}
