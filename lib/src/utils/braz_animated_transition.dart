import 'package:flutter/material.dart';

enum BrazTransitionEnum {
  fade,
  scale,
  rotate,
  sizeHorizontal,
  sizeVertical,
  slideSwitch,
  slideVertical,
  slideVerticalDismiss,
  slideHorizontal,
  slideHorizontalDismiss,
}

class BrazTransition {
  final BrazTransitionEnum transition;
  final Curve curveIn;
  final Curve curveOut;
  final Duration duration;

  BrazTransition(
      {this.transition,
      this.curveIn = Curves.linear,
      this.curveOut = Curves.linear,
      this.duration = const Duration(milliseconds: 500)});

  Widget builder(Widget child, Animation<double> animation) {
    switch (transition) {
      case BrazTransitionEnum.scale:
        return ScaleTransition(scale: animation, child: child);
      case BrazTransitionEnum.rotate:
        return RotationTransition(turns: animation, child: child);
      case BrazTransitionEnum.sizeHorizontal:
        return SizeTransition(
            axis: Axis.horizontal,
            axisAlignment: -1,
            sizeFactor: animation,
            child: child);
      case BrazTransitionEnum.sizeVertical:
        return SizeTransition(
            axis: Axis.vertical,
            axisAlignment: -1,
            sizeFactor: animation,
            child: child);
      case BrazTransitionEnum.slideSwitch:
        final offsetAnimation =
            Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                .animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      case BrazTransitionEnum.slideVerticalDismiss:
        final offsetAnimation = TweenSequence([
          TweenSequenceItem(
              tween:
                  Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)),
              weight: 20),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 60),
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: Offset(0.0, 0.0), end: Offset(0.0, -1.0)),
              weight: 20)
        ]).animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      case BrazTransitionEnum.slideVertical:
        final offsetAnimation = TweenSequence([
          TweenSequenceItem(
              tween:
                  Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)),
              weight: 1),
          TweenSequenceItem(
              tween:
                  Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 0.0)),
              weight: 1)
        ]).animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      case BrazTransitionEnum.slideHorizontal:
        final offsetAnimation = TweenSequence([
          TweenSequenceItem(
              tween:
                  Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)),
              weight: 1),
          TweenSequenceItem(
              tween:
                  Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 0.0)),
              weight: 1)
        ]).animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      case BrazTransitionEnum.slideHorizontalDismiss:
        final offsetAnimation = TweenSequence([
          TweenSequenceItem(
              tween:
                  Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)),
              weight: 20),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 60),
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: Offset(0.0, 0.0), end: Offset(-1.0, 0.0)),
              weight: 20)
        ]).animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      default:
        return FadeTransition(opacity: animation, child: child);
    }
  }
}

class BrazAnimatedTransition extends AnimatedSwitcher {
  final BrazTransition transition;
  final Widget child;

  BrazAnimatedTransition({@required this.child, @required this.transition})
      : super(
          layoutBuilder: [
            BrazTransitionEnum.slideVertical,
            BrazTransitionEnum.slideVerticalDismiss,
            BrazTransitionEnum.slideHorizontal,
            BrazTransitionEnum.slideHorizontalDismiss,
          ].contains(transition.transition)
              ? (Widget currentChild, List<Widget> previousChildren) {
                  return currentChild;
                }
              : AnimatedSwitcher.defaultLayoutBuilder,
          switchInCurve: transition.curveIn,
          switchOutCurve: transition.curveOut,
          transitionBuilder: transition.builder,
          duration: transition.duration,
          child: child,
        );
}
