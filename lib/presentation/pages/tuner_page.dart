// import 'package:flute2/business_logic/tuner_cubit/cubit/tuner_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class TunerScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> frequencies = [
//     {'note': 'A4', 'frequency': 440.0},
//     {'note': 'C5', 'frequency': 523.25},
//     {'note': 'G4', 'frequency': 392.0},
//     {'note': 'E4', 'frequency': 329.63},
//     {'note': 'D4', 'frequency': 293.66},
//   ];

//   TunerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<TunerCubit>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tuner'),
//       ),
//       body: BlocBuilder<TunerCubit, TunerState>(
//         builder: (context, state) {
//           Color backgroundColor = Colors.grey;
//           String pitchText = 'لا يوجد تردد';
//           String targetText = '';

//           if (state is TunerRecording) {
//             pitchText = '${state.pitch.toStringAsFixed(2)} Hz';
//             targetText =
//                 'التردد المستهدف: ${state.targetFrequency.toStringAsFixed(2)} Hz';
//             backgroundColor = state.isCloseToTarget ? Colors.green : Colors.red;
//           }

//           return Container(
//             color: backgroundColor,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(pitchText,
//                       style: const TextStyle(
//                           fontSize: 32, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 20),
//                   Text(targetText, style: const TextStyle(fontSize: 20)),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (cubit.isRecording) {
//                         cubit.stopRecording();
//                       } else {
//                         cubit.startRecording();
//                       }
//                     },
//                     child: Text(
//                         cubit.isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل'),
//                   ),
//                   const SizedBox(height: 20),
//                   Wrap(
//                     spacing: 10,
//                     children: frequencies.map((freq) {
//                       return ElevatedButton(
//                         onPressed: () {
//                           cubit.setTargetFrequency(freq['frequency']);
//                         },
//                         child:
//                             Text('${freq['note']} (${freq['frequency']} Hz)'),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flute2/data/repository/tuner_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../business_logic/tuner_cubit/cubit/tuner_cubit.dart';

// class TunerScreen extends StatelessWidget {
//   const TunerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Create repository and cubit
//     return BlocProvider(
//       create: (context) => TunerCubit(
//         PitchRepository(
//           sampleRate: 44100,
//           bufferSize: 2048,
//         ),
//       ),
//       child: const _TunerScreenView(),
//     );
//   }
// }

// class _TunerScreenView extends StatelessWidget {
//   const _TunerScreenView();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TunerCubit, TunerState>(
//       builder: (context, state) {
//         // Define background color based on tuning state
//         Color backgroundColor = Colors.grey;
//         if (state.detectedPitch != null) {
//           backgroundColor = state.isInTune ? Colors.green : Colors.red;
//         }

//         // Deviation calculation
//         double? deviation = state.detectedPitch != null
//             ? state.detectedPitch! - state.targetFrequency
//             : null;
//         String deviationText = deviation != null
//             ? (deviation > 0
//                 ? '+${deviation.toStringAsFixed(1)}'
//                 : '${deviation.toStringAsFixed(1)}')
//             : '';

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Tuner المحسن'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.info_outline),
//                 onPressed: () => _showInstructions(context),
//               ),
//             ],
//           ),
//           body: Container(
//             color: backgroundColor,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Detected pitch display
//                   Text(
//                     state.detectedPitch != null
//                         ? '${state.detectedPitch!.toStringAsFixed(1)} Hz'
//                         : 'لا يوجد تردد',
//                     style: const TextStyle(
//                         fontSize: 36, fontWeight: FontWeight.bold),
//                   ),

//                   // Closest note display
//                   if (state.closestNote.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'النغمة الأقرب: ${state.closestNote}',
//                         style: const TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                     ),

//                   // Error message display
//                   if (state.errorMessage != null)
//                     _buildMessageContainer(state.errorMessage!, Colors.red),

//                   // Warning message display
//                   if (state.warningMessage != null)
//                     _buildMessageContainer(
//                         state.warningMessage!, Colors.orange),

//                   const SizedBox(height: 20),

//                   // Target frequency display
//                   Text(
//                     'التردد المستهدف: ${state.targetFrequency.toStringAsFixed(1)} Hz (${state.targetNote})',
//                     style: const TextStyle(fontSize: 20),
//                   ),

//                   const SizedBox(height: 20),

//                   // Record button
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       if (state.isRecording) {
//                         context.read<TunerCubit>().stopRecording();
//                       } else {
//                         context.read<TunerCubit>().startRecording();
//                       }
//                     },
//                     icon: Icon(state.isRecording ? Icons.stop : Icons.mic),
//                     label: Text(
//                       state.isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل',
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 12),
//                       backgroundColor:
//                           state.isRecording ? Colors.red : Colors.blue,
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // Note selector
//                   const Text(
//                     'اختر النغمة المستهدفة:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 10),

