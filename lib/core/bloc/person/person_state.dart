part of 'person_bloc.dart';

sealed class PersonState extends Equatable {
  const PersonState();

  @override
  List<Object> get props => [];
}

final class PersonInitializing extends PersonState {}

final class PersonInitializeError extends PersonState {
  final String message;

  const PersonInitializeError(this.message);

  @override
  List<Object> get props => [message];
}

final class PersonInitialized extends PersonState {
  final PersonsModel model;

  const PersonInitialized(this.model);

  @override
  List<Object> get props => [model];
}

final class PersonDetailsInitialized extends PersonState {
  final PersonDetailsModel model;

  const PersonDetailsInitialized(this.model);

  @override
  List<Object> get props => [model];
}

final class PersonUpdatedOrGenerated extends PersonState {
  final bool status;

  const PersonUpdatedOrGenerated(this.status);

  @override
  List<Object> get props => [status];
}
