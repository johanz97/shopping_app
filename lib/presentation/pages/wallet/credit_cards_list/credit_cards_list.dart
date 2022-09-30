import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import '../../../../aplication/wallet/select_card/select_card_bloc.dart';
import '../../../../core/utils.dart';
import '../../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../../../injection.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/bottom_sheet_dialog.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../routes/router.gr.dart';
import '../credit_card/widgets/credit_card_ui/credit_card.dart';
import '../credit_card/widgets/credit_card_ui/extra/card_type.dart';
import '../credit_card/widgets/credit_card_ui/style/card_background.dart';

class CreditCardsListPage extends StatelessWidget {
  final bool showSelect;
  final List<CreditCardInfo> creditCards;
  const CreditCardsListPage({
    Key? key,
    this.showSelect = false,
    required this.creditCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<SelectCardBloc>()
          ..add(
            SelectCardEvent.initialize(
              creditCards,
            ),
          ),
        child: BlocConsumer<SelectCardBloc, SelectCardState>(
          listener: (context, state) {
            state.failureOrDeleteCard.fold(
              () => null,
              (eihter) => eihter.fold(
                (failure) => null,
                (crads) {
                  context
                      .read<SelectCardBloc>()
                      .add(const SelectCardEvent.updateList());
                  showSnackBarSuccess(
                    context,
                    "credit_cards_list.success_delete".tr(),
                  );
                },
              ),
            );
          },
          builder: (context, state) {
            final bloc = context.read<SelectCardBloc>();
            return state.isLoading
                ? const LoadingStatePage()
                : Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarBrightness: Brightness.light,
                      ),
                      backgroundColor: Colors.transparent,
                      leading: BackButtonCustom(
                        onTap: () => context.router.pop(),
                      ),
                      centerTitle: false,
                      title: Text(
                        "credit_cards_list.title".tr(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    body: Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: StackedCardCarousel(
                        pageController: state.pageController,
                        spaceBetweenItems: 300.h,
                        items: List.generate(creditCards.length, (index) {
                          final randomIndex = random(0, 10);
                          return InkWell(
                            onTap: () => context.read<SelectCardBloc>().add(
                                  SelectCardEvent.selectCard(
                                    creditCards[index],
                                  ),
                                ),
                            child: CreditCard(
                              height: 300.h,
                              width: 0.2.sw,
                              isSelected: state.creditCardInfo.id ==
                                  creditCards[index].id,
                              frontBackground:
                                  CardBackgrounds.getAnyColor(randomIndex),
                              frontTextColor: randomIndex == 1
                                  ? Colors.black
                                  : Colors.white,
                              backBackground: CardBackgrounds.black,
                              cardType: CardType.dinersClub,
                              showShadow: true,
                              cardNumber:
                                  "XXXX XXXX XXXX ${creditCards[index].cardNumber.substring(11, 16)}",
                              textExpiry:
                                  "${creditCards[index].cardMonth}/${creditCards[index].cardYear.substring(2, 4)}",
                              cardHolderName: creditCards[index].holderName,
                            ),
                          );
                        }),
                      ),
                    ),
                    bottomNavigationBar: showSelect
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 40.h),
                            child: CustomButtom(
                              onTap: () {},
                              title: "credit_cards_list.action_1".tr(),
                              width: 1.3.sw,
                              isActive: true,
                            ),
                          )
                        : Visibility(
                            visible: state.creditCardInfo.id !=
                                CreditCardInfo.test().id,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 40.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButtom(
                                    icon: Icons.edit,
                                    title: "",
                                    onTap: () async {
                                      final needsUpdateList =
                                          await context.router.push(
                                        CreditCardFormRoute(
                                          creditCardInfo: state.creditCardInfo,
                                        ),
                                      );

                                      if (needsUpdateList != null) {
                                        bloc.add(
                                          const SelectCardEvent.updateList(),
                                        );
                                      }
                                    },
                                    width: 250.w,
                                    isActive: true,
                                  ),
                                  CustomButtom(
                                    icon: Icons.delete,
                                    title: "",
                                    onTap: () => showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) => BottomSheetDialog(
                                        title:
                                            "credit_cards_list.delete_dialog.title"
                                                .tr(),
                                        accept:
                                            "credit_cards_list.delete_dialog.accept"
                                                .tr(),
                                        cancel:
                                            "credit_cards_list.delete_dialog.cancel"
                                                .tr(),
                                        onAccept: () => bloc.add(
                                          const SelectCardEvent
                                              .deleteCreditCard(),
                                        ),
                                        onCancel: () => context.router.pop(),
                                      ),
                                    ),
                                    width: 250.w,
                                    isActive: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  );
          },
        ),
      ),
    );
  }
}
