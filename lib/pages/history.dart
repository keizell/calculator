import 'package:calculator_ranni/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class HistoryPage extends StatelessWidget {
  final List<String> history;

  const HistoryPage({required this.history, super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    
    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    appBar: AppBar(
      iconTheme: const IconThemeData(
      color: Colors.white, // White color for the back button
    ),
      title: Text("History",style: GoogleFonts.poppins(
          color: Colors.white, // White color for the title
          fontSize: 24, // Adjust size as needed
          fontWeight: FontWeight.w600, // Semi-bold
        ),
      ),
      backgroundColor: Colors.black,
    ),
     // FloatingActionButton
    body: 
    
    StreamBuilder<QuerySnapshot>(
      stream: Firestore.getResultStream(),
      builder: (context, snapshot) {
        // if we have data, get all the docs
        if (snapshot.hasData) {
          List result = snapshot.data!.docs;

          return ListView.builder(
            itemBuilder: (context, index) {
              // get each individual doc
              DocumentSnapshot document = result[index];

              // get note from each doc
              Map<String, dynamic> data = 
                document.data() as Map<String, dynamic>;
              String resulttext = data['result'];
              Timestamp resulttime = data['time'];
              DateTime dateTime = resulttime.toDate();
              String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

              // Display each note
              return Padding(
                
  padding: EdgeInsets.all(10.0), // Exterior space around the container
  child: Container(
    padding: EdgeInsets.all(30), // Inner padding inside the container
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 196, 169, 18),
      border: Border.all(color: const Color.fromARGB(255, 18, 16, 20)), // Border color
      borderRadius: BorderRadius.circular(8.0), // Rounded corners
    ),
    
    child: ListTile(
      
      title: Text(
        resulttext,
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ), // Bigger text for title
      ),
      subtitle: Text(
        formattedDate,
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: 18, // Bigger text for subtitle
        ),
      ),
    ),
  ),
);

            },
            itemCount: result.length,
          );
        }
        else {
          return const Text('NO DATA');
        }
      },
    ), // StreamBuilder
  );
}

}
