import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_widget/src/components/loader_widget.dart';
import 'package:mobx_widget/src/components/reloader_button_widget.dart';
import 'package:mobx_widget/src/utils/animated_transition.dart';

class ObserverFuture<D, E> extends StatefulWidget {
  /// If [fetchData] is filled, it will be called just once on initState.
  final VoidCallback? fetchData;

  /// [observableFuture]
  final ObservableFuture? Function()? observableFuture;

  /// onError callback
  final Widget Function(BuildContext context, E error)? onError;

  /// onPending callback
  final Widget Function(BuildContext context)? onPending;

  /// onUnstarted callback
  final Widget Function(BuildContext context)? onUnstarted;

  /// onNull callback
  final Widget Function(BuildContext context)? onNull;
  final Transition? transition;

  /// if it get some exception, it will try to call [fetchData] again
  final int retry;

  /// If true, it will try to call [fetchData] callback
  /// [autoInitialize] default is true
  final bool autoInitialize;

  /// Executed on every event changes
  final void Function(ObservableFuture<dynamic>?)? listen;

  /// the [data] property has the value of ObservableFuture, and it may be null eventually.
  /// You can handle null value on [onData] callback or just enter a [onNull] callback to handle null values separately.
  /// Note, if you set a [onNull] callback, the [onData] will not be triggered if value == null.
  final Widget Function(BuildContext context, D data) onData;

  /// Show CircularProgressIndicator while status == pending
  /// Warning: onPending overrides this
  final bool showDefaultProgressInWidget;

  /// Show CircularProgressIndicator over the entire app and lock taps on screen, while status == pending
  final bool showDefaultProgressInOverlay;

  /// Overlay [onPending] circular progress indicator color (if showDefaultProgressInOverlay is enabled)
  final Color? progressOverlayColor;

  /// Overlay [onPending] Background color (if showDefaultProgressInOverlay is enabled)
  final Color? progressOverlayBgColor;

  /// Required to inform [showDefaultProgressInOverlay = true] in order to show that widget on [onPending] event
  /// This widget will be shown over the entire screen
  final Widget? overlayWidget;

  /// Required to inform [fetchData] in order to show that button on error events
  final String? reloadButtonText;

  ObserverFuture({
    Key? key,
    required this.observableFuture,
    required this.onData,
    this.onNull,
    this.fetchData,
    this.onPending,
    this.onError,
    this.onUnstarted,
    this.showDefaultProgressInOverlay = false,
    this.showDefaultProgressInWidget = false,
    this.progressOverlayColor,
    this.reloadButtonText,
    this.progressOverlayBgColor,
    this.overlayWidget,
    this.transition,
    this.retry = 0,
    this.autoInitialize = true,
    this.listen,
  })  : assert(showDefaultProgressInOverlay == false || showDefaultProgressInWidget == false,
            ' ==>> Warning: Cannot provide both a showDefaultProgressInOverlay and a showDefaultProgressInWidget'),
        assert(!(retry > 0 && fetchData == null), 'In order to use [retry] you must inform the [fetchData] callback'),
        super(key: key);

  @override
  _ObserverFutureState<D, E> createState() => _ObserverFutureState<D, E>();
}

class _ObserverFutureState<D, E> extends State<ObserverFuture<D, E>> {
  OverlayEntry? _overlayEntry;
  int tries = 0;
  ObservableFuture<dynamic>? _observableFuture;

  @override
  void initState() {
    super.initState();

    if (_observableFuture == null) {
      _observableFuture = widget.observableFuture?.call();
    }

    tries = widget.retry;

    if ((widget.autoInitialize && widget.fetchData != null && _observableFuture == null) ||
        (widget.autoInitialize &&
            widget.fetchData != null &&
            _observableFuture != null &&
            _observableFuture!.status != FutureStatus.pending &&
            _observableFuture!.value == null)) {
      fetchDataCallback();
    }
  }

  void fetchDataCallback() => Future.delayed(Duration.zero, () => widget.fetchData?.call());

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (widget.transition != null)
        return AnimatedTransition(
          transition: widget.transition!,
          child: _getChildWidget(context),
        );

      return _getChildWidget(context);
    });
  }

  Widget _getChildWidget(BuildContext context) {
    _observableFuture = widget.observableFuture?.call();

    if (_observableFuture != null && _observableFuture!.status != FutureStatus.pending) hideOverlay();

    widget.listen?.call(_observableFuture);

    switch (_observableFuture?.status) {
      case FutureStatus.pending:
        return showPendingWidget(context);
      case FutureStatus.rejected:
        if (tries > 0 && widget.fetchData != null) {
          tries--;
          fetchDataCallback();
          return showPendingWidget(context);
        }

        if (widget.onError != null) return widget.onError!(context, _observableFuture?.error);
        if (widget.fetchData != null && widget.reloadButtonText != null)
          return ReloaderButtonWidget(
            callback: widget.fetchData,
            buttonText: widget.reloadButtonText,
          );
        return const SizedBox.shrink();
      case FutureStatus.fulfilled:
        if (widget.onNull != null) {
          if (_observableFuture?.value == null) return widget.onNull!(context);
        }
        return widget.onData(context, _observableFuture?.value);
      default:
        if (widget.onUnstarted != null) return widget.onUnstarted!(context);
        return const SizedBox.shrink();
    }
  }

  /// handle pending widget
  Widget showPendingWidget(BuildContext context) {
    if (widget.showDefaultProgressInOverlay) showOverlay();
    if (widget.onPending != null) return widget.onPending!(context);
    return (widget.showDefaultProgressInWidget)
        ? LoaderWidget(
            color: widget.progressOverlayColor,
            backgroundColor: Colors.transparent,
          )
        : const SizedBox.shrink();
  }

  void hideOverlay() {
    this._overlayEntry?.remove();
    this._overlayEntry = null;
  }

  void showOverlay() {
    if (widget.showDefaultProgressInOverlay) {
      if (this._overlayEntry != null) return;

      Future.delayed(Duration.zero, () {
        this._overlayEntry = createOverlayEntry();
        Overlay.of(context)?.insert(this._overlayEntry!);
      });
    }
  }

  OverlayEntry createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => widget.overlayWidget != null
            ? Material(
                child: widget.overlayWidget,
                color: Colors.transparent,
              )
            : LoaderWidget(
                color: widget.progressOverlayColor,
                backgroundColor: widget.progressOverlayBgColor,
              ));
  }
}
