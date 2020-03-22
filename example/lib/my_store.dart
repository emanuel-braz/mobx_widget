import 'dart:async';
import 'dart:math';

import 'package:mobx/mobx.dart';

part 'my_store.g.dart';

class MyStore = _MyStore with _$MyStore;

abstract class _MyStore with Store {
  Timer _timer;
  final _random = Random();
  StreamController<String> _streamController;
  ObservableStream<String> observableStream; // Use in widget ObserverStreamWidget

  @observable
  ObservableFuture<String> observableFuture; // Use in widget ObserverFutureWidget

  @action
  Future<String> fetch() async {
    return observableFuture = ObservableFuture(_clientFetch());
  }

  _MyStore() {
    _streamController = StreamController<String>();
    _timer = Timer.periodic(const Duration(seconds: 2), _handleStreamData);
    observableStream = ObservableStream(_streamController.stream);
    
    // Delay future call, to allow rendering unstarted widget
    Future.delayed(Duration(seconds: 3), fetch);
  }

  Future<String> _clientFetch() async {
    await Future.delayed(Duration(seconds: 3));
    return 'Got Some Future Data';
    // return Future.value(null);
    // return Future.error('Sh**ts happens!');
  } 

  _handleStreamData(Timer _) {
    var result = _random.nextInt(3);
    print(result);

    if (result == 0) {
      _streamController.add(null);
    } else if (result == 1) {
      _streamController.addError('Sh**ts happens!');
    } else {
      _streamController.add('got some stream data');
    }
  }

  void dispose() async {
    _timer.cancel();
    await _streamController.close();
  }
}
