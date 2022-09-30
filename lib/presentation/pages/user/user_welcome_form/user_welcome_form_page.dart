import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../aplication/user/user_welcome_form/user_welcome_form_bloc.dart';

import '../../../../injection.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../core/widgets/scafold_core.dart';
import '../../../core/widgets/steper.dart';
import '../../../routes/router.gr.dart';

class UserWelcomeFormPage extends StatefulWidget {
  const UserWelcomeFormPage({Key? key}) : super(key: key);

  @override
  State<UserWelcomeFormPage> createState() => _UserWelcomeFormPageState();
}

class _UserWelcomeFormPageState extends State<UserWelcomeFormPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldCore(
      showActions: false,
      body: BlocProvider(
        create: (_) => getIt<UserWelcomeFormBloc>()
          ..add(const UserWelcomeFormEvent.initialize()),
        child: BlocBuilder<UserWelcomeFormBloc, UserWelcomeFormState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                height: 1.sh,
                margin: EdgeInsets.symmetric(
                  vertical: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.h,
                      ),
                      child: Text(
                        "user_welcome_form_page.title".tr(),
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontSize: 70.sp,
                            ),
                      ),
                    ),
                    CupertinoStepper(
                      physics: const NeverScrollableScrollPhysics(),
                      currentStep: state.actualStep,
                      onStepContinue: () async {
                        bool? hasCreate;
                        if (state.actualStep == 0) {
                          hasCreate = await context.router.push(
                            UserFormRoute(),
                          ) as bool?;
                        } else if (state.actualStep == 1) {
                          hasCreate = await context.router
                              .push(AddressFormRoute(isFirst: true)) as bool?;
                        } else {
                          hasCreate = await context.router
                              .push(CreditCardFormRoute()) as bool?;
                        }
                        if (hasCreate != null &&
                            hasCreate == true &&
                            state.actualStep <= 1) {
                          if (!mounted) return;
                          context
                              .read<UserWelcomeFormBloc>()
                              .add(const UserWelcomeFormEvent.nextStep());
                        } else if (hasCreate != null &&
                            hasCreate == true &&
                            state.actualStep == 2) {
                          if (!mounted) return;
                          context.read<UserWelcomeFormBloc>().add(
                                const UserWelcomeFormEvent.finishProcess(),
                              );
                          context.router.pushAndPopUntil(
                            HomeTicketRoute(),
                            predicate: (_) => false,
                          );
                        }
                      },
                      steps: [
                        Step(
                          isActive: state.actualStep == 0,
                          title: Text(
                            "user_welcome_form_page.step_1.title".tr(),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.black,
                                      fontWeight: state.actualStep == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                          subtitle: Text(
                            "user_welcome_form_page.step_1.subtitle".tr(),
                          ),
                          state: state.actualStep == 0
                              ? StepState.editing
                              : state.actualStep > 0
                                  ? StepState.complete
                                  : StepState.indexed,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                "user_welcome_form_page.step_1.content.item_1"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_1.content.item_2"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_1.content.item_3"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_1.content.item_4"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_1.content.item_5"
                                    .tr(),
                              ),
                            ],
                          ),
                        ),
                        Step(
                          isActive: state.actualStep == 1,
                          state: state.actualStep == 1
                              ? StepState.editing
                              : state.actualStep > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                          title: Text(
                            "user_welcome_form_page.step_2.title".tr(),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.black,
                                      fontWeight: state.actualStep == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                          subtitle: Text(
                            "user_welcome_form_page.step_2.subtitle".tr(),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                "user_welcome_form_page.step_2.content.item_1"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_2.content.item_2"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_2.content.item_3"
                                    .tr(),
                              ),
                            ],
                          ),
                        ),
                        Step(
                          isActive: state.actualStep == 2,
                          state: state.actualStep == 2
                              ? StepState.editing
                              : StepState.indexed,
                          title: Text(
                            "user_welcome_form_page.step_3.title".tr(),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.black,
                                      fontWeight: state.actualStep == 2
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                          subtitle: Text(
                            "user_welcome_form_page.step_3.subtitle".tr(),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                "user_welcome_form_page.step_3.content.item_1"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_3.content.item_2"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_3.content.item_3"
                                    .tr(),
                              ),
                              Text(
                                "user_welcome_form_page.step_3.content.item_4"
                                    .tr(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 50.h,
                      ),
                      child: CustomButtom(
                        onTap: () => context.router.pushAndPopUntil(
                          HomeTicketRoute(),
                          predicate: (e) => false,
                        ),
                        title: "user_welcome_form_page.action_1".tr(),
                        width: 500,
                        isActive: true,
                        hasGradient: false,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
