import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final double value;
  const TransactionItem({
    Key? key,
    required this.title,
    required this.date,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          Icons.car_repair_outlined,
          size: 60.sp,
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: SizedBox(
          height: 100.h,
          width: 150.w,
          child: Center(
            child: Text(
              'R\$ ${NumberFormat.currency(locale: 'pt-BR', symbol: '').format(value)}',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
