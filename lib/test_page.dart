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
import 'dart:math' as Math;

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

// class TunerScreen extends StatefulWidget {
//   const TunerScreen({super.key});

//   @override
//   State<TunerScreen> createState() => _TunerScreenState();
// }

// class _TunerScreenState extends State<TunerScreen> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool isRecording = false;
//   double? detectedPitch;
//   String? errorMessage;
//   String? warningMessage;

//   final double sampleRate = 44100;
//   final int bufferSize = 1024; // Matches incoming chunk sizes

//   late PitchDetector _pitchDetector;
//   late StreamController<Uint8List> audioStreamController;
//   final List<int> _audioBuffer = [];

//   final List<double> _pitchReadings = [];
//   final int _maxReadings = 5;
//   double? previousPitch;
//   double alpha = 0.2;
//   double changeThreshold = 1.0;

//   final List<Map<String, dynamic>> frequencies = [
//     {'note': 'A4', 'frequency': 440.0},
//     {'note': 'C5', 'frequency': 523.25},
//     {'note': 'G4', 'frequency': 392.0},
//     {'note': 'E4', 'frequency': 329.63},
//     {'note': 'D4', 'frequency': 293.66},
//   ];

//   double targetFrequency = 440.0;
//   Timer? _noPitchTimer;

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
//     try {
//       await _recorder.openRecorder();
//       print('Recorder initialized successfully');
//     } catch (e) {
//       setState(() {
//         errorMessage = 'فشل تهيئة المسجل: $e';
//       });
//     }
//   }

//   Future<void> _requestPermission() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw 'Microphone permission not granted';
//     }
//     print('Microphone permission granted');
//   }

//   Future<void> startRecording() async {
//     try {
//       await _requestPermission();

//       audioStreamController = StreamController<Uint8List>();

//       audioStreamController.stream.listen((Uint8List data) {
//         _processAudioStream(data);
//       }, onError: (e) {
//         print('Stream error: $e');
//         setState(() {
//           errorMessage = 'خطأ في تدفق الصوت: $e';
//         });
//       });

//       await _recorder.startRecorder(
//         codec: Codec.pcm16,
//         sampleRate: sampleRate.toInt(),
//         numChannels: 1,
//         toStream: audioStreamController.sink,
//       );

//       setState(() {
//         isRecording = true;
//         errorMessage = null;
//         warningMessage = null;
//       });
//       print('Recording started');

//       // Warn if no valid pitch after 5 seconds
//       _noPitchTimer = Timer(const Duration(seconds: 5), () {
//         if (detectedPitch == null && isRecording) {
//           setState(() {
//             warningMessage =
//                 'لم يتم اكتشاف تردد صالح. جرب نغمة واضحة بصوت معتدل بعيدًا عن التشويش.';
//           });
//         }
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'فشل بدء التسجيل: $e';
//       });
//       print('Error starting recording: $e');
//     }
//   }

//   Future<void> stopRecording() async {
//     try {
//       await _recorder.stopRecorder();
//       await audioStreamController.close();
//       _noPitchTimer?.cancel();
//       setState(() {
//         isRecording = false;
//         detectedPitch = null;
//         errorMessage = null;
//         warningMessage = null;
//       });
//       print('Recording stopped');
//     } catch (e) {
//       setState(() {
//         errorMessage = 'فشل إيقاف التسجيل: $e';
//       });
//       print('Error stopping recording: $e');
//     }
//   }

//   void _processAudioStream(Uint8List data) async {
//     try {
//       final samples = Int16List.view(data.buffer);
//       print('Received audio data: ${samples.length} samples');

//       _audioBuffer.addAll(samples);

//       // Process audio in chunks of bufferSize
//       while (_audioBuffer.length >= bufferSize) {
//         final segment = _audioBuffer.sublist(0, bufferSize);
//         _audioBuffer.removeRange(0, bufferSize);

