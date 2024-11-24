import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/data/model/ad_filter_model.dart';
import 'package:jibox_reels/extensions/extensions.dart';
import 'package:jibox_reels/gen/colors.gen.dart';
import 'package:jibox_reels/presentation/screens/main/filter/draw_location/draw_location_page.dart';
import 'package:jibox_reels/presentation/screens/main/filter/select_location/select_location_page.dart';
import 'package:jibox_reels/presentation/ui/common/box_conatiner.dart';
import 'package:jibox_reels/presentation/ui/common/edit_text.dart';
import 'package:jibox_reels/presentation/ui/common/regular_app_bar.dart';
import 'package:jibox_reels/presentation/ui/common/simple_button.dart';
import 'package:jibox_reels/presentation/ui/common/text_view.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/utils/common.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../data/model/enum/estate_type.dart';
import '../../../../gen/assets.gen.dart';
import 'reels_filter_bloc.dart';
import 'reels_filter_event.dart';

class ReelsFilterPage extends StatelessWidget {
  final AdFilterModel filterModel;

  ReelsFilterPage(this.filterModel);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ReelsFilterBloc()..add(InitEvent(filterModel)),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<ReelsFilterBloc>(context);

    return BlocBuilder<ReelsFilterBloc, BaseState>(
      buildWhen: (p, current) => current is InitialState,
      builder: (context, state) {
        return Scaffold(
          appBar: RegularAppBar(context, "Filter"),
          body: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BoxContainer(
                        withShadow: true,
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextView(
                              "Qidiruv markazi",
                              textStyle: TextViewStyle.SEMIBOLD,
                            ),
                            12.height,
                            BoxContainer(
                              color: ColorName.backgroundColor,
                              borderRadius: BorderRadius.circular(12.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 14.h),
                              child: Row(
                                children: [
                                  Assets.icons.locations.svg(width: 20.w),
                                  8.width,
                                  Expanded(
                                      child: TextView(
                                    "Xaritada nuqta belgilangan",
                                    textColor: ColorName.textPrimary,
                                    textStyle: TextViewStyle.SEMIBOLD,
                                  )),
                                ],
                              ),
                            ),
                            8.height,
                            Row(
                              children: [
                                Expanded(child: SimpleButton("Chegaralar chizish", (){
                                  AppRouter.push(
                                      DrawLocationPage(LatLng(
                                          bloc.filter.latitude,
                                          bloc.filter.longitude)), (r) {
                                    if (r is LatLng) {
                                      bloc.filter.latitude = r.latitude;
                                      bloc.filter.longitude = r.longitude;
                                    }
                                  });
                                }, icon: Assets.images.square.path, type: SimpleButtonStyle.OUTLINED,), ),
                                8.width,
                                Expanded(child: SimpleButton("Nuqta belgilash", (){
                                  AppRouter.push(
                                      SelectLocationPage(LatLng(
                                          bloc.filter.latitude,
                                          bloc.filter.longitude)), (r) {
                                    if (r is LatLng) {
                                      bloc.filter.latitude = r.latitude;
                                      bloc.filter.longitude = r.longitude;
                                    }
                                  });
                                }, icon: Assets.images.location.path,)),
                              ],
                            )
                          ],
                        ),
                      ),
                      4.height,
                      BoxContainer(
                        withShadow: true,
                        padding: EdgeInsets.all(16.w),
                        child: BlocBuilder<ReelsFilterBloc, BaseState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextView(
                                        "Qidiruv radiusi",
                                        textStyle: TextViewStyle.SEMIBOLD,
                                      ),
                                    ),
                                    TextView(
                                        "${bloc.filter.fromRadius.toInt()} km - ${bloc.filter.toRadius.toInt()} km")
                                  ],
                                ),
                                12.height,
                                SfRangeSlider(
                                  min: 0.0,
                                  max: 100.0,
                                  stepSize: 1,
                                  values: SfRangeValues(bloc.filter.fromRadius,
                                      bloc.filter.toRadius),
                                  showTicks: false,
                                  semanticFormatterCallback:
                                      (dynamic value, SfThumb thumb) {
                                    return 'The $thumb value is $value';
                                  },
                                  minorTicksPerInterval: 1,
                                  onChanged: (SfRangeValues values) {
                                    bloc.add(UpdateRangeEvent(values));
                                  },
                                  activeColor: ColorName.mainPrimary500Base,
                                  tooltipTextFormatterCallback: (v, _) {
                                    return "$v km";
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      4.height,
                      BlocBuilder<ReelsFilterBloc, BaseState>(
                        builder: (context, state) {
                          return BoxContainer(
                            withShadow: true,
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextView(
                                  "E'lon turi",
                                  textStyle: TextViewStyle.SEMIBOLD,
                                ),
                                12.height,
                                Wrap(
                                  spacing: 10.w,
                                  runSpacing: 8.h,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        bloc.add(UpdateAdTypeEvent(null));
                                      },
                                      child: BoxContainer(
                                        borderRadius:
                                            BorderRadius.circular(16.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 6.h),
                                        color: bloc.filter.adType == null
                                            ? ColorName.mainPrimary500Base
                                            : ColorName.backgroundColor,
                                        child: TextView(
                                          "Barchasi",
                                          textColor: bloc.filter.adType == null
                                              ? Colors.white
                                              : ColorName.textPrimary,
                                        ),
                                      ),
                                    ),
                                    ...AdType.values
                                        .where((item) => item != AdType.NONE)
                                        .map((item) {
                                      return GestureDetector(
                                        onTap: () {
                                          bloc.add(UpdateAdTypeEvent(item));
                                        },
                                        child: BoxContainer(
                                          borderRadius:
                                              BorderRadius.circular(16.w),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 6.h),
                                          color: bloc.filter.adType == item
                                              ? ColorName.mainPrimary500Base
                                              : ColorName.backgroundColor,
                                          child: TextView(
                                            item.getTitle(),
                                            textColor:
                                                bloc.filter.adType == item
                                                    ? Colors.white
                                                    : ColorName.textPrimary,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      4.height,
                      BoxContainer(
                        withShadow: true,
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextView(
                              "Qavati",
                              textStyle: TextViewStyle.SEMIBOLD,
                            ),
                            12.height,
                            Row(
                              children: [
                                Expanded(
                                  child: EditText(
                                    "Qavatdan",
                                    textEditingController:
                                        TextEditingController(
                                            text: bloc.filter.fromFloor
                                                ?.toString()),
                                    onChanged: (v) {
                                      bloc.filter.fromFloor = int.tryParse(v);
                                    },
                                    inputType: TextInputType.number,
                                  ),
                                ),
                                8.width,
                                Expanded(
                                    child: EditText(
                                  "Qavatgacha",
                                  textEditingController: TextEditingController(
                                      text: bloc.filter.toFloor?.toString()),
                                  onChanged: (v) {
                                    bloc.filter.toFloor = int.tryParse(v);
                                  },
                                  inputType: TextInputType.number,
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                      4.height,
                      BoxContainer(
                        withShadow: true,
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextView(
                              "Xonalar soni",
                              textStyle: TextViewStyle.SEMIBOLD,
                            ),
                            12.height,
                            Row(
                              children: [
                                Expanded(
                                    child: EditText(
                                  "Xonadan",
                                  textEditingController: TextEditingController(
                                      text: bloc.filter.fromRoomCount
                                          ?.toString()),
                                  onChanged: (v) {
                                    bloc.filter.fromRoomCount = int.tryParse(v);
                                  },
                                  inputType: TextInputType.number,
                                )),
                                8.width,
                                Expanded(
                                    child: EditText(
                                  "Xonagacha",
                                  textEditingController: TextEditingController(
                                      text:
                                          bloc.filter.toRoomCount?.toString()),
                                  onChanged: (v) {
                                    bloc.filter.toRoomCount = int.tryParse(v);
                                  },
                                  inputType: TextInputType.number,
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                      4.height,
                      BoxContainer(
                        withShadow: true,
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                TextView(
                                  "Valyuta",
                                  textStyle: TextViewStyle.SEMIBOLD,
                                ),
                              ],
                            ),
                            12.height,
                            BlocBuilder<ReelsFilterBloc, BaseState>(
                              builder: (context, state) {
                                return CustomSlidingSegmentedControl(
                                  children: <CurrencyType, Widget>{
                                    CurrencyType.UZS: TextView(
                                      CurrencyType.UZS.getTitle(),
                                      textStyle: bloc.filter.currency ==
                                              CurrencyType.UZS
                                          ? TextViewStyle.SEMIBOLD
                                          : TextViewStyle.REGULAR,
                                      textColor: bloc.filter.currency ==
                                              CurrencyType.UZS
                                          ? Colors.white
                                          : ColorName.textPrimary,
                                    ),
                                    CurrencyType.USD: TextView(
                                      CurrencyType.USD.getTitle(),
                                      textStyle: bloc.filter.currency ==
                                              CurrencyType.USD
                                          ? TextViewStyle.SEMIBOLD
                                          : TextViewStyle.REGULAR,
                                      textColor: bloc.filter.currency ==
                                              CurrencyType.USD
                                          ? Colors.white
                                          : ColorName.textPrimary,
                                    ),
                                  },
                                  decoration: BoxDecoration(
                                    color: ColorName.backgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  thumbDecoration: BoxDecoration(
                                    color: ColorName.mainPrimary500Base,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInToLinear,
                                  onValueChanged: (v) {
                                    bloc.filter.currency = v;
                                    bloc.add(UpdateCurrencyEvent());
                                  },
                                  isStretch: true,
                                  initialValue: CurrencyType.USD,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      4.height,
                      BoxContainer(
                        withShadow: true,
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                TextView(
                                  "Narxi",
                                  textStyle: TextViewStyle.SEMIBOLD,
                                ),
                              ],
                            ),
                            12.height,
                            Row(
                              children: [
                                Expanded(
                                    child: EditText(
                                  "Summadan",
                                  textEditingController: TextEditingController(
                                      text: bloc.filter.fromSumma?.toString()),
                                  onChanged: (v) {
                                    bloc.filter.fromSumma = int.tryParse(v);
                                  },
                                  inputType: TextInputType.number,
                                )),
                                8.width,
                                Expanded(
                                    child: EditText(
                                  "Summagacha",
                                  textEditingController: TextEditingController(
                                      text: bloc.filter.toSumma?.toString()),
                                  onChanged: (v) {
                                    bloc.filter.toSumma = int.tryParse(v);
                                  },
                                  inputType: TextInputType.number,
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                      4.height,
                      BoxContainer(
                        withShadow: true,
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextView(
                              "Qo'shimchalar",
                              textStyle: TextViewStyle.SEMIBOLD,
                            ),
                            12.height,
                            BlocBuilder<ReelsFilterBloc, BaseState>(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    CupertinoSwitch(
                                        value: bloc.filter.isNew,
                                        onChanged: (v) {
                                          bloc.filter.isNew = v;
                                          bloc.add(UpdateIsNewEvent());
                                        }),
                                    TextView(
                                      "Yangi qurilgan uylar",
                                    )
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      (safePadding(context).bottom + 200).height
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BoxContainer(
                  withShadow: true,
                  padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: safePadding(context).bottom + 16.h,
                      top: 16.h),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.w),
                      topRight: Radius.circular(8.w)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Assets.icons.notificationBell.svg(width: 24.w),
                          8.width,
                          Expanded(
                            child:
                                TextView("Yangi e'lon joylansa habar berish"),
                          ),
                          CupertinoSwitch(value: true, onChanged: (v) {})
                        ],
                      ),
                      12.height,
                      Row(
                        children: [
                          Expanded(
                              child: SimpleButton(
                            "Tozalash",
                            () {
                              bloc.add(ClearFilterEvent());
                            },
                            type: SimpleButtonStyle.OUTLINED,
                          )),
                          8.width,
                          Expanded(
                              child: SimpleButton("Saqlash", () {
                            AppRouter.pop(bloc.filter);
                          })),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
