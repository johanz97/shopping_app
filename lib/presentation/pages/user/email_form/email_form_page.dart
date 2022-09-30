import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../../../aplication/user/email_edit_form_bloc/email_edit_form_bloc.dart';
import '../../../../core/validator.dart';
import '../../../../injection.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/border_input.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../core/widgets/dot_steper.dart';
import '../../../routes/router.gr.dart';

class EmailFormPage extends StatelessWidget {
  final String email;
  const EmailFormPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmailEditFormBloc>()
        ..add(
          EmailEditFormEvent.initialize(email),
        ),
      child: BlocConsumer<EmailEditFormBloc, EmailEditFormState>(
        listener: (context, state) {
          state.failureOrSuccessResendOtpCode.fold(
            () => {},
            (either) => either.fold((failure) {
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  failure.maybeMap(
                    orElse: () => "email_edit_page.errors.or_else".tr(),
                  ),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                      ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (user) {
              final snackBar = SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "email_edit_page.msg_success.snackbar_resend".tr(),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                      ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }),
          );
          state.failureOrSuccessUpdateEmail.fold(
            () => {},
            (either) => either.fold((failure) {
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  failure.maybeMap(
                    orElse: () => "email_edit_page.errors.or_else".tr(),
                    emailAlreadyExists: (_) =>
                        "email_edit_page.errors.email_already_exists".tr(),
                  ),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                      ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (user) {
              context.read<EmailEditFormBloc>().add(
                    const EmailEditFormEvent.nextStep(),
                  );
              context.read<EmailEditFormBloc>().add(
                    EmailEditFormEvent.setOtpCodeFromServer(
                      user.preferredEmail.confirmationToken,
                    ),
                  );
            }),
          );
          state.failureOrSuccessOtpValidation.fold(
            () => {},
            (either) => either.fold(
              (failure) => context.router.push(
                ErrorStateRoute(
                  title: "email_edit_page.msg_error.title".tr(),
                  subtitle: failure.maybeMap(
                    orElse: () =>
                        "email_edit_page.msg_error.subtitle_or_else".tr(),
                  ),
                ),
              ),
              (r) => context.router.pop(),
            ),
          );
        },
        builder: (context, state) {
          return state.isLoading
              ? const LoadingStatePage()
              : Scaffold(
                  appBar: AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.light,
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: BackButtonCustom(
                      onTap: () => context.router.pop(),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "email_edit_page.phase".tr(
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
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
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
                        Container(
                          width: 0.9.sw,
                          margin: EdgeInsets.only(
                            top: 30.h,
                            left: 50.w,
                            right: 50.w,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 20),
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
                        ),
                        Visibility(
                          visible: state.actualStep == 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 50.w,
                              top: 50.h,
                            ),
                            child: InkWell(
                              onTap: () => context
                                  .read<EmailEditFormBloc>()
                                  .add(
                                    const EmailEditFormEvent.reSendOtpCode(),
                                  ),
                              child: Text(
                                'email_edit_page.otp_page.action_3'.tr(),
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
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomButtom(
                              onTap: () => nextStep(state, context),
                              title: "email_edit_page.action_1".tr(),
                              isActive: isValid(state),
                              width: 1.2.sw,
                            ),
                            DotSteper(
                              dotCount: state.totalSteps,
                              activeStep: state.actualStep,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  static List<String> getTitle = [
    "email_edit_page.email_page.title".tr(),
    "email_edit_page.otp_page.title".tr(),
  ];

  static List<String> getSubTitle = [
    "email_edit_page.email_page.subtitle".tr(),
    "email_edit_page.otp_page.subtitle".tr(),
  ];

  Widget getInputs(int index, BuildContext context, EmailEditFormState state) {
    final inputs = <Widget>[
      BorderInput(
        filterPattern: "",
        text: 'email_edit_page.email_page.input_leading'.tr(),
        keyboardType: TextInputType.emailAddress,
        textEditingController: state.emailController,
        onChange: (input) => context.read<EmailEditFormBloc>().add(
              EmailEditFormEvent.emailChanged(input),
            ),
        onEditingComplete: () => nextStep(state, context),
        maxLength: 50,
        validator: (value) => Validator.validateEmail(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            invalidEmail: (_) =>
                "email_edit_page.email_page.errors.invalid_email".tr(),
            withOutMinStringLength: (_) =>
                "email_edit_page.email_page.errors.with_out_min_string_length"
                    .tr(),
            empty: (_) => "email_edit_page.email_page.errors.empty".tr(),
            multiline: (_) =>
                "email_edit_page.email_page.errors.multiline".tr(),
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
            'email_edit_page.otp_page.action_2'.tr(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        onCompleted: (value) {
          context.read<EmailEditFormBloc>().add(
                EmailEditFormEvent.otpCodeChanged(value),
              );
          nextStep(state, context);
        },
        onEditing: (value) {},
      ),
    ];
    return inputs[index];
  }

  bool isValid(EmailEditFormState state) {
    final validators = [
      Validator.validateEmail(state.emailController.text).isRight(),
      Validator.validateOtp(state.otpCode.toString()).isRight(),
    ];
    return validators[state.actualStep];
  }

  void nextStep(EmailEditFormState state, BuildContext context) {
    if (isValid(state)) {
      if (state.actualStep == 0) {
        context
            .read<EmailEditFormBloc>()
            .add(const EmailEditFormEvent.updateEmail());
      } else if (state.actualStep == 1) {
        context
            .read<EmailEditFormBloc>()
            .add(const EmailEditFormEvent.confirmEmail());
      }
    }
  }
}
