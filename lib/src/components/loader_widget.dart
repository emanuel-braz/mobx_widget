import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {

  final Color color;
  final Color backgroundColor;

  const LoaderWidget({Key key, this.color, this.backgroundColor}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: backgroundColor ?? Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}