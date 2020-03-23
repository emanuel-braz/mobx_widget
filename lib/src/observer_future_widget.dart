import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_widget/src/components/loader_widget.dart';
import 'package:mobx_widget/src/components/reloader_button_widget.dart';

class ObserverFutureWidget extends StatefulWidget {
  final VoidCallback fetchData;
  final ObservableFuture Function() observableFuture;
  final Widget Function(BuildContext context, dynamic error) onError;
  final Widget Function(BuildContext context) onPending;
  final Widget Function(BuildContext context) onUnstarted;
  final Widget Function(BuildContext context) onResultNull;
  final Widget Function(BuildContext context, dynamic data) onResult;

  final bool progressOverlayEnabled;
  final Color progressOverlayColor;
  final Color progressOverlayBgColor;
  final String reloadButtonText;

  ObserverFutureWidget(
      {Key key,
      @required this.observableFuture,
      @required this.onResult,
      this.onResultNull,
      this.fetchData,
      this.onPending,
      this.onError,
      this.onUnstarted,
      this.progressOverlayEnabled = false,
      this.progressOverlayColor,
      this.reloadButtonText,
      this.progressOverlayBgColor})
      : assert(onResult != null),
        assert(observableFuture != null),
        super(key: key);

  @override
  _ObserverFutureWidgetState createState() => _ObserverFutureWidgetState();
}

class _ObserverFutureWidgetState extends State<ObserverFutureWidget> {
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget?.fetchData != null &&
        widget?.observableFuture()?.status != FutureStatus.pending &&
        widget?.observableFuture()?.value == null) widget.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      ObservableFuture observable = widget?.observableFuture();

      if (observable?.status != FutureStatus.pending) hideOverlay();

      switch (observable?.status) {
        case FutureStatus.pending:
          if (widget.progressOverlayEnabled) showOverlay();
          if (widget.onPending != null) return widget.onPending(context);
          return (widget.progressOverlayEnabled) ? Container() : LoaderWidget();
        case FutureStatus.rejected:
          if (widget.onError != null)
            return widget.onError(context, observable?.error);
          if (widget.fetchData != null && widget.reloadButtonText != null) 
            return ReloaderButtonWidget(
              callback: widget.fetchData,
              buttonText: widget.reloadButtonText,
            );
          return Container();
        case FutureStatus.fulfilled:
          if (widget.onResultNull != null) {
            if (observable?.value == null) return widget.onResultNull(context);
          }
          return widget.onResult(context, observable?.value);
        default:
          if (widget.onUnstarted != null) return widget.onUnstarted(context);
          return Container();
      }
    });
  }

  void hideOverlay() {
    this._overlayEntry?.remove();
    this._overlayEntry = null;
  }

  void showOverlay() {
    if (widget.progressOverlayEnabled) {
      Future.delayed(Duration(milliseconds: 1), () {
        this._overlayEntry = createOverlayEntry(
            color: widget.progressOverlayColor,
            backgroundColor: widget.progressOverlayBgColor);
        Overlay.of(context).insert(this._overlayEntry);
      });
    }
  }

  OverlayEntry createOverlayEntry({Color color, Color backgroundColor}) {
    return OverlayEntry(
        builder: (context) => LoaderWidget(
              color: color ?? Theme.of(context).primaryColor,
              backgroundColor: backgroundColor ?? Colors.black12,
            ));
  }
}
