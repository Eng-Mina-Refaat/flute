import 'package:flute2/business_logic/tuner_cubit/cubit/tuner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TunerScreen extends StatelessWidget {
  final List<Map<String, dynamic>> frequencies = [
    {'note': 'A4', 'frequency': 440.0},
    {'note': 'C5', 'frequency': 523.25},
    {'note': 'G4', 'frequency': 392.0},
    {'note': 'E4', 'frequency': 329.63},
    {'note': 'D4', 'frequency': 293.66},
  ];

  TunerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TunerCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuner'),
      ),
      body: BlocBuilder<TunerCubit, TunerState>(
        builder: (context, state) {
          Color backgroundColor = Colors.grey;
          String pitchText = 'لا يوجد تردد';
          String targetText = '';

          if (state is TunerRecording) {
            pitchText = '${state.pitch.toStringAsFixed(2)} Hz';
            targetText =
                'التردد المستهدف: ${state.targetFrequency.toStringAsFixed(2)} Hz';
            backgroundColor = state.isCloseToTarget ? Colors.green : Colors.red;
          }

          return Container(
            color: backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(pitchText,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text(targetText, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (cubit.isRecording) {
                        cubit.stopRecording();
                      } else {
                        cubit.startRecording();
                      }
                    },
                    child: Text(
                        cubit.isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل'),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: frequencies.map((freq) {
                      return ElevatedButton(
                        onPressed: () {
                          cubit.setTargetFrequency(freq['frequency']);
                        },
                        child:
                            Text('${freq['note']} (${freq['frequency']} Hz)'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
