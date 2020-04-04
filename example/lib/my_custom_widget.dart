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
        observableFuture: observableFuture,
        onData: onData,
        onNull: (_) => Text('🤔'),
        onError: (_, error) => Text('😥'),
        onUnstarted: (_) => Text('😐'),
        onPending: (_) => Text('👂👂👂'),
        showDefaultProgressInOverlay: true,
        overlayWidget: Container(
          color: Colors.black45,
          child: Text(
            '👀💬',
            style: TextStyle(fontSize: 40),
          ),
          alignment: Alignment.center,
        ));
  }
}
