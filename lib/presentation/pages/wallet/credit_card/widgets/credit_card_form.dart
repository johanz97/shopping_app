import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../aplication/wallet/credit_card_form_bloc/credit_card_form_bloc.dart';

import '../../../../../core/validator.dart';
import '../../../../../responsive.dart';
import '../../../../core/widgets/border_input.dart';
import '../../../../core/widgets/custom_buttom.dart';

class CreditCardForm extends StatelessWidget {
  final FocusNode focusNode;

  final VoidCallback flipCard;
  final CreditCardFormState state;

  const CreditCardForm({
    Key? key,
    required this.focusNode,
    required this.flipCard,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode:
          state.hasErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Container(
        margin: EdgeInsets.only(top: 0.30.sh),
        height: 0.55.sh,
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context)
              ? 0.05.sw
              : Responsive.isTablet(context)
                  ? 0.25.sw
                  : 0.35.sw,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'credit_card_form.card_number.title'.tr(),
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.start,
            ),
            BorderInput(
              filterPattern: '[A-Za-z]',
              text: 'credit_card_form.card_number.hint'.tr(),
              keyboardType: TextInputType.number,
              initialValue: state.cardNumber,
              onChange: (input) {
                if (input.length == 16 && !input.contains(' ')) {
                  context.read<CreditCardFormBloc>().add(
                        CreditCardFormEvent.cardNumberChanged(
                          state.cardNumberController.text,
                        ),
                      );
                } else {
                  context
                      .read<CreditCardFormBloc>()
                      .add(CreditCardFormEvent.cardNumberChanged(input));
                }
              },
              textEditingController: state.cardNumberController,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(state.cardHolderNode);
              },
              maxLength: 19,
              validator: (value) => Validator.validateCardNumber(value!).fold(
                (f) => f.maybeMap(
                  empty: (_) => 'credit_card_form.card_number.error_1'.tr(),
                  missingStringLength: (_) =>
                      'credit_card_form.card_number.error_2'.tr(),
                  orElse: () => null,
                ),
                (_) => null,
              ),
            ),
            Text(
              'credit_card_form.holder_name.title'.tr(),
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.start,
            ),
            BorderInput(
              filterPattern: '[0-9]',
              focusNode: state.cardHolderNode,
              initialValue: state.holderName,
              text: 'credit_card_form.holder_name.hint'.tr(),
              textEditingController: state.cardHolderNameController,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(state.expiryDateNode);
              },
              keyboardType: TextInputType.name,
              maxLength: 25,
              onChange: (input) => context
                  .read<CreditCardFormBloc>()
                  .add(CreditCardFormEvent.nameChanged(input)),
              validator: (value) => Validator.validateName(value!).fold(
                (f) => f.maybeMap(
                  empty: (_) => 'credit_card_form.holder_name.error_1'.tr(),
                  notIsOnlyString: (_) => 'No Numeros',
                  orElse: () => null,
                ),
                (_) => null,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'credit_card_form.date_exp.title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      BorderInput(
                        filterPattern: '[A-Za-z]',
                        keyboardType: TextInputType.number,
                        initialValue: state.dateExp,
                        text: 'credit_card_form.date_exp.hint'.tr(),
                        maxLength: 7,
                        focusNode: state.expiryDateNode,
                        onChange: (input) => context
                            .read<CreditCardFormBloc>()
                            .add(CreditCardFormEvent.cardDateChanged(input)),
                        textEditingController: state.expiryDateController,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                        validator: (value) =>
                            Validator.validateDateExp(value!).fold(
                          (f) => f.maybeMap(
                            invalidMonth: (_) =>
                                'credit_card_form.date_exp.error_1'.tr(),
                            invalidYear: (_) =>
                                'credit_card_form.date_exp.error_2'.tr(),
                            empty: (_) =>
                                'credit_card_form.date_exp.error_3'.tr(),
                            orElse: () => null,
                          ),
                          (_) => null,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'credit_card_form.cvv_code.title'.tr(),
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? 110.w
                            : Responsive.isMobile(context)
                                ? 323.w
                                : 200,
                        child: BorderInput(
                          filterPattern: '[A-Za-z]',
                          initialValue: state.cardCvvNumber,
                          focusNode: focusNode,
                          textEditingController: state.cvvCodeController,
                          onEditingComplete: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            flipCard();
                            Timer(const Duration(seconds: 1), () {
                              focusNode.unfocus();
                            });
                          },
                          text: 'credit_card_form.cvv_code.hint'.tr(),
                          keyboardType: TextInputType.number,
                          onChange: (input) => context
                              .read<CreditCardFormBloc>()
                              .add(CreditCardFormEvent.cvvCodeChanged(input)),
                          maxLength: 3,
                          validator: (value) =>
                              Validator.validateCvvCode(value!).fold(
                            (f) => f.maybeMap(
                              empty: (_) =>
                                  'credit_card_form.cvv_code.error_1'.tr(),
                              orElse: () => null,
                            ),
                            (_) => null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomButtom(
              width: 1.2.sw,
              isActive: true,
              onTap: () {
                if (state.isConfirmed) {
                  if (state.isEditing) {
                    context
                        .read<CreditCardFormBloc>()
                        .add(const CreditCardFormEvent.update());
                  } else {
                    context
                        .read<CreditCardFormBloc>()
                        .add(const CreditCardFormEvent.save());
                  }
                } else {
                  context
                      .read<CreditCardFormBloc>()
                      .add(const CreditCardFormEvent.validateData());
                  context
                      .read<CreditCardFormBloc>()
                      .add(const CreditCardFormEvent.confirmedChanged());
                  if (focusNode.hasFocus) {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    flipCard();
                    Timer(const Duration(seconds: 1), () {
                      focusNode.unfocus();
                    });
                  }
                }
              },
              title: state.isConfirmed
                  ? state.isEditing
                      ? 'credit_card_form.action_3'.tr()
                      : 'credit_card_form.action_1'.tr()
                  : 'credit_card_form.action_2'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
