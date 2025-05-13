import 'dart:io';
import 'package:flute2/business_logic/audio_cubit/audio_cubit.dart';
import 'package:flute2/business_logic/audio_cubit/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  RecordScreenState createState() => RecordScreenState();
}

class RecordScreenState extends State<RecordScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  String? _filePath;
  String? _currentlyPlaying;

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _setupAudioPlayer();
    context.read<RecordCubit>().loadRecords();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم رفض إذن الميكروفون')),
      );
      return;
    }

    try {
      await _recorder.openRecorder();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تهيئة المسجل: $e')),
      );
    }
  }

  void _setupAudioPlayer() {
    _player.onPlayerComplete.listen((_) {
      setState(() => _currentlyPlaying = null);
    });
  }

  Future<void> _startRecording() async {
    final externalDirectory = await getExternalStorageDirectory();
    _filePath =
        "${externalDirectory!.path}/record_${DateTime.now().millisecondsSinceEpoch}.aac";

    await _recorder.startRecorder(toFile: _filePath);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);

    if (_filePath != null) {
      final title = _titleController.text.trim().isNotEmpty
          ? _titleController.text
          : 'تسجيل جديد';
      context.read<RecordCubit>().saveRecord(_filePath!, title);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التسجيل بنجاح')),
      );
    }

    _titleController.clear();
  }

  Future<void> _togglePlayPause(String path) async {
    if (_currentlyPlaying == path) {
      await _player.pause();
      setState(() => _currentlyPlaying = null);
    } else {
      if (_currentlyPlaying != null) {
        await _player.stop();
      }
      await _player.play(UrlSource(path));
      setState(() => _currentlyPlaying = path);
    }
  }

  Future<void> _deleteRecord(int index, String filePath) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'حذف التسجيل',
      desc: 'هل أنت متأكد من حذف التسجيل؟',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          context.read<RecordCubit>().deleteRecording(index);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف التسجيل بنجاح')),
          );
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('التعرف على النغمات'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              margin: EdgeInsets.only(top: 5.h, bottom: 8.h),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'اسم التسجيل',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? "إيقاف التسجيل" : "بدء التسجيل"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : Colors.blue,
              ),
            ),
            SizedBox(height: 10.h),
            BlocBuilder<RecordCubit, RecordState>(
              builder: (context, state) {
                if (state is RecordLoaded) {
                  if (state.records.isEmpty) {
                    return const Center(child: Text("لا توجد تسجيلات."));
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      final record = state.records[index];
                      final isPlaying = _currentlyPlaying == record.filePath;
                      final formattedDate = DateFormat('MMM d, kk:mm aa')
                          .format(record.timestamp);

                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 13.w, vertical: 6.h),
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () {
                              context
                                  .read<RecordCubit>()
                                  .shareRecording(record.filePath);
                            },
                            icon: const Icon(Icons.share),
                          ),
                          title: Text(record.title),
                          subtitle: Text(formattedDate),
                          trailing: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: isPlaying ? Colors.red : Colors.green,
                            ),
                            onPressed: () => _togglePlayPause(record.filePath),
                          ),
                          onLongPress: () =>
                              _deleteRecord(index, record.filePath),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
