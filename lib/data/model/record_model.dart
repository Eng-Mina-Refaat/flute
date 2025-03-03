import 'package:hive/hive.dart';

part 'record_model.g.dart';

@HiveType(typeId: 0)
class RecordModel extends HiveObject {
  @HiveField(0)
  final String filePath;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String title;

  RecordModel(
      {required this.filePath, required this.timestamp, required this.title});
}
