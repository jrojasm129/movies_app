import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:movies_info/constants/constants_colors.dart';
import 'package:movies_info/providers/movies_provider.dart';
import 'package:movies_info/widgets/movie_page_slider.dart';
import 'package:provider/provider.dart';

import '../delegates/search_delegate.dart';
import '../widgets/widgets.dart';
import 'movie_details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {    
    super.initState();

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Provider.of<MoviesProvider>(context, listen: false).initMovies();
    });
  }

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('STARZ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              final movie = await showSearch(
                context: context, delegate: CustomSearchDelegate()
              ); 
              if(movie == null) return;

              movie.heroTag= 'results + $movie.id';

             Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movie.id.toString(), heroTag: movie.heroTag!)));

            }
          , icon: const Icon(Icons.search, color: kprimaryColor,)
          )
        ],
      ), 
  
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [  
                const SizedBox(height: 10),

                const CustomListTitle(title: 'Tendencia', fontSize: 28),
                MoviePageSlider(
                  collection: 'Trending',
                  movies: moviesProvider.popularMovies,
                  onScrollEnds: (){
                    if(!moviesProvider.isLoadingPopulars){
                      moviesProvider.getPopulars();
                    }
                  }
                ),
                
                const SizedBox(height: 30),
                  
                const CustomListTitle(title: 'En cartelera'),
                MovieListSlider(
                  collection: 'Now playing',
                  movies: moviesProvider.nowPlaying,
                  onScrollEnds: (){
                    if(!moviesProvider.isLoadingNowPlaying){
                      moviesProvider.getNowPlaying();
                    }
                  },
                ),

                const SizedBox(height: 30),
                  
                const CustomListTitle(title: 'Mejor valoradas'),
                MovieListSlider(
                  collection: 'Top rated',
                  movies: moviesProvider.topRatedMovies,
                  onScrollEnds: (){
                    if(!moviesProvider.isLoadingTopRated){
                      moviesProvider.getTopRated();
                    }
                  },
                ),

                const SizedBox(height: 30),
                  
                const CustomListTitle(title: 'Próximamente'),
                MovieListSlider(
                  collection: 'Top rated',
                  movies: moviesProvider.upComingMovies,
                  onScrollEnds: (){
                    if(!moviesProvider.isLoadingUpComing){
                      moviesProvider.getUpComing();
                    }
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
  }
}




