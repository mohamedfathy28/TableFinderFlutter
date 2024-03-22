// ignore_for_file: non_constant_identifier_names

class HistoryDetailsTranslationsModel {
  final int id;
  final String translationable_type;
  final int translationable_id;
  final String locale;
  final String key;
  final String? value;
  final dynamic created_at;
  final dynamic updated_at;

  HistoryDetailsTranslationsModel({
    required this.id,
    required this.translationable_type,
    required this.translationable_id,
    required this.locale,
    required this.key,
    required this.value,
    required this.created_at,
    required this.updated_at,
  });

  factory HistoryDetailsTranslationsModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailsTranslationsModel(
      id: json["id"],
      translationable_type: json["translationable_type"],
      translationable_id: json["translationable_id"],
      locale: json["locale"],
      key: json["key"],
      value: json["value"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "translationable_type": translationable_type,
      "translationable_id": translationable_id,
      "locale": locale,
      "key": key,
      "value": value,
      "created_at": created_at,
      "updated_at": updated_at,
    };
  }
}
