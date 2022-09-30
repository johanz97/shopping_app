import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import '../../../../aplication/auth/reset_password/reset_password_bloc.dart';

import '../../../../core/validator.dart';
import '../../../../injection.dart';
import '../../../core/animations/traslade_y_fade_animation.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/border_input.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../routes/router.gr.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ResetPasswordBloc>(),
      child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          state.failureOrSuccessResetPassword.fold(
            () => {},
            (either) => either.fold(
              (failure) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    failure.maybeMap(
                      orElse: () => "reset_password_page.errors.or_else".tr(),
                      emailAlreadyExists: (_) =>
                          "reset_password_page.errors.email_already_exists"
                              .tr(),
                    ),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              (r) => context.read<ResetPasswordBloc>().add(
                    const ResetPasswordEvent.nextStep(),
                  ),
            ),
          );
          state.failureOrSuccessOtpValidation.fold(
            () => {},
            (either) => either.fold(
              (failure) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    failure.maybeMap(
                      orElse: () => "reset_password_page.errors.or_else".tr(),
                      otpCodeIncorrect: (_) =>
                          "reset_password_page.errors.otpCodeIncorrect".tr(),
                    ),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              (r) => context.read<ResetPasswordBloc>().add(
                    const ResetPasswordEvent.nextStep(),
                  ),
            ),
          );
          state.failureOrSuccessNewPassword.fold(
            () => {},
            (either) => either.fold(
              (failure) => context.router.replace(
                ErrorStateRoute(
                  title: "reset_password_page.msg_error.error_title".tr(),
                  subtitle: failure.maybeMap(
                    orElse: () =>
                        "reset_password_page.msg_error.error_subtitle_or_else"
                            .tr(),
                  ),
                ),
              ),
              (r) => context.router.replace(
                SuccessStateRoute(
                  title: "reset_password_page.msg_success.title".tr(),
                  subtitle: "reset_password_page.msg_success.subtitle".tr(),
                ),
              ),
            ),
          );
        },
        builder: (context, state) {
          return state.isLoading
              ? const LoadingStatePage()
              : Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: BackButtonCustom(
                      onTap: () => context.router.pop(),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "reset_password_page.phase".tr(
                            args: [
                              (state.actualStep + 1).toString(),
                              getTitle.length.toString()
                            ],
                          ),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: SizedBox(
                      height: 1.sh -
                          (ScreenUtil().statusBarHeight +
                              ScreenUtil().bottomBarHeight +
                              45.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TrasladeYFadeAnimation(
                            delay: 1,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 50.w,
                                top: 60.h,
                                right: 50.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTitle[state.actualStep],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 75.sp,
                                        ),
                                  ),
                                  SizedBox(height: 50.h),
                                  Text(
                                    getSubTitle[state.actualStep],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                          fontSize: 30.sp,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          TrasladeYFadeAnimation(
                            delay: 1.5,
                            child: Container(
                              width: 0.9.sw,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 30.h,
                                horizontal: 30.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 4.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0,
                                    color: Color.fromRGBO(196, 196, 196, .76),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Form(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 20),
                                      transitionBuilder: (child, animation) =>
                                          FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                      child: getInputs(
                                        state.actualStep,
                                        context,
                                        state,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TrasladeYFadeAnimation(
                            delay: 1.8,
                            child: Visibility(
                              visible: state.actualStep == 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 50.w),
                                child: InkWell(
                                  onTap: () =>
                                      context.read<ResetPasswordBloc>().add(
                                            const ResetPasswordEvent
                                                .resetPassword(),
                                          ),
                                  child: Text(
                                    'reset_password_page.otp_page.action_1'
                                        .tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 30.sp,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TrasladeYFadeAnimation(
                            delay: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 50.h,
                                    top: 200.h,
                                  ),
                                  child: CustomButtom(
                                    onTap: () => nextStep(state, context),
                                    title: "reset_password_page.action_1".tr(),
                                    isActive: true,
                                    width: 1.2.sw,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  static List<String> getTitle = [
    "reset_password_page.email_page.title".tr(),
    "reset_password_page.otp_page.title".tr(),
    "reset_password_page.password_page.title".tr(),
  ];

  static List<String> getSubTitle = [
    "reset_password_page.email_page.subtitle".tr(),
    "reset_password_page.otp_page.subtitle".tr(),
    "reset_password_page.password_page.subtitle".tr(),
  ];

  Widget getInputs(int index, BuildContext context, ResetPasswordState state) {
    final inputs = <Widget>[
      BorderInput(
        filterPattern: '',
        text: 'reset_password_page.email_page.input_leading'.tr(),
        keyboardType: TextInputType.emailAddress,
        onChange: (input) => context.read<ResetPasswordBloc>().add(
              ResetPasswordEvent.emailChanged(input),
            ),
        textEditingController: state.emailController,
        onEditingComplete: () => nextStep(state, context),
        maxLength: 50,
        validator: (value) => Validator.validateEmail(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            invalidEmail: (_) =>
                "reset_password_page.email_page.errors.invalid_email".tr(),
            withOutMinStringLength: (_) =>
                "reset_password_page.email_page.errors.with_out_min_string_length"
                    .tr(),
            empty: (_) => "reset_password_page.email_page.errors.empty".tr(),
            multiline: (_) => "reset_password_page.email_page.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      VerificationCode(
        length: 6,
        textStyle: Theme.of(context).textTheme.headline5!.copyWith(
              color: Colors.black,
            ),
        underlineColor: Theme.of(context).primaryColor,
        clearAll: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'reset_password_page.otp_page.action_2'.tr(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        onCompleted: (value) {
          context.read<ResetPasswordBloc>().add(
                ResetPasswordEvent.otpCodeChanged(value),
              );
          nextStep(state, context);
        },
        onEditing: (value) {},
      ),
      Column(
        children: [
          BorderInput(
            isPassword: true,
            filterPattern: '',
            text: 'reset_password_page.password_page.input_leading_1'.tr(),
            keyboardType: TextInputType.visiblePassword,
            onChange: (input) => context.read<ResetPasswordBloc>().add(
                  ResetPasswordEvent.passwordChanged(input),
                ),
            onEditingComplete: () => nextStep(state, context),
            maxLength: 25,
            validator: (value) => Validator.validatePassWord(value!).fold(
              (failure) => failure.maybeMap(
                orElse: () => null,
                withOutMinStringLength: (_) =>
                    "reset_password_page.password_page.errors.with_out_min_string_length"
                        .tr(),
                empty: (_) =>
                    "reset_password_page.password_page.errors.empty".tr(),
                multiline: (_) =>
                    "reset_password_page.password_page.errors.multiline".tr(),
              ),
              (r) => null,
            ),
          ),
          SizedBox(height: 30.h),
          BorderInput(
            isPassword: true,
            filterPattern: '',
            text: 'reset_password_page.password_page.input_leading_2'.tr(),
            keyboardType: TextInputType.visiblePassword,
            onChange: (input) => context.read<ResetPasswordBloc>().add(
                  ResetPasswordEvent.passwordVerifyChanged(input),
                ),
            onEditingComplete: () => {
              nextStep(state, context),
              FocusScope.of(context).unfocus(),
            },
            maxLength: 25,
            validator: (value) => Validator.validatePassWord(value!).fold(
              (failure) => failure.maybeMap(
                orElse: () => null,
                withOutMinStringLength: (_) =>
                    "reset_password_page.password_page.errors.with_out_min_string_length"
                        .tr(),
                empty: (_) =>
                    "reset_password_page.password_page.errors.empty".tr(),
                multiline: (_) =>
                    "reset_password_page.password_page.errors.multiline".tr(),
              ),
              (vPass) => vPass == state.password
                  ? null
                  : "reset_password_page.password_page.errors.not_equeals",
            ),
          ),
        ],
      ),
    ];
    return inputs[index];
  }

  bool isValid(ResetPasswordState state) {
    final validators = [
      Validator.validateEmail(state.email).isRight(),
      Validator.validateOtp(state.otpCode.toString()).isRight(),
      Validator.validatePassWord(state.password).isRight() &&
          Validator.validatePassWord(state.passwordVerified).isRight()
    ];
    return validators[state.actualStep];
  }

  void nextStep(ResetPasswordState state, BuildContext context) {
    if (isValid(state)) {
      if (state.actualStep > 1) {
        context
            .read<ResetPasswordBloc>()
            .add(const ResetPasswordEvent.nextStep());
      } else if (state.actualStep == 0) {
        context
            .read<ResetPasswordBloc>()
            .add(const ResetPasswordEvent.resetPassword());
      } else if (state.actualStep == 1) {
        context
            .read<ResetPasswordBloc>()
            .add(const ResetPasswordEvent.sendOtpCode());
      }
    }
  }
}
