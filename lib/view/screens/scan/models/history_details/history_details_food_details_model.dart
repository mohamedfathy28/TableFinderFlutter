// ignore_for_file: non_constant_identifier_names
import 'history_details_category_ids_model.dart';
import 'history_details_cuisines_model.dart';
import 'history_details_translations_model.dart';

class HistoryDetailsFoodDetailsModel {
  final int id;
  final String name;
  final dynamic description;
  final String image;
  final int category_id;
  final List<HistoryDetailsCategoryIdsModel> category_ids;
  final dynamic variations;
  final dynamic add_ons;
  final String attributes;
  final String choice_options;
  final double price;
  final int tax;
  final String tax_type;
  final dynamic discount;
  final String discount_type;
  final String available_time_starts;
  final String available_time_ends;
  final dynamic veg;
  final int status;
  final int restaurant_id;
  final String? created_at;
  final String? updated_at;
  final dynamic order_count;
  final dynamic avg_rating;
  final dynamic rating_count;
  final dynamic recommended;
  final String? slug;
  final dynamic maximum_cart_quantity;
  final String? restaurant_name;
  final int restaurant_status;
  final dynamic restaurant_discount;
  final String? restaurant_opening_time;
  final String? restaurant_closing_time;
  final dynamic schedule_order;
  final dynamic free_delivery;
  final dynamic min_delivery_time;
  final dynamic max_delivery_time;
  final List<HistoryDetailsCuisinesModel> cuisines;
  final List<HistoryDetailsTranslationsModel> translations;

  HistoryDetailsFoodDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category_id,
    required this.category_ids,
    required this.variations,
    required this.add_ons,
    required this.attributes,
    required this.choice_options,
    required this.price,
    required this.tax,
    required this.tax_type,
    required this.discount,
    required this.discount_type,
    required this.available_time_starts,
    required this.available_time_ends,
    required this.veg,
    required this.status,
    required this.restaurant_id,
    required this.created_at,
    required this.updated_at,
    required this.order_count,
    required this.avg_rating,
    required this.rating_count,
    required this.recommended,
    required this.slug,
    required this.maximum_cart_quantity,
    required this.restaurant_name,
    required this.restaurant_status,
    required this.restaurant_discount,
    required this.restaurant_opening_time,
    required this.restaurant_closing_time,
    required this.schedule_order,
    required this.free_delivery,
    required this.min_delivery_time,
    required this.max_delivery_time,
    required this.cuisines,
    required this.translations,
  });

  factory HistoryDetailsFoodDetailsModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailsFoodDetailsModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      image: json["image"],
      category_id: json["category_id"],
      category_ids: List<HistoryDetailsCategoryIdsModel>.from(
          json["category_ids"]
              .map((x) => HistoryDetailsCategoryIdsModel.fromJson(x))),
      variations: json["variations"],
      add_ons: json["add_ons"],
      attributes: json["attributes"],
      choice_options: json["choice_options"].toString(),
      price: json["price"].toDouble(),
      tax: json["tax"],
      tax_type: json["tax_type"],
      discount: json["discount"],
      discount_type: json["discount_type"],
      available_time_starts: json["available_time_starts"],
      available_time_ends: json["available_time_ends"],
      veg: json["veg"],
      status: json["status"],
      restaurant_id: json["restaurant_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      order_count: json["order_count"],
      avg_rating: json["avg_rating"],
      rating_count: json["rating_count"],
      recommended: json["recommended"],
      slug: json["slug"],
      maximum_cart_quantity: json["maximum_cart_quantity"],
      restaurant_name: json["restaurant_name"],
      restaurant_status: json["restaurant_status"],
      restaurant_discount: json["restaurant_discount"],
      restaurant_opening_time: json["restaurant_opening_time"],
      restaurant_closing_time: json["restaurant_closing_time"],
      schedule_order: json["schedule_order"],
      free_delivery: json["free_delivery"],
      min_delivery_time: json["min_delivery_time"],
      max_delivery_time: json["max_delivery_time"],
      cuisines: List<HistoryDetailsCuisinesModel>.from(
          json["cuisines"].map((x) => HistoryDetailsCuisinesModel.fromJson(x))),
      translations: List<HistoryDetailsTranslationsModel>.from(
          json["translations"]
              .map((x) => HistoryDetailsTranslationsModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "image": image,
      "category_id": category_id,
      "category_ids": category_ids,
      "variations": variations,
      "add_ons": add_ons,
      "attributes": attributes,
      "choice_options": choice_options,
      "price": price,
      "tax": tax,
      "tax_type": tax_type,
      "discount": discount,
      "discount_type": discount_type,
      "available_time_starts": available_time_starts,
      "available_time_ends": available_time_ends,
      "veg": veg,
      "status": status,
      "restaurant_id": restaurant_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "order_count": order_count,
      "avg_rating": avg_rating,
      "rating_count": rating_count,
      "recommended": recommended,
      "slug": slug,
      "maximum_cart_quantity": maximum_cart_quantity,
      "restaurant_name": restaurant_name,
      "restaurant_status": restaurant_status,
      "restaurant_discount": restaurant_discount,
      "restaurant_opening_time": restaurant_opening_time,
      "restaurant_closing_time": restaurant_closing_time,
      "schedule_order": schedule_order,
      "free_delivery": free_delivery,
      "min_delivery_time": min_delivery_time,
      "max_delivery_time": max_delivery_time,
      "cuisines": cuisines,
      "translations": translations,
    };
  }
}
