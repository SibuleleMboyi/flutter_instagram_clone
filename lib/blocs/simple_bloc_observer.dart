import 'package:flutter_bloc/flutter_bloc.dart';

// To use this file, we can it in the main()

/// Makes BloC to continuously print out to our debug console so it gets easier to Debug
class SimpleBlocObserver extends BlocObserver{

  /// Called whenever an event is added to any bloc with the given bloc and event.
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  /// Is called when a bloc is changing from one state to another state
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  /// Called whenever an error is thrown in any Bloc or Cubit.
  // This one is asynchronous because it's the Error that is thrown if the request failed from fetching data from the Database
  @override
  Future<void> onError(Cubit cubit, Object error, StackTrace stackTrace) async{
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}