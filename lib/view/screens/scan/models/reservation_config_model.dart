// ignore_for_file: non_constant_identifier_names

class ReservationModel {
  final bool success;
  final String message;
  final ReservationDataModel data;

  ReservationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      success: json['success'],
      message: json['message'],
      data: ReservationDataModel.fromJson(json['data']),
    );
  }
}

class ReservationDataModel {
  final ConfigModel config;
  final List<DayModel> days;
  final List<DataItemModel> area_selection;
  final String? CancellationPolicy;

  ReservationDataModel({
    required this.CancellationPolicy,
    required this.config,
    required this.days,
    required this.area_selection,
  });

  factory ReservationDataModel.fromJson(Map<String, dynamic> json) {
    return ReservationDataModel(
      config: ConfigModel.fromJson(json['config']),
      days: List<DayModel>.from(
        json['new_data'].map(
          (x) => DayModel.fromJson(x),
        ),
      ),
      area_selection: List<DataItemModel>.from(
        json['area_selection'].map(
          (x) => DataItemModel.fromJson(x),
        ),
      ),
      CancellationPolicy: json['CancellationPolicy'],
    );
  }
}

class ConfigModel {
  final bool fees_status;
  final String reservation_fees;
  final bool minim_order_status;
  final String minim_order;
  final bool required_order;
  final bool minim_order_pay_status;
  final String minim_order_pay;

  ConfigModel({
    required this.fees_status,
    required this.reservation_fees,
    required this.minim_order_status,
    required this.minim_order,
    required this.required_order,
    required this.minim_order_pay_status,
    required this.minim_order_pay,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      fees_status: json['fees_status'],
      reservation_fees: json['reservation_fees'],
      minim_order_status: json['minim_order_status'],
      minim_order: json['minim_order'],
      required_order: json['required_order'],
      minim_order_pay_status: json['minim_order_pay_status'],
      minim_order_pay: json['minim_order_pay'],
    );
  }
}

class DataItemModel {
  final int id;
  final String name;

  DataItemModel({required this.id, required this.name});

  factory DataItemModel.fromJson(Map<String, dynamic> json) {
    return DataItemModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

class DayModel {
  final String day;
  final String day_month;
  final String value;

  DayModel({
    required this.day,
    required this.day_month,
    required this.value,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      day: json['day'],
      day_month: json['day_month'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "day_month": day_month,
      "value": value,
    };
  }
}
