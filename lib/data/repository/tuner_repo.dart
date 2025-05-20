// // import 'dart:async';
// // import 'dart:typed_data';
// // import 'package:flutter_sound/flutter_sound.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:pitch_detector_dart/pitch_detector.dart';

// // class AudioRepository {
// //   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
// //   final PitchDetector _pitchDetector;
// //   final double sampleRate;
// //   final int bufferSize;
// //   final StreamController<Uint8List> _audioStreamController = StreamController();

// //   Stream<Uint8List> get audioStream => _audioStreamController.stream;

// //   AudioRepository({
// //     this.sampleRate = 44100,
// //     this.bufferSize = 1024,
// //   }) : _pitchDetector = PitchDetector(
// //           audioSampleRate: sampleRate,
// //           bufferSize: bufferSize,
// //         );

// //   Future<void> init() async {
// //     await _recorder.openRecorder();
// //   }

// //   Future<void> requestPermission() async {
// //     var status = await Permission.microphone.request();
// //     if (status != PermissionStatus.granted) {
// //       throw 'Microphone permission not granted';
// //     }
// //   }

// //   Future<void> startRecording() async {
// //     await requestPermission();
// //     await _recorder.startRecorder(
// //       codec: Codec.pcm16,
// //       sampleRate: sampleRate.toInt(),
// //       numChannels: 1,
// //       toStream: _audioStreamController.sink,
// //     );
// //   }

// //   Future<void> stopRecording() async {
// //     await _recorder.stopRecorder();
// //     await _audioStreamController.close();
// //   }

// //   Future<double?> processAudio(Uint8List data) async {
// //     final samples = Int16List.view(data.buffer);
// //     final floatSamples = samples.map((e) => e.toDouble() / 32768.0).toList();

// //     try {
// //       final pitchResult = await _pitchDetector
// //           .getPitchFromFloatBuffer(Float32List.fromList(floatSamples));

// //       if (pitchResult.pitch > 0) {
// //         return pitchResult.pitch;
// //       }
// //     } catch (e) {
// //       print('خطأ أثناء تحليل الصوت: $e');
// //     }
// //     return null;
// //   }

// //   Future<void> dispose() async {
// //     await _recorder.closeRecorder();
// //   }
// // }
// import 'dart:async';
// import 'dart:typed_data';
// import 'package:audio_streamer/audio_streamer.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:math' as Math;
// import 'package:pitch_detector_dart/pitch_detector.dart';

// class PitchRepository {
//   final AudioStreamer _audioStreamer = AudioStreamer();
//   final PitchDetector _pitchDetector;
//   final double sampleRate;
//   final int bufferSize;

//   // Constants for frequency validation
//   final double minValidFrequency = 15.0;
//   final double maxValidFrequency = 4000.0;

//   // Smoothing parameters
//   final List<double> _pitchReadings = [];
//   final int _maxReadings = 10;
//   double alpha = 0.3;
//   int _invalidPitchCount = 0;
//   double? previousPitch;

//   // Stream controllers
//   final StreamController<double?> pitchStreamController = StreamController<double?>.broadcast();
//   final StreamController<String?> warningStreamController = StreamController<String?>.broadcast();
//   final StreamController<String?> errorStreamController = StreamController<String?>.broadcast();

//   // Variables to cache the last emitted values
//   double? _lastEmittedPitch;
//   String? _lastWarningMessage;
//   String? _lastErrorMessage;

//   // Predefined frequencies map for music notes
//   final List<Map<String, dynamic>> frequencies = [
//     {'note': 'A4', 'frequency': 440.0},
//     {'note': 'A3', 'frequency': 219.9},
//     {'note': 'F4#', 'frequency': 370.3},
//     {'note': 'F3#', 'frequency': 184.8},
//     {'note': 'D3', 'frequency': 147.0},
//     {'note': 'C3#', 'frequency': 138.4},
//     {'note': 'F4', 'frequency': 349.1},
//     {'note': 'B4', 'frequency': 493.5},
//     {'note': 'C5#', 'frequency': 554.5},
//     {'note': 'G5', 'frequency': 784.7},
//     {'note': 'G3', 'frequency': 195.9},
//     {'note': 'C4#', 'frequency': 277.4},
//     {'note': 'D3#', 'frequency': 155.7},
//     {'note': 'F5#', 'frequency': 740.9},
//     {'note': 'F5', 'frequency': 698.8},
//     {'note': 'C3', 'frequency': 130.8},
//     {'note': 'G4', 'frequency': 392.1},
//     {'note': 'C5', 'frequency': 523.8},
//     {'note': 'G3#', 'frequency': 207.5},
//     {'note': 'F3', 'frequency': 174.7},
//     {'note': 'A3#', 'frequency': 232.9},
//     {'note': 'D4#', 'frequency': 310.9},
//     {'note': 'G4#', 'frequency': 415.8},
//     {'note': 'C4', 'frequency': 216.6},
//     {'note': 'D5#', 'frequency': 622.0},
//     {'note': 'D4', 'frequency': 293.5},
//     {'note': 'D5', 'frequency': 587.4},
//     {'note': 'E3', 'frequency': 164.9},
//     {'note': 'A4', 'frequency': 439.8},
//     {'note': 'B3', 'frequency': 246.7},
//     {'note': 'E5', 'frequency': 658.7},
//     {'note': 'A4#', 'frequency': 465.8},
//     {'note': 'E4', 'frequency': 329.3},
//   ];

