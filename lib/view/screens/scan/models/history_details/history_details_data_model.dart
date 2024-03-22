// ignore_for_file: non_constant_identifier_names
import 'history_details_order_details_model.dart';

class HistoryDetailsDataModel {
  final int id;
  final String restaurant_name;
  final String restaurant_logo;
  final String total;
  final int guest;
  final dynamic table_number;
  final String status;
  final List<HistoryDetailsOrderDetailsModel> order_details;
  final bool can_cancel;
  final String date_time;

  HistoryDetailsDataModel(
      {required this.id,
      required this.restaurant_name,
      required this.restaurant_logo,
      required this.total,
      required this.guest,
      required this.table_number,
      required this.status,
      required this.order_details,
      required this.can_cancel,
      required this.date_time});

  factory HistoryDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailsDataModel(
      id: json["id"],
      restaurant_name: json["restaurant_name"],
      restaurant_logo: json["restaurant_logo"],
      total: json["total"],
      guest: json["guest"],
      table_number: json["table_number"],
      status: json["status"],
      order_details: List<HistoryDetailsOrderDetailsModel>.from(
          json["order_details"]
              .map((x) => HistoryDetailsOrderDetailsModel.fromJson(x))),
      can_cancel: json["can_cancel"],
      date_time: json["date_time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "restaurant_name": restaurant_name,
      "restaurant_logo": restaurant_logo,
      "total": total,
      "guest": guest,
      "table_number": table_number,
      "status": status,
      "order_details": order_details,
      "can_cancel": can_cancel,
      "date_time": date_time.toString(),
    };
  }
}
