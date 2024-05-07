import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:proj_mobile_flutter/band_details_page.dart'; 

//in this page i used a timer to stop the app from checking after every key stroke which will result in unnecessary load on the performance
//so the timer here checks the text after a certain period of time which boosts performance as well as presenting a nice experience for the user
//because they dont have to wait to press enter to get the results, they can see the results as they type, making the app flow nicer

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController(); // Text controller for search_term
  String _searchTerm = ""; 
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];
  Timer? _searchTimer;

  @override
  void dispose() {
    _searchTimer?.cancel(); // Cancel timer on widget disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Bands",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
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
            children: [
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), 
                  ),
                  hintText: 'Search for Bands!',
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                ),
                onChanged: (text) {
                  setState(() {
                    _searchTerm = text; //get the text anf make it the search term
                  });
                  _searchTimer?.cancel(); // Cancel any previous timer
                  _searchTimer = Timer(const Duration(milliseconds: 500), () {
                    get_bands(_searchTerm);
                  });
                },
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: _searchResults.isEmpty
                    ? const Center(child: Text("No results found", style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          final bandData = _searchResults[index].data();
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              elevation: 4,
                              shadowColor: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                tileColor: const Color(0xFF8B0000),
                                title: Row(
                                  children: [
                                    Text(
                                      bandData["name"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  final bandData = _searchResults[index].data();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BandDetailsPage(bandData: bandData),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        itemCount: _searchResults.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void get_bands(String inp) async {
    if (inp.isEmpty) {
      setState(() {
        _searchResults = []; // Clear search results when input is empty
      });
      return;
    }

    final bandsCollection = FirebaseFirestore.instance.collection('bands');
    final snapshot = await bandsCollection.get();
    setState(() {
      _searchResults = snapshot.docs.where((doc) => doc['name'].toLowerCase().startsWith(inp.toLowerCase())).toList();
    });
  }


}
