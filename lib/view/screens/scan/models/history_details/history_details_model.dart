// ignore_for_file: non_constant_identifier_names
import 'history_details_data_model.dart';

class HistoryDetailsModel {

	final bool success;
	final String message;
	final HistoryDetailsDataModel data;

	HistoryDetailsModel({
		required this.success,
		required this.message,
		required this.data,
	});

	factory HistoryDetailsModel.fromJson(Map<String, dynamic> json) {
		return HistoryDetailsModel(
			success: json["success"],
			message: json["message"],
			data: HistoryDetailsDataModel.fromJson(json["data"]),
		);
	}

	Map<String, dynamic> toJson() {
		return {
			"success": success,
			"message": message,
			"data": data,
		};
	}

}
