import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoaderWidget {
  Widget? _widget;

  LoaderOverlayEntry? overlayEntry;
  Widget? get w => _widget;

  factory LoaderWidget() => _instance;
  static final LoaderWidget _instance = LoaderWidget._internal();

  LoaderWidget._internal();

  static LoaderWidget get instance => _instance;

  static bool get onScreen => _instance.w != null;

  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, LoaderOverlay(child: child));
      } else {
        return LoaderOverlay(child: child);
      }
    };
  }

  ///Duration in milliseconds
  static showLoader() {
    Widget w = Material(
        elevation: 0.0,
        color: Colors.black38,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            color: Colors.black26,
            child: CircularProgressIndicator(),
          ),
        ));

    SchedulerBinding.instance
        ?.addPostFrameCallback((_) => _instance._show(widget: w));

    _instance._show(widget: w);
  }

  static Future<void> hideLoader() {
    return _instance._dismiss();
  }

  _show({Widget? widget}) async {
    _widget = widget;

    _markNeedsBuild();
  }

  Future<void> _dismiss() async {
    _widget = null;
    _markNeedsBuild();
  }

  void _markNeedsBuild() {
    overlayEntry?.markNeedsBuild();
  }

  static TransitionBuilder transitionBuilder({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(
          context,
          MediaQuery(
            child: LoaderOverlay(child: child),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          ),
        );
      } else {
        // return LoaderOverlay(child: child);
        return MediaQuery(
          child: LoaderOverlay(child: child),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      }
    };
  }
}

class LoaderOverlayEntry extends OverlayEntry {
  final WidgetBuilder builder;

  LoaderOverlayEntry({
    required this.builder,
  }) : super(builder: builder);

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance?.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {});
      super.markNeedsBuild();
    } else {
      super.markNeedsBuild();
    }
  }
}

class LoaderOverlay extends StatefulWidget {
  final Widget? child;

  const LoaderOverlay({
    Key? key,
    required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  _LoaderOverlayState createState() => _LoaderOverlayState();
}

class _LoaderOverlayState extends State<LoaderOverlay> {
  late LoaderOverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = LoaderOverlayEntry(
      builder: (BuildContext context) => LoaderWidget.instance.w ?? Container(),
    );
    LoaderWidget.instance.overlayEntry = _overlayEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          LoaderOverlayEntry(
            builder: (BuildContext context) {
              if (widget.child != null) {
                return widget.child!;
              } else {
                return Container();
              }
            },
          ),
          _overlayEntry,
        ],
      ),
    );
  }
}
