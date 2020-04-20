import 'dart:async';
import 'dart:math';

import 'package:mobx/mobx.dart';

part 'my_store.g.dart';

class MyStore = _MyStore with _$MyStore;

abstract class _MyStore with Store {
  Timer _timer;
  Timer _timer2;
  final _random = Random();
  StreamController<String> _streamController;
  ObservableStream<String>
      observableStream; // Use in widget ObserverStreamWidget
  StreamController<double> _streamController2;
  ObservableStream<double>
      observableStream2; // Use in widget ObserverStreamWidget

  @observable
  String text = "UNSTARTED";
  @action
  void changeText(String value) => text = value;

  @observable
  ObservableFuture<String>
      observableFuture; // Use in widget ObserverFutureWidget

  @action
  Future<String> fetch() async {
    return observableFuture = ObservableFuture(_clientFetch());
  }

  _MyStore() {
    _streamController = StreamController<String>();
    _timer = Timer.periodic(const Duration(seconds: 2), _handleStreamData);
    observableStream = ObservableStream(_streamController.stream);

    double counter = 0;
    _streamController2 = StreamController<double>();
    observableStream2 = ObservableStream(_streamController2.stream);
    _timer2 = Timer.periodic(const Duration(milliseconds: 100), (d) {
      if (counter == 100) counter = 0;
      _streamController2.add(counter++);
    });

    Future.delayed(Duration(seconds: 3),
        fetch); // Delay future call, to allow rendering unstarted widget
  }

  Future<String> _clientFetch() async {
    await Future.delayed(Duration(seconds: 3));
    Future.delayed(Duration(seconds: 2), fetch);
    return 'lorem ipsum';
    // return Future.value(null);
    // return Future.error(Exception('mistakes happens'));
  }

  _handleStreamData(Timer _) {
    var result = _random.nextInt(3);

    if (result == 0) {
      _streamController.add(null);
      changeText('null');
    } else if (result == 1) {
      _streamController.addError('mistakes happens');
      changeText('mistakes happens');
    } else {
      _streamController.add('stream:lorem ipsum data');
      changeText('stream:lorem ipsum data');
    }
  }

  void dispose() async {
    _timer.cancel();
    _timer2.cancel();
    await _streamController.close();
  }
}
