import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './searchbar.dart';

class TopRatedMoviesWidget extends StatefulWidget {
  @override
  _TopRatedMoviesWidgetState createState() => _TopRatedMoviesWidgetState();
}

class _TopRatedMoviesWidgetState extends State<TopRatedMoviesWidget> {
  static const _baseUrl = 'http://192.168.1.6:3000';
  List _movies = [];

  Future<void> fetchTopRatedMovies() async {
    var response = await http.get(Uri.parse("$_baseUrl/home/popular"));
    var data = json.decode(response.body);
    setState(() {
      _movies = data["results"];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _movies.length,
        itemBuilder: (BuildContext context, int index) {
          var movie = _movies[index];
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${movie["poster_path"]}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  movie["title"],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  '(' + "${movie["vote_average"]}" + ')',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
