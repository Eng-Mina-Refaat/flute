part of 'tuner_cubit.dart';

@immutable
sealed class TunerState {}

final class TunerInitial extends TunerState {}

class TunerRecording extends TunerState {
  final double pitch;
  final double targetFrequency;
  final bool isCloseToTarget;

  TunerRecording({
    required this.pitch,
    required this.targetFrequency,
    required this.isCloseToTarget,
  });
}

class TunerStopped extends TunerState {}
