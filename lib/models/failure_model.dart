import 'package:equatable/equatable.dart';

class Failure extends Equatable{
  // Equatable helps us to compare 2 instances
  final String code;
  final String message;

  // passes empty strings if parameters are not passed
  const Failure({this.code= '', this.message= ''});

  /// prints out the readable format for our instances so we can see all the different properties (props).
  @override
  bool get stringify => true;

  @override
  /// The list of properties that will be used to determine whether two instances are equal, e.g failure1 == failure2 ?
  List<Object> get props => [code, message];
}