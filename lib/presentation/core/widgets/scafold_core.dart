import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../routes/router.gr.dart';

class ScaffoldCore extends StatelessWidget {
  final Widget body;
  final bool showActions;
  const ScaffoldCore({
    Key? key,
    required this.body,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size(1.sw, 140.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/img/banner.png',
              height: 180.h,
            ),
            Visibility(
              visible: showActions,
              child: Padding(
                padding: EdgeInsets.only(right: 20.w, top: 20.h),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => {
                        context.router.push(
                          const UserProfileRoute(),
                        )
                      },
                      child: Container(
                        width: 80.sp,
                        height: 80.sp,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Icon(
                          Icons.account_circle_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 60.sp,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.router.push(
                        const WalletHomeRoute(),
                      ),
                      icon: Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 60.sp,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.router.push(
                        const TicketsArchiveRoute(),
                      ),
                      icon: Icon(
                        Icons.archive_rounded,
                        size: 60.sp,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        constraints: BoxConstraints(
          minWidth: 1.sw,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF4EF),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: body,
      ),
    );
  }
}
