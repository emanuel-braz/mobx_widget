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
              Container(
                  alignment: Alignment.center, 
                  child: Text(
                    'ObservableStream > ',
                    style: Theme.of(context).textTheme.headline5,
                  )),
              ObserverStreamWidget( // Use this widget to handle ObservableStream events
                observableStream: () => myStore.observableStream,
                onData: (_, data) => Text('$data'),
                onNull: (_) => Text('NULL'),
                onUnstarted: (_) => Text('UNSTARTED'),
                onError: (context, error) => Text('error: ' + error.toString()),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    'ObservableFuture > ',
                    style: Theme.of(context).textTheme.headline5,
                  )),
              ObserverFutureWidget( // Use this widget to handle ObservableFuture events
                observableFuture: () => myStore.observableFuture,
                onResult: (_, data) => Text(data.toString()),
                onResultNull: (_) => Text('NULL'),
                onError: (context, error) => Text('error: ${error.toString()}'),
                onPending: (context) => CircularProgressIndicator(),
                onUnstarted: (context) => Text('UNSTARTED'),
              ),
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
