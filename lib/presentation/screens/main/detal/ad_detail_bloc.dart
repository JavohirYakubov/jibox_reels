import 'package:bloc/bloc.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/data/repository/user_repository.dart';

import '../../../../data/model/ad_model.dart';
import 'ad_detail_event.dart';
import 'ad_detail_state.dart';

class AdDetailBloc extends Bloc<AdDetailEvent, BaseState> {
  final AdModel ad;
  final UserRepository userRepository;
  AdDetailBloc(this.ad, this.userRepository) : super(InitialState()) {
    on<InitEvent>((event, emit){

    });
    on<ToggleLikeEvent>((event, emit)async{
      await toggleLike(event, emit);
    });
  }


  Future<void> toggleLike(ToggleLikeEvent event, Emitter<BaseState> emit) async {
    event.ad.hasLike = !(event.ad.hasLike ?? false);
    if (event.ad.hasLike == true) {
      event.ad.likeCount++;
    } else {
      event.ad.likeCount--;
    }
    emit(UpdateLikeState());
    final response = await userRepository.toggleLike(event.ad.id);
  }
}
