import 'package:jibox_reels/data/model/ad_model.dart';

abstract class MainEvent {}

class InitEvent extends MainEvent {}
class LoadAdListEvent extends MainEvent {}
class UpdateItemsEvent extends MainEvent {}
class UpdateItemEvent extends MainEvent {
  final int adId;
  UpdateItemEvent(this.adId);
}
class ToggleLikeEvent extends MainEvent {
  final AdModel ad;
  ToggleLikeEvent(this.ad);
}
class UpdateMapMarkersEvent extends MainEvent {}