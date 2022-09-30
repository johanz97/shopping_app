import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_buttom.dart';
import '../../../../routes/router.gr.dart';

class WalletNewUser extends StatelessWidget {
  const WalletNewUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 80.w,
      ),
      child: SizedBox(
        height: 0.95.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/img/wallet.png",
                ),
                SizedBox(height: 50.h),
                Text(
                  "wallet_home_page.tuto_msg".tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 38.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            CustomButtom(
              onTap: () => context.router.push(
                const UserWelcomeFormRoute(),
              ),
              title: "wallet_home_page.action_1".tr(),
              width: 1.2.sw,
              isActive: true,
              icon: Icons.add,
            )
          ],
        ),
      ),
    );
  }
}
