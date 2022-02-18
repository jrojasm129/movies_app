import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_info/api/movies_api.dart';
import 'package:movies_info/providers/movies_provider.dart';
import 'package:movies_info/screens/home_screen.dart';
import 'package:movies_info/widgets/app_life_cycle_wraper.dart';
import 'package:provider/provider.dart';

import 'constants/constants_colors.dart';

void main() { 

  WidgetsFlutterBinding.ensureInitialized();
  MoviesApi.configureDio();
  
  runApp(const MyAppState());

}


class MyAppState extends StatelessWidget {
  const MyAppState({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: AppLifeCycleWraper(
        onDetached: () => print('onDetached'),
        onInactive: () => print('onInactive'),
        onPaused:   () => print('onPaused'),
        onResumed:  () => print('onResumed'),
        child: const HomePage(),
        ),
        
        theme: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const  AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,              
            ),
             elevation: 0,
             color: kprimaryColor 
          )
        ),
      
    );
  }
}