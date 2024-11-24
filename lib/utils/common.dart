import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jibox_reels/presentation/ui/common/simple_button.dart';
import 'package:jibox_reels/utils/pref_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../di/locator.dart';
import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../presentation/screens/auth/auth_page.dart';
import '../presentation/ui/common/box_conatiner.dart';
import '../presentation/ui/common/text_view.dart';
import 'app_router.dart';

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

EdgeInsets safePadding(BuildContext context) => MediaQuery.paddingOf(context);

Future<bool> openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    return false;
  } else {
    return true;
  }
}

Future<bool> openMap(
    BuildContext context, double latitude, double longitude) async {
  // Construct Google Maps URL
  final String googleMapsUrl =
      'https://www.google.com/maps?q=$latitude,$longitude';
  // Construct Yandex Maps URL
  final String yandexMapsUrl =
      'yandexmaps://maps.yandex.ru/?lat=$latitude&lon=$longitude&z=12';

  // Show Cupertino-style Bottom Sheet (CupertinoActionSheet)
  bool? isGoogleMapsSelected = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: const Text('Xarita turi'),
        message: const Text(
            'Siz tanlagan xaritangizda joylashuvni ko\'rishingiz mumkin bo\'ladi'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, true); // Google Maps selected
            },
            child: const Text('Google Maps'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, false); // Yandex Maps selected
            },
            child: const Text('Yandex Maps'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context); // Cancel the action sheet
          },
          child: const Text('Berkitish'),
          isDestructiveAction: true,
        ),
      );
    },
  );

  // Check the user's selection and open the corresponding map
  if (isGoogleMapsSelected == null) {
    return false; // User dismissed the bottom sheet without selecting
  } else if (isGoogleMapsSelected) {
    // Open Google Maps
    if (await launchUrl(Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication)) {
      return true;
    } else {
      return false;
    }
  } else {
    // Open Yandex Maps
    if (await launchUrl(Uri.parse(yandexMapsUrl),
        mode: LaunchMode.externalApplication)) {
      return true;
    } else {
      return false;
    }
  }
}

showErrorToast(BuildContext context, String message) {
  final fToast = FToast();
  fToast.init(context);

  Widget toast = BoxContainer(
    padding: EdgeInsets.all(16.w),
    withShadow: true,
    color: ColorName.alertError500Base,
    borderRadius: BorderRadius.circular(16.w),
    child: Row(
      children: [
        // Assets.icons.closeCircleFill.svg(width: 28.w, height: 28.w),
        const Icon(
          Icons.warning_rounded,
          color: ColorName.white,
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
            child: TextView(
          message,
          textStyle: TextViewStyle.SEMIBOLD,
          fontSize: 16.sp,
          textColor: ColorName.white,
        ))
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
  );
}

showSuccessToast(BuildContext context, String message) {
  final fToast = FToast();
  fToast.init(context);

  Widget toast = BoxContainer(
    padding: EdgeInsets.all(16.w),
    withShadow: true,
    borderRadius: BorderRadius.circular(16.w),
    child: Row(
      children: [
        Assets.icons.checkboxCircleFill.svg(width: 28.w, height: 28.w),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
            child: TextView(
          message,
          textStyle: TextViewStyle.SEMIBOLD,
          fontSize: 16.sp,
        ))
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
  );
}

String checkPasswordAsStrong(String password) {
  final lowercase = RegExp(r'[a-z]');
  final uppercase = RegExp(r'[A-Z]');
  final number = RegExp(r'[0-9]');

  if (!lowercase.hasMatch(password)) {
    return ('Your password must have a lowercase letter!');
  } else if (!uppercase.hasMatch(password)) {
    return ('Your password must have an uppercase letter!');
  } else if (!number.hasMatch(password)) {
    return ('Your password must have a number!');
  } else if (password.length < 6) {
    return ('Your password must have minimum 6 letter!');
  } else {
    return "";
  }
}

Future<void> showSuccessDialog(
  BuildContext context, {
  required String title,
  required String comment,
  required Function onOk,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.w))),
          contentPadding: EdgeInsets.all(20.w),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Assets.icons.checkboxCircleFill
                    .svg(width: 48.w, height: 48.w),
              ),
              SizedBox(
                height: 24.h,
              ),
              TextView(
                title,
                textStyle: TextViewStyle.BOLD,
                fontSize: 20,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextView(
                comment,
                textColor: ColorName.textTertiaryLight,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24.h,
              ),
              SimpleButton("Ok", () {
                AppRouter.pop();
                onOk();
              }),
            ],
          ));
    },
  );
}

