import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardFrontLayout {
  String bankName;
  String? cardNumber;
  String? cardExpiry;
  String? cardHolderName;
  Widget? cardTypeIcon;
  double? cardWidth;
  double? cardHeight;
  Color? textColor;

  String? textExpDate;
  String? textName;
  String? textExpiry;

  CardFrontLayout({
    this.bankName = '',
    this.cardNumber = '',
    this.cardExpiry = '',
    this.cardHolderName = '',
    this.textExpDate = 'Exp. Date',
    this.textExpiry = 'MM/YY',
    this.textName = 'Card Holder',
    this.cardTypeIcon,
    this.cardWidth = 0,
    this.cardHeight = 0,
    this.textColor,
  });

  Widget layout1() {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    bankName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/img/contactless_icon.png',
                      fit: BoxFit.fitHeight,
                      width: 40.0.sp,
                      height: 40.0.sp,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            cardNumber == null || cardNumber!.isEmpty
                                ? 'XXXX XXXX XXXX XXXX'
                                : cardNumber!,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MavenPro',
                              fontSize: bankName.isEmpty ? 22 : 15,
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                textExpDate!,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'MavenPro',
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                width: 10.h,
                              ),
                              Text(
                                cardExpiry == null || cardExpiry!.isEmpty
                                    ? textExpiry!
                                    : cardExpiry!,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'MavenPro',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            cardHolderName == null || cardHolderName!.isEmpty
                                ? textName!
                                : cardHolderName!,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MavenPro',
                              fontSize: 17,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      cardTypeIcon!
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
