class ReservationTimesModel {
  final bool success;
  final String message;
  final List<List<String>> data;

  ReservationTimesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReservationTimesModel.fromJson(Map<String, dynamic> json) {
    return ReservationTimesModel(
      success: json['success'],
      message: json['message'],
      data: List<List<String>>.from(
        json['data'].map((x) => List<String>.from(x.map((x) => x))),
      ),
    );
  }
}
