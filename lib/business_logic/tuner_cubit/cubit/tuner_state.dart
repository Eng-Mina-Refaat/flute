// // part of 'tuner_cubit.dart';

// // @immutable
// // sealed class TunerState {}

// // final class TunerInitial extends TunerState {}

// // class TunerRecording extends TunerState {
// //   final double pitch;
// //   final double targetFrequency;
// //   final bool isCloseToTarget;

// //   TunerRecording({
// //     required this.pitch,
// //     required this.targetFrequency,
// //     required this.isCloseToTarget,
// //   });
// // }

// // class TunerStopped extends TunerState {}

// part of 'tuner_cubit.dart';

// class TunerState extends Equatable {
//   final double? detectedPitch;
//   final double targetFrequency;
//   final String targetNote;
//   final bool isInTune;
//   final bool isRecording;
//   final String closestNote;
//   final String? errorMessage;
//   final String? warningMessage;

//   const TunerState({
//     this.detectedPitch,
//     this.targetFrequency = 440.0,
//     this.targetNote = 'A4',
//     this.isInTune = false,
//     this.isRecording = false,
//     this.closestNote = '',
//     this.errorMessage,
//     this.warningMessage,
//   });

//   TunerState copyWith({
//     double? detectedPitch,
//     double? targetFrequency,
//     String? targetNote,
//     bool? isInTune,
//     bool? isRecording,
//     String? closestNote,
//     String? errorMessage,
//     String? warningMessage,
//   }) {
//     return TunerState(
//       detectedPitch: detectedPitch ?? this.detectedPitch,
//       targetFrequency: targetFrequency ?? this.targetFrequency,
//       targetNote: targetNote ?? this.targetNote,
//       isInTune: isInTune ?? this.isInTune,
//       isRecording: isRecording ?? this.isRecording,
//       closestNote: closestNote ?? this.closestNote,
//       errorMessage: errorMessage ?? this.errorMessage,
//       warningMessage: warningMessage ?? this.warningMessage,
//     );
//   }

//   TunerState clearPitch() {
//     return TunerState(
//       detectedPitch: null,
//       targetFrequency: targetFrequency,
//       targetNote: targetNote,
//       isInTune: false,
//       isRecording: isRecording,
//       closestNote: '',
//       errorMessage: errorMessage,
//       warningMessage: warningMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         detectedPitch,
//         targetFrequency,
//         targetNote,
//         isInTune,
//         isRecording,
//         closestNote,
//         errorMessage,
//         warningMessage,
//       ];
// }
