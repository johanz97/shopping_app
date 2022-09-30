import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../aplication/wallet/wallet_bloc/wallet_bloc.dart';
import '../../../../injection.dart';
import '../../../core/pages/error/error_state_page.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/mini_action.dart';
import '../../../routes/router.gr.dart';
import '../credit_card/widgets/credit_card_ui/credit_card.dart';
import '../credit_card/widgets/credit_card_ui/extra/card_type.dart';
import '../credit_card/widgets/credit_card_ui/style/card_background.dart';
import 'widgets/transaction_item.dart';
import 'widgets/wallet_new_user.dart';

class WalletHomePage extends StatelessWidget {
  const WalletHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "wallet_home_page.app_bar_title".tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<WalletBloc>()
          ..add(
            const WalletEvent.initialize(),
          ),
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const Scaffold(),
              loadInProgress: () => const LoadingStatePage(),
              newUser: () => const WalletNewUser(),
              success: (creditCards, transactions) => SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 30.h,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 50.w,
                          right: 50.h,
                          bottom: 20.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "wallet_home_page.subtitle_1".tr(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            MiniAction(
                              size: 60.sp,
                              icon: Icons.add,
                              onTap: () =>
                                  context.router.push(CreditCardFormRoute()),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => context.router.push(
                          CreditCardsListRoute(
                            creditCards: creditCards,
                          ),
                        ),
                        child: SizedBox(
                          height: 400.h,
                          width: 0.9.sw,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 10,
                                child: Container(
                                  width: 0.7.sw,
                                  height: 300.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 25,
                                child: Container(
                                  width: 0.78.sw,
                                  height: 300.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 40,
                                child: CreditCard(
                                  height: 300.h,
                                  width: 0.2.sw,
                                  frontBackground: CardBackgrounds.black,
                                  backBackground: CardBackgrounds.white,
                                  cardType: CardType.dinersClub,
                                  showShadow: true,
                                  cardNumber:
                                      "XXXX XXXX XXXX ${creditCards.first.cardNumber.substring(11, 16)}",
                                  textExpiry:
                                      "${creditCards.first.cardMonth}/${creditCards.first.cardYear.substring(2, 4)}",
                                  cardHolderName: creditCards.first.holderName,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 30.h,
                            left: 50.w,
                            bottom: 30.h,
                          ),
                          child: Text(
                            "wallet_home_page.subtitle_2".tr(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.5.sh,
                        width: 1.sw - 100.w,
                        child: transactions.isNotEmpty
                            ? ListView(
                                padding: EdgeInsets.only(
                                  bottom: 100.h,
                                ),
                                children: List.generate(
                                  transactions.length,
                                  (index) => TransactionItem(
                                    title: "wallet_home_page.item_title".tr(),
                                    date: DateFormat("yyyy-MM-dd")
                                        .format(transactions[index].date),
                                    value: transactions[index].value,
                                  ),
                                ),
                              )
                            : Container(
                                height: 0.4.sh,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 100),
                                    Icon(
                                      Icons.info,
                                      size: 70,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "wallet_home_page.empty_message".tr(),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              loadFailure: () => ErrorStatePage(
                title: "wallet_home_page.error_state.title".tr(),
                subtitle: "wallet_home_page.error_state.subtitle_or_else".tr(),
                reload: () => context.read<WalletBloc>().add(
                      const WalletEvent.initialize(),
                    ),
              ),
              orElse: () => const Scaffold(),
            );
          },
        ),
      ),
    );
  }
}
