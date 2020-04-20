import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_widget/mobx_widget.dart';

class MyCustomObserverFutureWidget extends StatelessWidget {
  final ObservableFuture Function() observableFuture;
  final Function(BuildContext context, dynamic data) onData;

  MyCustomObserverFutureWidget({Key key, this.observableFuture, this.onData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObserverFuture(
      transition: BrazTransition(transition: BrazTransitionEnum.rotate),
      observableFuture: observableFuture,
      onData: onData,
      onNull: (_) => Icon(
        Icons.ac_unit,
        key: ObserverKeyOnNull,
      ),
      onError: (_, error) => Icon(
        Icons.access_alarms,
        key: ObserverKeyOnError,
      ),
      onUnstarted: (_) => Icon(
        Icons.accessibility_new,
        key: ObserverKeyOnUnstarted,
      ),
      onPending: (_) => Icon(Icons.account_box, key: ObserverKeyOnPending),
      // showDefaultProgressInOverlay: true,
      // overlayWidget: Container(
      //   color: Colors.black45,
      //   child: Text(
      //     '👀💬',
      //     style: TextStyle(fontSize: 40),
      //   ),
      //   alignment: Alignment.center,
      // ),
    );
  }
}
