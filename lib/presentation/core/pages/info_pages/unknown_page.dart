import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/custom_buttom.dart';

class UnknownPage extends StatelessWidget {
  final VoidCallback reload;
  const UnknownPage({Key? key, required this.reload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/not-found.json',
            height: 0.5.sh,
            width: 0.8.sw,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 50.w,
            ),
            child: Text(
              'error_page.error_not_found'.tr(),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          CustomButtom(
            isActive: true,
            onTap: reload,
            title: "error_page.action".tr(),
            width: 0.9.sw,
          )
        ],
      ),
    );
  }
}
