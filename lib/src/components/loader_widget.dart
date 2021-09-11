import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;

  const LoaderWidget({Key? key, this.color, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: this.backgroundColor ?? Colors.black26,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
            this.color ?? Theme.of(context).accentColor),
      ),
    );
  }
}
