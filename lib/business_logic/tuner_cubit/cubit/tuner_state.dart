// part of 'tuner_cubit.dart';

// @immutable
// sealed class TunerState {}

// final class TunerInitial extends TunerState {}

// class TunerRecording extends TunerState {
//   final double pitch;
//   final double targetFrequency;
//   final bool isCloseToTarget;

//   TunerRecording({
//     required this.pitch,
//     required this.targetFrequency,
//     required this.isCloseToTarget,
//   });
// }

// class TunerStopped extends TunerState {}

part of 'tuner_cubit.dart';

class TunerState extends Equatable {
  final bool isRecording;
  final double? detectedPitch;
  final String? errorMessage;
  final String? warningMessage;
  final double targetFrequency;
  final String targetNote;
  final bool isInTune;
  final String closestNote;

  const TunerState({
    this.isRecording = false,
    this.detectedPitch,
    this.errorMessage,
    this.warningMessage,
    this.targetFrequency = 440.0,
    this.targetNote = 'A4',
    this.isInTune = false,
    this.closestNote = '',
  });

  @override
  List<Object?> get props => [
        isRecording,
        detectedPitch,
        errorMessage,
        warningMessage,
        targetFrequency,
        targetNote,
        isInTune,
        closestNote,
      ];

  TunerState copyWith({
    bool? isRecording,
    double? detectedPitch,
    String? errorMessage,
    String? warningMessage,
    double? targetFrequency,
    String? targetNote,
    bool? isInTune,
    String? closestNote,
  }) {
    return TunerState(
      isRecording: isRecording ?? this.isRecording,
      detectedPitch: detectedPitch ?? this.detectedPitch,
      errorMessage: errorMessage ?? this.errorMessage,
      warningMessage: warningMessage ?? this.warningMessage,
      targetFrequency: targetFrequency ?? this.targetFrequency,
      targetNote: targetNote ?? this.targetNote,
      isInTune: isInTune ?? this.isInTune,
      closestNote: closestNote ?? this.closestNote,
    );
  }

  // Helper method for setting pitch to null
  TunerState clearPitch() {
    return TunerState(
      isRecording: isRecording,
      detectedPitch: null,
      errorMessage: errorMessage,
      warningMessage: warningMessage,
      targetFrequency: targetFrequency,
      targetNote: targetNote,
      isInTune: false,
      closestNote: '',
    );
  }
}
