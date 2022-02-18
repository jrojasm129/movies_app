

import 'package:flutter/cupertino.dart';
import 'package:movies_info/api/movies_api.dart';
import 'package:movies_info/models/movie_model.dart';
import 'package:movies_info/models/movie_response.dart';

class MoviesProvider extends ChangeNotifier{

  List<Movie> popularMovies = [];
  int popularCurrentPage = 0;
  bool isLoadingPopulars= false;

  List<Movie> nowPlaying = [];
  int nowPlayingCurrentPage = 0;
  bool isLoadingNowPlaying= false;

  List<Movie> topRatedMovies = [];
  int topRatedCurrentPage = 0;
  bool isLoadingTopRated= false;

  List<Movie> upComingMovies = [];
  int upComingCurrentPage = 0;
  bool isLoadingUpComing= false;

  Future<void> getPopulars() async {
    isLoadingPopulars = true;
    notifyListeners();

    final json = await MoviesApi.httpGet(path: '/movie/popular', page: popularCurrentPage + 1);
    final MovieResponse movieResponse = MovieResponse.fromMap(json);
    popularMovies.addAll(movieResponse.results);

    popularCurrentPage += 1;

    isLoadingPopulars = false;
    notifyListeners();
  }
  
  Future<void> getNowPlaying() async {
    isLoadingNowPlaying = true;
    notifyListeners();

    final json = await MoviesApi.httpGet(path: '/movie/now_playing', page: nowPlayingCurrentPage + 1);
    final MovieResponse movieResponse = MovieResponse.fromMap(json);
    nowPlaying.addAll(movieResponse.results);

    nowPlayingCurrentPage += 1;

    isLoadingNowPlaying = false;
    notifyListeners();
  }

  Future<void> getTopRated() async {
    isLoadingTopRated = true;
    notifyListeners();

    final json = await MoviesApi.httpGet(path: '/movie/top_rated', page: topRatedCurrentPage + 1);
    final MovieResponse movieResponse = MovieResponse.fromMap(json);
    topRatedMovies.addAll(movieResponse.results);

    topRatedCurrentPage += 1;

    isLoadingTopRated = false;
    notifyListeners();
  }

  Future<void> getUpComing() async {
    isLoadingUpComing = true;
    notifyListeners();

    final json = await MoviesApi.httpGet(path: '/movie/upcoming', page: upComingCurrentPage + 1);
    final MovieResponse movieResponse = MovieResponse.fromMap(json);
    upComingMovies.addAll(movieResponse.results);

    upComingCurrentPage += 1;

    isLoadingUpComing = false;
    notifyListeners();
  }

  Future<List<Movie>> getMovieByQuery(String query) async {

    query = query.trim().isEmpty ? '*': query;

    final json = await MoviesApi.httpGet(path: '/search/movie', query: query.trim(), page: 1);

    final MovieResponse movieResponse = MovieResponse.fromMap(json);

    movieResponse.results;

    return movieResponse.results;
  }

  Future<void> initMovies() async {
    await Future.wait([
      getPopulars(),
      getNowPlaying(),
      getTopRated(),
      getUpComing()
    ]);
  }






}