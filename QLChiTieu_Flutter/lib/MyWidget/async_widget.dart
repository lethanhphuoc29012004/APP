import 'package:flutter/material.dart';

class AsyncWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final Widget Function()? loading;

  final Widget Function()? error;
  final Widget Function(BuildContext context, AsyncSnapshot snapshot) builder;

  const AsyncWidget(
      {super.key,
        required this.snapshot,
        this.loading,
        this.error,
        required this.builder});

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return error == null
          ? const Center(
        child: Text("Loi roi !!!"),
      )
          : error!();
    }

    if (!snapshot.hasData) {
      return loading == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : loading!();
    }

    return builder(context, snapshot);
  }
}