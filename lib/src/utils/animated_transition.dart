import 'package:flutter/material.dart';

enum TransitionType {
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

class Transition {
  final TransitionType? transition;
  final Curve curveIn;
  final Curve curveOut;
  final Duration duration;

  Transition(
      {this.transition,
      this.curveIn = Curves.linear,
      this.curveOut = Curves.linear,
      this.duration = const Duration(milliseconds: 500)});

  /// builder
  Widget builder(Widget child, Animation<double> animation) {
    switch (transition) {
      case TransitionType.scale:
        return ScaleTransition(scale: animation, child: child);
      case TransitionType.rotate:
        return RotationTransition(turns: animation, child: child);
      case TransitionType.sizeHorizontal:
        return SizeTransition(axis: Axis.horizontal, axisAlignment: -1, sizeFactor: animation, child: child);
      case TransitionType.sizeVertical:
        return SizeTransition(axis: Axis.vertical, axisAlignment: -1, sizeFactor: animation, child: child);
      case TransitionType.slideSwitch:
        final offsetAnimation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)).animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      case TransitionType.slideVerticalDismiss:
        final offsetAnimation = TweenSequence([
          TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)), weight: 20),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 60),
          TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, -1.0)), weight: 20)
        ]).animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      case TransitionType.slideVertical:
        final offsetAnimation = TweenSequence([
          TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)), weight: 1),
          TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 0.0)), weight: 1)
        ]).animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      case TransitionType.slideHorizontal:
        final offsetAnimation = TweenSequence([
          TweenSequenceItem(tween: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)), weight: 1),
          TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 0.0)), weight: 1)
        ]).animate(animation);
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      case TransitionType.slideHorizontalDismiss:
        final offsetAnimation = TweenSequence([
          TweenSequenceItem(tween: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)), weight: 20),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 60),
          TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(-1.0, 0.0)), weight: 20)
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

class AnimatedTransition extends AnimatedSwitcher {
  final Transition transition;
  final Widget child;

  AnimatedTransition({required this.child, required this.transition})
      : super(
          layoutBuilder: [
            TransitionType.slideVertical,
            TransitionType.slideVerticalDismiss,
            TransitionType.slideHorizontal,
            TransitionType.slideHorizontalDismiss,
          ].contains(transition.transition)
              ? (Widget? currentChild, List<Widget> previousChildren) {
                  return currentChild as Widget;
                }
              : AnimatedSwitcher.defaultLayoutBuilder,
          switchInCurve: transition.curveIn,
          switchOutCurve: transition.curveOut,
          transitionBuilder: transition.builder,
          duration: transition.duration,
          child: child,
        );
}
