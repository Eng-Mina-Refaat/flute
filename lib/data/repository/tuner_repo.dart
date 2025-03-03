import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';

class AudioRepository {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final PitchDetector _pitchDetector;
  final double sampleRate;
  final int bufferSize;
  final StreamController<Uint8List> _audioStreamController = StreamController();

  Stream<Uint8List> get audioStream => _audioStreamController.stream;

  AudioRepository({
    this.sampleRate = 44100,
    this.bufferSize = 1024,
  }) : _pitchDetector = PitchDetector(
          audioSampleRate: sampleRate,
          bufferSize: bufferSize,
        );

  Future<void> init() async {
    await _recorder.openRecorder();
  }

  Future<void> requestPermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
  }

  Future<void> startRecording() async {
    await requestPermission();
    await _recorder.startRecorder(
      codec: Codec.pcm16,
      sampleRate: sampleRate.toInt(),
      numChannels: 1,
      toStream: _audioStreamController.sink,
    );
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    await _audioStreamController.close();
  }

  Future<double?> processAudio(Uint8List data) async {
    final samples = Int16List.view(data.buffer);
    final floatSamples = samples.map((e) => e.toDouble() / 32768.0).toList();

    try {
      final pitchResult = await _pitchDetector
          .getPitchFromFloatBuffer(Float32List.fromList(floatSamples));

      if (pitchResult.pitch > 0) {
        return pitchResult.pitch;
      }
    } catch (e) {
      print('خطأ أثناء تحليل الصوت: $e');
    }
    return null;
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }
}
