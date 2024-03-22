// ignore_for_file: non_constant_identifier_names

class ReserveHistoryModel {
  final bool success;
  final String message;
  final List<ReserveHistoryItemModel> data;

  ReserveHistoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReserveHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReserveHistoryModel(
      success: json['success'],
      message: json['message'],
      data: List<ReserveHistoryItemModel>.from(
        json['data'].map(
          (x) => ReserveHistoryItemModel.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    };
  }
}

class ReserveHistoryItemModel {
  final int id;
  final String restaurant_name;
  final String restaurant_logo;
  final String total;
  final int guest;
  final String? table_number;
  final String status;
  final bool can_cancel;

  ReserveHistoryItemModel({
    required this.restaurant_logo,
    required this.total,
    required this.guest,
    required this.table_number,
    required this.status,
    required this.id,
    required this.restaurant_name,
    required this.can_cancel,
  });

  factory ReserveHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ReserveHistoryItemModel(
      id: json['id'],
      restaurant_name: json['restaurant_name'],
      restaurant_logo: json['restaurant_logo'],
      total: json['total'].toString(),
      guest: json['guest'],
      table_number: json['table_number'],
      status: json['status'],
      can_cancel: json['can_cancel'],
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
      "can_cancel": can_cancel,
    };
  }
}
