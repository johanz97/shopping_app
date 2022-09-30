import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/custom_buttom.dart';

class InfoModal extends StatelessWidget {
  final bool isPaid;
  const InfoModal({
    Key? key,
    required this.isPaid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height: 0.43.sh,
        constraints: const BoxConstraints(maxWidth: 350),
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomButtom(
              width: 260,
              isActive: true,
              onTap: () => context.router.pop(),
              title: isPaid
                  ? 'info_app_container.action_1'.tr()
                  : 'info_app_container.action_2'.tr(),
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
