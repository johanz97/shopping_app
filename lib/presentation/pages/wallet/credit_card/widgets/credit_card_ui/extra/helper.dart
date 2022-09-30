import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'card_type.dart';

Widget getCardTypeIcon({CardType? cardType, String? cardNumber}) {
  switch (cardType ?? getCardType(cardNumber!)) {
    case CardType.americanExpress:
      return Image.asset(
        'assets/img/american_express.png',
        width: 95.sp,
        height: 80.sp,
      );
    case CardType.dinersClub:
      return Image.asset(
        'assets/img/diners_club.png',
        width: 80.sp,
        height: 80.sp,
      );
    case CardType.discover:
      return Image.asset(
        'assets/img/discover.png',
        width: 90.sp,
        height: 70.sp,
      );
    case CardType.jcb:
      return Image.asset(
        'assets/img/jcb.png',
        width: 80.sp,
        height: 80.sp,
      );
    case CardType.masterCard:
      return Image.asset(
        'assets/img/master_card.png',
        width: 95.sp,
        height: 80.sp,
      );
    case CardType.maestro:
      return Image.asset(
        'assets/img/maestro.png',
        width: 95.sp,
        height: 80.sp,
      );
    case CardType.rupay:
      return Image.asset(
        'assets/img/rupay.png',
        width: 120.sp,
        height: 90.sp,
      );
    case CardType.visa:
      return Image.asset(
        'assets/img/visa.png',
        width: 95.sp,
        height: 80.sp,
      );
    case CardType.elo:
      return Image.asset(
        'assets/img/elo.png',
        width: 90.sp,
        height: 90.sp,
      );
    default:
      return Container();
  }
}

CardType getCardType(String cardNumber) {
  final rAmericanExpress = RegExp(r'^3[47][0-9]{0,}$');
  final rDinersClub = RegExp(r'^3(?:0[0-59]{1}|[689])[0-9]{0,}$');
  final rDiscover = RegExp(
    r'^(6011|65|64[4-9]|62212[6-9]|6221[3-9]|622[2-8]|6229[01]|62292[0-5])[0-9]{0,}$',
  );
  final rJcb = RegExp(r'^(?:2131|1800|35)[0-9]{0,}$');
  final rMasterCard =
      RegExp(r'^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]{0,}$');
  final rMaestro = RegExp(r'^(5[06789]|6)[0-9]{0,}$');
  final rRupay = RegExp(r'^(6522|6521|60)[0-9]{0,}$');
  final rVisa = RegExp(r'^4[0-9]{0,}$');
  final rElo = RegExp(
    '^(4011(78|79)|43(1274|8935)|45(1416|7393|763(1|2))|50(4175|6699|67[0-7][0-9]|9000)|50(9[0-9][0-9][0-9])|627780|63(6297|6368)|650(03([^4])|04([0-9])|05(0|1)|05([7-9])|06([0-9])|07([0-9])|08([0-9])|4([0-3][0-9]|8[5-9]|9[0-9])|5([0-9][0-9]|3[0-8])|9([0-6][0-9]|7[0-8])|7([0-2][0-9])|541|700|720|727|901)|65165([2-9])|6516([6-7][0-9])|65500([0-9])|6550([0-5][0-9])|655021|65505([6-7])|6516([8-9][0-9])|65170([0-4]))',
  );

  // Remove all the spaces from the card number
  final newCardNumber = cardNumber.trim().replaceAll(' ', '');

  if (rAmericanExpress.hasMatch(newCardNumber)) {
    return CardType.americanExpress;
  } else if (rMasterCard.hasMatch(newCardNumber)) {
    return CardType.masterCard;
  } else if (rVisa.hasMatch(newCardNumber)) {
    return CardType.visa;
  } else if (rDinersClub.hasMatch(newCardNumber)) {
    return CardType.dinersClub;
  } else if (rRupay.hasMatch(newCardNumber)) {
    // Additional check to see if it's a discover card
    // Some discover card starts with 6011 and some rupay card starts with 60
    // If the card number matches the 6011 then it must be discover.

    // Note: Keep rupay check before the discover check
    if (rDiscover.hasMatch(newCardNumber)) {
      return CardType.discover;
    } else {
      return CardType.rupay;
    }
  } else if (rDiscover.hasMatch(newCardNumber)) {
    return CardType.discover;
  } else if (rJcb.hasMatch(newCardNumber)) {
    return CardType.jcb;
  } else if (rElo.hasMatch(newCardNumber)) {
    return CardType.elo;
  } else if (rMaestro.hasMatch(newCardNumber)) {
    return CardType.maestro;
  }

  return CardType.unknown;
}
