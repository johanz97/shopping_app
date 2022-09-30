import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../aplication/wallet/credit_card_form_bloc/credit_card_form_bloc.dart';
import '../../../../core/utils.dart';
import '../../../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../../../injection.dart';
import '../../../../responsive.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../routes/router.gr.dart';
import 'widgets/credit_card_form.dart';
import 'widgets/credit_card_ui/credit_card.dart';
import 'widgets/credit_card_ui/style/card_background.dart';

class CreditCardFormPage extends StatefulWidget {
  final CreditCardInfo? creditCardInfo;
  const CreditCardFormPage({
    Key? key,
    this.creditCardInfo,
  }) : super(key: key);

  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardFormPage> {
  late FocusNode _focusNode;
  bool showBack = false;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        showBack = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreditCardFormBloc>()
        ..add(
          CreditCardFormEvent.initialized(
            card: widget.creditCardInfo,
          ),
        ),
      child: CreditCardSection(
        flipCard: () {
          setState(() {
            showBack = !showBack;
          });
        },
        showBack: showBack,
        focusNode: _focusNode,
      ),
    );
  }
}

class CreditCardSection extends StatelessWidget {
  final bool showBack;
  final FocusNode focusNode;
  final VoidCallback flipCard;
  const CreditCardSection({
    Key? key,
    required this.showBack,
    required this.focusNode,
    required this.flipCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreditCardFormBloc, CreditCardFormState>(
      listener: (context, state) {
        state.failureOrCreditCard.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.router.push(
              ErrorStateRoute(
                title: "credit_card_form.error_state.title".tr(),
                subtitle: failure.maybeMap(
                  orElse: () => "credit_card_form.error_state.subtitle".tr(),
                ),
                valueReturned: false,
              ),
            ),
            (user) => context.router.pop(true),
          ),
        );
        state.failureOrUpdate.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.router.push(
              ErrorStateRoute(
                title: "credit_card_form.error_state.title".tr(),
                subtitle: failure.maybeMap(
                  orElse: () => "credit_card_form.error_state.subtitle".tr(),
                ),
                valueReturned: false,
              ),
            ),
            (user) async {
              showSnackBarSuccess(
                context,
                "credit_card_form.success_state.title".tr(),
              );

              context.router.pop(true);
            },
          ),
        );
      },
      builder: (context, state) {
        return state.isLoading
            ? const LoadingStatePage()
            : Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                  ),
                  centerTitle: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: BackButtonCustom(
                    onTap: () => {
                      SystemChannels.textInput.invokeMethod('TextInput.hide'),
                      context.router.pop(),
                    },
                  ),
                  title: Text(
                    'credit_card_form.title'.tr(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                body: SafeArea(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: CreditCardForm(
                              state: state,
                              focusNode: focusNode,
                              flipCard: flipCard,
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 00.h,
                        child: Container(
                          width: 1.sw,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: EdgeInsets.symmetric(
                            vertical: 40.h,
                            horizontal: Responsive.isMobile(context)
                                ? 0.005.sw
                                : Responsive.isTablet(context)
                                    ? 0.25.sw
                                    : 0.35.sw,
                          ),
                          child: CreditCard(
                            height: 180,
                            width: 320,
                            cardNumber: state.cardNumber,
                            cardExpiry: state.dateExp,
                            cardHolderName: state.holderName,
                            cvv: state.cardCvvNumber,
                            bankName: "credit_card_form.bank_name".tr(),
                            // Optional if you want to override Card Type
                            showBackSide: showBack,
                            frontBackground: CardBackgrounds.black,
                            backBackground: CardBackgrounds.white,
                            showShadow: true,
                            textExpDate: 'credit_card_form.text_exp_date'.tr(),
                            textName: 'credit_card_form.text_name'.tr(),
                            textExpiry: 'credit_card_form.format_date'.tr(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: state.showCheck,
                        child: Positioned(
                          top: 0.h,
                          right: 0,
                          child: LottieBuilder.asset(
                            "assets/animations/check.json",
                            repeat: false,
                            onLoaded: (_) async {
                              await Future.delayed(const Duration(seconds: 2));

                              // ignore: use_build_context_synchronously
                              context.read<CreditCardFormBloc>().add(
                                    const CreditCardFormEvent.showCheck(
                                      show: false,
                                    ),
                                  );
                            },
                          ),
                        ),
                      ),
                      //CreditCardForm2(),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/credit_card.json',
            height: 0.20.sh,
            width: 0.3.sw,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'credit_card_form.LoadingStateWidget.title'.tr(),
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'credit_card_form.LoadingStateWidget.subtitle'.tr(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
