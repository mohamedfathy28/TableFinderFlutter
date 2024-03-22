// ignore_for_file: non_constant_identifier_names

class HistoryDetailsCategoryIdsModel {

	final String id;
	final int position;

	HistoryDetailsCategoryIdsModel({
		required this.id,
		required this.position,
	});

	factory HistoryDetailsCategoryIdsModel.fromJson(Map<String, dynamic> json) {
		return HistoryDetailsCategoryIdsModel(
			id: json["id"],
			position: json["position"],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			"id": id,
			"position": position,
		};
	}

}
