import 'package:flute2/data/repository/tuner_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/tuner_cubit/cubit/tuner_cubit.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TunerCubit(
        PitchRepository(
          sampleRate: 44100,
          bufferSize: 2048,
        ),
      ),
      child: const _TunerScreenView(),
    );
  }
}

class _TunerScreenView extends StatelessWidget {
  const _TunerScreenView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TunerCubit, TunerState>(
      builder: (context, state) {
        Color backgroundColor = Colors.grey.shade200;
        if (state.detectedPitch != null) {
          backgroundColor = state.isInTune ? Colors.green : Colors.red;
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
                            _buildFrequencyButtons(context, state),
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
                                // Record button
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (state.isRecording) {
                                      context
                                          .read<TunerCubit>()
                                          .stopRecording();
                                    } else {
                                      context
                                          .read<TunerCubit>()
                                          .startRecording();
                                    }
                                  },
                                  icon: Icon(
                                    state.isRecording ? Icons.stop : Icons.mic,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    state.isRecording
                                        ? 'إيقاف التسجيل'
                                        : 'بدء التسجيل',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    backgroundColor: state.isRecording
                                        ? Colors.red
                                        : Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Detected pitch display
                                Text(
                                  state.detectedPitch != null
                                      ? '${state.detectedPitch!.toStringAsFixed(1)} Hz'
                                      : 'لا يوجد تردد',
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (state.closestNote.isNotEmpty)
                                  Text(
                                    'النغمة الأقرب: ${state.closestNote}',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                // Error and warning messages
                                if (state.errorMessage != null)
                                  _buildMessageContainer(
                                      state.errorMessage!, Colors.red),
                                if (state.warningMessage != null)
                                  _buildMessageContainer(
                                      state.warningMessage!, Colors.orange),
                              ],
                            ),
                            const SizedBox(
                                height: 5), // Add spacing between sections
                            // Bottom section: Note image
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildNoteImage(state.targetNote),
                                const SizedBox(height: 16),
                                Text(
                                  state.targetNote,
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'التردد المستهدف: ${state.targetFrequency.toStringAsFixed(1)} Hz',
                                  style: const TextStyle(fontSize: 15),
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
      },
    );
  }

  Widget _buildNoteImage(String note) {
    // Map notes to image assets, including octave
    final Map<String, String> noteImages = {
      'A4': 'assets/images/flute.png', // لنغمة A4
      'C5': 'assets/images/flute2.jpg', // لنغمة C5
      'G4': 'assets/images/flute3.jpg', // لنغمة G4
      'E4': 'assets/images/flute4.jpg', // لنغمة E4
      'D4': 'assets/images/flute5.jpg', // لنغمة D4
      'B4': 'assets/images/flute6.jpg', // لنغمة B4
      'F4': 'assets/images/flute7.jpg', // لنغمة F4
      'A3': 'assets/images/flute8.png', // لنغمة A3
      'E3': 'assets/images/flute9.jpg', // لنغمة E3
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
              fit: BoxFit.contain, // Changed to contain to show full image
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

  Widget _buildMessageContainer(String message, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color, // Fixed: Use the passed color for the background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        overflow: TextOverflow.ellipsis, // Handle long text
        maxLines: 1, // Limit to one line
      ),
    );
  }

  Widget _buildFrequencyButtons(BuildContext context, TunerState state) {
    final frequencies = context.read<TunerCubit>().availableFrequencies;

    return Wrap(
      spacing: 5,
      runSpacing: 10,
      alignment: WrapAlignment.end, // Changed to center for better distribution
      children: frequencies.map((freq) {
        bool isSelected = state.targetFrequency == freq['frequency'];
        return ElevatedButton(
          onPressed: () {
            context.read<TunerCubit>().setTargetFrequency(
                  freq['frequency'],
                  freq['note'],
                );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.orange : null,
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8), // Adjusted padding
          ),
          child: Text(
            '${freq['note']} (${freq['frequency']} Hz)',
            style: const TextStyle(fontSize: 14), // Reduced font size
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
