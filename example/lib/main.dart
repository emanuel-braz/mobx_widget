import 'package:example/my_custom_widget.dart';
import 'package:example/my_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx_widget/mobx_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MobX Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyStore myStore;

  @override
  void initState() {
    super.initState();
    myStore = MyStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ObservableStream:',
              ),
              ObserverStream(
                // Use this widget to handle ObservableStream events
                observableStream: () => myStore.observableStream,
                onData: (_, data) => Text('DATA: $data'),
                onNull: (_) => Text('NULL'),
                onUnstarted: (_) => Text('UNSTARTED'),
                onError: (_, error) => Text('ERROR: ' + error.toString()),
              ),
              SizedBox(
                height: 16,
              ),
              Divider(),
              ObserverText(
                onData: (_) => 'ObserverText:\n${myStore.text}',
                // style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
              Divider(),
              Text(
                'ObservableFuture:',
              ),
              ObserverFuture(
                // Use this widget to handle ObservableFuture events
                observableFuture: () => myStore.observableFuture,
                onData: (_, data) => Text('DATA: ${data.toString()}'),
                onNull: (_) => Text('NULL'),
                onError: (_, error) => Text('ERROR: ${error.toString()}'),
                onPending: (_) => Text('PENDING'),
                onUnstarted: (_) => Text('UNSTARTED'),
              ),
              SizedBox(
                height: 16,
              ),
              Divider(),
              Text(
                'MyCustomObserverFuture:',
              ),
              MyCustomObserverFutureWidget(
                observableFuture: () => myStore.observableFuture,
                onData: (_, data) => Text('😍'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myStore.dispose();
    super.dispose();
  }
}
