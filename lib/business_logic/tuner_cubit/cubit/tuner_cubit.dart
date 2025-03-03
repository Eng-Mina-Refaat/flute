import 'package:bloc/bloc.dart';
import 'package:flute2/data/repository/tuner_repo.dart';
import 'package:meta/meta.dart';

part 'tuner_state.dart';

class TunerCubit extends Cubit<TunerState> {
  final AudioRepository audioRepository;

  final int maxReadings = 5;
  final double alpha = 0.2;
  final double changeThreshold = 1.0;

  List<double> _pitchReadings = [];
  double? _previousPitch;
  double _targetFrequency = 440.0;

  bool isRecording = false;

  TunerCubit({required this.audioRepository}) : super(TunerInitial());

  Future<void> init() async {
    await audioRepository.init();
  }

  Future<void> startRecording() async {
    await audioRepository.startRecording();
    isRecording = true;
    audioRepository.audioStream.listen((data) async {
      final pitch = await audioRepository.processAudio(data);
      if (pitch != null) {
        _smoothPitch(pitch);
      }
    });

    emit(TunerStopped());
  }

  Future<void> stopRecording() async {
    await audioRepository.stopRecording();
    isRecording = false;
    emit(TunerStopped());
  }

  void _smoothPitch(double pitch) {
    if (_previousPitch == null) {
      _previousPitch = pitch;
    } else {
      _previousPitch = alpha * pitch + (1 - alpha) * _previousPitch!;
    }

    if (_pitchReadings.length >= maxReadings) {
      _pitchReadings.removeAt(0);
    }
    _pitchReadings.add(_previousPitch!);

    double averagePitch =
        _pitchReadings.reduce((a, b) => a + b) / _pitchReadings.length;

    if (state is! TunerRecording ||
        (state is TunerRecording &&
            (averagePitch - (state as TunerRecording).pitch).abs() >
                changeThreshold)) {
      emit(TunerRecording(
        pitch: averagePitch,
        targetFrequency: _targetFrequency,
        isCloseToTarget: (averagePitch - _targetFrequency).abs() <= 15,
      ));
    }
  }

  void setTargetFrequency(double frequency) {
    _targetFrequency = frequency;
    if (state is TunerRecording) {
      emit(TunerRecording(
        pitch: (state as TunerRecording).pitch,
        targetFrequency: _targetFrequency,
        isCloseToTarget:
            ((state as TunerRecording).pitch - _targetFrequency).abs() <= 15,
      ));
    }
  }
}
