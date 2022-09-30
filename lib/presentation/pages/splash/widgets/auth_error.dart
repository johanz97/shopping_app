import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/custom_buttom.dart';

class AuthError extends StatelessWidget {
  final VoidCallback reload;
  const AuthError({
    Key? key,
    required this.reload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            toolbarHeight: 110.h,
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                "global_error_messages.title".tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => context.router.pop(),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 40.w,
            ),
            child: Text(
              "global_error_messages.subtitle".tr(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          CustomButtom(
            onTap: reload,
            title: "Volver a intentar",
            width: double.infinity,
            isActive: true,
          )
        ],
      ),
    );
  }
}
