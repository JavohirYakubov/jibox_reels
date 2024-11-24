import 'package:jibox_reels/data/model/ad_filter_model.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../data/model/enum/estate_type.dart';

abstract class ReelsFilterEvent {}

class InitEvent extends ReelsFilterEvent {
  final AdFilterModel filterModel;
  InitEvent(this.filterModel);
}
class ClearFilterEvent extends ReelsFilterEvent {

}
class UpdateCurrencyEvent extends ReelsFilterEvent {

}
class UpdateIsNewEvent extends ReelsFilterEvent {

}
class UpdateRangeEvent extends ReelsFilterEvent {
  final SfRangeValues values;
  UpdateRangeEvent(this.values);
}
class UpdateAdTypeEvent extends ReelsFilterEvent {
  final AdType? value;
  UpdateAdTypeEvent(this.value);
}