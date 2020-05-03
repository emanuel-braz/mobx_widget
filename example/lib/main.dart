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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: Container(
              height: 100,
              width: screenWidth,
              color: Colors.amber,
              child: ObserverFuture(
                transition: BrazTransition(
                  transition: BrazTransitionEnum.slideVertical,
                  duration: Duration(seconds: 1),
                ),
                observableFuture: () => myStore.observableFuture,
                onData: (_, data) => Center(
                  key: ObserverKeyOnData,
                  child: Text(
                    ' 86 °F',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
                onUnstarted: (_) => Center(
                  key: ObserverKeyOnUnstarted,
                  child: Text(
                    'Looking for weather servers...',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                onPending: (_) => Center(
                    key: ObserverKeyOnPending,
                    child: CircularProgressIndicator()),
              ),
            ),
          ),
          DefaultTextStyle(
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.blue),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 40),
                  Text(
                    'ObservableStream:',
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.black26,
                      alignment: Alignment.centerLeft,
                      width: screenWidth * .9,
                      child: ObserverStream<double, dynamic>(
                        transition: BrazTransition(
                            transition: BrazTransitionEnum.sizeHorizontal,
                            duration: Duration(milliseconds: 100)),
                        observableStream: () => myStore.observableStream2,
                        onData: (_, data) => Container(
                            width:
                                data != null ? screenWidth * (data / 100) : 0,
                            color: Colors.green,
                            height: 28,
                            key: ObserverKeyOnData),
                        onUnstarted: (_) => Container(
                            color: Colors.green,
                            height: 28,
                            width: 0,
                            key: ObserverKeyOnUnstarted),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Container(
                    width: double.infinity,
                    child: ObserverStream<String, String>(
                      transition: BrazTransition(
                        duration: Duration(seconds: 2),
                        transition: BrazTransitionEnum.slideHorizontalDismiss,
                        curveIn: Curves.linear,
                        curveOut: Curves.linear,
                      ),
                      observableStream: () => myStore.observableStream,
                      onData: (_, data) =>
                          Text('DATA: $data', key: ObserverKeyOnData),
                      onNull: (_) => Text(
                        'NULL',
                        key: ObserverKeyOnNull,
                        style: TextStyle(color: Colors.green),
                      ),
                      onUnstarted: (_) => Text('UNSTARTED',
                          key: ObserverKeyOnUnstarted,
                          style: TextStyle(color: Colors.grey)),
                      onError: (_, error) => Text('ERROR: ' + error,
                          key: ObserverKeyOnError,
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  Divider(),
                  ObserverStream<String, String>(
                    transition: BrazTransition(
                      duration: Duration(seconds: 2),
                      transition: BrazTransitionEnum.slideVerticalDismiss,
                    ),
                    observableStream: () => myStore.observableStream,
                    onData: (_, data) =>
                        Text('DATA: $data', key: ObserverKeyOnData),
                    onNull: (_) => Text(
                      'NULL',
                      key: ObserverKeyOnNull,
                      style: TextStyle(color: Colors.green),
                    ),
                    onUnstarted: (_) => Text('UNSTARTED',
                        key: ObserverKeyOnUnstarted,
                        style: TextStyle(color: Colors.grey)),
                    onError: (_, error) => Text('ERROR: ' + error,
                        key: ObserverKeyOnError,
                        style: TextStyle(color: Colors.red)),
                  ),
                  Divider(),
                  ObserverStream<String, String>(
                    transition: BrazTransition(
                      duration: Duration(seconds: 2),
                      transition: BrazTransitionEnum.slideVertical,
                    ),
                    observableStream: () => myStore.observableStream,
                    onData: (_, data) =>
                        Text('DATA: $data', key: ObserverKeyOnData),
                    onNull: (_) => Text(
                      'NULL',
                      key: ObserverKeyOnNull,
                      style: TextStyle(color: Colors.green),
                    ),
                    onUnstarted: (_) => Text('UNSTARTED',
                        key: ObserverKeyOnUnstarted,
                        style: TextStyle(color: Colors.grey)),
                    onError: (_, error) => Text('ERROR: ' + error,
                        key: ObserverKeyOnError,
                        style: TextStyle(color: Colors.red)),
                  ),
                  Divider(),
                  ObserverStream<String, String>(
                    transition: BrazTransition(
                        duration: Duration(seconds: 2),
                        transition: BrazTransitionEnum.slideHorizontal),
                    observableStream: () => myStore.observableStream,
                    onData: (_, data) =>
                        Text('DATA: $data', key: ObserverKeyOnData),
                    onNull: (_) => Text(
                      'NULL',
                      key: ObserverKeyOnNull,
                      style: TextStyle(color: Colors.green),
                    ),
                    onUnstarted: (_) => Text('UNSTARTED',
                        key: ObserverKeyOnUnstarted,
                        style: TextStyle(color: Colors.grey)),
                    onError: (_, error) => Text('ERROR: ' + error,
                        key: ObserverKeyOnError,
                        style: TextStyle(color: Colors.red)),
                  ),
                  Divider(),
                  ObserverText(
                    transition: BrazTransition(
                      transition: BrazTransitionEnum.fade,
                      duration: Duration(seconds: 1),
                      curveIn: Curves.linear,
                      curveOut: Curves.linear,
                    ),
                    onData: (_) => 'ObserverText:\n${myStore.text}',
                    // style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Divider(),
                  Text(
                    'ObservableFuture:',
                  ),
                  ObserverFuture(
                    transition: BrazTransition(
                      transition: BrazTransitionEnum.slideHorizontal,
                      duration: Duration(seconds: 1),
                    ),
                    retry: 1,
                    autoInitialize: false,
                    fetchData: myStore.fetch,
                    observableFuture: () => myStore.observableFuture,
                    onData: (_, data) => Text(
                      '😊',
                      key: ObserverKeyOnNull,
                    ),
                    onNull: (_) => Text(
                      '🙄',
                      key: ObserverKeyOnNull,
                    ),
                    onError: (_, error) => Text(
                      '😥',
                      key: ObserverKeyOnError,
                    ),
                    onUnstarted: (_) => Text(
                      '😐',
                      key: ObserverKeyOnUnstarted,
                    ),
                    onPending: (_) => Text('🤔', key: ObserverKeyOnPending),
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
                    onData: (_, data) => Icon(
                      Icons.ac_unit,
                      key: ObserverKeyOnData,
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    myStore.dispose();
    super.dispose();
  }
}
