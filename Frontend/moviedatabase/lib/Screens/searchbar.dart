import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TMDBApi {
  static const _baseUrl = 'http://192.168.1.6:3000';
  // static const _apiKey = 'ab8c30463ed06a2663385616321f1f35';

  static Future<List<dynamic>> searchMovies(String query) async {
    final url = '$_baseUrl/home/title/:$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

class searchbar extends StatefulWidget {
  const searchbar({Key? key}) : super(key: key);

  @override
  _searchbarState createState() => _searchbarState();
}

class _searchbarState extends State<searchbar> {
  final _controller = TextEditingController();
  List<dynamic> _searchResults = [];

  void _onSearch() async {
    final query = _controller.text;
    final results = await TMDBApi.searchMovies(query);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(
            fontSize: 20,
            color: Colors.black87,
          ),
          controller: _controller,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
            hintText: '  Search movies...',
          ),
          onSubmitted: (_) => _onSearch(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearch,
          ),
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final result = _searchResults[index];
          return ListTile(
            contentPadding: EdgeInsets.all(10),

            // leading: Image.network(
            //   'https://image.tmdb.org/t/p/w92${result['poster_path']}',
            // ),
            title: Text(
              result['title'],
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(result['overview'], style: TextStyle(fontSize: 14)),
          );
        },
      ),
    );
  }
}
