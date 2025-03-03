import 'package:flute2/business_logic/audio_cubit/audio_cubit.dart';
import 'package:flute2/business_logic/tuner_cubit/cubit/tuner_cubit.dart';
import 'package:flute2/data/repository/recordrepository.dart';
import 'package:flute2/data/model/record_model.dart';
import 'package:flute2/presentation/pages/home_page.dart';
import 'package:flute2/test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getExternalStorageDirectory();
  await Hive.initFlutter(appDocumentDir!.path);
  Hive.registerAdapter(RecordModelAdapter());
  await Hive.openBox<RecordModel>('records');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get audioRepository => null;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecordCubit(RecordRepository()),
        ),
        BlocProvider(
          create: (context) =>
              TunerCubit(audioRepository: audioRepository)..init(),
        )
      ],
      child: MaterialApp(
        locale: Locale('ar', 'EG'),
        supportedLocales: [
          Locale('ar', 'EG'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: TunerScreen(),
      ),
    );
  }
}
