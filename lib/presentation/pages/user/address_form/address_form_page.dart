import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../aplication/user/address_form_bloc/address_form_bloc.dart';
import '../../../../core/validator.dart';
import '../../../../domain/user/address/address.dart';
import '../../../../injection.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/border_input.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../core/widgets/dot_steper.dart';
import '../../../routes/router.gr.dart';

class AddressFormPage extends StatelessWidget {
  final Address? address;
  final bool isEditing;
  final bool isFirst;
  final int index;
  const AddressFormPage({
    Key? key,
    this.isFirst = false,
    this.isEditing = false,
    this.address,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddressFormBloc>()
        ..add(
          AddressFormEvent.initialize(
            isFirst: isFirst,
            index: index,
            address: address,
          ),
        ),
      child: BlocConsumer<AddressFormBloc, AddressFormState>(
        listener: (context, state) {
          state.failureOrUser.fold(
            () => null,
            (either) => either.fold(
              (failure) => context.router.push(
                ErrorStateRoute(
                  title: "address_form_page.error_state.title".tr(),
                  subtitle: failure.maybeMap(
                    orElse: () => "address_form_page.error_state.subtitle".tr(),
                  ),
                  valueReturned: false,
                ),
              ),
              (user) => context.router.pop(true),
            ),
          );
          state.failureOrAddress.fold(
            () => {},
            (either) => either.fold((failure) {
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  failure.maybeMap(
                    orElse: () => "address_form_page.messages.error".tr(),
                  ),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                      ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (address) {
              state.streetController.text = address.street;

              state.complementController.text = address.complement;
              state.complementController.selection = TextSelection.fromPosition(
                TextPosition(offset: address.complement.length),
              );
              state.neighborhoodController.text = address.neighborhood;
              state.neighborhoodController.selection =
                  TextSelection.fromPosition(
                TextPosition(offset: address.neighborhood.length),
              );
              state.stateController.text = address.state;
              state.stateController.selection = TextSelection.fromPosition(
                TextPosition(offset: address.state.length),
              );
              state.cityController.text = address.city;
              state.cityController.selection = TextSelection.fromPosition(
                TextPosition(offset: address.city.length),
              );
              context.read<AddressFormBloc>().add(
                    const AddressFormEvent.incrementStep(),
                  );
            }),
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
                      Visibility(
                        visible: !isEditing,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "address_form_page.phase".tr(
                              args: [
                                (state.actualStep + 1).toString(),
                                state.totalSteps.toString()
                              ],
                            ),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                      context,
                                      state,
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
                                        context.read<AddressFormBloc>().add(
                                              const AddressFormEvent.backStep(),
                                            ),
                                    width: 0.25.sw,
                                  ),
                                ),
                                CustomButtom(
                                  title: "address_form_page.action".tr(),
                                  onTap: () => context
                                      .read<AddressFormBloc>()
                                      .add(const AddressFormEvent.nextStep()),
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

  static List<String> getTitle = [
    "address_form_page.cep_input.title".tr(),
    "address_form_page.street_input.title".tr(),
    "address_form_page.complement_input.title".tr(),
    "address_form_page.number_input.title".tr(),
    "address_form_page.neighborhood_input.title".tr(),
    "address_form_page.city_inpnut.title".tr(),
    "address_form_page.state_inpnut.title".tr(),
    "address_form_page.nickname_inpnut.title".tr(),
    "address_form_page.is_prefered_input.title".tr(),
  ];

  static List<String> getSubTitle = [
    "address_form_page.cep_input.subtitle".tr(),
    "address_form_page.street_input.subtitle".tr(),
    "address_form_page.complement_input.subtitle".tr(),
    "address_form_page.number_input.subtitle".tr(),
    "address_form_page.neighborhood_input.subtitle".tr(),
    "address_form_page.city_inpnut.subtitle".tr(),
    "address_form_page.state_inpnut.subtitle".tr(),
    "address_form_page.nickname_inpnut.subtitle".tr(),
    "address_form_page.is_prefered_input.subtitle".tr(),
  ];

  bool isValid(AddressFormState state) {
    final validators = [
      Validator.validateCep(state.address.zipcode).isRight(),
      Validator.validateAddressProperties(state.address.street).isRight(),
      Validator.validateAddressProperties(state.address.complement).isRight(),
      Validator.validateAddressProperties(state.address.number).isRight(),
      Validator.validateAddressProperties(state.address.neighborhood).isRight(),
      Validator.validateAddressProperties(state.address.city).isRight(),
      Validator.validateAddressProperties(state.address.state).isRight(),
      Validator.validateAddressProperties(state.address.nickname).isRight(),
      true,
    ];
    return validators[state.actualStep];
  }

  Widget getInputs(int index, BuildContext context, AddressFormState state) {
    final inputs = <Widget>[
      BorderInput(
        textEditingController: state.cepController,
        text: "address_form_page.cep_input.leading".tr(),
        keyboardType: TextInputType.number,
        maxLength: 8,
        onEditingComplete: () {
          if (Validator.validateCep(state.address.zipcode).isRight()) {
            context.read<AddressFormBloc>().add(
                  const AddressFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<AddressFormBloc>().add(
              AddressFormEvent.cepChanged(value),
            ),
        validator: (value) => Validator.validateCep(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            withOutMinStringLength: (_) =>
                "address_form_page.cep_input.errors.withOutMinStringLength"
                    .tr(),
            empty: (_) => "address_form_page.cep_input.errors.empty".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        initialValue: state.address.street,
        textEditingController: state.streetController,
        text: "",
        keyboardType: TextInputType.text,
        onEditingComplete: () {
          if (Validator.validateName(state.address.street).isRight()) {
            context.read<AddressFormBloc>().add(
                  const AddressFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<AddressFormBloc>().add(
              AddressFormEvent.addressChanged(value),
            ),
        validator: (value) => Validator.validateAddressProperties(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) => "address_form_page.street_input.errors.empty".tr(),
            multiline: (_) =>
                "address_form_page.street_input.errors.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        initialValue: state.address.complement,
        textEditingController: state.complementController,
        text: "",
        keyboardType: TextInputType.text,
        onEditingComplete: () {
          if (Validator.validateName(state.address.complement).isRight()) {
            context.read<AddressFormBloc>().add(
                  const AddressFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<AddressFormBloc>().add(
              AddressFormEvent.complementChanged(value),
            ),
        validator: (value) => Validator.validateAddressProperties(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) =>
                "address_form_page.complement_input.errors.empty".tr(),
            multiline: (_) =>
                "address_form_page.complement_input.errors.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        textEditingController: state.numberController,
        text: "123AES",
        keyboardType: TextInputType.text,
        onEditingComplete: () {
          if (Validator.validateName(state.address.number).isRight()) {
            context.read<AddressFormBloc>().add(
                  const AddressFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<AddressFormBloc>().add(
              AddressFormEvent.numberChanged(value.toUpperCase()),
            ),
        validator: (value) => Validator.validateAddressProperties(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) => "address_form_page.number_input.errors.empty".tr(),
            multiline: (_) =>
                "address_form_page.number_input.errors.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        initialValue: state.address.neighborhood,
        textEditingController: state.neighborhoodController,
        text: "",
        keyboardType: TextInputType.text,
        onEditingComplete: () {
          if (Validator.validateName(state.address.neighborhood).isRight()) {
            context.read<AddressFormBloc>().add(
                  const AddressFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<AddressFormBloc>().add(
              AddressFormEvent.neighborhoodChanged(value),
            ),
        validator: (value) => Validator.validateAddressProperties(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) =>
                "address_form_page.neighborhood_input.errors.empty".tr(),
            multiline: (_) =>
                "address_form_page.neighborhood_input.errors.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        initialValue: state.address.city,
        textEditingController: state.cityController,
        text: "",
        keyboardType: TextInputType.text,
        onEditingComplete: () {
          if (Validator.validateName(state.address.city).isRight()) {
            context.read<AddressFormBloc>().add(
                  const AddressFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<AddressFormBloc>().add(
              AddressFormEvent.cityChanged(value),
            ),
        validator: (value) => Validator.validateAddressProperties(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) => "address_form_page.city_inpnut.errors.empty".tr(),
            multiline: (_) =>
                "address_form_page.city_inpnut.errors.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        initialValue: state.address.state,
        textEditingController: state.stateController,
        text: "",
        keyboardType: TextInputType.text,
        onEditingComplete: () {
          if (Validator.validateName(state.address.state).isRight()) {
            context.read<AddressFormBloc>().add(
                  const AddressFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<AddressFormBloc>().add(
              AddressFormEvent.stateChanged(value),
            ),
        validator: (value) => Validator.validateAddressProperties(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) => "address_form_page.state_inpnut.errors.empty".tr(),
            multiline: (_) =>
                "address_form_page.state_inpnut.errors.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      BorderInput(
        initialValue: state.address.nickname,
        textEditingController: state.nicknameController,
        text: "address_form_page.nickname_inpnut.leading".tr(),
        keyboardType: TextInputType.text,
        onEditingComplete: () {
          if (Validator.validateName(state.address.nickname).isRight()) {
            context.read<AddressFormBloc>().add(
                  const AddressFormEvent.nextStep(),
                );
          }
        },
        onChange: (value) => context.read<AddressFormBloc>().add(
              AddressFormEvent.nickNameChanged(value),
            ),
        validator: (value) => Validator.validateAddressProperties(value!).fold(
          (failure) => failure.maybeMap(
            orElse: () => null,
            empty: (_) => "address_form_page.nickname_inpnut.errors.empty".tr(),
            multiline: (_) =>
                "address_form_page.nickname_inpnut.errors.multiline".tr(),
          ),
          (r) => null,
        ),
      ),
      Visibility(visible: isFirst, child: Container()),
    ];
    return inputs[index];
  }
}
