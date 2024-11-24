import '../../../../data/model/ad_model.dart';

abstract class AdDetailEvent {}

class InitEvent extends AdDetailEvent {}

class ToggleLikeEvent extends AdDetailEvent {
  final AdModel ad;
  ToggleLikeEvent(this.ad);
}