//         // Normalize samples with dynamic gain control
//         final floatSamples = segment.map((e) {
//           final normalized = e.toDouble() / 32768.0;
//           return normalized.clamp(-0.999, 0.999); // Prevent clipping
//         }).toList();

//         // Check amplitude
//         final amplitude =
//             floatSamples.reduce((a, b) => a.abs() > b.abs() ? a : b).abs();
//         print('Amplitude: $amplitude');

//         // Apply gain reduction if amplitude is too high
//         double gain = 1.0;
//         if (amplitude > 0.8) {
//           gain = 0.8 / amplitude; // Scale down to keep amplitude below 0.8
//           print('Applying gain reduction: $gain');
//           for (int i = 0; i < floatSamples.length; i++) {
//             floatSamples[i] *= gain;
//           }
//         }

//         // Recheck amplitude after gain adjustment
//         final adjustedAmplitude =
//             floatSamples.reduce((a, b) => a.abs() > b.abs() ? a : b).abs();
//         print('Adjusted amplitude: $adjustedAmplitude');

//         if (adjustedAmplitude < 0.01) {
//           print('Audio amplitude too low, skipping pitch detection');
//           setState(() {
//             warningMessage = 'الصوت منخفض جدًا. ارفع مستوى الصوت قليلاً.';
//           });
//           return;
//         }

//         // Log first 5 samples for debugging
//         print('Sample values (first 5): ${floatSamples.take(5).toList()}');

//         final pitchResult = await _pitchDetector.getPitchFromFloatBuffer(
//           Float32List.fromList(floatSamples),
//         );

//         print('Pitch result: ${pitchResult.pitch} Hz');
//         // Validate pitch (20 Hz to 2000 Hz for musical notes)
//         if (pitchResult.pitch > 20 && pitchResult.pitch < 2000) {
//           _smoothPitch(pitchResult.pitch);
//         } else {
//           print('Invalid pitch detected: ${pitchResult.pitch} Hz');
//           setState(() {
//             warningMessage =
//                 'تردد غير صالح. تأكد من تشغيل نغمة واضحة بصوت معتدل.';
//           });
//         }
//       }

//       // Handle partial buffer
//       if (_audioBuffer.length > 0 && _audioBuffer.length < bufferSize) {
//         print(
//             'Partial buffer: ${_audioBuffer.length} samples, waiting for more data');
//       }
//     } catch (e) {
//       print('Error processing audio: $e');
//       setState(() {
//         errorMessage = 'خطأ أثناء تحليل الصوت: $e';
//       });
//     }
//   }

//   void _smoothPitch(double pitch) {
//     if (previousPitch == null) {
//       previousPitch = pitch;
//     } else {
//       previousPitch = alpha * pitch + (1 - alpha) * previousPitch!;
//     }

//     if (_pitchReadings.length >= _maxReadings) {
//       _pitchReadings.removeAt(0);
//     }
//     _pitchReadings.add(previousPitch!);

//     double averagePitch =
//         _pitchReadings.reduce((a, b) => a + b) / _pitchReadings.length;

//     if (detectedPitch == null ||
//         (averagePitch - detectedPitch!).abs() > changeThreshold) {
//       setState(() {
//         detectedPitch = averagePitch;
//         errorMessage = null;
//         warningMessage = null;
//         _noPitchTimer?.cancel();
//       });
//       print('Detected pitch: $averagePitch Hz');
//     }
//   }

//   bool isCloseToTarget(double frequency) {
//     const double tolerance = 20.0;
//     return (frequency - targetFrequency).abs() <= tolerance;
//   }

