// // import 'package:bloc/bloc.dart';
// // import 'package:flute2/data/repository/tuner_repo.dart';
// // import 'package:meta/meta.dart';

// // part 'tuner_state.dart';

// // class TunerCubit extends Cubit<TunerState> {
// //   final AudioRepository audioRepository;

// //   final int maxReadings = 5;
// //   final double alpha = 0.2;
// //   final double changeThreshold = 1.0;

// //   List<double> _pitchReadings = [];
// //   double? _previousPitch;
// //   double _targetFrequency = 440.0;

// //   bool isRecording = false;

// //   TunerCubit({required this.audioRepository}) : super(TunerInitial());

// //   Future<void> init() async {
// //     await audioRepository.init();
// //   }

// //   Future<void> startRecording() async {
// //     await audioRepository.startRecording();
// //     isRecording = true;
// //     audioRepository.audioStream.listen((data) async {
// //       final pitch = await audioRepository.processAudio(data);
// //       if (pitch != null) {
// //         _smoothPitch(pitch);
// //       }
// //     });

// //     emit(TunerStopped());
// //   }

// //   Future<void> stopRecording() async {
// //     await audioRepository.stopRecording();
// //     isRecording = false;
// //     emit(TunerStopped());
// //   }

// //   void _smoothPitch(double pitch) {
// //     if (_previousPitch == null) {
// //       _previousPitch = pitch;
// //     } else {
// //       _previousPitch = alpha * pitch + (1 - alpha) * _previousPitch!;
// //     }

// //     if (_pitchReadings.length >= maxReadings) {
// //       _pitchReadings.removeAt(0);
// //     }
// //     _pitchReadings.add(_previousPitch!);

// //     double averagePitch =
// //         _pitchReadings.reduce((a, b) => a + b) / _pitchReadings.length;

// //     if (state is! TunerRecording ||
// //         (state is TunerRecording &&
// //             (averagePitch - (state as TunerRecording).pitch).abs() >
// //                 changeThreshold)) {
// //       emit(TunerRecording(
// //         pitch: averagePitch,
// //         targetFrequency: _targetFrequency,
// //         isCloseToTarget: (averagePitch - _targetFrequency).abs() <= 15,
// //       ));
// //     }
// //   }

// //   void setTargetFrequency(double frequency) {
// //     _targetFrequency = frequency;
// //     if (state is TunerRecording) {
// //       emit(TunerRecording(
// //         pitch: (state as TunerRecording).pitch,
// //         targetFrequency: _targetFrequency,
// //         isCloseToTarget:
// //             ((state as TunerRecording).pitch - _targetFrequency).abs() <= 15,
// //       ));
// //     }
// //   }
// // }

// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flute2/data/repository/tuner_repo.dart';

// part 'tuner_state.dart';

// class TunerCubit extends Cubit<TunerState> {
//   final PitchRepository _repository;
//   StreamSubscription? _pitchSubscription;
//   StreamSubscription? _warningSubscription;
//   StreamSubscription? _errorSubscription;

//   TunerCubit(this._repository) : super(const TunerState()) {
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     await _repository.initialize();

//     // Subscribe to streams from repository
//     _pitchSubscription = _repository.pitchStream.listen((pitch) {
//       if (pitch == null) {
//         emit(state.clearPitch());
//       } else {
//         final closestNote = _repository.findClosestNote(pitch);
//         final isInTune =
//             _repository.isCloseToTarget(pitch, state.targetFrequency);

//         emit(state.copyWith(
//           detectedPitch: pitch,
//           isInTune: isInTune,
//           closestNote: closestNote,
//         ));
//       }
//     });

//     _warningSubscription = _repository.warningStream.listen((warning) {
//       emit(state.copyWith(warningMessage: warning));
//     });

//     _errorSubscription = _repository.errorStream.listen((error) {
//       emit(state.copyWith(errorMessage: error));
//     });
//   }

//   Future<void> startRecording() async {
//     emit(state.copyWith(isRecording: true));
//     await _repository.startRecording();
//   }

//   Future<void> stopRecording() async {
//     await _repository.stopRecording();
//     emit(state.copyWith(isRecording: false));
//   }

//   void setTargetFrequency(double frequency, String note) {
//     emit(state.copyWith(
//       targetFrequency: frequency,
//       targetNote: note,
//       isInTune: state.detectedPitch != null
//           ? _repository.isCloseToTarget(state.detectedPitch!, frequency)
//           : false,
//     ));
//   }

//   List<Map<String, dynamic>> get availableFrequencies =>
//       _repository.frequencies;

//   @override
//   Future<void> close() {
//     _pitchSubscription?.cancel();
//     _warningSubscription?.cancel();
//     _errorSubscription?.cancel();
//     _repository.dispose();
//     return super.close();
//   }
// }
