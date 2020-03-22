## If you use ObservableFuture or ObservableStream, maybe you should be considering to use some helpers widgets in your project, like ObserverFutureWidget or ObserverStreamWidget.


### Example usage

#### add dependency to pubspec.yaml
```yaml
  mobx_widget:
    git: https://github.com/emanuel-braz/mobx_widget.git
```
 OR
```yaml
  dependencies:
    mobx_widget: ^0.1.0
```

#### Import package
```dart
import 'package:mobx_widget/mobx_widget.dart';
```

#### Create the ObservableFuture
```dart
class MyStore {

  ...

  MyStore(){
    fetchData();
  }
  
  @observable
  ObservableFuture<String> myObservableFuture;
  
  @action
  Future<String> fetchData() async {
    return await (myObservableFuture = ObservableFuture( _repository.fetch() ));
  }
}
```

#### With Future (ObservableFuture)
```dart
...

ObserverFutureWidget(
  observableFuture: () => myStore.myObservableFuture,
  onResult: (_, data) => MyCustomDataWidget(data: data),
  onResultNull: (_) => Center(child: Text('Oops! No connection.')),
  onPending: (_) => CircularProgressIndicator(),
  onError: (_, error) => MyCustomErrorReloaderWidget(error),
);
```

#### With Stream (ObservableStream)
```dart
...

ObserverStreamWidget(
  observableStream: () => myObservableStream,
  onData: (_, data) => Text('$data'),
  onNull: (_) => Text('NULL'),
  onUnstarted: (_) => Text('UNSTARTED'),
  onError: (_, error) => Text('ERROR: ' + error.toString())
)
```

### TODO
- [x] add example
- [ ] add unit test
- [ ] widget test
