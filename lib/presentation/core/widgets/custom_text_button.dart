import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  final String content;
  final VoidCallback onPressed;
  final double? heigth;
  final double? width;

  const CustomTextButton({
    Key? key,
    required this.content,
    required this.onPressed,
    this.heigth,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      height: heigth ?? 80.h,
      width: width ?? 1.sw,
      alignment: Alignment.center,
      child: InkWell(
        onTap: onPressed,
        child: Text(
          content,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 32.sp,
              ),
        ),
      ),
    );
  }
}
