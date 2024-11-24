import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/di/locator.dart';
import 'package:jibox_reels/extensions/extensions.dart';
import 'package:jibox_reels/presentation/screens/auth/auth_state.dart';
import 'package:jibox_reels/presentation/screens/auth/confirm/auth_confirm_page.dart';
import 'package:jibox_reels/presentation/ui/common/box_conatiner.dart';
import 'package:jibox_reels/presentation/ui/common/edit_text.dart';
import 'package:jibox_reels/presentation/ui/common/regular_app_bar.dart';
import 'package:jibox_reels/presentation/ui/common/simple_button.dart';
import 'package:jibox_reels/presentation/ui/common/text_view.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/utils/common.dart';

import 'auth_bloc.dart';
import 'auth_event.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthBloc(getIt.get())..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, BaseState>(
      listener: (context, state) {
        if (state is ShowErrorMessage) {
          showErrorToast(context, state.message);
        } else if (state is NavigateToConfirmState) {
          AppRouter.push(AuthConfirmPage(state.phone));
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
                    EditText(
                      "Telefon raqam",
                      textEditingController: bloc.phoneEditingController,
                      inputFormatters: [bloc.maskFormatter],
                      onChanged: (v) {
                        bloc.add(ChangePhoneEvent());
                      },
                    ),
                    20.height,
                    BlocBuilder<AuthBloc, BaseState>(
                      builder: (context, state) {
                        return SimpleButton(
                          "Keyingisi",
                          () {
                            bloc.add(SubmitEvent());
                          },
                          progress: state is ShowLoadingState && state.show,
                          active: bloc.phoneEditingController.text.length >= 12,
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
