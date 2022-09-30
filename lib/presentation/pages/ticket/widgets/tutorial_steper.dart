import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_stepper/stepper.dart';

import '../../../../aplication/core/instructions_steper/instructions_steper_bloc.dart';
import '../../../../injection.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../routes/router.gr.dart';

class TutorialSteper extends StatelessWidget {
  const TutorialSteper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InstructionsSteperBloc>()
        ..add(
          const InstructionsSteperEvent.initialize(),
        ),
      child: BlocBuilder<InstructionsSteperBloc, InstructionsSteperState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(height: 120.h),
              Text(
                "ticket_scanner_tutorial.title".tr(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 73.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "ticket_scanner_tutorial.subtitle"
                    .tr(args: ["${state.step + 1}/3"]),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 31.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 0.25.sh,
                width: 1.sw,
                margin: const EdgeInsets.all(20),
                child: PageView.builder(
                  onPageChanged: (index) {
                    context
                        .read<InstructionsSteperBloc>()
                        .add(InstructionsSteperEvent.nextStep(index));
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      state.images[state.step],
                    );
                  },
                  itemCount: state.totalSteps,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  state.descriptions[state.step],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.h),
              DotStepper(
                dotCount: state.totalSteps,
                dotRadius: 6,
                tappingEnabled: false,
                activeStep: state.step,
                shape: Shape.stadium,
                spacing: 5,
                indicator: Indicator.worm,
                indicatorDecoration: IndicatorDecoration(
                  strokeWidth: 8,
                  color: Theme.of(context).primaryColor,
                ),
                lineConnectorDecoration: const LineConnectorDecoration(
                  color: Colors.white,
                  strokeWidth: 0,
                ),
              ),
              SizedBox(height: 30.h),
              Visibility(
                visible: state.isNewUser && state.step == 0,
                child: CustomButtom(
                  onTap: () => context.router.pushAndPopUntil(
                    const UserWelcomeFormRoute(),
                    predicate: (e) => false,
                  ),
                  title: "ticket_scanner_tutorial.action_3".tr(),
                  width: 500.w,
                  height: 60.h,
                  isActive: true,
                  hasGradient: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
