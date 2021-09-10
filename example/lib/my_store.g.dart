// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MyStore on _MyStore, Store {
  final _$textAtom = Atom(name: '_MyStore.text');

  @override
  String get text {
    _$textAtom.reportRead();
    return super.text;
  }

  @override
  set text(String value) {
    _$textAtom.reportWrite(value, super.text, () {
      super.text = value;
    });
  }

  final _$observableFutureAtom = Atom(name: '_MyStore.observableFuture');

  @override
  ObservableFuture<String?>? get observableFuture {
    _$observableFutureAtom.reportRead();
    return super.observableFuture;
  }

  @override
  set observableFuture(ObservableFuture<String?>? value) {
    _$observableFutureAtom.reportWrite(value, super.observableFuture, () {
      super.observableFuture = value;
    });
  }

  final _$fetchAsyncAction = AsyncAction('_MyStore.fetch');

  @override
  Future<String?> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  final _$_MyStoreActionController = ActionController(name: '_MyStore');

  @override
  void changeText(String value) {
    final _$actionInfo =
        _$_MyStoreActionController.startAction(name: '_MyStore.changeText');
    try {
      return super.changeText(value);
    } finally {
      _$_MyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
text: ${text},
observableFuture: ${observableFuture}
    ''';
  }
}
