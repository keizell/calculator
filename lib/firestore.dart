import 'package:cloud_firestore/cloud_firestore.dart';


class Firestore { 
  
  static CollectionReference resultsCollection = FirebaseFirestore.instance.collection('results');
  static Future<void> addResult(String result) {
  // Reference to the Firestore collection
 

  // Add a new document to the collection
  return resultsCollection.add({
    'result': result,
    'time': Timestamp.now(),
  });

  //READ ALL RESULTS

  //DELETE OLD RESULTS

  }

static Stream <QuerySnapshot> getResultStream(){
  final resultStream = resultsCollection.orderBy('time', descending: true).snapshots();
  return resultStream;
}

}
