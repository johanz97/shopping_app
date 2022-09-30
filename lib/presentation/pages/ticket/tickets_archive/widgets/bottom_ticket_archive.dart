import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomTicketArchive extends StatelessWidget {
  final String ticketNumber;
  const BottomTicketArchive({Key? key, required this.ticketNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      color: Colors.white,
      width: double.infinity,
      height: 0.18.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 30.w,
            ),
            child: Column(
              children: [
                BarcodeWidget(
                  barcode: Barcode.itf(),
                  data: ticketNumber,
                  height: 50.h,
                  width: 450.w,
                  drawText: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: BarcodeWidget(
                    barcode: Barcode.itf(),
                    height: 50.h,
                    width: 450.w,
                    drawText: false,
                    data: ticketNumber,
                  ),
                ),
                BarcodeWidget(
                  barcode: Barcode.itf(),
                  data: ticketNumber,
                  height: 50.h,
                  width: 450.w,
                  drawText: false,
                ),
                Text(
                  ticketNumber,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
