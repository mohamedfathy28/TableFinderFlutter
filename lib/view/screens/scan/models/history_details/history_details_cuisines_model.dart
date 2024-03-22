// ignore_for_file: non_constant_identifier_names

class HistoryDetailsCuisinesModel {

	final int id;
	final String name;
	final String image;

	HistoryDetailsCuisinesModel({
		required this.id,
		required this.name,
		required this.image,
	});

	factory HistoryDetailsCuisinesModel.fromJson(Map<String, dynamic> json) {
		return HistoryDetailsCuisinesModel(
			id: json["id"],
			name: json["name"],
			image: json["image"],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			"id": id,
			"name": name,
			"image": image,
		};
	}

}
