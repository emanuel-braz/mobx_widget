## ObserverFutureWidget - A simple Widget to handle MobX ObservableFuture events.


### Example usage

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
  onError: (_) => MyCustomErrorReloaderWidget(),
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
