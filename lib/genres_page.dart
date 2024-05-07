import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'genre_details_page.dart'; 

class GenresPage extends StatefulWidget {
  const GenresPage({super.key});

  @override
  State<GenresPage> createState() => GenresPageState();
}

class GenresPageState extends State<GenresPage> {
  final _genreStream = FirebaseFirestore.instance.collection('/genres').snapshots();  //go to the genres collection and get the instances

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Explore Metal Genres",
          style: TextStyle( 
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
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _genreStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());  //so that the user doesnt think the app has crashed while waiting, display loading circle
              }

              // if no bands were found (testing)
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("No genres found"));
              }

              final genres = snapshot.data!.docs.map((doc) => doc.data()['genre_name'] as String).toList(); //get the genre name field and displa it in a list

              return ListView.builder(
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  return GenreListItem(genre: genre, onTap: () => navigateToGenreDetails(genre)); //go to the genre details oage upon pressing and pass te genre name so the app knows what genre to display details for
                },
                itemCount: genres.length,
              );
            },
          ),
        ),
      ),
    );
  }

  void navigateToGenreDetails(String genreName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenreDetailsPage(genreName: genreName),
      ),
    );
  }
}

class GenreListItem extends StatelessWidget { //to make the list of the genres look nice and fit the app theme
  final String genre;
  final VoidCallback onTap;

  const GenreListItem({super.key, required this.genre, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF8B0000).withOpacity(0.7), 
      child: ListTile(
        title: Text(
          genre,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
