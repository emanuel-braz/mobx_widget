import 'dart:async';
import 'dart:math';

import 'package:mobx/mobx.dart';

part 'my_store.g.dart';

class MyStore = _MyStore with _$MyStore;

abstract class _MyStore with Store {
  Timer _timer;
  final _random = Random();
  StreamController<String> _streamController;
  ObservableStream<String>
      observableStream; // Use in widget ObserverStreamWidget

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

    Future.delayed(Duration(seconds: 3),
        fetch); // Delay future call, to allow rendering unstarted widget
  }

  Future<String> _clientFetch() async {
    await Future.delayed(Duration(seconds: 3));
    return 'lorem ipsum';
    // return Future.value(null);
    // return Future.error('mistakes happens');
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
    await _streamController.close();
  }
}
