import '../../di/locator.dart';
import '../../utils/pref_utils.dart';
import 'enum/lang_type.dart';

class AppSettingsModel {
  final int id;
  final int deliveryPrice;
  final String termsOfDeliveryUz;
  final String termsOfDeliveryRu;
  final String termsOfDeliveryEn;
  final int forIsland;
  final int transferPercent;
  final int productCashbackPercent;
  final int freeDeliveryAmountMin;
  final int freeDeliveryAmountMax;
  final bool allowOrder;
  final bool allowCard;
  final bool allowTransfer;
  final String termsUrl;
  final String phoneNumber;
  final String instagram;
  final String telegram;
  final String whatsapp;
  final String shareUrl;

  AppSettingsModel({
    required this.id,
    required this.deliveryPrice,
    required this.termsOfDeliveryUz,
    required this.termsOfDeliveryRu,
    required this.termsOfDeliveryEn,
    required this.forIsland,
    required this.transferPercent,
    required this.productCashbackPercent,
    required this.freeDeliveryAmountMin,
    required this.freeDeliveryAmountMax,
    required this.allowOrder,
    required this.allowCard,
    required this.allowTransfer,
    required this.termsUrl,
    required this.phoneNumber,
    required this.instagram,
    required this.telegram,
    required this.whatsapp,
    required this.shareUrl,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      id: json['id'],
      deliveryPrice: json['delivery_price'],
      termsOfDeliveryUz: json['terms_of_delivery_uz'],
      termsOfDeliveryRu: json['terms_of_delivery_ru'],
      termsOfDeliveryEn: json['terms_of_delivery_en'],
      forIsland: json['for_island'],
      transferPercent: json['transfer_percent'],
      productCashbackPercent: json['product_cashback_percent'],
      freeDeliveryAmountMin: json['free_delivery_amount_min'],
      freeDeliveryAmountMax: json['free_delivery_amount_max'],
      allowOrder: json['allow_order'],
      allowCard: json['allow_card'],
      allowTransfer: json['allow_transfer'],
      termsUrl: json['terms_url'],
      phoneNumber: json['phone_number'],
      instagram: json['instagram'],
      telegram: json['telegram'],
      whatsapp: json['whatsapp'],
      shareUrl: json['share_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_price': deliveryPrice,
      'terms_of_delivery_uz': termsOfDeliveryUz,
      'terms_of_delivery_ru': termsOfDeliveryRu,
      'terms_of_delivery_en': termsOfDeliveryEn,
      'for_island': forIsland,
      'transfer_percent': transferPercent,
      'product_cashback_percent': productCashbackPercent,
      'free_delivery_amount_min': freeDeliveryAmountMin,
      'free_delivery_amount_max': freeDeliveryAmountMax,
      'allow_order': allowOrder,
      'allow_card': allowCard,
      'allow_transfer': allowTransfer,
      'terms_url': termsUrl,
      'phone_number': phoneNumber,
      'instagram': instagram,
      'telegram': telegram,
      'whatsapp': whatsapp,
      'share_url': shareUrl,
    };
  }

  String? getLocaleTermsOfDelivery() {
    switch (getIt<PrefUtils>().getCurrentLang()) {
      case LangType.UZ:
        return termsOfDeliveryUz;
      case LangType.EN:
        return termsOfDeliveryEn;
      case LangType.RU:
        return termsOfDeliveryRu;
    }
  }
}
