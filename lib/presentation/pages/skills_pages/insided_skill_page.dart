import 'package:flute2/presentation/pages/audio_screen2.dart';
import 'package:flute2/presentation/pages/exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InsidedSkillPage extends StatefulWidget {
  const InsidedSkillPage({super.key});

  @override
  State<InsidedSkillPage> createState() => _InsidedSkillPageState();
}

class _InsidedSkillPageState extends State<InsidedSkillPage> {
  bool keepLandscape = true;
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
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: Text('شاهد'),
          ),
          FloatingActionButton(
            foregroundColor: Colors.black,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExercisePage())),
            child: Text('تدريب'),
          ),
          FloatingActionButton(
            foregroundColor: Colors.black,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecordScreen())),
            child: Text('تسجيل'),
          )
          // TextButton(onPressed: () {}, child: Text("data"))
        ],
      ),
      appBar: AppBar(),
    );
  }
}
