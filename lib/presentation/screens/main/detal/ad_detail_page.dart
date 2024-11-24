import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/data/model/ad_model.dart';
import 'package:jibox_reels/di/locator.dart';
import 'package:jibox_reels/extensions/extensions.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/utils/common.dart';
import 'package:video_player/video_player.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../ui/common/box_conatiner.dart';
import '../../../ui/common/image_view.dart';
import '../../../ui/common/text_view.dart';
import 'ad_detail_bloc.dart';
import 'ad_detail_event.dart';
import 'ad_detail_state.dart';

class AdDetailPage extends StatefulWidget {
  final AdModel ad;

  AdDetailPage(this.ad);

  @override
  State<AdDetailPage> createState() => _AdDetailPageState();
}

class _AdDetailPageState extends State<AdDetailPage> {
  late StreamController<String> _streamController;
  late Stream<String> _timeStream;
  Timer? _timer;

  @override
  void initState() {
    _streamController = StreamController<String>.broadcast();
    _timeStream = _streamController.stream;
    if (widget.ad.videoController != null) {
      Timer(Duration(seconds: 1), () {
        widget.ad.videoController?.play().then((v) {});
      });

      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamController.close();
    super.dispose();
  }

  // Timer to emit video time updates to the Stream
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (widget.ad.videoController!.value.isInitialized) {
        // Calculate the remaining time
        final currentPosition = widget.ad.videoController!.value.position;
        final duration = widget.ad.videoController!.value.duration;
        final remainingTime = duration - currentPosition;

        // Format the remaining time as mm:ss and emit to the stream
        final formattedRemainingTime = _formatDuration(remainingTime);
        final formattedDuration = _formatDuration(duration);

        _streamController.add(formattedRemainingTime);
      }
    });
  }

  // Helper method to format Duration into mm:ss
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AdDetailBloc(widget.ad, getIt.get())..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<AdDetailBloc>(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: bloc.ad.thumbNailImage != null || bloc.ad.mainImage != null
                  ? ImageView(
                      bloc.ad.thumbNailImage ?? bloc.ad.mainImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Container(
                      color: Colors.black,
                      padding: EdgeInsets.all(24.w),
                      child: Center(
                        child: TextView(
                          bloc.ad.shortText2,
                          textAlign: TextAlign.center,
                          textColor: Colors.white,
                          textStyle: TextViewStyle.SEMIBOLD,
                          fontSize: 34,
                        ),
                      ))),
          if (bloc.ad.videoController != null)
            Positioned.fill(
                child: GestureDetector(
              onTap: () {
                if (bloc.ad.videoController?.value.isPlaying == true) {
                  bloc.ad.videoController?.pause();
                } else {
                  bloc.ad.videoController?.play();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      // Ensures the video covers the widget
                      child: SizedBox(
                        width: bloc.ad.videoController!.value.size.width,
                        height: bloc.ad.videoController!.value.size.height,
                        child: VideoPlayer(
                          bloc.ad.videoController!,
                        ),
                      ),
                    ),
                  ),
                  // Show loading indicator
                  if (!bloc.ad.videoController!.value.isInitialized)
                    const CupertinoActivityIndicator(
                      color: ColorName.white,
                      radius: 24,
                    ),
                  // Play/Pause Icon
                ],
              ),
            )),
          Positioned(
              child: IgnorePointer(
            ignoring: true,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                ColorName.black.withOpacity(0.6),
                Colors.transparent,
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            ),
          )),
          Positioned.fill(
              child: Column(
            children: [
              const Expanded(
                  child: IgnorePointer(
                ignoring: true,
              )),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 4.h,
                          children: [
                            BoxContainer(
                              borderRadius: BorderRadius.circular(16.w),
                              border: Border.all(
                                  color: ColorName.white.withOpacity(
                                    0.6,
                                  ),
                                  width: 0.5),
                              color: ColorName.white.withOpacity(0.2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.w),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 44.0, sigmaY: 44.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Assets.images.building.image(
                                            width: 16.w,
                                            color: ColorName.white),
                                        4.width,
                                        TextView(
                                          bloc.ad.adType.getTitle(),
                                          textColor: ColorName.white,
                                          textStyle: TextViewStyle.MEDIUM,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            BoxContainer(
                              borderRadius: BorderRadius.circular(16.w),
                              border: Border.all(
                                  color: ColorName.white.withOpacity(
                                    0.6,
                                  ),
                                  width: 0.5),
                              color: ColorName.white.withOpacity(0.2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.w),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 44.0, sigmaY: 44.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Assets.images.handshake.image(
                                            width: 16.w,
                                            color: ColorName.white),
                                        4.width,
                                        TextView(
                                          bloc.ad.sellType.getTitle(),
                                          textColor: ColorName.white,
                                          textStyle: TextViewStyle.MEDIUM,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            BoxContainer(
                              borderRadius: BorderRadius.circular(16.w),
                              border: Border.all(
                                  color: ColorName.white.withOpacity(
                                    0.6,
                                  ),
                                  width: 0.5),
                              color: ColorName.white.withOpacity(0.2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.w),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 44.0, sigmaY: 44.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Assets.images.area.image(
                                            width: 16.w,
                                            color: ColorName.white),
                                        4.width,
                                        TextView(
                                          "${bloc.ad.square}",
                                          textColor: ColorName.white,
                                          textStyle: TextViewStyle.MEDIUM,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            BoxContainer(
                              borderRadius: BorderRadius.circular(16.w),
                              border: Border.all(
                                  color: ColorName.white.withOpacity(
                                    0.6,
                                  ),
                                  width: 0.5),
                              color: ColorName.white.withOpacity(0.2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.w),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 44.0, sigmaY: 44.0),
                                    child: TextView(
                                      DateTime.parse(bloc.ad.createdAt).timeAgo,
                                      textColor: ColorName.white,
                                      textStyle: TextViewStyle.MEDIUM,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        12.height,
                        TextView(
                          bloc.ad.shortText,
                          textColor: ColorName.white,
                          textStyle: TextViewStyle.SEMIBOLD,
                          fontSize: 20,
                          maxLines: 2,
                        ),
                        4.height,
                        if (bloc.ad.content?.isNotEmpty == true)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bloc.ad.expandContent = !bloc.ad.expandContent;
                              });
                            },
                            child: bloc.ad.expandContent
                                ? Container(
                                    constraints:
                                        const BoxConstraints(maxHeight: 150),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Flexible(
                                          child: SingleChildScrollView(
                                            child: TextView(
                                              bloc.ad.content ?? "",
                                              fontSize: 14,
                                              textColor: ColorName.white,
                                            ),
                                          ),
                                        ),
                                        TextView(
                                          "Kamroq ko'rish",
                                          textColor:
                                              ColorName.mainPrimary500Base,
                                          fontSize: 14,
                                        )
                                      ],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TextView(
                                        bloc.ad.content ?? "",
                                        maxLines: 1,
                                        fontSize: 12,
                                        textColor: ColorName.white,
                                      ),
                                      TextView(
                                        "Ko'proq ko'rish",
                                        textColor: ColorName.mainPrimary500Base,
                                        fontSize: 14,
                                      )
                                    ],
                                  ),
                          ),
                        12.height,
                        GestureDetector(
                          onTap: () {
                            checkAuthAndCall(context, () {
                              openMap(
                                  context, bloc.ad.latitude, bloc.ad.longitude);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h, right: 8.w),
                            child: Row(
                              children: [
                                Assets.icons.location.svg(width: 18.w),
                                4.width,
                                Expanded(
                                  child: TextView(
                                    bloc.ad.address ?? "---",
                                    textColor: ColorName.white.withOpacity(0.9),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (safePadding(context).bottom + 16.h).height
                      ],
                    ),
                  )),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, left: 16.w),
                    child: BlocBuilder<AdDetailBloc, BaseState>(
                      buildWhen: (p, current) => current is UpdateLikeState,
                      builder: (context, state) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                checkAuthAndCall(context, () {
                                  bloc.add(ToggleLikeEvent(bloc.ad));
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.w, right: 8.w, bottom: 8.h),
                                child: Icon(
                                  bloc.ad.hasLike == true
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: bloc.ad.hasLike == true
                                      ? ColorName.alertError500Base
                                      : ColorName.icon,
                                  size: 30.w,
                                ),
                              ),
                            ),
                            TextView(
                              "${bloc.ad.likeCount ?? 0}",
                              fontSize: 14,
                              textColor: ColorName.white,
                            ),
                            GestureDetector(
                              onTap: () {
                                checkAuthAndCall(context, () {
                                  callPhone(context, bloc.ad.phone ?? "");
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    bottom: 12.h,
                                    top: 16.h),
                                child: Assets.images.phoneCall
                                    .image(width: 28.w, color: ColorName.icon),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    bottom: 12.h,
                                    top: 12.h),
                                child: Assets.icons.shareIcon.svg(
                                  width: 28.w,
                                ),
                              ),
                            ),
                            8.height,
                          ],
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          )),
          Positioned(
              top: safePadding(context).top + 16.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      AppRouter.pop();
                    },
                    child: Assets.icons.arrowLeft.svg(
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                          ColorName.white, BlendMode.srcIn),
                    ),
                  ),
                  Spacer(),
                  StreamBuilder<String>(
                      stream: _timeStream,
                      builder: (context, snapshot) {
                        return TextView(
                          snapshot.data ?? "00:00",
                          textColor: ColorName.white,
                        );
                      }),
                ],
              ))
        ],
      ),
    );
  }
}
