import 'package:bloc/bloc.dart';
import 'package:flute2/business_logic/audio_cubit/audio_state.dart';
import 'package:flute2/data/repository/recordrepository.dart';
// import 'package:meta/meta.dart';

class RecordCubit extends Cubit<RecordState> {
  final RecordRepository _repository;
  // String? _currentFilePath;

  RecordCubit(this._repository) : super(RecordInitial());

  void loadRecords() {
    final records = _repository.getRecords();
    emit(RecordLoaded(records));
  }

  Future<void> saveRecord(String filePath, String name) async {
    await _repository.saveRecord(filePath, name);
    loadRecords();
  }

  Future<void> deleteRecording(int index) async {
    await _repository.deleteRecording(index);
    loadRecords();
  }

  Future<void> shareRecording(String filePath) async {
    await _repository.shareRecording(filePath);
    // } else {
    //   emit(RecordError('No recording available to share.'));
    // }
  }
}
