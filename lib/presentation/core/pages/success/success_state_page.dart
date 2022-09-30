import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/custom_buttom.dart';

class SuccessStatePage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Object? valueReturned;
  const SuccessStatePage({
    Key? key,
    required this.title,
    required this.subtitle,
    this.valueReturned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 50.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400.h,
                    width: 400.h,
                    child: Lottie.asset(
                      'assets/animations/done.json',
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 42.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.black87, fontSize: 36.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          CustomButtom(
            onTap: () {
              if (valueReturned != null) {
                context.router.pop(valueReturned);
              } else {
                context.router.pop();
              }
            },
            title: "Aceitar",
            width: 1.3.sw,
            isActive: true,
          ),
          SizedBox(
            height: ScreenUtil().bottomBarHeight,
          )
        ],
      ),
    );
  }
}