//   @override
//   void dispose() {
//     _recorder.closeRecorder();
//     if (isRecording) {
//       audioStreamController.close();
//     }
//     _noPitchTimer?.cancel();
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
//               if (errorMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     errorMessage!,
//                     style: const TextStyle(color: Colors.red, fontSize: 16),
//                   ),
//                 ),
//               if (warningMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     warningMessage!,
//                     style: const TextStyle(color: Colors.orange, fontSize: 16),
//                   ),
//                 ),
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

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;
  double? detectedPitch;
  String? errorMessage;
  String? warningMessage;

  final double sampleRate = 44100;
  final int bufferSize = 2048; // زيادة حجم البفر لنتائج أدق

  late PitchDetector _pitchDetector;
  late StreamController<Uint8List> audioStreamController;
  final List<int> _audioBuffer = [];

  final List<double> _pitchReadings = [];
  final int _maxReadings =
      10; // زيادة عدد القراءات للحصول على متوسط أكثر استقرارًا
  double? previousPitch;
  double alpha = 0.3; // زيادة تأثير القراءات الجديدة
  double changeThreshold =
      0.5; // تقليل عتبة التغيير لتحديث التردد بشكل أكثر استجابة
  int _invalidPitchCount = 0;

  // إضافة نطاق تردد أوسع للتردد الصالح
  final double minValidFrequency = 15.0; // خفض الحد الأدنى
  final double maxValidFrequency = 4000.0; // زيادة الحد الأقصى

  List<Map<String, dynamic>> frequencies = [
    {'note': 'A4', 'frequency': 440.0},
    {'note': 'C5', 'frequency': 523.25},
    {'note': 'G4', 'frequency': 392.0},
    {'note': 'E4', 'frequency': 329.63},
    {'note': 'D4', 'frequency': 293.66},
    {'note': 'B4', 'frequency': 493.88},
    {'note': 'F4', 'frequency': 349.23},
    {'note': 'A3', 'frequency': 220.0},
    {'note': 'E3', 'frequency': 164.81},
  ];

  double targetFrequency = 440.0;
  Timer? _noPitchTimer;

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
    try {
      await _recorder.openRecorder();
    } catch (e) {
      setState(() {
        errorMessage = 'فشل تهيئة المسجل: $e';
      });
    }
  }

  Future<void> _requestPermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
  }

  Future<void> startRecording() async {
    try {
      await _requestPermission();

      audioStreamController = StreamController<Uint8List>();

      audioStreamController.stream.listen((Uint8List data) {
        _processAudioStream(data);
      }, onError: (e) {
        setState(() {
          errorMessage = 'خطأ في تدفق الصوت: $e';
        });
      });

      await _recorder.startRecorder(
        codec: Codec.pcm16,
        sampleRate: sampleRate.toInt(),
        numChannels: 1,
        toStream: audioStreamController.sink,
      );

      setState(() {
        isRecording = true;
        errorMessage = null;
        warningMessage = null;
        detectedPitch = null; // إعادة ضبط التردد المكتشف عند بدء تسجيل جديد
        _invalidPitchCount = 0; // إعادة ضبط عداد الترددات غير الصالحة
        _pitchReadings.clear(); // إعادة ضبط قراءات التردد السابقة
        previousPitch = null; // إعادة ضبط التردد السابق
      });

      // تحذير إذا لم يتم اكتشاف أي تردد بعد 5 ثوانٍ
      _noPitchTimer = Timer(const Duration(seconds: 5), () {
        if (detectedPitch == null && isRecording) {
          setState(() {
            warningMessage =
                'لم يتم اكتشاف تردد صالح. جرب نغمة واضحة بصوت معتدل بعيدًا عن التشويش.';
          });
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'فشل بدء التسجيل: $e';
      });
    }
  }

  Future<void> stopRecording() async {
    try {
      await _recorder.stopRecorder();
      await audioStreamController.close();
      _noPitchTimer?.cancel();
      setState(() {
        isRecording = false;
        detectedPitch = null;
        errorMessage = null;
        warningMessage = null;
        _invalidPitchCount = 0;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'فشل إيقاف التسجيل: $e';
      });
    }
  }

  void _processAudioStream(Uint8List data) async {
    try {
      final samples = Int16List.view(data.buffer);
      _audioBuffer.addAll(samples);

      // Process audio in chunks of bufferSize
      while (_audioBuffer.length >= bufferSize) {
        final segment = _audioBuffer.sublist(0, bufferSize);
        _audioBuffer.removeRange(0, bufferSize);

        // تطبيق نافذة Hanning لتحسين تحليل التردد وتقليل التسرب الطيفي
        final windowedSamples = _applyWindow(segment);

        // التحقق من مستوى الصوت باستخدام RMS
        final amplitude = _calculateRMS(windowedSamples);

        // تعديل عتبة مستوى الصوت المنخفض
        if (amplitude < 0.005) {
          // خفض العتبة لزيادة الحساسية
          setState(() {
            warningMessage = 'الصوت منخفض جدًا. ارفع مستوى الصوت قليلاً.';
          });
          continue; // تخطي هذه الدفعة والانتقال للتالية
        } else {
          // مسح الرسالة إذا كان مستوى الصوت مقبولاً
          if (warningMessage == 'الصوت منخفض جدًا. ارفع مستوى الصوت قليلاً.') {
            setState(() {
              warningMessage = null;
            });
          }
        }

        // طباعة القيم الأولى للتصحيح

        final pitchResult = await _pitchDetector.getPitchFromFloatBuffer(
          Float32List.fromList(windowedSamples),
        );

        // تحسين التحقق من صلاحية التردد
        if (pitchResult.pitch > minValidFrequency &&
            pitchResult.pitch < maxValidFrequency) {
          // تحقق إضافي من الثقة في النتيجة (اختياري إذا كان PitchDetector يدعم هذه الخاصية)
          _smoothPitch(pitchResult.pitch);

          // مسح رسالة التحذير إذا تم اكتشاف تردد صالح
          if (warningMessage ==
              'تردد غير صالح. تأكد من تشغيل نغمة واضحة بصوت معتدل.') {
            setState(() {
              warningMessage = null;
            });
          }
        } else {
          // تعديل فترة إظهار رسالة التردد غير الصالح
          // لا تظهر الرسالة إلا بعد عدة محاولات فاشلة
          _invalidPitchCount++;
          if (_invalidPitchCount > 5) {
            // عرض الرسالة بعد 5 محاولات فاشلة
            setState(() {
              warningMessage =
                  'تردد غير صالح. تأكد من تشغيل نغمة واضحة بصوت معتدل.';
            });
          }
        }
      }

      // التعامل مع البافر الجزئي
      if (_audioBuffer.isNotEmpty && _audioBuffer.length < bufferSize) {
        print(
            'Partial buffer: ${_audioBuffer.length} samples, waiting for more data');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'خطأ أثناء تحليل الصوت: $e';
      });
    }
  }

  // إضافة طريقة لتطبيق نافذة Hanning على العينات
  List<double> _applyWindow(List<int> samples) {
    final List<double> windowedSamples = List<double>.filled(samples.length, 0);

    for (int i = 0; i < samples.length; i++) {
      // تطبيق نافذة Hanning: 0.5 * (1 - cos(2π*n/(N-1)))
      double windowCoefficient =
          0.5 * (1 - Math.cos(2 * Math.pi * i / (samples.length - 1)));

      // تطبيق المعامل وتطبيع القيمة
      windowedSamples[i] =
          (samples[i].toDouble() / 32768.0) * windowCoefficient;
    }

    return windowedSamples;
  }

  // حساب قيمة RMS للإشارة (مقياس أفضل لمستوى الصوت)
  double _calculateRMS(List<double> samples) {
    double sum = 0;
    for (int i = 0; i < samples.length; i++) {
      sum += samples[i] * samples[i];
    }
    return Math.sqrt(sum / samples.length);
  }

  void _smoothPitch(double pitch) {
    // إعادة ضبط عداد التردد غير الصالح
    _invalidPitchCount = 0;

    if (previousPitch == null) {
      previousPitch = pitch;
    } else {
      // تطبيق فلتر إضافي للتخلص من القيم المتطرفة
      if ((pitch - previousPitch!).abs() > previousPitch! * 0.5) {
        // تجاهل القيم المتطرفة التي تختلف كثيرًا عن القيمة السابقة
        return;
      }

      previousPitch = alpha * pitch + (1 - alpha) * previousPitch!;
    }

    if (_pitchReadings.length >= _maxReadings) {
      _pitchReadings.removeAt(0);
    }
    _pitchReadings.add(previousPitch!);

    // استخدام متوسط النصف الأخير من القراءات فقط
    int startIdx = Math.max(0, _pitchReadings.length - (_maxReadings ~/ 2));
    double averagePitch =
        _pitchReadings.sublist(startIdx).reduce((a, b) => a + b) /
            (_pitchReadings.length - startIdx);

    if (detectedPitch == null ||
        (averagePitch - detectedPitch!).abs() > changeThreshold) {
      setState(() {
        detectedPitch = averagePitch;
        errorMessage = null;

        // تحديث الرسالة فقط إذا كان هناك تحذير عن تردد غير صالح
        if (warningMessage ==
            'تردد غير صالح. تأكد من تشغيل نغمة واضحة بصوت معتدل.') {
          warningMessage = null;
        }

        _noPitchTimer?.cancel();
      });
    }
  }

  // تحسين قيم التسامح مع الترددات القريبة من المستهدفة
  double getTolerance(double freq) {
    // التسامح يتناسب مع التردد (كلما زاد التردد زاد التسامح)
    return freq < 100 ? 3.0 : (freq < 500 ? 10.0 : 20.0);
  }

  bool isCloseToTarget(double frequency) {
    final double tolerance = getTolerance(targetFrequency);
    return (frequency - targetFrequency).abs() <= tolerance;
  }

  // إضافة وظيفة لاقتراح النغمة الأقرب للتردد المكتشف
  String findClosestNote(double frequency) {
    double minDifference = double.infinity;
    String closestNote = '';

    for (var freq in frequencies) {
      double difference = (frequency - freq['frequency']).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestNote = freq['note'];
      }
    }

    return closestNote;
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    if (isRecording) {
      audioStreamController.close();
    }
    _noPitchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey;
    if (detectedPitch != null) {
      backgroundColor =
          isCloseToTarget(detectedPitch!) ? Colors.green : Colors.red;
    }

    // اقتراح النغمة الأقرب
    String closestNote =
        detectedPitch != null ? findClosestNote(detectedPitch!) : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuner المحسن'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تعليمات الاستخدام'),
                  content: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '1. استخدم الأوتار المفردة عند ضبط الآلة الموسيقية.'),
                        Text(
                            '2. اعزف بقوة متوسطة ومستمرة لمدة كافية (3-5 ثوانٍ).'),
                        Text('3. حافظ على بيئة هادئة قدر الإمكان.'),
                        Text('4. ضع الجهاز على مسافة 15-30 سم من الآلة.'),
                        Text('5. اختر النغمة المطلوبة من الأزرار في الأسفل.'),
                        Text(
                            '6. عندما يتحول اللون إلى أخضر، تكون النغمة مضبوطة.'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('فهمت'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                detectedPitch != null
                    ? '${detectedPitch!.toStringAsFixed(1)} Hz'
                    : 'لا يوجد تردد',
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              if (closestNote.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'النغمة الأقرب: $closestNote',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              if (warningMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      warningMessage!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'التردد المستهدف: ${targetFrequency.toStringAsFixed(1)} Hz ($closestNote)',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isRecording ? stopRecording : startRecording,
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
                label: Text(
                  isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: isRecording ? Colors.red : Colors.blue,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'اختر النغمة المستهدفة:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: frequencies.map((freq) {
                  bool isSelected = targetFrequency == freq['frequency'];
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        targetFrequency = freq['frequency'];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.deepPurple : null,
                    ),
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
