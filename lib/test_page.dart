// import 'dart:typed_data';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pitch_detector_dart/pitch_detector.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Tuner باستخدام flutter_sound',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: TunerScreen(),
//     );
//   }
// }

// class TunerScreen extends StatefulWidget {
//   @override
//   _TunerScreenState createState() => _TunerScreenState();
// }

// class _TunerScreenState extends State<TunerScreen> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool isRecording = false;
//   double? detectedPitch;
//   final double targetFrequency = 440.0;

//   final double sampleRate = 44100;
//   final int bufferSize = 1024;

//   late PitchDetector _pitchDetector;
//   late StreamController<Uint8List> audioStreamController;

//   final List<int> _audioBuffer = [];

//   @override
//   void initState() {
//     super.initState();
//     _pitchDetector = PitchDetector(
//       audioSampleRate: sampleRate,
//       bufferSize: bufferSize,
//     );
//     _initRecorder();
//   }

//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//   }

//   Future<void> _requestPermission() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw 'Microphone permission not granted';
//     }
//   }

//   Future<void> startRecording() async {
//     await _requestPermission();

//     audioStreamController = StreamController<Uint8List>();

//     // الاستماع للبيانات من الـ Stream
//     audioStreamController.stream.listen((Uint8List data) {
//       _processAudioStream(data);
//     });

//     await _recorder.startRecorder(
//       codec: Codec.pcm16,
//       sampleRate: sampleRate.toInt(),
//       numChannels: 1,
//       toStream: audioStreamController.sink,
//     );

//     setState(() {
//       isRecording = true;
//     });
//   }

//   Future<void> stopRecording() async {
//     await _recorder.stopRecorder();
//     await audioStreamController.close();
//     setState(() {
//       isRecording = false;
//     });
//   }

//   void _processAudioStream(Uint8List data) async {
//     final samples = Int16List.view(data.buffer);

//     _audioBuffer.addAll(samples);

//     while (_audioBuffer.length >= bufferSize) {
//       final segment = _audioBuffer.sublist(0, bufferSize);
//       _audioBuffer.removeRange(0, bufferSize);

//       final floatSamples = segment.map((e) => e.toDouble() / 32768.0).toList();

//       try {
//         final pitchResult = await _pitchDetector
//             .getPitchFromFloatBuffer(Float32List.fromList(floatSamples));

//         if (pitchResult.pitch > 0) {
//           setState(() {
//             detectedPitch = pitchResult.pitch;
//           });
//         }
//       } catch (e) {
//         print('خطأ أثناء تحليل الصوت: $e');
//       }
//     }
//   }

//   bool isCloseToTarget(double frequency) {
//     const double tolerance = 15;
//     return (frequency - targetFrequency).abs() <= tolerance;
//   }

//   @override
//   void dispose() {
//     _recorder.closeRecorder();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Color backgroundColor = Colors.grey;
//     if (detectedPitch != null) {
//       backgroundColor =
//           isCloseToTarget(detectedPitch!) ? Colors.green : Colors.red;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tuner باستخدام flutter_sound'),
//       ),
//       body: Container(
//         color: backgroundColor,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 detectedPitch != null
//                     ? '${detectedPitch!.toStringAsFixed(2)} Hz'
//                     : 'لا يوجد تردد',
//                 style:
//                     const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: isRecording ? stopRecording : startRecording,
//                 child: Text(isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:typed_data';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pitch_detector_dart/pitch_detector.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Tuner باستخدام flutter_sound',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const TunerScreen(),
//     );
//   }
// }

// class TunerScreen extends StatefulWidget {
//   const TunerScreen({super.key});

//   @override
//   State<TunerScreen> createState() => _TunerScreenState();
// }

// class _TunerScreenState extends State<TunerScreen> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool isRecording = false;
//   double? detectedPitch;

//   final double sampleRate = 44100;
//   final int bufferSize = 1024;

//   late PitchDetector _pitchDetector;
//   late StreamController<Uint8List> audioStreamController;
//   final List<int> _audioBuffer = [];

//   // مجموعة الترددات اللي هنشتغل عليها
//   final List<Map<String, dynamic>> frequencies = [
//     {'note': 'A4', 'frequency': 440.0},
//     {'note': 'C5', 'frequency': 523.25},
//     {'note': 'G4', 'frequency': 295.8},
//     {'note': 'E4', 'frequency': 329.63},
//     {'note': 'D4', 'frequency': 293.66},
//   ];

//   double targetFrequency = 440.0;

//   @override
//   void initState() {
//     super.initState();
//     _pitchDetector = PitchDetector(
//       audioSampleRate: sampleRate,
//       bufferSize: bufferSize,
//     );
//     _initRecorder();
//   }

//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//   }

//   Future<void> _requestPermission() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw 'Microphone permission not granted';
//     }
//   }

//   Future<void> startRecording() async {
//     await _requestPermission();

//     audioStreamController = StreamController<Uint8List>();

//     audioStreamController.stream.listen((Uint8List data) {
//       _processAudioStream(data);
//     });

//     await _recorder.startRecorder(
//       codec: Codec.pcm16,
//       sampleRate: sampleRate.toInt(),
//       numChannels: 1,
//       toStream: audioStreamController.sink,
//     );

//     setState(() {
//       isRecording = true;
//     });
//   }

//   Future<void> stopRecording() async {
//     await _recorder.stopRecorder();
//     await audioStreamController.close();
//     setState(() {
//       isRecording = false;
//     });
//   }

//   void _processAudioStream(Uint8List data) async {
//     final samples = Int16List.view(data.buffer);

//     _audioBuffer.addAll(samples);

