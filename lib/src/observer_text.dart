import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_widget/src/utils/braz_animated_transition.dart';

class ObserverText extends StatelessWidget {
  final BrazTransition transition;
  final String Function(BuildContext context) onData;
  final InlineSpan Function(BuildContext context) onDataRich;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;
  final TextWidthBasis textWidthBasis;
  final bool isRich;

  ObserverText({
    Key key,
    @required this.onData,
    this.onDataRich,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.transition,
    isRich,
  })  : isRich = false,
        assert(onData != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (transition != null)
        return BrazAnimatedTransition(
          transition: transition,
          child: _getChildWidget(context, isRich),
        );

      return _getChildWidget(context, isRich);
    });
  }

  ObserverText.rich(
      {Key key,
      this.onData,
      @required this.onDataRich,
      this.transition,
      this.style,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      isRich})
      : isRich = true,
        assert(onDataRich != null),
        super(key: key);

  Widget _getChildWidget(BuildContext context, bool isRich) => isRich
      ? Text.rich(onDataRich(context),
          key: key ?? onDataRich(context)?.hashCode,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis)
      : Text(onData(context) ?? '',
          key: key ?? ValueKey(onData(context)),
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis);
}
