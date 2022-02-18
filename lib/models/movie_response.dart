import 'dart:convert';

import 'package:movies_info/models/movie_model.dart';


class MovieResponse {
    MovieResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory MovieResponse.fromJson(String str) => MovieResponse.fromMap(json.decode(str));

    factory MovieResponse.fromMap(Map<String, dynamic> json) => MovieResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}




