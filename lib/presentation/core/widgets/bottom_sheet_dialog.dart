import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_buttom.dart';
import 'custom_text_button.dart';

class BottomSheetDialog extends StatelessWidget {
  final String? title;
  final String? accept;
  final String? cancel;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;

  const BottomSheetDialog({
    Key? key,
    this.title,
    this.accept,
    this.cancel,
    this.onAccept,
    this.onCancel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
              child: Center(
                child: Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: 36.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButtom(
                  onTap: onAccept!,
                  title: accept!,
                  width: 1.3.sw,
                  isActive: true,
                ),
                CustomTextButton(
                  content: cancel!,
                  heigth: 70.h,
                  width: 400.w,
                  onPressed: onCancel!,
                ),
                SizedBox(height: 20.h)
              ],
            )
          ],
        ),
      ),
    );
  }
}
