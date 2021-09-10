[![Pub Version](https://img.shields.io/pub/v/mobx_widget?color=%2302569B&label=pub&logo=flutter)](https://pub.dev/packages/mobx_widget) ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

### ObserverFuture, ObserverStream and ObserverText Widget - A simple way to consume MobX Observables through widgets. You can find a sort of widgets.


![preview](https://user-images.githubusercontent.com/3827308/79704747-40f2b600-8289-11ea-97e4-55f4d85800e8.gif)

### Example usage

`flutter pub add mobx_widget`

```yaml
  dependencies:
    mobx_widget: ^0.5.0
```

#### Import package and use Observer Widgets
```dart
import 'package:mobx_widget/mobx_widget.dart';
```

#### Animated Transitions for Observable Text Widget (ObserverText)
```dart
ObserverText(
  transition: Transition( // Trasition is optional
    transition: TransitionType.fade,
    duration: Duration(seconds: 1),
    curveIn: Curves.linear,
    curveOut: Curves.linear,
  ),
  onData: (_) => '${myStore.currentStatus}',
  // style: Theme.of(context).textTheme.bodyText1,
)
```

#### ObservableFuture (ObserverFuture) - Generic types is optional(required both if used)
```dart
ObserverFuture<String, Exception>( // Use this widget to handle ObservableFuture events
  retry: 2, // It will retry 2 times after the first error event
  autoInitialize: false, // If true, it will call [fetchData] automatically
  fetchData: myStore.fetch, // VoidCallback
  
  observableFuture: () => myStore.observableFuture,
  onData: (_, data) => Text('DATA: $data'),
  onNull: (_) => Text('NULL'),
  onError: (_, error) => Text('${error.toString()}'),
  onPending: (_) => Text('PENDING'),
  onUnstarted: (_) => Text('UNSTARTED'),
)
```

#### ObservableStream (ObserverStream)
```dart
ObserverStream(  // Use this widget to handle ObservableStream events
  observableStream: () => myStore.observableStream,
  onData: (_, data) => Text('DATA: $data'),
  onNull: (_) => Text('NULL'),
  onUnstarted: (_) => Text('UNSTARTED'),
  onError: (_, error) => Text('ERROR: ' + error.toString()),
),
```

#### Text Widget (ObserverText)
```dart
ObserverText(
  onData: (_) => myStore.text,
  // style: Theme.of(context).textTheme.bodyText1,
)
```

#### Customize the ObserverFuture widget behavior just once and use it in the entire application.
```dart
MyCustomObserverFutureWidget(
  observableFuture: () => myStore.observableFuture,
  onData: (_, data) => Text('😍'),
)
```
```dart
class MyCustomObserverFutureWidget extends StatelessWidget {
  
  final ObservableFuture Function() observableFuture;
  final Function(BuildContext context, dynamic data) onData;

  MyCustomObserverFutureWidget({Key key, this.observableFuture, this.onData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObserverFuture(
      observableFuture: observableFuture,
      onData: onData,
      onNull: (_) => Text('🤔'),
      onError: (_, error) => Text('😥'),
      onUnstarted: (_) => Text('😐'),
      onPending: (_)=> Text('👂👂👂'),
      showDefaultProgressInOverlay: true,
      overlayWidget: Container(color:Colors.black45, child: Text('👀💬', style: TextStyle(fontSize: 40),), alignment: Alignment.center,)
    );
  }
}
```

### All widgets has an optional transition prorpety

#### Contributions of any kind are welcome! 👾

### TODO
- [x] add example
- [x] add animated transitions
- [ ] add unit test
- [ ] add widget test
- [ ] add more widgets
