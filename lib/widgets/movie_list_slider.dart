import 'package:flutter/material.dart';
import 'package:movies_info/constants/constants_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../models/movie_model.dart';
import '../screens/movie_details_screen.dart';

class MovieListSlider extends StatefulWidget {

  final List<Movie> movies;
  final double height;
  final double itemExtent;
  final Function? onScrollEnds;
  final String collection;
  final bool replaceRoute;

  const MovieListSlider({
    Key? key,
    required this.movies,
    this.onScrollEnds,
    this.height = 200,
    this.itemExtent = 130, 
    required this.collection, 
    this.replaceRoute = false
  }) : super(key: key);



  @override
  State<MovieListSlider> createState() => _MovieListSliderState();
}

class _MovieListSliderState extends State<MovieListSlider> {

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollControllerListener);
    super.initState();
  }

  void _scrollControllerListener(){
    if(_scrollController.offset >= _scrollController.position.maxScrollExtent - 100 && widget.onScrollEnds != null){
     widget.onScrollEnds!();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollControllerListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: widget.movies.isNotEmpty 
       ? ListView.builder(
           physics: const BouncingScrollPhysics(),
           controller: _scrollController,
           itemExtent: widget.itemExtent,
           scrollDirection: Axis.horizontal,
           itemCount: widget.movies.length,
           itemBuilder: (context, i) {
           
             final movie = widget.movies[i];

             movie.heroTag = '${widget.collection} $movie.id';

             return GestureDetector(
               child: _ListItem(movie: movie),
               onTap: (){
                 widget.replaceRoute 
                 ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movie.id.toString(), heroTag: movie.heroTag!)))
                 : Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movie.id.toString(), heroTag: movie.heroTag!)));
               },
             );
           },
        )
       : ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemExtent: widget.itemExtent,
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, i) {      
          return Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(.3), 
            highlightColor: Colors.grey.withOpacity(0.6),
            child: const _EmptyListItem(), 
          );
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        children: [
          
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.5),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(movie.fullPosterPath),
                  fit: BoxFit.fill
                )
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(3)
                ),
                child: Text(
                  movie.releaseDate != null
                      ? movie.releaseDate!.year.toString()
                      : 'unknow',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(3)
                ),
                child: Text(
                  '${movie.voteAverage}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              
            ],
          ),
              )
            ),
          ),

        ],
      ),
    );
  }
}

class _EmptyListItem extends StatelessWidget {
  const _EmptyListItem({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        children: [
          
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
              
                    Container(
                      height: 30,
                      width: 60,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8)
                      ),
                    ),  
              
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle
                      )                      
                    ),
                  ],
                ),
              )
            ),
          ),

          const SizedBox(height: 5),                
      
          Container(
            height: 40,           
            decoration: BoxDecoration(
               color: Colors.grey,
              borderRadius: BorderRadius.circular(20)
            ),
          )
        ],
      ),
    );
  }
}