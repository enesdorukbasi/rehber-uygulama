import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DialogWidget {
  static Future<bool> faildDialog(BuildContext context, String text) async {
    bool isDeleted = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.pop(context),
        );
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 80.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dangerous,
                          color: Colors.white,
                          size: 7.w,
                        ),
                        SizedBox(
                          width: 70.w,
                          child: Text(
                            text,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return isDeleted;
  }

  static Future<void> regurableDialog(
      BuildContext context, Widget child) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: child,
        );
      },
    );
  }
}
