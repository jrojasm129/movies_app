

import 'package:flutter/cupertino.dart';

import '../api/movies_api.dart';
import '../models/movie_details_model.dart';
import '../models/movie_model.dart';
import '../models/movie_response.dart';

class MoviesDetailsProvider extends ChangeNotifier{

  MoviesDetailsProvider(String movieId){
    initMovieDetails(movieId);
  }

  List<Movie> similarMovies = [];
  int similarMoviesCurrentPage = 0;
  bool isLoadingSimilarMovies= false;

  MovieDetailsModel? movieDetails;

  Future<void> getSimilarMovies({required String movieId}) async {
    isLoadingSimilarMovies = true;
    notifyListeners();

    final json = await MoviesApi.httpGet(path: '/movie/$movieId/similar', page: similarMoviesCurrentPage + 1);
    final MovieResponse movieResponse = MovieResponse.fromMap(json);
    similarMovies.addAll(movieResponse.results);

    similarMoviesCurrentPage += 1;

    isLoadingSimilarMovies = false;
    notifyListeners();
  }

   Future<void> getMovieDetails({required String movieId}) async {

    final json = await MoviesApi.httpGet(path: '/movie/$movieId', appendToResponse: 'videos,credits');
    final MovieDetailsModel details = MovieDetailsModel.fromMap(json);

    movieDetails = details;
    notifyListeners();
  }

    Future<void> initMovieDetails(String movieId) async {
    await Future.wait([
      getMovieDetails(movieId: movieId),
      getSimilarMovies(movieId: movieId)
    ]);
  }

  void clearMovieDetails() {
    similarMovies.clear();
    movieDetails = null;
  }


}