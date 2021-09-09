library mobx_widget;

import 'package:flutter/foundation.dart';

export 'package:mobx_widget/src/observer_future.dart';
export 'package:mobx_widget/src/observer_stream.dart';
export 'package:mobx_widget/src/observer_text.dart';
export 'package:mobx_widget/src/utils/animated_transition.dart';

enum keyEnum { onData, onError, onUnstarted, onNull, onPending }
const ValueKey ObserverKeyOnData = ValueKey(keyEnum.onData);
const ValueKey ObserverKeyOnError = ValueKey(keyEnum.onError);
const ValueKey ObserverKeyOnUnstarted = ValueKey(keyEnum.onUnstarted);
const ValueKey ObserverKeyOnNull = ValueKey(keyEnum.onNull);
const ValueKey ObserverKeyOnPending = ValueKey(keyEnum.onPending);
