import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/data/model/ad_filter_model.dart';
import 'package:jibox_reels/gen/assets.gen.dart';
import 'package:jibox_reels/gen/colors.gen.dart';
import 'package:jibox_reels/presentation/screens/main/add/add_ad_page.dart';
import 'package:jibox_reels/presentation/screens/main/filter/reels_filter_page.dart';
import 'package:jibox_reels/presentation/screens/main/main_state.dart';
import 'package:jibox_reels/presentation/screens/main/map/estates_map_page.dart';
import 'package:jibox_reels/presentation/ui/common/box_conatiner.dart';
import 'package:jibox_reels/presentation/ui/common/regular_divider.dart';
import 'package:jibox_reels/presentation/ui/common/text_view.dart';
import 'package:jibox_reels/presentation/ui/itemview/reels_item_view.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/utils/common.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../di/locator.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';
import 'main_bloc.dart';
import 'main_event.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;
  ScrollController _scrollController = ScrollController();
  int _currentCenterItemIndex = 0;

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(
        MyApp.currentLocation!.latitude, MyApp.currentLocation!.longitude),
    zoom: 11,
  );
  Set<Marker> _markers = {};
  final List<List<Point>> _clusters = [];

  void _generateMapCircles(bool withZoom) async {
    _clusters.clear(); // Clear previous clusters
    if (bloc.items?.isNotEmpty != true) {
      _markers = {};
      bloc.add(UpdateMapMarkersEvent());
      return;
    }

    final currentZoomLevel = await _googleMapController!.getZoomLevel();
    List<Marker> newMarkers = [];

    final threshold = calculateThreshold(currentZoomLevel, context);

    for (var item in bloc.items!) {
      bool addedToCluster = false;
      for (var cluster in _clusters) {
        double distance = calculateDistance(
            cluster.first,
            Point(
                id: item.id.toString(),
                latitude: item.latitude,
                longitude: item.longitude));
        print('Distance between point and cluster: $distance meters');
        if (distance < threshold) {
          cluster.add(Point(
              id: item.id.toString(),
              latitude: item.latitude,
              longitude: item.longitude));
          addedToCluster = true;
          break;
        }
      }

      if (!addedToCluster) {
        _clusters.add([
          Point(
              id: item.id.toString(),
              latitude: item.latitude,
              longitude: item.longitude)
        ]);
      }
      if (withZoom) {
        _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(bloc.filter.latitude, bloc.filter.longitude),
              zoom: 12),
        ));
      }
    }

    for (var cluster in _clusters) {
      if (cluster.length == 1) {
        newMarkers.add(Marker(
          markerId: MarkerId(cluster[0].id),
          position: LatLng(cluster[0].latitude, cluster[0].longitude),
          icon: circleMarkerIcon,
          anchor: const Offset(.5, .5),
          infoWindow: InfoWindow(
              title: "E'lon #${cluster[0].id}",
              snippet: bloc.items
                  ?.where((item) => "${item.id}" == cluster[0].id)
                  .firstOrNull
                  ?.shortText2),
        ));
      } else {
        newMarkers.add(Marker(
          markerId: MarkerId(cluster.first.id),
          position: LatLng(cluster.first.latitude, cluster.first.longitude),
          icon: await _getMarkerBitmap(100, text: "${cluster.length}"),
        ));
      }
    }

    _markers = newMarkers.toSet();
    bloc.add(UpdateMapMarkersEvent());
  }

  double calculateThreshold(double zoomLevel, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Scale the base threshold based on the zoom level
    print("Zoom $zoomLevel");

    double baseThreshold;
    if (zoomLevel <= 10) {
      baseThreshold = 10000;
    } else if (zoomLevel == 11) {
      baseThreshold = 2000;
    } else if (zoomLevel == 12) {
      baseThreshold = 1500;
    } else if (zoomLevel == 13) {
      baseThreshold = 1000;
    } else if (zoomLevel == 14) {
      baseThreshold = 800;
    } else if (zoomLevel == 15) {
      baseThreshold = 700;
    } else {
      baseThreshold = 0;
    }

    // Adjust the base threshold according to screen width (or height)
    double screenSizeFactor =
        screenWidth / 400; // Example: 400 is an arbitrary "base" width
    return baseThreshold * screenSizeFactor;
  }

  double calculateDistance(Point point1, Point point2) {
    const double earthRadius = 6371000; // Radius of Earth in meters

    final double lat1 = point1.latitude * pi / 180;
    final double lon1 = point1.longitude * pi / 180;
    final double lat2 = point2.latitude * pi / 180;
    final double lon2 = point2.longitude * pi / 180;

    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  GoogleMapController? _googleMapController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.orange;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Height of SliverAppBar
  double get sliverAppBarHeight => MediaQuery.of(context).size.height * 2 / 5;

  void _onScroll() {
    // if ((bloc.items?.isNotEmpty == true)) {
    //   double screenHeight = MediaQuery.of(context).size.height;
    //   double currentPosition = _scrollController.offset;
    //   double centerPosition =
    //       currentPosition + (screenHeight - sliverAppBarHeight) / 2;
    //
    //   // Calculate new index based on the center position
    //   int newIndex = ((centerPosition - sliverAppBarHeight) / 580.h)
    //       .floor(); // Adjusted calculation
    //
    //   if (newIndex > 0 &&
    //       newIndex != _currentCenterItemIndex &&
    //       newIndex < bloc.items!.length) {
    //     _currentCenterItemIndex = newIndex;
    //     bloc.centeredItemStreamController.sink.add(bloc.items![newIndex].id);
    //   } else if (newIndex == -1 && _currentCenterItemIndex != 0) {
    //     _currentCenterItemIndex = 0;
    //     bloc.centeredItemStreamController.sink.add(bloc.items![0].id);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          MainBloc(getIt.get(), getIt.get(), getIt.get())..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    bloc = BlocProvider.of<MainBloc>(context);

    return BlocListener<MainBloc, BaseState>(
      listener: (context, state) {
        if (state is ShowErrorMessage) {
          showErrorToast(context, state.message);
        } else if (state is InitialState) {
          _onScroll();
        } else if (state is LoadedItems) {
          _generateMapCircles(true);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    snap: false,
                    centerTitle: false,
                    backgroundColor: ColorName.mainPrimary500Base,
                    title: Assets.images.logoWhite.image(height: 36.h),
                    actions: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: GestureDetector(
                            onTap: () {
                              AppRouter.push(ReelsFilterPage(bloc.filter), (r) {
                                if (r is AdFilterModel) {
                                  bloc.filter = r;
                                  bloc.add(LoadAdListEvent());
                                }
                              });
                            },
                            child: SizedBox(
                              height: 42.w,
                              width: 42.w,
                              child: BoxContainer(
                                withShadow: true,
                                borderRadius: BorderRadius.circular(8.w),
                                color: ColorName.mainSecondary500Base,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Assets.icons.filter.svg(
                                        width: 24.w,
                                      ),
                                    ),
                                    Positioned(
                                        right: 4.w,
                                        top: 4.h,
                                        child: Icon(
                                          Icons.circle,
                                          color: ColorName.mainPrimary500Base,
                                          size: 10.w,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                    expandedHeight: MediaQuery.of(context).size.height * 2 / 5,
                    flexibleSpace: FlexibleSpaceBar(
                      background: BlocBuilder<MainBloc, BaseState>(
                        buildWhen: (p, current) =>
                            current is UpdateMapMarkersState,
                        builder: (context, state) {
                          return GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            gestureRecognizers: <Factory<
                                OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              ),
                            },
                            markers: _markers,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _googleMapController = controller;
                            },
                            onCameraIdle: () {
                              _generateMapCircles(false);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<MainBloc, BaseState>(
                      builder: (context, state) {
                        return bloc.items != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.h,
                                        left: 16.w,
                                        right: 16.w,
                                        bottom: 8.h),
                                    child: TextView(
                                      "${bloc.items!.length} ta e'lonlar",
                                      textStyle: TextViewStyle.SEMIBOLD,
                                      fontSize: 18,
                                    ),
                                  ),
                                  RegularDivider(),
                                ],
                              )
                            : SizedBox();
                      },
                    ),
                  ),
                  BlocBuilder<MainBloc, BaseState>(
                    builder: (context, state) {
                      return bloc.items?.isNotEmpty == true
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                  (_, position) {
                                    final item = bloc.items![position];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.w,
                                          right: 16.w,
                                          bottom: 8.h,
                                          top: position == 0 ? 8.h : 0),
                                      child: BlocBuilder<MainBloc, BaseState>(
                                        buildWhen: (p, current) =>
                                            current is UpdateitemsState ||
                                            (current is UpdateItemState &&
                                                current.adId == item.id),
                                        builder: (context, state) {
                                          if (item.mainVideo?.isNotEmpty ==
                                                  true &&
                                              item.videoController == null) {
                                            item.videoController =
                                                VideoPlayerController
                                                    .networkUrl(Uri.parse(
                                                        BASE_FILE_URL +
                                                            item.mainVideo!));
                                            item.videoController
                                                ?.initialize()
                                                .then((v) {
                                              item.videoController
                                                  ?.setLooping(true);
                                              bloc.add(
                                                  UpdateItemEvent(item.id));
                                            });
                                          }
                                          return VisibilityDetector(
                                            key: Key('video-$position'),
                                            onVisibilityChanged:
                                                (visibilityInfo) {
                                              final visibleFraction =
                                                  visibilityInfo
                                                      .visibleFraction;
                                              if (visibleFraction > 0.8) {
                                                item.videoController?.play();
                                              } else {
                                                item.videoController?.pause();
                                              }
                                            },
                                            child: ReelsItemView(
                                              ad: item,
                                              onCall: () {
                                                checkAuthAndCall(context, () {
                                                  callPhone(context,
                                                      item.phone ?? "");
                                                });
                                              },
                                              onLike: () {
                                                checkAuthAndCall(context, () {
                                                  bloc.add(
                                                      ToggleLikeEvent(item));
                                                });
                                              },
                                              onShare: () {},
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  childCount: bloc.items?.length ?? 0,
                                ))
                              : SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        state is ShowLoadingState && state.show
                                            ? Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              )
                                            : TextView(
                                                "Yaqin atrofda e'lonlar topilmadi!",
                                                textColor:
                                                    ColorName.textTertiaryLight,
                                                textAlign: TextAlign.center,
                                              )
                                      ],
                                    ),
                                  ),
                                );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: safePadding(context).bottom + 100.h,
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: safePadding(context).bottom + 8.h),
                child: BoxContainer(
                  height: 56.w,
                  width: 216.w,
                  borderRadius: BorderRadius.circular(56.w),
                  color: ColorName.white,
                  withShadow: true,
                  padding: EdgeInsets.all(4.w),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 12.h),
                          child: Assets.icons.homeFill.svg(
                              width: 24.w,
                              colorFilter: ColorFilter.mode(
                                  ColorName.mainPrimary500Base,
                                  BlendMode.srcIn)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: BoxContainer(
                            borderRadius: BorderRadius.circular(8.w),
                            color: ColorName.gray100,
                            child: SizedBox(
                              width: 1.w,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            checkAuthAndCall(context, () {
                              AppRouter.push(AddAdPage());
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 12.h),
                            child: Assets.icons.addIcon.svg(
                                width: 24.w,
                                colorFilter: ColorFilter.mode(
                                    ColorName.iconDisabled, BlendMode.srcIn)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: BoxContainer(
                            borderRadius: BorderRadius.circular(8.w),
                            color: ColorName.gray100,
                            child: SizedBox(
                              width: 1.w,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            AppRouter.push(EstatesMapPage());
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 12.h),
                            child: Assets.icons.mapIcon.svg(
                                width: 24.w,
                                colorFilter: const ColorFilter.mode(
                                    ColorName.iconDisabled, BlendMode.srcIn)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Point {
  final String id;
  final double latitude;
  final double longitude;

  Point({required this.id, required this.latitude, required this.longitude});
}
