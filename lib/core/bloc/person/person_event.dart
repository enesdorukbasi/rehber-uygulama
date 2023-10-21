part of 'person_bloc.dart';

sealed class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object> get props => [];
}

class FetchAllPersonEvent extends PersonEvent {
  final int? page;
  final int? cityId;
  final int? genderId;
  final String? personName;
  final BuildContext context;

  const FetchAllPersonEvent(
      {this.page,
      this.cityId,
      this.genderId,
      this.personName,
      required this.context});

  @override
  List<Object> get props => [page!, cityId!, genderId!, personName!, context];
}

class FetchPersonDetailsEvent extends PersonEvent {
  final int personId;
  final BuildContext context;

  const FetchPersonDetailsEvent(this.personId, this.context);

  @override
  List<Object> get props => [personId, context];
}

class UpdateOrGeneratePersonEvent extends PersonEvent {
  final int personId;
  final int cityId;
  final int townId;
  final String personName;
  final String personPhone;
  final File? image;
  final BuildContext context;
  final PersonBloc personBloc;
  final int genderId;
  final int pageNumber;
  final int? cityIdForFilter;
  final int? genderIdForFilter;
  final String? personNameForFilter;

  const UpdateOrGeneratePersonEvent({
    required this.personId,
    required this.cityId,
    required this.townId,
    required this.personName,
    required this.personPhone,
    required this.image,
    required this.context,
    required this.personBloc,
    required this.genderId,
    required this.pageNumber,
    this.cityIdForFilter,
    this.genderIdForFilter,
    this.personNameForFilter,
  });

  @override
  List<Object> get props => [
        personId,
        cityId,
        townId,
        personName,
        personPhone,
        context,
        personBloc,
        genderId,
      ];
}

class DeletePersonEvent extends PersonEvent {
  final int personId;
  final BuildContext context;
  final PersonBloc personBloc;
  final int pageNumber;
  final int? cityId;
  final int? genderId;
  final String? personName;

  const DeletePersonEvent(this.personId, this.context, this.personBloc,
      this.pageNumber, this.cityId, this.genderId, this.personName);

  @override
  List<Object> get props => [
        personId,
        context,
        personBloc,
        pageNumber,
        cityId!,
        genderId!,
        personName!
      ];
}
