import 'package:flutter/material.dart';



class AppLifeCycleWraper extends StatefulWidget {

  final Widget child;
  final Function? onResumed;
  final Function? onInactive;
  final Function? onPaused;
  final Function? onDetached;
  
  const AppLifeCycleWraper({
     Key? key, 
     required this.child, 
     this.onResumed,
     this.onInactive,
     this.onPaused,
     this.onDetached,
  }) : super(key: key);

  @override
  _AppLifeCycleWraperState createState() => _AppLifeCycleWraperState();
}

class _AppLifeCycleWraperState extends State<AppLifeCycleWraper> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

        switch (state) {
          case AppLifecycleState.resumed:
           if(widget.onResumed != null) widget.onResumed!();
            break;
          case AppLifecycleState.inactive:
             if(widget.onInactive != null) widget.onInactive!();
            break;
          case AppLifecycleState.paused:
             if(widget.onPaused != null) widget.onPaused!();
            break;
          case AppLifecycleState.detached:
             if(widget.onDetached != null) widget.onDetached!();
            break;
        }
}


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}