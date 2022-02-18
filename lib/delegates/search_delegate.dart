

import 'package:flutter/material.dart';
import 'package:movies_info/models/movie_model.dart';
import 'package:movies_info/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate<dynamic>{

  CustomSearchDelegate():super(
    searchFieldLabel: 'Busca una película...',    
  );

  List<Movie> results = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      
      textTheme: const TextTheme().copyWith(
            headline6: const TextStyle(color:Colors.white, fontSize: 15)
      ),
      inputDecorationTheme: const InputDecorationTheme().copyWith(
        border:  InputBorder.none,
        focusedBorder:InputBorder.none,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15),
      ),

      textSelectionTheme: const TextSelectionThemeData().copyWith(cursorColor: Colors.white),
      scaffoldBackgroundColor: Colors.black
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      query.isNotEmpty 
       ? IconButton(onPressed: ()=> query = '', icon: const Icon(Icons.clear, color: Colors.white))
       : const SizedBox.shrink()
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(
      color: Colors.white,
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SugestionsViewer(
      results: results,
      onClose: close,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     return FutureBuilder(
     future: Provider.of<MoviesProvider>(context).getMovieByQuery(query),
     builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
      
       if(!snapshot.hasData) return const SizedBox.shrink();
       results = snapshot.data!;  
     
       return _SugestionsViewer(
         results: results,
         onClose: close,
       );
     
     }
      );
  }
}

class _SugestionsViewer extends StatelessWidget {

  final Function(BuildContext context, dynamic result) onClose;
  final List<Movie> results;
 
  const _SugestionsViewer({
    Key? key,
    required this.results,
    required this.onClose
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: results.length + 1,
      itemBuilder: ( context, index) {

        if(index == 0) return const SizedBox(height: 15) ;

        final movie = results[index - 1];
        
        return _SuggestionItem(
         movie: movie,
         onMovieSelected: (){
          onClose(context, movie);
         },
       );
      }
    );

  }
}

class _SuggestionItem extends StatelessWidget {
  final Movie movie;
  final Function()? onMovieSelected;
  
  const _SuggestionItem({
    Key? key,
    required this.movie,
    this.onMovieSelected
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onMovieSelected,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: screenSize.width,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 0.5
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
              child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(movie.fullPosterPath),
                          fit: BoxFit.cover),
                  )),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      movie.title, 
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 5),
                    Text( 
                      movie.overview, 
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w300
                      ),
                      maxLines: 4, 
                      overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 5),
                    Text(movie.releaseDate?.year.toString() ?? '')              
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}