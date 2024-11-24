import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jibox_reels/data/model/ad_model.dart';
import 'package:jibox_reels/extensions/extensions.dart';
import 'package:jibox_reels/presentation/screens/main/detal/ad_detail_page.dart';
import 'package:jibox_reels/presentation/ui/common/image_view.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/utils/common.dart';
import 'package:video_player/video_player.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../common/box_conatiner.dart';
import '../common/text_view.dart';

class ReelsItemView extends StatefulWidget {
  final AdModel ad;
  final Function onCall;
  final Function onLike;
  final Function onShare;

  const ReelsItemView(
      {super.key,
      required this.ad,
      required this.onCall,
      required this.onLike,
      required this.onShare});

  @override
  State<ReelsItemView> createState() => _ReelsItemViewState();
}

class _ReelsItemViewState extends State<ReelsItemView>
    with WidgetsBindingObserver {
  bool openDetail = false;
  StreamSubscription? centeredStreamSubscription;
  late StreamController<String> _streamController;
  late Stream<String> _timeStream;
  Timer? _timer;

  @override
  void initState() {
    _streamController = StreamController<String>.broadcast();
    _timeStream = _streamController.stream;
    if (widget.ad.videoController != null) {
      _startTimer();
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused && !openDetail) {
      // Pause video when the app goes to the background or another window
      widget.ad.videoController?.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (widget.ad.videoController?.value.isPlaying != true) {
        // Resume video when returning to the screen
        widget.ad.videoController?.play();
      }
      openDetail = false;
    }
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
    return BoxContainer(
      height: 580.h,
      borderRadius: BorderRadius.circular(16.w),
      withShadow: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.w),
        child: Stack(
          children: [
            Positioned.fill(
                child: widget.ad.thumbNailImage != null ||
                        widget.ad.mainImage != null
                    ? ImageView(
                        widget.ad.thumbNailImage ?? widget.ad.mainImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Container(
                        color: Colors.black,
                        padding: EdgeInsets.all(24.w),
                        child: Center(
                          child: TextView(
                            widget.ad.shortText2,
                            textAlign: TextAlign.center,
                            textColor: Colors.white,
                            textStyle: TextViewStyle.SEMIBOLD,
                            fontSize: 34,
                          ),
                        ))),
            if (widget.ad.videoController != null)
              Positioned.fill(
                  child: GestureDetector(
                onTap: () {
                  openDetail = true;
                  AppRouter.push(AdDetailPage(widget.ad));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        // Ensures the video covers the widget
                        child: SizedBox(
                          width: widget.ad.videoController!.value.size.width,
                          height: widget.ad.videoController!.value.size.height,
                          child: VideoPlayer(
                            widget.ad.videoController!,
                          ),
                        ),
                      ),
                    ),
                    // Show loading indicator
                    if (!widget.ad.videoController!.value.isInitialized)
                      const CupertinoActivityIndicator(
                        color: ColorName.white,
                        radius: 24,
                      ),
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
                                            widget.ad.adType.getTitle(),
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
                                            widget.ad.sellType.getTitle(),
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
                                            "${widget.ad.square}",
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
                                        DateTime.parse(widget.ad.createdAt)
                                            .timeAgo,
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
                            widget.ad.shortText,
                            textColor: ColorName.white,
                            textStyle: TextViewStyle.SEMIBOLD,
                            fontSize: 20,
                            maxLines: 2,
                          ),
                          4.height,
                          if (widget.ad.content?.isNotEmpty == true)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.ad.expandContent =
                                      !widget.ad.expandContent;
                                });
                              },
                              child: widget.ad.expandContent
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
                                                widget.ad.content ?? "",
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
                                          widget.ad.content ?? "",
                                          maxLines: 1,
                                          fontSize: 12,
                                          textColor: ColorName.white,
                                        ),
                                        TextView(
                                          "Ko'proq ko'rish",
                                          textColor:
                                              ColorName.mainPrimary500Base,
                                          fontSize: 14,
                                        )
                                      ],
                                    ),
                            ),
                          12.height,
                          GestureDetector(
                            onTap: () {
                              checkAuthAndCall(context, () {
                                openMap(context, widget.ad.latitude,
                                    widget.ad.longitude);
                              });
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: 16.h, right: 8.w),
                              child: Row(
                                children: [
                                  Assets.icons.location.svg(width: 18.w),
                                  4.width,
                                  Expanded(
                                    child: TextView(
                                      widget.ad.address ?? "---",
                                      textColor:
                                          ColorName.white.withOpacity(0.9),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.only(right: 16.w, left: 16.w),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.onLike();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 8.w, right: 8.w, bottom: 8.h),
                              child: Icon(
                                widget.ad.hasLike == true
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: widget.ad.hasLike == true
                                    ? ColorName.alertError500Base
                                    : ColorName.icon,
                                size: 30.w,
                              ),
                            ),
                          ),
                          TextView(
                            "${widget.ad.likeCount ?? 0}",
                            fontSize: 14,
                            textColor: ColorName.white,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onCall();
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
                            onTap: () {
                              widget.onShare();
                            },
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
                      ),
                    )
                  ],
                )
              ],
            )),
            if (widget.ad.mainVideo?.isNotEmpty == true)
              Positioned(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                child: Row(
                  children: [
                    Expanded(
                        child: StreamBuilder<String>(
                            stream: _timeStream,
                            builder: (context, snapshot) {
                              return TextView(snapshot.data ?? "00:00");
                            })),
                    GestureDetector(
                      onTap: _toggleMute,
                      child: widget.ad.videoController?.value.volume == 0
                          ? Assets.icons.voiceMute.svg(width: 34.w)
                          : Assets.icons.soundCircle.svg(width: 34.w),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleMute() {
    if (widget.ad.videoController!.value.volume > 0) {
      widget.ad.videoController!.setVolume(0);
    } else {
      widget.ad.videoController!.setVolume(1);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
