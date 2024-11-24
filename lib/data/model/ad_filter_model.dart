
import 'enum/estate_type.dart';

enum CurrencyType {
  USD,
  UZS;

  static CurrencyType getObj(String key) {
    if (key == "usd") {
      return CurrencyType.USD;
    } else {
      return CurrencyType.UZS;
    }
  }

  String getTitle() {
    switch (this) {
      case CurrencyType.USD:
        return "USD";
      case CurrencyType.UZS:
        return "UZS";
    }
  }

  String getKey() {
    switch (this) {
      case CurrencyType.USD:
        return "usd";
      case CurrencyType.UZS:
        return "uzs";
    }
  }
}

class AdFilterModel {
  int cityId;
  AdType? adType;
  CurrencyType currency;
  double fromRadius;
  double toRadius;
  double latitude;
  double longitude;
  int? fromFloor;
  int? toFloor;
  int? fromRoomCount;
  int? toRoomCount;
  int? fromSumma;
  int? toSumma;
  bool isNew;

  AdFilterModel({
    this.cityId = 0,
    this.adType,
    this.currency = CurrencyType.USD,
    this.fromRadius = 0,
    this.toRadius = 100,
    required this.latitude,
    required this.longitude,
    this.fromFloor,
    this.toFloor,
    this.fromRoomCount,
    this.toRoomCount,
    this.fromSumma,
    this.toSumma,
    this.isNew = false,
  });

  factory AdFilterModel.fromJson(Map<String, dynamic> json) {
    return AdFilterModel(
      cityId: json['city_id'],
      adType: json['ad_type'] == null ? null : AdType.getObj(json["ad_type"]),
      currency: CurrencyType.getObj(json['usd']),
      fromRadius: json['from_radius'],
      toRadius: json['to_radius'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      fromFloor: json['from_floor'],
      toFloor: json['to_floor'],
      fromRoomCount: json['from_room_count'],
      toRoomCount: json['to_room_count'],
      fromSumma: json['from_summa'],
      toSumma: json['to_summa'],
      isNew: json['is_new'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_id': cityId,
      'ad_type': adType?.getKey(),
      'currency': currency.getKey(),
      'from_radius': fromRadius,
      'to_radius': toRadius,
      'latitude': latitude,
      'longitude': longitude,
      'from_floor': fromFloor,
      'to_floor': toFloor,
      'from_room_count': fromRoomCount,
      'to_room_count': toRoomCount,
      'from_summa': fromSumma,
      'to_summa': toSumma,
      'is_new': isNew,
    };
  }

  AdFilterModel copyWith({
    int? cityId,
    AdType? adType,
    CurrencyType? currency,
    double? fromRadius,
    double? toRadius,
    double? latitude,
    double? longitude,
    int? fromFloor,
    int? toFloor,
    int? fromRoomCount,
    int? toRoomCount,
    int? fromSumma,
    int? toSumma,
    bool? isNew,
  }) {
    return AdFilterModel(
      cityId: cityId ?? this.cityId,
      adType: adType ?? this.adType,
      currency: currency ?? this.currency,
      fromRadius: fromRadius ?? this.fromRadius,
      toRadius: toRadius ?? this.toRadius,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fromFloor: fromFloor ?? this.fromFloor,
      toFloor: toFloor ?? this.toFloor,
      fromRoomCount: fromRoomCount ?? this.fromRoomCount,
      toRoomCount: toRoomCount ?? this.toRoomCount,
      fromSumma: fromSumma ?? this.fromSumma,
      toSumma: toSumma ?? this.toSumma,
      isNew: isNew ?? this.isNew,
    );
  }
}
