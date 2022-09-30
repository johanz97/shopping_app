import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

class DotSteper extends StatelessWidget {
  final int dotCount;
  final int activeStep;

  const DotSteper({
    Key? key,
    required this.dotCount,
    required this.activeStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DotStepper(
      dotCount: dotCount,
      dotRadius: 6,
      tappingEnabled: false,
      activeStep: activeStep,
      shape: Shape.stadium,
      spacing: 5,
      indicator: Indicator.worm,
      indicatorDecoration: IndicatorDecoration(
        color: Theme.of(context).primaryColor,
      ),
      lineConnectorDecoration: const LineConnectorDecoration(
        color: Colors.white,
        strokeWidth: 0,
      ),
    );
  }
}
