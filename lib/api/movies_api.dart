import 'package:dio/dio.dart';

const _apiKey = '1635c4a1018c84d86e6d0ec8ae680760';

class MoviesApi {

  static final Dio _dio = Dio();

  static void configureDio(){

    _dio.options.baseUrl = 'https://api.themoviedb.org/3';
    _dio.options.queryParameters = {
      "api_key":_apiKey,
      "language":"es-Es",
    };
    
  }

  static Future<dynamic> httpGet({required String path, int? page, String? query, String? appendToResponse}) async{

    Map<String, dynamic> queryParameters = {};

    if(page  != null) queryParameters['page'] = page;
    if(query != null) queryParameters['query'] = query;
    if(appendToResponse != null) queryParameters['append_to_response'] = appendToResponse;

    try {
      
     final resp = await _dio.get(path, queryParameters: queryParameters );
     
     return resp.data;

    } catch (e) {
      throw('error: $e');
    }

  }


}