class SpentModel {
  final int id;
  final String title;
  final String date;
  final String points;
  final String amount;

  SpentModel({
    required this.id,
    required this.title,
    required this.date,
    required this.points,
    required this.amount,
  });

  factory SpentModel.fromJson(Map<String, dynamic> json) {
    return SpentModel(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      points: json['points'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'points': points,
      'amount': amount,
    };
  }
}
