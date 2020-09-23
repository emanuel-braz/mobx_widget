import 'package:flutter/material.dart';

class ReloaderButtonWidget extends StatelessWidget {
  final VoidCallback callback;
  final String buttonText;
  final Color buttontextColor;
  final Color buttonBackgroundColor;

  const ReloaderButtonWidget(
      {this.callback,
      Key key,
      this.buttonText,
      this.buttontextColor,
      this.buttonBackgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.all(kFloatingActionButtonMargin),
          child: callback != null
              ? RaisedButton(
                  color:
                      buttonBackgroundColor ?? Theme.of(context).primaryColor,
                  onPressed: this.callback,
                  child: Text(
                    buttonText ?? 'RELOAD',
                    style: TextStyle(
                        color: buttontextColor ?? Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : SizedBox.shrink()),
    );
  }
}
