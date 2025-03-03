import 'dart:io';

import 'package:flute2/data/model/record_model.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

// import 'package:path_provider/path_provider.dart';

class RecordRepository {
  final Box<RecordModel> _recordBox = Hive.box<RecordModel>('records');

  Future<void> saveRecord(String filePath, String name) async {
    final record =
        RecordModel(filePath: filePath, timestamp: DateTime.now(), title: name);
    await _recordBox.add(record);
  }

  List<RecordModel> getRecords() {
    return _recordBox.values.toList();
  }

  Future<void> deleteRecording(int index) async {
    var box = Hive.box<RecordModel>('records');
    await box.deleteAt(index);
  }

  Future<void> shareRecording(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out my recording!');
    }
  }
}
