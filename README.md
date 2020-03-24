[![Pub Version](https://img.shields.io/pub/v/mobx_widget?color=%2302569B&label=pub&logo=flutter)](https://pub.dev/packages/mobx_widget) ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

### A simple way to consume MobX Observables through widgets. You can find a sort of widgets, like ObserverFuture, ObserverStream and ObserverText


### Example usage

#### add dependency to pubspec.yaml
```yaml
  mobx_widget:
    git: https://github.com/emanuel-braz/mobx_widget.git
```
 OR
```yaml
  dependencies:
    mobx_widget: ^0.1.3
```

#### Import package and use Observer Widgets
```dart
import 'package:mobx_widget/mobx_widget.dart';
```

#### ObservableFuture (ObserverFuture)
```dart
ObserverFuture(
  observableFuture: () => myStore.myObservableFuture,
  onResult: (_, data) => MyCustomDataWidget(data: data),
  onResultNull: (_) => Center(child: Text('Oops! No connection.')),
  onPending: (_) => CircularProgressIndicator(),
  onError: (_, error) => MyCustomErrorReloaderWidget(error),
);
```

#### ObservableStream (ObserverStream)
```dart
ObserverStream(
  observableStream: () => myObservableStream,
  onData: (_, data) => Text('$data'),
  onNull: (_) => Text('NULL'),
  onUnstarted: (_) => Text('UNSTARTED'),
  onError: (_, error) => Text('ERROR: ' + error.toString())
)
```

#### Text Widget (ObserverText)
```dart
ObserverText(onData: (_) => myStore.text)
```

#### Contributions of any kind are welcome! 👾

### TODO
- [x] add example
- [ ] add unit test
- [ ] add widget test
- [ ] add more widgets
