import 'package:flutter/material.dart';
import 'package:proj_mobile_flutter/auth.dart';
import 'package:proj_mobile_flutter/genres_page.dart';
import 'package:proj_mobile_flutter/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Auth(); 

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/resizedElectricGuitar.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(), // Navigate to SearchPage
                      ),
                    );   
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Search Bands',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GenresPage(), // Navigate to GenresPage
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.library_music_outlined,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Explore Genres',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                  ),
                ),
              ],
            ),
          ),
          //sign-out button bottom left to look good
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: ElevatedButton(
              onPressed: () async {
                await auth.signOut(); // Call the signOut method from the auth class
                Navigator.of(context).pushReplacementNamed('/login'); // Navigate to the login page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white, 
              ),
              child: const Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }
}
