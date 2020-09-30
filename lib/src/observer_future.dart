import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_widget/src/components/loader_widget.dart';
import 'package:mobx_widget/src/components/reloader_button_widget.dart';
import 'package:mobx_widget/src/utils/braz_animated_transition.dart';

class ObserverFuture<D, E> extends StatefulWidget {
  /// If [fetchData] is filled, it will be called just once on initState.
  final VoidCallback fetchData;

  final ObservableFuture Function() observableFuture;
  final Widget Function(BuildContext context, E error) onError;
  final Widget Function(BuildContext context) onPending;
  final Widget Function(BuildContext context) onUnstarted;
  final Widget Function(BuildContext context) onNull;
  final BrazTransition transition;
  final int retry;
  final bool autoInitialize;

  /// the [data] property has the value of ObservableFuture, and it may be null eventually.
  /// You can handle null value on [onData] callback or just enter a [onNull] callback to handle null values separately.
  /// Note, if you set a [onNull] callback, the [onData] will not be triggered if value == null.
  final Widget Function(BuildContext context, D data) onData;

  /// Show CircularProgressIndicator while status == pending
  final bool showDefaultProgressInWidget;

  /// Show CircularProgressIndicator over the entire app and lock taps on screen, while status == pending
  final bool showDefaultProgressInOverlay;

  /// Overlay [onPending] circular progress indicator color (if showDefaultProgressInOverlay is enabled)
  final Color progressOverlayColor;

  /// Overlay [onPending] Background color (if showDefaultProgressInOverlay is enabled)
  final Color progressOverlayBgColor;

  /// Required to inform [showDefaultProgressInOverlay = true] in order to show that widget on [onPending] event
  /// This widget will be shown over the entire screen
  final Widget overlayWidget;

  /// Required to inform [fetchData] in order to show that button on error events
  final String reloadButtonText;

  ObserverFuture(
      {Key key,
      @required this.observableFuture,
      @required this.onData,
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
      this.retry,
      this.autoInitialize = true})
      : assert(onData != null),
        assert(observableFuture != null),
        assert(
            showDefaultProgressInOverlay == false ||
                showDefaultProgressInWidget == false,
            ' ==>> Warning: Cannot provide both a showDefaultProgressInOverlay and a showDefaultProgressInWidget'),
        assert(!(retry != null && fetchData == null),
            'In order to use [retry] you must inform the [fetchData] callback'),
        super(key: key);

  @override
  _ObserverFutureState<D, E> createState() => _ObserverFutureState<D, E>();
}

class _ObserverFutureState<D, E> extends State<ObserverFuture<D, E>> {
  OverlayEntry _overlayEntry;
  int tries;

  @override
  void initState() {
    super.initState();

    tries = widget.retry;

    if (widget.autoInitialize == true &&
        widget?.fetchData != null &&
        widget?.observableFuture()?.status != FutureStatus.pending &&
        widget?.observableFuture()?.value == null) fetchDataCallback();
  }

  void fetchDataCallback() =>
      Future.delayed(Duration.zero, () => widget.fetchData?.call());

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (widget.transition != null)
        return BrazAnimatedTransition(
          transition: widget.transition,
          child: _getChildWidget(context),
        );

      return _getChildWidget(context);
    });
  }

  Widget _getChildWidget(BuildContext context) {
    ObservableFuture observable = widget?.observableFuture();

    if (observable?.status != FutureStatus.pending) hideOverlay();

    switch (observable?.status) {
      case FutureStatus.pending:
        return showPendingWidget(context);
      case FutureStatus.rejected:
        if (widget.retry != null && widget.fetchData != null) {
          if (tries > 0) {
            tries--;
            fetchDataCallback();
            return showPendingWidget(context);
          }
        }

        if (widget.onError != null)
          return widget.onError(context, observable.error);
        if (widget.fetchData != null && widget.reloadButtonText != null)
          return ReloaderButtonWidget(
            callback: widget.fetchData,
            buttonText: widget.reloadButtonText,
          );
        return const SizedBox.shrink();
      case FutureStatus.fulfilled:
        if (widget.onNull != null) {
          if (observable.value == null) return widget.onNull(context);
        }
        return widget.onData(context, observable.value);
      default:
        if (widget.onUnstarted != null) return widget.onUnstarted(context);
        return const SizedBox.shrink();
    }
  }

  Widget showPendingWidget(BuildContext context) {
    if (widget.showDefaultProgressInOverlay) showOverlay();
    if (widget.onPending != null) return widget.onPending(context);
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
        Overlay.of(context).insert(this._overlayEntry);
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
