import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ObserverText extends Observer {
  ObserverText({
    Key key,
    @required String onData(BuildContext context),
    style,
    strutStyle,
    textAlign,
    textDirection,
    locale,
    softWrap,
    overflow,
    textScaleFactor,
    maxLines,
    semanticsLabel,
    textWidthBasis,
  })  : assert(onData != null),
        super(
            key: key,
            builder: (context) => Text(onData(context),
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
                textWidthBasis: textWidthBasis));

  ObserverText.rich({
    Key key,
    @required TextSpan onData(BuildContext context),
    style,
    strutStyle,
    textAlign,
    textDirection,
    locale,
    softWrap,
    overflow,
    textScaleFactor,
    maxLines,
    semanticsLabel,
    textWidthBasis,
  })  : assert(onData != null),
        super(
            key: key,
            builder: (context) => Text.rich(onData(context),
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
                textWidthBasis: textWidthBasis));
}
