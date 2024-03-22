class ReservationHistoryDetails {
  final bool success;
  final String message;
  final ReservationHistoryDetailsData data;

  ReservationHistoryDetails({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReservationHistoryDetails.fromJson(Map<String, dynamic> json) {
    return ReservationHistoryDetails(
      success: json["success"] as bool,
      message: json["message"] as String,
      data: ReservationHistoryDetailsData.fromJson(
          json["data"] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data.toJson(),
    };
  }
}

class ReservationHistoryDetailsData {
  final int id;
  final String restaurantName;
  final String restaurantLogo;
  final String total;
  final int guest;
  final dynamic tableNumber;
  final String status;
  final List<OrderDetail> orderDetails;
  final bool canCancel;

  ReservationHistoryDetailsData({
    required this.id,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.total,
    required this.guest,
    this.tableNumber,
    required this.status,
    required this.orderDetails,
    required this.canCancel,
  });

  factory ReservationHistoryDetailsData.fromJson(Map<String, dynamic> json) {
    return ReservationHistoryDetailsData(
      id: json["id"] as int,
      restaurantName: json["restaurant_name"] as String,
      restaurantLogo: json["restaurant_logo"] as String,
      total: json["total"] as String,
      guest: json["guest"] as int,
      tableNumber: json["table_number"],
      status: json["status"] as String,
      orderDetails: (json["order_details"] as List<dynamic>)
          .map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      canCancel: json["can_cancel"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "restaurant_name": restaurantName,
      "restaurant_logo": restaurantLogo,
      "total": total,
      "guest": guest,
      "table_number": tableNumber,
      "status": status,
      "order_details": orderDetails.map((e) => e.toJson()).toList(),
      "can_cancel": canCancel,
    };
  }
}

class OrderDetail {
  final int id;
  final int foodId;
  final int orderId;
  final String price;
  final FoodDetails foodDetails;
  final dynamic variation;
  final dynamic addOns;
  final String discountOnFood;
  final String discountType;
  final int quantity;
  final String taxAmount;
  final dynamic variant;
  final dynamic itemCampaignId;
  final String totalAddOnPrice;
  final dynamic deletedAt;
  final String createdAt;
  final String updatedAt;

  OrderDetail({
    required this.id,
    required this.foodId,
    required this.orderId,
    required this.price,
    required this.foodDetails,
    this.variation,
    this.addOns,
    required this.discountOnFood,
    required this.discountType,
    required this.quantity,
    required this.taxAmount,
    this.variant,
    this.itemCampaignId,
    required this.totalAddOnPrice,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json["id"] as int,
      foodId: json["food_id"] as int,
      orderId: json["order_id"] as int,
      price: json["price"] as String,
      foodDetails:
          FoodDetails.fromJson(json["food_details"] as Map<String, dynamic>),
      variation: json["variation"],
      addOns: json["add_ons"],
      discountOnFood: json["discount_on_food"] as String,
      discountType: json["discount_type"] as String,
      quantity: json["quantity"] as int,
      taxAmount: json["tax_amount"] as String,
      variant: json["variant"],
      itemCampaignId: json["item_campaign_id"],
      totalAddOnPrice: json["total_add_on_price"] as String,
      deletedAt: json["deleted_at"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "food_id": foodId,
      "order_id": orderId,
      "price": price,
      "food_details": foodDetails.toJson(),
      "variation": variation,
      "add_ons": addOns,
      "discount_on_food": discountOnFood,
      "discount_type": discountType,
      "quantity": quantity,
      "tax_amount": taxAmount,
      "variant": variant,
      "item_campaign_id": itemCampaignId,
      "total_add_on_price": totalAddOnPrice,
      "deleted_at": deletedAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}

class CategoryId {
  final String id;
  final int position;

  CategoryId({required this.id, required this.position});

  factory CategoryId.fromJson(Map<String, dynamic> json) {
    return CategoryId(
      id: json["id"] as String,
      position: json["position"] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "position": position,
    };
  }
}

class FoodDetails {
  final int id;
  final String name;
  final dynamic description;
  final String image;
  final int categoryId;
  final List<CategoryId> categoryIds;
  final dynamic variations;
  final dynamic addOns;
  final String attributes;
  final String choiceOptions;
  final double price;
  final int tax;
  final String taxType;
  final int discount;
  final String discountType;
  final String availableTimeStarts;
  final String availableTimeEnds;
  final dynamic veg;
  final int status;
  final int restaurantId;
  final String createdAt;
  final String updatedAt;
  final int orderCount;
  final double avgRating;
  final int ratingCount;
  final int recommended;
  final String slug;
  final dynamic maximumCartQuantity;
  final String restaurantName;
  final int restaurantStatus;
  final int restaurantDiscount;
  final String restaurantOpeningTime;
  final String restaurantClosingTime;
  final bool scheduleOrder;
  final int freeDelivery;
  final int minDeliveryTime;
  final int maxDeliveryTime;
  final List<Cuisine> cuisines;
  final List<Translation> translations;

  FoodDetails({
    required this.id,
    required this.name,
    this.description,
    required this.image,
    required this.categoryId,
    required this.categoryIds,
    this.variations,
    this.addOns,
    required this.attributes,
    required this.choiceOptions,
    required this.price,
    required this.tax,
    required this.taxType,
    required this.discount,
    required this.discountType,
    required this.availableTimeStarts,
    required this.availableTimeEnds,
    this.veg,
    required this.status,
    required this.restaurantId,
    required this.createdAt,
    required this.updatedAt,
    required this.orderCount,
    required this.avgRating,
    required this.ratingCount,
    required this.recommended,
    required this.slug,
    this.maximumCartQuantity,
    required this.restaurantName,
    required this.restaurantStatus,
    required this.restaurantDiscount,
    required this.restaurantOpeningTime,
    required this.restaurantClosingTime,
    required this.scheduleOrder,
    required this.freeDelivery,
    required this.minDeliveryTime,
    required this.maxDeliveryTime,
    required this.cuisines,
    required this.translations,
  });

  factory FoodDetails.fromJson(Map<String, dynamic> json) {
    return FoodDetails(
      id: json["id"] as int,
      name: json["name"] as String,
      description: json["description"],
      image: json["image"] as String,
      categoryId: json["category_id"] as int,
      categoryIds: (json["category_ids"] as List<dynamic>)
          .map((e) => CategoryId.fromJson(e as Map<String, dynamic>))
          .toList(),
      variations: json["variations"],
      addOns: json["add_ons"],
      attributes: json["attributes"] as String,
      choiceOptions: json["choice_options"] as String,
      price: double.tryParse(json["price"] as String) ?? 0.0,
      tax: json["tax"] as int,
      taxType: json["tax_type"] as String,
      discount: json["discount"] as int,
      discountType: json["discount_type"] as String,
      availableTimeStarts: json["available_time_starts"] as String,
      availableTimeEnds: json["available_time_ends"] as String,
      veg: json["veg"],
      status: json["status"] as int,
      restaurantId: json["restaurant_id"] as int,
      createdAt: json["created_at"] as String,
      updatedAt: json["updated_at"] as String,
      orderCount: json["order_count"] as int,
      avgRating: double.tryParse(json["avg_rating"] as String) ?? 0.0,
      ratingCount: json["rating_count"] as int,
      recommended: json["recommended"] as int,
      slug: json["slug"] as String,
      maximumCartQuantity: json["maximum_cart_quantity"],
      restaurantName: json["restaurant_name"] as String,
      restaurantStatus: json["restaurant_status"] as int,
      restaurantDiscount: json["restaurant_discount"] as int,
      restaurantOpeningTime: json["restaurant_opening_time"] as String,
      restaurantClosingTime: json["restaurant_closing_time"] as String,
      scheduleOrder: json["schedule_order"] as bool,
      freeDelivery: json["free_delivery"] as int,
      minDeliveryTime: json["min_delivery_time"] as int,
      maxDeliveryTime: json["max_delivery_time"] as int,
      cuisines: (json["cuisines"] as List<dynamic>)
          .map((e) => Cuisine.fromJson(e as Map<String, dynamic>))
          .toList(),
      translations: (json["translations"] as List<dynamic>)
          .map((e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "image": image,
      "category_id": categoryId,
      "category_ids": categoryIds.map((e) => e.toJson()).toList(),
      "variations": variations,
      "add_ons": addOns,
      "attributes": attributes,
      "choice_options": choiceOptions,
      "price": price.toStringAsFixed(2),
      "tax": tax,
      "tax_type": taxType,
      "discount": discount,
      "discount_type": discountType,
      "available_time_starts": availableTimeStarts,
      "available_time_ends": availableTimeEnds,
      "veg": veg,
      "status": status,
      "restaurant_id": restaurantId,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "order_count": orderCount,
      "avg_rating": avgRating.toStringAsFixed(1),
      "rating_count": ratingCount,
      "recommended": recommended,
      "slug": slug,
      "maximum_cart_quantity": maximumCartQuantity,
      "restaurant_name": restaurantName,
      "restaurant_status": restaurantStatus,
      "restaurant_discount": restaurantDiscount,
      "restaurant_opening_time": restaurantOpeningTime,
      "restaurant_closing_time": restaurantClosingTime,
      "schedule_order": scheduleOrder,
      "free_delivery": freeDelivery,
      "min_delivery_time": minDeliveryTime,
      "max_delivery_time": maxDeliveryTime,
      "cuisines": cuisines.map((e) => e.toJson()).toList(),
      "translations": translations.map((e) => e.toJson()).toList(),
    };
  }
}

class Cuisine {
  final int id;
  final String name;
  final String image;

  Cuisine({required this.id, required this.name, required this.image});

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json["id"] as int,
      name: json["name"] as String,
      image: json["image"] as String,
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

class Translation {
  final int id;
  final String translationableType;
  final int translationableId;
  final String locale;
  final String key;
  final String value;
  final dynamic createdAt;
  final dynamic updatedAt;

  Translation({
    required this.id,
    required this.translationableType,
    required this.translationableId,
    required this.locale,
    required this.key,
    required this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json["id"] as int,
      translationableType: json["translationable_type"] as String,
      translationableId: json["translationable_id"] as int,
      locale: json["locale"] as String,
      key: json["key"] as String,
      value: json["value"] as String,
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "translationable_type": translationableType,
      "translationable_id": translationableId,
      "locale": locale,
      "key": key,
      "value": value,
      "created_at": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
