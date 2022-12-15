import 'package:design_generator/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStream extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Widget onLoading;
  final Widget onError;
  final Function(Map item, int index) onItemBuild;
  final Function(QuerySnapshot snapshot) onSnapshot;

  FireStream({
    this.stream,
    this.onLoading,
    this.onError,
    this.onItemBuild,
    this.onSnapshot,
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

        QuerySnapshot querySnapshot = stream.data;
        if (onSnapshot != null) {
          return onSnapshot(querySnapshot);
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: querySnapshot.docs.length,
          itemBuilder: (context, index) {
            var item = querySnapshot.docs[index].data();
            var docId = querySnapshot.docs[index].id;
            item["id"] = docId;

            if (onItemBuild != null) {
              return onItemBuild(item, index);
            }

            return Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ExNetworkImage(
                    src: item['photo'] ??
                        "https://upload.wikimedia.org/wikipedia/commons/0/0a/No-image-available.png",
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("John Doe",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text(
                            "description...",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
