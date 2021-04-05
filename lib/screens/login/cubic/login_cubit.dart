import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/repositories/repositories.dart';

part 'login_state.dart';

// Cubic is a BloC without the Events.
// The Cubic has a method that you call and this method will emit state.
// Base on this state the UI will update accordingly

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({
    @required AuthRepository authRepository,
  }) : _authRepository = authRepository,super(LoginState.initial());

  /// Fires whenever we change email in the email field
  //  The reason we set 'status' to 'initial when user types is so
  //  that the LoginStatus is able to change back from the Error state to the initial state
  void emailChanged(String value){
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  /// Fires whenever we change password in the password field
  void passwordChanged(String value){
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  void logInWithCredentials() async{

    /// ensures that this function does not fire while status in currently submitting
    if(!state.isFormValid || state.status == LoginStatus.submitting)
      return;

    emit(state.copyWith(status: LoginStatus.submitting));

    try{
      await _authRepository.logInWithEmailAndPassword(email: state.email, password: state.password);
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch(err){
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }
}