//     while (_audioBuffer.length >= bufferSize) {
//       final segment = _audioBuffer.sublist(0, bufferSize);
//       _audioBuffer.removeRange(0, bufferSize);

//       final floatSamples = segment.map((e) => e.toDouble() / 32768.0).toList();

//       try {
//         final pitchResult = await _pitchDetector
//             .getPitchFromFloatBuffer(Float32List.fromList(floatSamples));

//         if (pitchResult.pitch > 0) {
//           setState(() {
//             detectedPitch = pitchResult.pitch;
//           });
//         }
//       } catch (e) {
//         print('خطأ أثناء تحليل الصوت: $e');
//       }
//     }
//   }

//   bool isCloseToTarget(double frequency) {
//     const double tolerance = 15.0;
//     return (frequency - targetFrequency).abs() <= tolerance;
//   }

//   @override
//   void dispose() {
//     _recorder.closeRecorder();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Color backgroundColor = Colors.grey;
//     if (detectedPitch != null) {
//       backgroundColor =
//           isCloseToTarget(detectedPitch!) ? Colors.green : Colors.red;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tuner باستخدام flutter_sound'),
//       ),
//       body: Container(
//         color: backgroundColor,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 detectedPitch != null
//                     ? '${detectedPitch!.toStringAsFixed(2)} Hz'
//                     : 'لا يوجد تردد',
//                 style:
//                     const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'التردد المستهدف: ${targetFrequency.toStringAsFixed(2)} Hz',
//                 style: const TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: isRecording ? stopRecording : startRecording,
//                 child: Text(isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل'),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'اختر تردد للمقارنة:',
//                 style: TextStyle(fontSize: 20),
//               ),
//               Wrap(
//                 spacing: 10,
//                 children: frequencies.map((freq) {
//                   return ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         targetFrequency = freq['frequency'];
//                       });
//                     },
//                     child: Text('${freq['note']} (${freq['frequency']} Hz)'),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tuner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TunerScreen(),
    );
  }
}

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;
  double? detectedPitch;

  final double sampleRate = 44100;
  final int bufferSize = 1024;

  late PitchDetector _pitchDetector;
  late StreamController<Uint8List> audioStreamController;
  final List<int> _audioBuffer = [];

  final List<double> _pitchReadings = [];
  final int _maxReadings = 5;
  double? previousPitch;
  double alpha = 0.2;
  double changeThreshold = 1.0;

  final List<Map<String, dynamic>> frequencies = [
    {'note': 'A4', 'frequency': 440.0},
    {'note': 'C5', 'frequency': 523.25},
    {'note': 'G4', 'frequency': 392.0},
    {'note': 'E4', 'frequency': 329.63},
    {'note': 'D4', 'frequency': 293.66},
  ];

  double targetFrequency = 440.0;

  @override
  void initState() {
    super.initState();
    _pitchDetector = PitchDetector(
      audioSampleRate: sampleRate,
      bufferSize: bufferSize,
    );
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _requestPermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
  }

  Future<void> startRecording() async {
    await _requestPermission();

    audioStreamController = StreamController<Uint8List>();

    audioStreamController.stream.listen((Uint8List data) {
      _processAudioStream(data);
    });

    await _recorder.startRecorder(
      codec: Codec.pcm16,
      sampleRate: sampleRate.toInt(),
      numChannels: 1,
      toStream: audioStreamController.sink,
    );

    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    await audioStreamController.close();
    setState(() {
      isRecording = false;
    });
  }

  void _processAudioStream(Uint8List data) async {
    final samples = Int16List.view(data.buffer);

    _audioBuffer.addAll(samples);

    while (_audioBuffer.length >= bufferSize) {
      final segment = _audioBuffer.sublist(0, bufferSize);
      _audioBuffer.removeRange(0, bufferSize);

      final floatSamples = segment.map((e) => e.toDouble() / 32768.0).toList();

      try {
        final pitchResult = await _pitchDetector
            .getPitchFromFloatBuffer(Float32List.fromList(floatSamples));

        if (pitchResult.pitch > 0) {
          _smoothPitch(pitchResult.pitch);
        }
      } catch (e) {
        print('خطأ أثناء تحليل الصوت: $e');
      }
    }
  }

  void _smoothPitch(double pitch) {
    if (previousPitch == null) {
      previousPitch = pitch;
    } else {
      previousPitch = alpha * pitch + (1 - alpha) * previousPitch!;
    }

    if (_pitchReadings.length >= _maxReadings) {
      _pitchReadings.removeAt(0);
    }
    _pitchReadings.add(previousPitch!);

    double averagePitch =
        _pitchReadings.reduce((a, b) => a + b) / _pitchReadings.length;

    if (detectedPitch == null ||
        (averagePitch - detectedPitch!).abs() > changeThreshold) {
      setState(() {
        detectedPitch = averagePitch;
      });
    }
  }

  bool isCloseToTarget(double frequency) {
    const double tolerance = 15.0;
    return (frequency - targetFrequency).abs() <= tolerance;
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey;
    if (detectedPitch != null) {
      backgroundColor =
          isCloseToTarget(detectedPitch!) ? Colors.green : Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuner باستخدام flutter_sound'),
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                detectedPitch != null
                    ? '${detectedPitch!.toStringAsFixed(2)} Hz'
                    : 'لا يوجد تردد',
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'التردد المستهدف: ${targetFrequency.toStringAsFixed(2)} Hz',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isRecording ? stopRecording : startRecording,
                child: Text(isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل'),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: frequencies.map((freq) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        targetFrequency = freq['frequency'];
                      });
                    },
                    child: Text('${freq['note']} (${freq['frequency']} Hz)'),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
