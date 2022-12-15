import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStreamDocument extends StatelessWidget {
  final Stream<DocumentSnapshot> stream;
  final Widget onLoading;
  final Widget onError;
  final Function(DocumentSnapshot snapshot) onSnapshot;

  FireStreamDocument({
    @required this.stream,
    @required this.onSnapshot,
    this.onLoading,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          if (onLoading == null)
            return const Center(child: CircularProgressIndicator());
        }

        if (stream.hasError) {
          if (onError == null)
            return Center(child: Text(stream.error.toString()));
        }

        DocumentSnapshot querySnapshot = stream.data;
        return onSnapshot(querySnapshot);
      },
    );
  }
}
