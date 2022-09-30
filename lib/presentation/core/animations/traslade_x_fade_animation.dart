import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class TrasladeXFadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  const TrasladeXFadeAnimation({
    Key? key,
    required this.delay,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create tween
    final tween = createTween(delay);

    return PlayAnimation<TimelineValue<AniProps>>(
      tween: tween, // provide tween
      duration: tween.duration,
      child: child, // total duration obtained from TimelineTween
      builder: (context, child, value) {
        return Opacity(
          opacity: value.get(AniProps.opacity),
          child: Transform.translate(
            offset: Offset(value.get(AniProps.tralateX), 0),
            child: child,
          ),
        );
      },
    );
  }
}

enum AniProps { opacity, tralateX }

TimelineTween<AniProps> createTween(double delay) => TimelineTween<AniProps>()
  ..addScene(
    begin: Duration.zero,
    end: Duration(milliseconds: (1000 * delay).round()),
  )
      .animate(
        AniProps.opacity,
        tween: Tween<double>(begin: 0.0, end: 1.0),
        curve: Curves.easeOut,
      )
      .animate(AniProps.tralateX, tween: Tween<double>(begin: -50.0, end: 0.0));
