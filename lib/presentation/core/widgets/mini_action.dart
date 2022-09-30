import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiniAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double? size;
  const MiniAction({
    Key? key,
    required this.icon,
    required this.onTap,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 70.sp,
      width: size ?? 70.sp,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: Colors.white,
          size: (size ?? 70.sp) / 1.5,
        ),
        onPressed: onTap,
      ),
    );
  }
}
