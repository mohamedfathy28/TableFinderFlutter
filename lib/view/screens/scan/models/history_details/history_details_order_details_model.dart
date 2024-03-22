// ignore_for_file: non_constant_identifier_names
import 'history_details_food_details_model.dart';

class HistoryDetailsOrderDetailsModel {

	final int id;
	final int food_id;
	final int order_id;
	final String price;
	final HistoryDetailsFoodDetailsModel food_details;
	final dynamic variation;
	final dynamic add_ons;
	final String discount_on_food;
	final String discount_type;
	final int quantity;
	final String tax_amount;
	final dynamic variant;
	final dynamic item_campaign_id;
	final String total_add_on_price;
	final dynamic deleted_at;
	final String created_at;
	final String updated_at;

	HistoryDetailsOrderDetailsModel({
		required this.id,
		required this.food_id,
		required this.order_id,
		required this.price,
		required this.food_details,
		required this.variation,
		required this.add_ons,
		required this.discount_on_food,
		required this.discount_type,
		required this.quantity,
		required this.tax_amount,
		required this.variant,
		required this.item_campaign_id,
		required this.total_add_on_price,
		required this.deleted_at,
		required this.created_at,
		required this.updated_at,
	});

	factory HistoryDetailsOrderDetailsModel.fromJson(Map<String, dynamic> json) {
		return HistoryDetailsOrderDetailsModel(
			id: json["id"],
			food_id: json["food_id"],
			order_id: json["order_id"],
			price: json["price"],
			food_details: HistoryDetailsFoodDetailsModel.fromJson(json["food_details"]),
			variation: json["variation"],
			add_ons: json["add_ons"],
			discount_on_food: json["discount_on_food"],
			discount_type: json["discount_type"],
			quantity: json["quantity"],
			tax_amount: json["tax_amount"],
			variant: json["variant"],
			item_campaign_id: json["item_campaign_id"],
			total_add_on_price: json["total_add_on_price"],
			deleted_at: json["deleted_at"],
			created_at: json["created_at"],
			updated_at: json["updated_at"],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			"id": id,
			"food_id": food_id,
			"order_id": order_id,
			"price": price,
			"food_details": food_details,
			"variation": variation,
			"add_ons": add_ons,
			"discount_on_food": discount_on_food,
			"discount_type": discount_type,
			"quantity": quantity,
			"tax_amount": tax_amount,
			"variant": variant,
			"item_campaign_id": item_campaign_id,
			"total_add_on_price": total_add_on_price,
			"deleted_at": deleted_at,
			"created_at": created_at,
			"updated_at": updated_at,
		};
	}

}
