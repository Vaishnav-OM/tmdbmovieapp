import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'theme/appColors.dart';
import 'theme/ktext.dart';

class MovieDetailsPage extends StatefulWidget {
  final eventId;

  const MovieDetailsPage(
    id, {
    required this.eventId,
  });

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class Details {
  var title;
  var image;
  var description;
  var releasedate;

  // ignore: duplicate_ignore
  Details({
    required this.title,
    required this.image,
    required this.description,
    required this.releasedate,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      title: json['title'],
      image: json['poster_path'],
      description: json['overview'],
      releasedate: json['release_date'],
    );
  }
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  // String? _title;
  // String? _image;
  // String? _description;
  // String? _releasedate;
  late Future<Details> futureAlbum;

  Future<Details> fetchmoviedetails(BuildContext context) async {
    const _baseUrl = 'http://192.168.137.1:3000';
    var response = await http
        .get(Uri.parse("$_baseUrl/home/details/ ${widget.eventId} /"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return Details.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Session Timed Out Error');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load page');
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchmoviedetails(context);
    ;
  }
  // late Map<String, dynamic> _movie;

  @override
  Widget build(BuildContext context) {
    // var _movies;

    // var movies = _movies;

    // var title = _movies[11];

    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: FutureBuilder<Details>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Get.defaultDialog(
                          title: snapshot.data!.title,
                          content: Image.network(
                            "https://image.tmdb.org/t/p/w500${snapshot.data!.image}",
                            fit: BoxFit.cover,
                            height: 500,
                            width: Get.width,
                          ),
                        ),
                        child: Container(
                          height: 200,
                          width: Get.width,
                          color: primaryColor2,
                          child: Image.network(
                            "https://image.tmdb.org/t/p/w500${snapshot.data!.image}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        left: 10,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: white,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 10,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite,
                            color: white,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: KText(
                          text: 'OverView',
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: snapshot.data!.title,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            KText(
                              text: "(" + snapshot.data!.releasedate + ")",
                              fontSize: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          itemSize: 20,
                          // updateOnDrag: true,
                          tapOnlyMode: true,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 5),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor2,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: KText(
                                  text: 'Story Line',
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            KText(
                              text: snapshot.data!.description,
                              fontSize: 14,
                              maxLines: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              throw Exception('Failed to load Profile Page');
            }
          }),
    )));
  }
}