//   // Timer to handle no-pitch detection warning
//   Timer? _noPitchTimer;
//   bool isRecording = false;

//   PitchRepository({required this.sampleRate, required this.bufferSize})
//       : _pitchDetector = PitchDetector(
//           audioSampleRate: sampleRate,
//           bufferSize: bufferSize,
//         );

//   // Stream getters
//   Stream<double?> get pitchStream => pitchStreamController.stream;
//   Stream<String?> get warningStream => warningStreamController.stream;
//   Stream<String?> get errorStream => errorStreamController.stream;

//   Future<void> initialize() async {
//     try {
//       // Initialize audio streamer
//       _audioStreamer.sampleRate = sampleRate.toInt();
//       _audioStreamer.bufferSize = bufferSize;
      
//       // Set up listener for audio data
//       _audioStreamer.audioStream.listen((buffer) {
//         _processAudioData(buffer);
//       }, onError: (e) {
//         _lastErrorMessage = 'خطأ في تدفق الصوت: $e';
//         errorStreamController.add(_lastErrorMessage);
//       });
//     } catch (e) {
//       _lastErrorMessage = 'فشل تهيئة المسجل: $e';
//       errorStreamController.add(_lastErrorMessage);
//     }
//   }

//   Future<void> dispose() async {
//     if (isRecording) {
//       await stopRecording();
//     }
//     _noPitchTimer?.cancel();
//     await pitchStreamController.close();
//     await warningStreamController.close();
//     await errorStreamController.close();
//   }

//   Future<void> _requestPermission() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw 'Microphone permission not granted';
//     }
//   }

//   Future<void> startRecording() async {
//     try {
//       await _requestPermission();

//       isRecording = true;
//       _lastEmittedPitch = null;
//       _lastWarningMessage = null;
//       _lastErrorMessage = null;
//       errorStreamController.add(null);
//       warningStreamController.add(null);
//       pitchStreamController.add(null);

//       _invalidPitchCount = 0;
//       _pitchReadings.clear();
//       previousPitch = null;

//       // Start the audio streamer
//       await _audioStreamer.start();

//       // Set up a timer to warn if no pitch is detected
//       _noPitchTimer = Timer(const Duration(seconds: 5), () {
//         if (!pitchStreamController.isClosed && isRecording && _lastEmittedPitch == null) {
//           _lastWarningMessage = 'لم يتم اكتشاف تردد صالح. جرب نغمة واضحة بصوت معتدل بعيدًا عن التشويش.';
//           warningStreamController.add(_lastWarningMessage);
//         }
//       });
//     } catch (e) {
//       _lastErrorMessage = 'فشل بدء التسجيل: $e';
//       errorStreamController.add(_lastErrorMessage);
//     }
//   }

//   Future<void> stopRecording() async {
//     try {
//       await _audioStreamer.stop();
//       _noPitchTimer?.cancel();

//       isRecording = false;
//       _lastEmittedPitch = null;
//       _lastWarningMessage = null;
//       _lastErrorMessage = null;
//       pitchStreamController.add(null);
//       errorStreamController.add(null);
//       warningStreamController.add(null);
//       _invalidPitchCount = 0;
//     } catch (e) {
//       _lastErrorMessage = 'فشل إيقاف التسجيل: $e';
//       errorStreamController.add(_lastErrorMessage);
//     }
//   }

//   void _processAudioData(Uint8List data) {
//     if (!isRecording) return;

