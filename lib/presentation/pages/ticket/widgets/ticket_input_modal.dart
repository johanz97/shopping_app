import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/validator.dart';
import '../../../core/text_edit_mask.dart';
import '../../../core/widgets/border_input.dart';
import '../../../core/widgets/custom_buttom.dart';

class TicketInputModal extends StatefulWidget {
  const TicketInputModal({Key? key}) : super(key: key);

  @override
  State<TicketInputModal> createState() => _TicketInputModalState();
}

class _TicketInputModalState extends State<TicketInputModal> {
  final MaskedTextController _ticketIdController =
      MaskedTextController(mask: '000000000000');
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              toolbarHeight: 110.h,
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  "ticket_scanner_tutorial.action_2_title".tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => context.router.pop(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 40,
              ),
              child: BorderInput(
                autoFocus: true,
                filterPattern: '[A-Za-z]',
                text: 'XXXXXXXXXXXX'.tr(),
                keyboardType: TextInputType.number,
                onChange: (input) {
                  setState(() {
                    _ticketIdController.text = input;
                  });
                },
                textEditingController: _ticketIdController,
                onEditingComplete: () {},
                maxLength: 19,
                validator: (value) => Validator.validateTicketId(value!).fold(
                  (f) => f.maybeMap(
                    empty: (_) => 'credit_card_form.card_number.error_1'.tr(),
                    withOutMinStringLength: (_) =>
                        'ticket_scanner_tutorial.error_msg'.tr(),
                    orElse: () => null,
                  ),
                  (_) => null,
                ),
              ),
            ),
            CustomButtom(
              onTap: () => context.router.pop(_ticketIdController.text),
              title: 'Digite o código',
              width: 1.2.sw,
              isActive: Validator.validateTicketId(_ticketIdController.text)
                  .isRight(),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
