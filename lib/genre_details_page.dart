import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//this page handles the display of the details of the genre we picked using the data stored in firestore

class GenreDetailsPage extends StatefulWidget {
  final String genreName;

  const GenreDetailsPage({super.key, required this.genreName}); //we need to get the genre picked so the previous page passes the genre name to this page

  @override
  State<GenreDetailsPage> createState() => _GenreDetailsPageState();
}

class _GenreDetailsPageState extends State<GenreDetailsPage> {
  Map<String, dynamic>? genreData;

  @override
  void initState() {
    super.initState();
    _fetchGenreDetails();
  }

  Future<void> _fetchGenreDetails() async { //check which instance in the firestore contains our genre's data and get this data
    final genreDoc = await FirebaseFirestore.instance
        .collection('genres')
        .where('genre_name', isEqualTo: widget.genreName)
        .get();

    if (genreDoc.docs.isNotEmpty) {
      setState(() {
        genreData = genreDoc.docs.first.data();
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    if (genreData != null) {
      final List<String> recBands = genreData!['rec_bands'].cast<String>(); //in the firestore i have the recommended bands stored in a list of strings, so we cast them.
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Genre: ${genreData!['genre_name']}",
            style: const TextStyle( 
              color: Colors.black, 
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF8B0000), 
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient( // Create a background gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF212121), 
                Color(0xFF1a1a1a), 
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Description:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
                Text(
                  genreData!['genre_description'] ?? 'No description provided', //if there is no description (cant hppen, mainly for testing), display no desc provided
                  style: const TextStyle(fontSize: 16.0, color: Colors.white70),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Recommended Bands:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    //fontFamily: 'Metal Mania' //i wanted to add a font to my app but then i didnt because it looked more professional this way.
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children: recBands.map((band) => Chip(  //map the recommended bands
                    label: Text(band),
                    backgroundColor: const Color(0xFF8B0000),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());  //display circular loading thing for the user not to feel like the app has crashed while waiting
    }
  }
}
