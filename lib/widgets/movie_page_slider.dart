import 'package:flutter/material.dart';
import 'package:movies_info/constants/constants_colors.dart';
import 'package:movies_info/models/movie_model.dart';

import '../screens/movie_details_screen.dart';

class MoviePageSlider extends StatefulWidget {

  final List<Movie> movies;
  final double itemHeight;
  final Function? onScrollEnds;
  final String collection;

  const MoviePageSlider({
    Key? key, 
    required this.movies,
    this.itemHeight = 260, 
    this.onScrollEnds, 
    required this.collection
  }) : super(key: key);

  @override
  _MoviePageSliderState createState() => _MoviePageSliderState();
}

class _MoviePageSliderState extends State<MoviePageSlider> {

  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: 0.70
    )..addListener(_pageControllerListener);

    super.initState();
  }

  
  void _pageControllerListener(){
    if(_pageController.offset >= _pageController.position.maxScrollExtent - 100 && widget.onScrollEnds != null){
     widget.onScrollEnds!();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: widget.itemHeight,
      width: screenSize.width,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.movies.length,
        onPageChanged: (index) => setState(() {
          currentPage = index;
        }),
        itemBuilder: (context, index){

          final isCurrentPage = currentPage == index;  
          final movie = widget.movies[index];
          movie.heroTag = '${widget.collection} $movie.id';

          return GestureDetector(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movie.id.toString(), heroTag: movie.heroTag!))),
            child: _PageItem(
              isCurrentPage: isCurrentPage, 
              movie: movie
            ),
          );


        }),
    );
  }
}

class _PageItem extends StatelessWidget {
  const _PageItem({
    Key? key,
    required this.isCurrentPage,
    required this.movie
  }) : super(key: key);

  final bool isCurrentPage;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        child: AnimatedContainer(
          width: double.infinity,
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(vertical: isCurrentPage ? 0 : 15),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(movie.fullPosterPath),
              fit: BoxFit.fill
            ) 
          ),
          child: isCurrentPage ? Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      movie.releaseDate != null
                      ? '${movie.releaseDate!.year}'
                      : 'Año: unknow',
                      style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w400
                      ),),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black87
                    ),
                  ),
                  
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      movie.releaseDate != null
                      ? '${movie.voteAverage}'
                      : 'Año: unknow',
                      style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w400
                      ),),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: kprimaryColor
                    ),
                  ),
                ]),
            ),
          ) : const SizedBox.shrink(),
        ),
      ),
    );
  }
}