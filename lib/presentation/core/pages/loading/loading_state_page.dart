import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingStatePage extends StatelessWidget {
  final String? animation;
  const LoadingStatePage({
    Key? key,
    this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                height: 350.h,
                width: 350.h,
                child: Lottie.asset(
                  animation ?? 'assets/animations/loading.json',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
