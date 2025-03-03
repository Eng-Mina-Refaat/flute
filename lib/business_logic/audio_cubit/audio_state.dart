import 'package:flute2/data/model/record_model.dart';

abstract class RecordState {
  const RecordState();

  // @override
  // List<Object> get props => [];
}

class RecordInitial extends RecordState {}

class RecordLoaded extends RecordState {
  final List<RecordModel> records;

  const RecordLoaded(this.records);

  // @override
  // List<Object> get props => [records];
}
