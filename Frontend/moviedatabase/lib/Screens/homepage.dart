import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'moviedetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _baseUrl = 'http://192.168.137.1:3000';
  // List _genre = [];

  // Future<void> fetchgenre() async {
  //   var response = await http.get(Uri.parse("$_baseUrl/home/genre"));
  //   var data = json.decode(response.body);
  //   setState(() {
  //     _genre = data["genres"];
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchgenre();
  // }

  List _movies = [];

  Future<void> fetchTopRatedMovies() async {
    var response = await http.get(Uri.parse("$_baseUrl/home/popular"));
    var data = json.decode(response.body);
    print(data);
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
    final primaryColor = Color.fromRGBO(28, 28, 28, 100);
    final primaryColor2 = Colors.grey[900];
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Movies',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              IconButton(
                onPressed: () => null,
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
        //   bottom: PreferredSize(
        //     preferredSize: Size.fromHeight(75),
        //     child: Container(
        //       height: 60,
        //       child: ListView.builder(
        //         physics: BouncingScrollPhysics(),
        //         scrollDirection: Axis.horizontal,
        //         shrinkWrap: true,
        //         primary: false,
        //         itemCount: _genre.length,
        //         itemBuilder: (context, int index) {
        //           var genre = _genre[index];

        //           return Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        //             child: Container(
        //               alignment: Alignment.center,
        //               // width: 140,
        //               decoration: BoxDecoration(
        //                 color: Colors.green,
        //                 borderRadius: BorderRadius.circular(15),
        //               ),
        //               child: Padding(
        //                 padding: EdgeInsets.all(8.0),
        //                 child: Text('${genre["name"]}'),
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     ),
        //   ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: .66),
          itemCount: _movies.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          primary: false,
          itemBuilder: (context, index) {
            var movies = _movies[index];
            final id = movies["id"];
            print(id);
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieDetailsPage(
                            id,
                            eventId: id,
                          ))),
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500/${movies["poster_path"]}",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${movies['title']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${movies['release_date']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 2),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            itemSize: 15,
                            // updateOnDrag: true,
                            tapOnlyMode: true,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          SizedBox(height: 2),
                          Text(
                            '${movies['overview']}',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white.withOpacity(.70),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