//     try {
//       // Convert byte data to int16 samples
//       final Int16List samples = Int16List.view(data.buffer);
      
//       // Apply window function to samples
//       final windowedSamples = _applyWindow(samples);
      
//       // Calculate amplitude
//       final amplitude = _calculateRMS(windowedSamples);

//       if (amplitude < 0.005) {
//         _lastWarningMessage = 'الصوت منخفض جدًا. ارفع مستوى الصوت قليلاً.';
//         warningStreamController.add(_lastWarningMessage);
//         return;
//       } else if (_lastWarningMessage == 'الصوت منخفض جدًا. ارفع مستوى الصوت قليلاً.') {
//         _lastWarningMessage = null;
//         warningStreamController.add(null);
//       }

//       // Detect pitch
//       final pitchResult = _pitchDetector.getPitchFromFloatBuffer(
//         Float32List.fromList(windowedSamples),
//       );

//       if (pitchResult.pitch > minValidFrequency && pitchResult.pitch < maxValidFrequency) {
//         _smoothPitch(pitchResult.pitch);

//         if (_lastWarningMessage == 'تردد غير صالح. تأكد من تشغيل نغمة واضحة بصوت معتدل.') {
//           _lastWarningMessage = null;
//           warningStreamController.add(null);
//         }
//       } else {
//         _invalidPitchCount++;
//         if (_invalidPitchCount > 5) {
//           _lastWarningMessage = 'تردد غير صالح. تأكد من تشغيل نغمة واضحة بصوت معتدل.';
//           warningStreamController.add(_lastWarningMessage);
//         }
//       }
//     } catch (e) {
//       _lastErrorMessage = 'خطأ أثناء تحليل الصوت: $e';
//       errorStreamController.add(_lastErrorMessage);
//     }
//   }

//   List<double> _applyWindow(Int16List samples) {
//     final List<double> windowedSamples = List<double>.filled(samples.length, 0);

//     for (int i = 0; i < samples.length; i++) {
//       double windowCoefficient = 0.5 * (1 - Math.cos(2 * Math.pi * i / (samples.length - 1)));
//       windowedSamples[i] = (samples[i].toDouble() / 32768.0) * windowCoefficient;
//     }

//     return windowedSamples;
//   }

//   double _calculateRMS(List<double> samples) {
//     double sum = 0;
//     for (int i = 0; i < samples.length; i++) {
//       sum += samples[i] * samples[i];
//     }
//     return Math.sqrt(sum / samples.length);
//   }

//   void _smoothPitch(double pitch) {
//     _invalidPitchCount = 0;

//     if (previousPitch == null) {
//       previousPitch = pitch;
//     } else {
//       if ((pitch - previousPitch!).abs() > previousPitch! * 0.5) {
//         return; // Avoid sudden large changes
//       }
//       previousPitch = alpha * pitch + (1 - alpha) * previousPitch!;
//     }

//     if (_pitchReadings.length >= _maxReadings) {
//       _pitchReadings.removeAt(0);
//     }
//     _pitchReadings.add(previousPitch!);

//     int startIdx = Math.max(0, _pitchReadings.length - (_maxReadings ~/ 2));
//     double averagePitch = _pitchReadings.sublist(startIdx).reduce((a, b) => a + b) / 
//                          (_pitchReadings.length - startIdx);

//     if (!pitchStreamController.isClosed) {
//       _lastEmittedPitch = averagePitch;
//       pitchStreamController.add(averagePitch); // Always emit the frequency
//       errorStreamController.add(null);

//       if (_lastWarningMessage == 'تردد غير صالح. تأكد من تشغيل نغمة واضحة بصوت معتدل.') {
//         _lastWarningMessage = null;
//         warningStreamController.add(null);
//       }

//       _noPitchTimer?.cancel();
//     }
//   }

//   double getTolerance(double freq) {
//     return freq < 100 ? 3.0 : (freq < 500 ? 10.0 : 20.0);
//   }

//   bool isCloseToTarget(double frequency, double targetFrequency) {
//     final double tolerance = getTolerance(targetFrequency);
//     return (frequency - targetFrequency).abs() <= tolerance;
//   }

//   String findClosestNote(double frequency) {
//     double minDifference = double.infinity;
//     String closestNote = '';

//     for (var freq in frequencies) {
//       double difference = (frequency - freq['frequency']).abs();
//       if (difference < minDifference) {
//         minDifference = difference;
//         closestNote = freq['note'];
//       }
//     }

//     return closestNote;
//   }
// }