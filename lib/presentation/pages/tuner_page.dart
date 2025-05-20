import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:permission_handler/permission_handler.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  StreamSubscription<Uint8List>? _micStream;
  final _pitchDetector =
      PitchDetector(audioSampleRate: 44100, bufferSize: 2048);
  final List<int> _buffer = [];
  double? detectedPitch;
  bool isListening = false;
  double targetFrequency = 440.0;
  String targetNote = 'A4';
  bool isInTune = false;
  String closestNote = '';

  // Smoothing variables
  final List<double> _pitchReadings = [];
  final int _maxReadings = 10; // Number of readings for averaging
  double? _previousPitch;
  final double _alpha = 0.3; // Smoothing factor (0 to 1, lower = smoother)
  final double _minAmplitude = 0.005; // Minimum amplitude threshold
  Timer? _updateTimer; // Timer for throttling UI updates

  // Frequency list from your original code
  final List<Map<String, dynamic>> frequencies = [
    {'note': 'A4', 'frequency': 440.0},
    {'note': 'A3', 'frequency': 219.9},
    {'note': 'F4#', 'frequency': 370.3},
    {'note': 'F3#', 'frequency': 184.8},
    {'note': 'D3', 'frequency': 147.0},
    {'note': 'C3#', 'frequency': 138.4},
    {'note': 'F4', 'frequency': 349.1},
    {'note': 'B4', 'frequency': 493.5},
    {'note': 'C5#', 'frequency': 554.5},
    {'note': 'G5', 'frequency': 784.7},
    {'note': 'G3', 'frequency': 195.9},
    {'note': 'C4#', 'frequency': 277.4},
    {'note': 'D3#', 'frequency': 155.7},
    {'note': 'F5#', 'frequency': 740.9},
    {'note': 'F5', 'frequency': 698.8},
    {'note': 'C3', 'frequency': 130.8},
    {'note': 'G4', 'frequency': 392.1},
    {'note': 'C5', 'frequency': 523.8},
    {'note': 'G3#', 'frequency': 207.5},
    {'note': 'F3', 'frequency': 174.7},
    {'note': 'A3#', 'frequency': 232.9},
    {'note': 'D4#', 'frequency': 310.9},
    {'note': 'G4#', 'frequency': 415.8},
    {'note': 'C4', 'frequency': 216.6},
    {'note': 'D5#', 'frequency': 622.0},
    {'note': 'D4', 'frequency': 293.5},
    {'note': 'D5', 'frequency': 587.4},
    {'note': 'E3', 'frequency': 164.9},
    {'note': 'A4', 'frequency': 439.8},
    {'note': 'B3', 'frequency': 246.7},
    {'note': 'E5', 'frequency': 658.7},
    {'note': 'A4#', 'frequency': 465.8},
    {'note': 'E4', 'frequency': 329.3},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _startListening();
  }

  @override
  void dispose() {
    _stopListening();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _startListening() async {
    if (await Permission.microphone.request().isGranted) {
      _micStream = MicStream.microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 44100,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AudioFormat.ENCODING_PCM_16BIT,
      ).listen((samples) async {
        if (samples.lengthInBytes.isOdd) {
          samples = samples.sublist(0, samples.lengthInBytes - 1);
        }

        final data = Int16List.view(
            samples.buffer, samples.offsetInBytes, samples.lengthInBytes ~/ 2);
        _buffer.addAll(data);

        while (_buffer.length >= 2048) {
          final segment = _buffer.sublist(0, 2048);
          _buffer.removeRange(0, 2048);

          final floatSamples = segment.map((e) => e / 32768.0).toList();
          final amplitude = _calculateRMS(floatSamples);
          if (amplitude < _minAmplitude) {
            _pitchReadings.clear();
            _previousPitch = null;
            return;
          }

          final result = await _pitchDetector
              .getPitchFromFloatBuffer(Float32List.fromList(floatSamples));

          if (result.pitch > 15.0 && result.pitch < 4000.0) {
            _smoothPitch(result.pitch);
          } else {
            _pitchReadings.clear();
            _previousPitch = null;
          }
        }
      }, onError: (e) {
        setState(() {
          detectedPitch = null;
          closestNote = '';
          isInTune = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تدفق الصوت: $e')),
        );
      });

      // Start timer for throttled UI updates
      _updateTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        _updateUI();
      });

      setState(() => isListening = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم منح إذن الميكروفون')),
      );
    }
  }

  void _stopListening() {
    _micStream?.cancel();
    _updateTimer?.cancel();
    setState(() {
      isListening = false;
      detectedPitch = null;
      closestNote = '';
      isInTune = false;
      _pitchReadings.clear();
      _previousPitch = null;
    });
  }

  double _calculateRMS(List<double> samples) {
    double sum = 0;
    for (var sample in samples) {
      sum += sample * sample;
    }
    return math.sqrt(sum / samples.length);
  }

  void _smoothPitch(double pitch) {
    if (_previousPitch == null) {
      _previousPitch = pitch;
    } else {
      _previousPitch = _alpha * pitch + (1 - _alpha) * _previousPitch!;
    }

    _pitchReadings.add(_previousPitch!);
    if (_pitchReadings.length > _maxReadings) {
      _pitchReadings.removeAt(0);
    }
  }

  void _updateUI() {
    if (_pitchReadings.isEmpty) {
      setState(() {
        detectedPitch = null;
        closestNote = '';
        isInTune = false;
      });
      return;
    }

    final averagePitch =
        _pitchReadings.reduce((a, b) => a + b) / _pitchReadings.length;
    setState(() {
      detectedPitch = averagePitch;
      closestNote = _findClosestNote(averagePitch);
      isInTune = _isCloseToTarget(averagePitch, targetFrequency);
    });
  }

  String _findClosestNote(double frequency) {
    double minDifference = double.infinity;
    String closest = '';

    for (var freq in frequencies) {
      double difference = (frequency - freq['frequency']).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closest = freq['note'];
      }
    }

    return closest;
  }

  bool _isCloseToTarget(double frequency, double targetFrequency) {
    final double tolerance =
        targetFrequency < 100 ? 3.0 : (targetFrequency < 500 ? 10.0 : 20.0);
    return (frequency - targetFrequency).abs() <= tolerance;
  }

  String _getNoteDescription(String note) {
    final Map<String, String> noteDescriptions = {
      'A4': 'نغمة لا الوسطى - تستخدم كنغمة مرجعية عالمية للضبط',
      'C5': 'نغمة دو العليا - تستخدم في المقطوعات العالية',
      'G4': 'نغمة صول الوسطى - شائعة في الموسيقى الشعبية',
      'E4': 'نغمة مي الوسطى - أساسية في السلم الموسيقي',
      'D4': 'نغمة ري الوسطى - تستخدم كثيراً في الموسيقى العربية',
      'B4': 'نغمة سي الوسطى - تكمل السلم الموسيقي الأساسي',
      'F4': 'نغمة فا الوسطى - مهمة في التناغم الموسيقي',
      'A3': 'نغمة لا المنخفضة - تعطي عمقاً للصوت',
      'E3': 'نغمة مي المنخفضة - تستخدم في النغمات القاعدية',
    };

    return noteDescriptions[note] ?? 'نغمة موسيقية أساسية';
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey.shade200;
    if (detectedPitch != null) {
      backgroundColor = isInTune ? Colors.green : Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInstructions(context),
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, right: 5, left: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'اختر النغمة المستهدفة:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildFrequencyButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: isListening
                                  ? _stopListening
                                  : _startListening,
                              icon: Icon(
                                isListening ? Icons.stop : Icons.mic,
                                color: Colors.white,
                              ),
                              label: Text(
                                isListening ? 'إيقاف التسجيل' : 'بدء التسجيل',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                backgroundColor:
                                    isListening ? Colors.red : Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              detectedPitch != null
                                  ? '${detectedPitch!.toStringAsFixed(1)} Hz'
                                  : 'لا يوجد تردد',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            if (closestNote.isNotEmpty)
                              Text(
                                'النغمة الأقرب: $closestNote',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Column(
                          children: [
                            _buildNoteImage(targetNote),
                            const SizedBox(height: 16),
                            Text(
                              targetNote,
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _getNoteDescription(targetNote),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 6.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteImage(String note) {
    final Map<String, String> noteImages = {
      'A4': 'assets/images/flute.png',
      'C5': 'assets/images/flute2.jpg',
      'G4': 'assets/images/flute3.jpg',
      'E4': 'assets/images/flute4.jpg',
      'D4': 'assets/images/flute5.jpg',
      'B4': 'assets/images/flute6.jpg',
      'F4': 'assets/images/flute7.jpg',
      'A3': 'assets/images/flute8.png',
      'E3': 'assets/images/flute9.jpg',
    };

    return Container(
      height: 150,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: noteImages.containsKey(note)
          ? Image.asset(
              noteImages[note]!,
              fit: BoxFit.contain,
            )
          : Center(
              child: Icon(
                Icons.music_note,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
    );
  }

  Widget _buildFrequencyButtons(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 10,
      alignment: WrapAlignment.end,
      children: frequencies.map((freq) {
        bool isSelected = targetFrequency == freq['frequency'];
        return ElevatedButton(
          onPressed: () {
            setState(() {
              targetFrequency = freq['frequency'];
              targetNote = freq['note'];
              isInTune = detectedPitch != null
                  ? _isCloseToTarget(detectedPitch!, targetFrequency)
                  : false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.orange : null,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          child: Text(
            '${freq['note']} (${freq['frequency']} Hz)',
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعليمات الاستخدام'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. استخدم الأوتار المفردة عند ضبط الآلة الموسيقية.'),
              Text('2. اعزف بقوة متوسطة ومستمرة لمدة كافية (3-5 ثوانٍ).'),
              Text('3. حافظ على بيئة هادئة قدر الإمكان.'),
              Text('4. ضع الجهاز على مسافة 15-30 سم من الآلة.'),
              Text('5. اختر النغمة المطلوبة من الأزرار في الأسفل.'),
              Text('6. عندما يتحول اللون إلى أخضر، تكون النغمة مضبوطة.'),
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
  }
}
