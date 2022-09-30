import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/animations/fade_animation.dart';
import '../../core/animations/traslade_x_fade_animation.dart';
import '../../core/animations/traslade_y_fade_animation.dart';
import '../../core/widgets/custom_buttom.dart';

import '../../routes/router.gr.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          padding: EdgeInsets.only(
            top: ScreenUtil().statusBarHeight * 1.5,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xffFF8617),
                const Color(0xffF59E16).withOpacity(0.7),
              ],
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeAnimation(
                delay: 1.2,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 50.w,
                    bottom: 100.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "welcome_page.title".tr(),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 75.sp,
                            ),
                      ),
                      Text(
                        "welcome_page.subtitle".tr(),
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              TrasladeXFadeAnimation(
                delay: 1,
                child: Image.asset(
                  "assets/img/login.png",
                ),
              ),
              const Spacer(),
              TrasladeYFadeAnimation(
                delay: 2.5,
                child: CustomButtom(
                  onTap: () => context.router.push(
                    const SignInRoute(),
                  ),
                  title: "welcome_page.action".tr(),
                  width: 1.2.sw,
                  isActive: true,
                  hasGradient: false,
                ),
              ),
              SizedBox(
                height: ScreenUtil().bottomBarHeight,
              )
            ],
          ),
        ),
      ),
    );
  }
}
