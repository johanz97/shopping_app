import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardBackLayout {
  String? cvv;
  double? width;
  double? height;
  Color? color;

  CardBackLayout({this.cvv, this.width, this.height, this.color});

  Widget layout1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Container(
          color: Colors.black,
          height: 40,
          width: 350,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 40,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 40,
              width: 120,
              child: Align(
                child: Text(
                  cvv.toString(),
                  style: TextStyle(
                    fontSize: 37.sp,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
