import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../aplication/auth/auth_bloc.dart';
import '../../../../aplication/auth/sign_in/sign_in_bloc.dart';
import '../../../../core/validator.dart';
import '../../../../injection.dart';
import '../../../core/animations/traslade_y_fade_animation.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/border_input.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../routes/router.gr.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInBloc>(),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          state.failureOrSuccess.fold(
            () => {},
            (either) => either.fold((failure) {
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  failure.maybeMap(
                    orElse: () => "sing_in_page.error_msgs.or_else".tr(),
                    incorrectEmailOrPassword: (_) =>
                        "sing_in_page.error_msgs.incorrect_email_or_password"
                            .tr(),
                    emailNotFound: (_) =>
                        "sing_in_page.error_msgs.email_not_found".tr(),
                  ),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                      ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (r) {
              context.read<AuthBloc>().add(
                    const AuthEvent.checkSession(),
                  );
              context.router.pushAndPopUntil(
                const SplashRoute(),
                predicate: (_) => false,
              );
            }),
          );
        },
        builder: (context, state) {
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
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      height: 1.sh -
                          (ScreenUtil().statusBarHeight +
                              ScreenUtil().bottomBarHeight +
                              170.h),
                      margin: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: ScreenUtil().bottomBarHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TrasladeYFadeAnimation(
                            delay: 1,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 50.w,
                                top: 60.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "sing_in_page.title".tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 75.sp,
                                        ),
                                  ),
                                  Text(
                                    "sing_in_page.subtitle".tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                              child: Form(
                                autovalidateMode: state.validateErrors
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.disabled,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BorderInput(
                                      filterPattern: '',
                                      text: 'sing_in_page.input_leading_1'.tr(),
                                      keyboardType: TextInputType.emailAddress,
                                      onChange: (input) =>
                                          context.read<SignInBloc>().add(
                                                SignInEvent.emailChanged(input),
                                              ),
                                      textEditingController:
                                          state.emailController,
                                      onEditingComplete: () {},
                                      maxLength: 50,
                                      validator: (value) =>
                                          Validator.validateEmail(value!).fold(
                                        (failure) => failure.maybeMap(
                                          orElse: () => null,
                                          invalidEmail: (_) =>
                                              "sing_in_page.email_input_errors.invalid_email"
                                                  .tr(),
                                          empty: (_) =>
                                              "sing_in_page.email_input_errors.empty"
                                                  .tr(),
                                          multiline: (_) =>
                                              "sing_in_page.email_input_errors.multiline"
                                                  .tr(),
                                        ),
                                        (r) => null,
                                      ),
                                    ),
                                    SizedBox(height: 50.h),
                                    BorderInput(
                                      isPassword: true,
                                      filterPattern: '',
                                      text: 'sing_in_page.input_leading_2'.tr(),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      onChange: (input) => context
                                          .read<SignInBloc>()
                                          .add(
                                            SignInEvent.passwordChanged(input),
                                          ),
                                      textEditingController:
                                          state.passwordController,
                                      onEditingComplete: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      maxLength: 25,
                                      validator: (value) =>
                                          Validator.validatePassWord(value!)
                                              .fold(
                                        (failure) => failure.maybeMap(
                                          orElse: () => "Error",
                                          withOutMinStringLength: (_) =>
                                              "sing_in_page.password_input_errors.with_out_min_string_length"
                                                  .tr(),
                                          empty: (_) =>
                                              "sing_in_page.password_input_errors.empy"
                                                  .tr(),
                                          multiline: (_) =>
                                              "sing_in_page.password_input_errors.multiline"
                                                  .tr(),
                                        ),
                                        (r) => null,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.w,
                                        top: 15.h,
                                      ),
                                      child: InkWell(
                                        onTap: () => context.router.push(
                                          const ResetPasswordRoute(),
                                        ),
                                        child: Text(
                                          "sing_in_page.action_1".tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20.sp,
                                              ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TrasladeYFadeAnimation(
                            delay: 2,
                            child: Column(
                              children: [
                                CustomButtom(
                                  onTap: () => context.read<SignInBloc>().add(
                                        const SignInEvent.signIn(),
                                      ),
                                  title: "sing_in_page.action_2".tr(),
                                  isActive: true,
                                  width: 1.2.sw,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0.28.sw,
                                    vertical: 15.h,
                                  ),
                                  child: InkWell(
                                    onTap: () => context.router.push(
                                      const SignUpRoute(),
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'sing_in_page.action_3_1'.tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 30.sp,
                                                ),
                                          ),
                                          TextSpan(
                                            text:
                                                'sing_in_page.action_3_2'.tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 30.sp,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
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
}
