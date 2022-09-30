import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../aplication/user/user_form_bloc/user_form_bloc.dart';
import '../../../../core/validator.dart';
import '../../../../domain/user/gender/gender.dart';
import '../../../../domain/user/user.dart';
import '../../../../injection.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/border_input.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../core/widgets/dot_steper.dart';
import '../../../routes/router.gr.dart';
import 'widgets/gender_widget.dart';

class UserFormPage extends StatelessWidget {
  final bool isEditing;
  final int index;
  final User? user;
  const UserFormPage({
    Key? key,
    this.isEditing = false,
    this.index = 0,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserFormBloc>()
        ..add(
          UserFormEvent.initialize(index, user),
        ),
      child: BlocConsumer<UserFormBloc, UserFormState>(
        listener: (context, state) {
          state.failureOrSuccess.fold(
            () => null,
            (either) => either.fold(
              (failure) => context.router.push(
                ErrorStateRoute(
                  title: "user_form_page.error_state.title".tr(),
                  subtitle: failure.maybeMap(
                    orElse: () => "user_form_page.error_state.subtitle".tr(),
                  ),
                  valueReturned: false,
                ),
              ),
              (user) => context.router.pop(true),
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
                      onTap: () => context.router.pop(false),
                    ),
                  ),
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
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
                              SizedBox(height: 20.h),
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
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 30.h,
                            left: 50.w,
                            right: 50.w,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(40.sp),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 20),
                                  transitionBuilder: (child, animation) =>
                                      FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                  child: Form(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: getInputs(
                                      state.actualStep,
                                      state,
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: isEditing
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.spaceEvenly,
                              children: [
                                Visibility(
                                  visible: !isEditing,
                                  child: CustomButtom(
                                    hasGradient: false,
                                    isActive: state.actualStep != 0,
                                    icon: Icons.arrow_back_ios,
                                    title: '',
                                    onTap: () =>
                                        context.read<UserFormBloc>().add(
                                              const UserFormEvent.backStep(),
                                            ),
                                    width: 0.25.sw,
                                  ),
                                ),
                                CustomButtom(
                                  title: state.isEditing
                                      ? "user_form_page.action_2".tr()
                                      : "user_form_page.action_1".tr(),
                                  onTap: () => context.read<UserFormBloc>().add(
                                        const UserFormEvent.nextStep(),
                                      ),
                                  width: 1.2.sw,
                                  isActive: isValid(state),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: !isEditing,
                              child: DotSteper(
                                dotCount: state.totalSteps,
                                activeStep: state.actualStep,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  bool isValid(UserFormState state) {
    final validators = [
      Validator.validateName(state.nameController.text).isRight(),
      Validator.validateCpfOrCnpj(state.cpfCodeController.text).isRight(),
      Validator.validatePhoneNumber(state.phoneNumberController.text).isRight(),
      Validator.validateBirth(state.birthController.text).isRight(),
      true,
    ];

    return validators[state.actualStep];
  }

  static List<String> getTitle = [
    "user_form_page.name_input.title".tr(),
    "user_form_page.cpf_input.title".tr(),
    "user_form_page.phone_number_input.title".tr(),
    "user_form_page.birth_input.title".tr(),
    "user_form_page.gender_input.title".tr(),
  ];

  static List<String> getSubTitle = [
    "user_form_page.name_input.subtitle".tr(),
    "user_form_page.cpf_input.subtitle".tr(),
    "user_form_page.phone_number_input.subtitle".tr(),
    "user_form_page.birth_input.subtitle".tr(),
    "user_form_page.gender_input.subtitle".tr(),
  ];

  Widget getInputs(int index, UserFormState state, BuildContext context) {
    return [
      BorderInput(
        textEditingController: state.nameController,
        text: "user_form_page.name_input.leading".tr(),
        onEditingComplete: () {
          if (Validator.validateName(state.nameController.text).isRight()) {
            context.read<UserFormBloc>().add(
                  const UserFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<UserFormBloc>().add(
              UserFormEvent.nameChanged(value),
            ),
        validator: (value) => Validator.validateName(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            exceedingStringLength: (_) =>
                "user_form_page.name_input.errors.exceedingStringLength".tr(),
            empty: (_) => "user_form_page.name_input.errors.empty".tr(),
            multiline: (_) => "user_form_page.name_input.errors.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        textEditingController: state.cpfCodeController,
        text: "###.###.###-##",
        keyboardType: TextInputType.number,
        onEditingComplete: () {
          if (Validator.validateCpfOrCnpj(state.cpfCodeController.text)
              .isRight()) {
            context.read<UserFormBloc>().add(
                  const UserFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<UserFormBloc>().add(
              UserFormEvent.cpfChanged(value),
            ),
        validator: (value) => Validator.validateCpfOrCnpj(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            invalidCpfOrCnpj: (_) =>
                "user_form_page.cpf_input.errors.invalidCpfOrCnpj".tr(),
            empty: (_) => "user_form_page.cpf_input.errors.empty".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        textEditingController: state.phoneNumberController,
        text: "(##) #####-####",
        keyboardType: TextInputType.number,
        onEditingComplete: () {
          if (Validator.validatePhoneNumber(state.phoneNumberController.text)
              .isRight()) {
            context.read<UserFormBloc>().add(
                  const UserFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<UserFormBloc>().add(
              UserFormEvent.cellPhoneChanged(value),
            ),
        validator: (value) => Validator.validatePhoneNumber(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) => "user_form_page.phone_number_input.errors.empty".tr(),
            withOutMinStringLength: (_) =>
                "user_form_page.phone_number_input.errors.withOutMinStringLength"
                    .tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        textEditingController: state.birthController,
        text: "##/##/####",
        keyboardType: TextInputType.number,
        onEditingComplete: () {
          if (Validator.validateBirth(state.birthController.text).isRight()) {
            context.read<UserFormBloc>().add(
                  const UserFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<UserFormBloc>().add(
              UserFormEvent.birthChanged(value),
            ),
        validator: (value) => Validator.validateBirth(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) => "user_form_page.birth_input.errors.empty".tr(),
            withOutMinStringLength: (_) =>
                "user_form_page.birth_input.errors.withOutMinStringLength".tr(),
          ),
          (r) => null,
        ),
      ),
      GenderWidget(
        title: "user_form_page.gender_input.leading".tr(),
        genders: state.genders,
        selected: state.user.gender,
        onSelect: (Gender gender) => context.read<UserFormBloc>().add(
              UserFormEvent.genderChanged(gender),
            ),
      )
    ][index];
  }
}
