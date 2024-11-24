import 'package:jibox_reels/data/model/category_model.dart';
import 'package:jibox_reels/data/model/currency_model.dart';
import 'package:jibox_reels/extensions/extensions.dart';
import 'package:video_player/video_player.dart';

import 'ad_filter_model.dart';
import 'enum/estate_type.dart';

enum SellType {
  RENT,
  SELL;

  static SellType getObj(String key) {
    if (key == "rent") {
      return SellType.RENT;
    } else {
      return SellType.SELL;
    }
  }

  String getTitle() {
    if (this == SellType.RENT) {
      return "Ijara";
    } else {
      return "Sotuv";
    }
  }
}

class AdModel {
  final int id;
  final String? mainVideo;
  final String? mainImage;
  final String? thumbNailImage;
  final String? content;
  final String? phone;
  final double latitude;
  final double longitude;
  final double distance;
  final String? address;
  final SellType sellType;
  final AdType adType;
  final int roomCount;
  final int floor;
  final int floorCount;
  final double summa;
  final double square;
  final bool isNew;
  final CurrencyModel currency;
  int likeCount;
  bool? hasLike;
  final String createdAt;
  final String? updatedAt;
  bool expandContent = false;
  VideoPlayerController? videoController;

  AdModel({
    required this.id,
    this.mainVideo,
    this.mainImage,
    this.thumbNailImage,
    this.content,
    this.phone,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.address,
    required this.sellType,
    required this.adType,
    required this.roomCount,
    required this.floor,
    required this.floorCount,
    required this.summa,
    required this.square,
    required this.isNew,
    required this.currency,
    required this.likeCount,
    required this.hasLike,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      mainVideo: json['main_video'],
      mainImage: json['main_image'],
      thumbNailImage: json['thumbnail_image'],
      content: json['content'],
      phone: json['phone'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      address: json['address'],
      sellType: SellType.getObj(json['sell_type'] ?? "rent"),
      adType: AdType.getObj(json['ad_type'] ?? "flat"),
      roomCount: json['room_count'],
      floor: json['floor'],
      floorCount: json['floor_count'],
      summa: (json['summa'] as num).toDouble(),
      square: (json['square'] as num).toDouble(),
      isNew: json['is_new'] == 1
          ? true
          : json['is_new'] == 0
              ? false
              : json['is_new'],
      currency: CurrencyModel.fromJson(json["currency"]),
      likeCount: json['like_count'],
      hasLike: json['has_like'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mainVideo': mainVideo,
      'mainImage': mainImage,
      'thumbNailImage': thumbNailImage,
      'content': content,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'address': address,
      'sellType': sellType,
      'floor': floor,
      'summa': summa,
      'square': square,
      'createdAt': createdAt,
    };
  }

  String get shortText {
    return "$roomCount/$floor/$floor ${summa.formattedAmountString(currency: "\$")}${isNew ? " Yangi uy" : ""}";
  }

  String get shortText2 {
    return "$roomCount/$floor/$floor ${summa.formattedAmountString(currency: "\$")}${isNew ? " Yangi uy" : ""}\n${address ?? ""}";
  }
}
