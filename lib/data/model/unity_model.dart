import 'package:jibox_reels/data/model/enum/lang_type.dart';
import 'package:jibox_reels/utils/pref_utils.dart';

import '../../di/locator.dart';

class UnityModel {
  final int id;
  final String? imageUz;
  final String? imageEn;
  final String? imageRu;

  UnityModel(this.id, this.imageUz, this.imageEn, this.imageRu);

  factory UnityModel.fromJson(Map<String, dynamic> json) =>
      UnityModel(
          json["id"],
          json["image_uz"],
          json["image_en"],
          json["image_ru"],
      );

  String? getLocaleImage(){
    switch(getIt.get<PrefUtils>().getCurrentLang()){

      case LangType.UZ:
        return imageUz;
      case LangType.EN:
        return imageEn;
      case LangType.RU:
        return imageRu;
    }
  }
}
