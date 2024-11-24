import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/di/locator.dart';
import 'package:jibox_reels/extensions/extensions.dart';
import 'package:jibox_reels/presentation/screens/main/main_page.dart';
import 'package:jibox_reels/utils/common.dart';
import 'package:pinput/pinput.dart';

import '../../../../gen/colors.gen.dart';
import '../../../../utils/app_router.dart';
import '../../../ui/common/box_conatiner.dart';
import '../../../ui/common/regular_app_bar.dart';
import '../../../ui/common/simple_button.dart';
import '../../../ui/common/text_view.dart';
import 'auth_confirm_bloc.dart';
import 'auth_confirm_event.dart';
import 'auth_confirm_state.dart';

class AuthConfirmPage extends StatelessWidget {
  final String phone;

  AuthConfirmPage(this.phone);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AuthConfirmBloc(getIt.get(), getIt.get())..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<AuthConfirmBloc>(context);
    double size = ((MediaQuery.of(context).size.width - 56.w) / 4) - 2;
    print(size);
    final defaultPinTheme = PinTheme(
      width: size > 100 ? 100 : size,
      height: size > 100 ? 100 : size,
      textStyle: const TextStyle(
          fontSize: 20,
          color: ColorName.textPrimary,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: ColorName.backgroundColor,
        borderRadius: BorderRadius.circular(16.w),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorName.mainPrimary500Base),
      borderRadius: BorderRadius.circular(16.w),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
        decoration: BoxDecoration(
      color: ColorName.mainPrimary500Base.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16.w),
    ));

    return BlocListener<AuthConfirmBloc, BaseState>(
      listener: (context, state) {
        if (state is ShowErrorMessage) {
          showErrorToast(context, state.message);
        } else if (state is NavigateToMainState) {
          AppRouter.pushAndClear(MainPage());
        }
      },
      child: Scaffold(
        appBar: RegularAppBar(context, "Tizimga kirish"),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BoxContainer(
                padding: EdgeInsets.all(16.w),
                withShadow: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextView(
                      "Telefon raqamingizni kiriting",
                      textStyle: TextViewStyle.SEMIBOLD,
                      fontSize: 24,
                    ),
                    8.height,
                    TextView(
                      "Tasdiqlash kodi bilan SMS xabar yuboriladi.",
                    ),
                    32.height,
                    Pinput(
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      controller: bloc.otpTextEditingController,
                      submittedPinTheme: submittedPinTheme,
                      length: 4,
                      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                      showCursor: true,
                      onChanged: (text) {
                        bloc.add(ChangePinEvent());
                      },
                      onCompleted: (pin) => print(pin),
                    ),
                    20.height,
                    BlocBuilder<AuthConfirmBloc, BaseState>(
                      builder: (context, state) {
                        return SimpleButton(
                          "Keyingisi",
                          () {
                            bloc.add(SubmitEvent(phone));
                          },
                          active:
                              bloc.otpTextEditingController.text.length == 4,
                          progress: state is ShowLoadingState && state.show,
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