Future<void> showCustomDialog(BuildContext context,
    {required String title,
    required String comment,
    required String buttonTitle,
    required Function onClick,
    Widget? icon}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.w))),
          contentPadding: EdgeInsets.all(20.w),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Center(
                  child: icon,
                ),
              if (icon != null)
                SizedBox(
                  height: 24.h,
                ),
              TextView(
                title,
                textStyle: TextViewStyle.BOLD,
                fontSize: 20,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextView(
                comment,
                textColor: ColorName.textTertiaryLight,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24.h,
              ),
              SimpleButton(buttonTitle, () {
                AppRouter.pop();
                onClick();
              }),
            ],
          ));
    },
  );
}

Future<void> showConfirmDialog(BuildContext context,
    {required String title,
    required String comment,
    required String positiveTitle,
    required String negativeTitle,
    required Function onAllow,
    required Function onCancel}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    // Optional: prevent dismissing by tapping outside
    builder: (context) {
      return Center(
        child: AlertDialog(
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.w))),
          contentPadding: EdgeInsets.all(20.w),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextView(
                title,
                textStyle: TextViewStyle.SEMIBOLD,
                fontSize: 17,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 4.h,
              ),
              TextView(
                comment,
                textColor: ColorName.textTertiaryLight,
                textAlign: TextAlign.center,
                fontSize: 14,
              ),
              SizedBox(
                height: 24.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: SimpleButton(
                      negativeTitle,
                      () {
                        AppRouter.pop();
                        onCancel();
                      },
                      type: SimpleButtonStyle.OUTLINED,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: SimpleButton(
                      positiveTitle,
                      () {
                        AppRouter.pop();
                        onAllow();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

void showBottomSheetDialog({
  required BuildContext context,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: ColorName.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.w),
    ),
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: child,
      );
    },
  );
}

Future<void> callPhone(BuildContext context, String phoneNumber) async {
  await showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: const Text('Telefon raqam'),
        message: Text("+$phoneNumber"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              // Attempt to make a phone call
              Navigator.pop(context); // Close the sheet
              FlutterPhoneDirectCaller.callNumber("+$phoneNumber");
            },
            child: const Text('Qo\'ng\'iroq qilish'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              // Copy the phone number to the clipboard
              Clipboard.setData(ClipboardData(text: "+$phoneNumber"));
              Navigator.pop(context); // Close the sheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nusxa olindi!')),
              );
            },
            child: const Text('Nusxa olish'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context); // Close the sheet without any action
          },
          isDestructiveAction: true,
          child: const Text('Berkitish'),
        ),
      );
    },
  );
}

Future<bool?> callNumber(String phone) {
  return FlutterPhoneDirectCaller.callNumber(phone);
}

Future<String?> showImagePicker(BuildContext context) async {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            try {
              final pickedImage = await ImagePicker()
                  .pickImage(source: ImageSource.camera, imageQuality: 60);
              if (pickedImage != null) {
                if ((await pickedImage.length()) > 1024 * 1024 * 8) {
                  showErrorToast(
                      context, "The maximum image size should be 8MB!");
                } else {
                  Navigator.pop(context, pickedImage.path);
                }
              }
            } catch (e) {
              if (e is PlatformException) {
                Fluttertoast.showToast(
                    msg:
                        "Please allow permissions for the app from the app settings section!");
              }
            }
          },
          child: const Text(
            "Camera",
            style: TextStyle(
              fontSize: 22,
              color: ColorName.blue,
            ),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            final pickedImage =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickedImage != null) {
              if ((await pickedImage.length()) > 1024 * 1024 * 8) {
                showErrorToast(
                    context, "The maximum image size should be 8MB!");
              } else {
                Navigator.pop(context, pickedImage.path);
              }
            }
          },
          child: const Text(
            "Photo",
            style: TextStyle(
              fontSize: 22,
              color: ColorName.blue,
            ),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Cancel",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: ColorName.blue,
          ),
        ),
      ),
    ),
  );
}

void checkAuthAndCall(BuildContext context, Function call) {
  if (getIt.get<PrefUtils>().getToken().isNotEmpty) {
    call();
  } else {
    showConfirmDialog(context,
        title: "Siz ro'yhatdan o'tmagansiz!",
        comment:
            "Yangi e'lon qo'shish uchun iltimos oldin ro'yhatdan o'ting! Bu juda oson!",
        positiveTitle: "Ro'yhatdan o'tish",
        negativeTitle: "Keyinroq", onAllow: () {
      AppRouter.push(AuthPage());
    }, onCancel: () {});
  }
}
