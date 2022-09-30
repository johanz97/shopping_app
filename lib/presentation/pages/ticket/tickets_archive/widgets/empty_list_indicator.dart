import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyListIndicator extends StatelessWidget {
  final String message;
  final IconData icon;
  const EmptyListIndicator({
    Key? key,
    required this.message,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          SizedBox(
            height: 260.h,
          ),
          Icon(
            icon,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 10.h,
          ),
          Align(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