//                   // Frequency buttons
//                   _buildFrequencyButtons(context, state),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMessageContainer(String message, Color color) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.7),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           message,
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildFrequencyButtons(BuildContext context, TunerState state) {
//     final frequencies = context.read<TunerCubit>().availableFrequencies;

//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       alignment: WrapAlignment.center,
//       children: frequencies.map((freq) {
//         bool isSelected = state.targetFrequency == freq['frequency'];
//         return ElevatedButton(
//           onPressed: () {
//             context.read<TunerCubit>().setTargetFrequency(
//                   freq['frequency'],
//                   freq['note'],
//                 );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: isSelected ? Colors.deepPurple : null,
//           ),
//           child: Text('${freq['note']} (${freq['frequency']} Hz)'),
//         );
//       }).toList(),
//     );
//   }

//   void _showInstructions(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('تعليمات الاستخدام'),
//         content: const SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('1. استخدم الأوتار المفردة عند ضبط الآلة الموسيقية.'),
//               Text('2. اعزف بقوة متوسطة ومستمرة لمدة كافية (3-5 ثوانٍ).'),
//               Text('3. حافظ على بيئة هادئة قدر الإمكان.'),
//               Text('4. ضع الجهاز على مسافة 15-30 سم من الآلة.'),
//               Text('5. اختر النغمة المطلوبة من الأزرار في الأسفل.'),
//               Text('6. عندما يتحول اللون إلى أخضر، تكون النغمة مضبوطة.'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('فهمت'),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
    // Set preferred orientations to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset orientation when leaving this screen
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
    // Create repository and cubit
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
        // Define background color based on tuning state
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
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left panel - Note image and information
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Note image
                          _buildNoteImage(state.targetNote),

                          const SizedBox(height: 16),

                          // Target note and frequency
                          Text(
                            state.targetNote,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'التردد المستهدف: ${state.targetFrequency.toStringAsFixed(1)} Hz',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Right panel - Tuner controls and readings
                Expanded(
                  flex: 3,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Detected pitch display
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      state.detectedPitch != null
                                          ? '${state.detectedPitch!.toStringAsFixed(1)} Hz'
                                          : 'لا يوجد تردد',
                                      style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (state.closestNote.isNotEmpty)
                                      Text(
                                        'النغمة الأقرب: ${state.closestNote}',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ],
                                ),
                              ],
                            ),

                            // Error and warning messages
                            if (state.errorMessage != null)
                              _buildMessageContainer(
                                  state.errorMessage!, Colors.red),
                            if (state.warningMessage != null)
                              _buildMessageContainer(
                                  state.warningMessage!, Colors.orange),

                            // Record button
                            ElevatedButton.icon(
                              onPressed: () {
                                if (state.isRecording) {
                                  context.read<TunerCubit>().stopRecording();
                                } else {
                                  context.read<TunerCubit>().startRecording();
                                }
                              },
                              icon: Icon(
                                  state.isRecording ? Icons.stop : Icons.mic),
                              label: Text(
                                state.isRecording
                                    ? 'إيقاف التسجيل'
                                    : 'بدء التسجيل',
                                style: const TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                backgroundColor: state.isRecording
                                    ? Colors.red
                                    : Colors.blue,
                              ),
                            ),

                            // Note selector
                            Column(
                              children: [
                                const Text(
                                  'اختر النغمة المستهدفة:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                _buildFrequencyButtons(context, state),
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
    // Map notes to image assets
    final Map<String, String> noteImages = {
      'C': 'assets/images/flute.png',
      'C#': 'assets/images/flute2.jpg',
      'D': 'assets/images/flute3.jpg',
      'D#': 'assets/images/flute4.jpg',
      'E': 'assets/images/flute5.jpg',
      'F': 'assets/images/flute6.jpg',
      'F#': 'assets/images/flute7.jpg',
      'G': 'assets/images/flute8.png',
      'G#': 'assets/images/flute9.jpg',
      'A': 'assets/images/flute10.jpg',
      'A#': 'assets/images/flute11.jpg',
      'B': 'assets/images/flute20.png',
    };

    // Extract the base note (remove octave number if present)
    String baseNote = note.replaceAll(RegExp(r'[0-9]'), '');

    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: noteImages.containsKey(baseNote)
          ? Image.asset(
              noteImages[baseNote]!,
              fit: BoxFit.contain,
            )
          : Center(
              child: Icon(
                Icons.music_note,
                size: 80,
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildFrequencyButtons(BuildContext context, TunerState state) {
    final frequencies = context.read<TunerCubit>().availableFrequencies;

    return Wrap(
      spacing: 5,
      runSpacing: 8,
      alignment: WrapAlignment.end,
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
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          ),
          child: Text('${freq['note']} (${freq['frequency']} Hz)'),
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
