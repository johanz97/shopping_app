import 'package:card_selector/card_selector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../aplication/wallet/select_card/select_card_bloc.dart';
import '../../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../core/widgets/custom_text_button.dart';
import '../../wallet/credit_card/widgets/credit_card_ui/credit_card.dart';
import '../../wallet/credit_card/widgets/credit_card_ui/extra/card_type.dart';
import '../../wallet/credit_card/widgets/credit_card_ui/style/card_background.dart';

class CreditCardsListModal extends StatelessWidget {
  final Function onAccept;
  final VoidCallback onCancel;

  const CreditCardsListModal({
    Key? key,
    required this.onAccept,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectCardBloc, SelectCardState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                  child: Center(
                    child: Text(
                      "TicketNotPaidStatusWidget.cards_list_modal.title".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 36.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (state.creditCards.isNotEmpty &&
                    state.creditCards.length != 1)
                  CardSelector(
                    cards: List.generate(state.creditCards.length, (index) {
                      return CreditCard(
                        height: 280.h,
                        isSelected: state.creditCardInfo.id ==
                            state.creditCards[index].id,
                        frontBackground: CardBackgrounds.getAnyColor(index),
                        frontTextColor:
                            index == 1 ? Colors.black : Colors.white,
                        backBackground: CardBackgrounds.black,
                        cardType: CardType.dinersClub,
                        showShadow: true,
                        cardNumber:
                            "XXXX XXXX XXXX ${state.creditCards[index].cardNumber.substring(11, 16)}",
                        textExpiry:
                            "${state.creditCards[index].cardMonth}/${state.creditCards[index].cardYear.substring(2, 4)}",
                        cardHolderName: state.creditCards[index].holderName,
                      );
                    }),
                    mainCardHeight: 320.h,
                    mainCardWidth: 0.9.sw,
                    cardAnimationDurationMs: 200,
                    cardsGap: 30.0,
                    onChanged: (int value) {},
                  ),
                if (state.creditCards.length == 1)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: CreditCard(
                      height: 260.h,
                      width: 0.4,
                      isSelected:
                          state.creditCardInfo.id == state.creditCards.first.id,
                      frontBackground: CardBackgrounds.getAnyColor(0),
                      backBackground: CardBackgrounds.black,
                      cardType: CardType.dinersClub,
                      showShadow: true,
                      cardNumber:
                          "XXXX XXXX XXXX ${state.creditCards.first.cardNumber.substring(11, 16)}",
                      textExpiry:
                          "${state.creditCards.first.cardMonth}/${state.creditCards.first.cardYear.substring(2, 4)}",
                      cardHolderName: state.creditCards.first.holderName,
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtom(
                      onTap: () => onAccept(state.creditCardInfo),
                      title: "TicketNotPaidStatusWidget.cards_list_modal.accept"
                          .tr(),
                      width: 1.3.sw,
                      isActive: state.creditCardInfo == CreditCardInfo.test(),
                    ),
                    CustomTextButton(
                      content:
                          "TicketNotPaidStatusWidget.cards_list_modal.cancel"
                              .tr(),
                      heigth: 70.h,
                      width: 400.w,
                      onPressed: onCancel,
                    ),
                    SizedBox(height: 20.h)
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
