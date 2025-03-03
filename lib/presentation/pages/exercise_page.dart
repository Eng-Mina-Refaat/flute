import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.grey[200],
        child: PageView(
          children: [
            Card(
              child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                    'التدريب على أداء مهارة النغمات الممتدة:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 3),
                  ),
                  subtitle: Text(
                      style: TextStyle(
                        wordSpacing: 4,
                        fontSize: 18,
                      ),
                      """
                      
هذه التدريبات تجعل الطالب قادرا على أداء المهارة بطريقة صحيحة ، فهي متدرجة من السهولة إلى الصعوبه وذلك حسب سهولة وصعوبة أداء المهارات.
                      
بعد الإنتهاء من الأداء الصحيح للتدريبات المقترحة يصبح الطالب قادرأ على أداء المهارة بطريقة صحيحة.
                      
 اسحب الشاشه ناحية اليمين:
                      """)),
            ),
            // ],
            //),
            Card(
              child: Column(
                children: [
                  Text(
                    "التدريب الاول علي أداء مهارة النغمات الممتدة",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/flute.png',
                        height: screenHeight * .22,
                        width: screenWidth,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                          top: 23, left: screenWidth * .175, child: NoteHole()),
                      Positioned(
                          top: 23, left: screenWidth * .602, child: NoteHole()),
                      Positioned(
                          top: 23, left: screenWidth * .54, child: NoteHole()),
                      Positioned(
                          top: 23, left: screenWidth * .66, child: NoteHole()),
                      Positioned(
                          top: 23, left: screenWidth * .73, child: NoteHole()),
                      Positioned(
                          top: 23, left: screenWidth * .782, child: NoteHole()),
                      Positioned(
                          top: 23, left: screenWidth * .854, child: NoteHole())
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoteHole extends StatelessWidget {
  const NoteHole({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم الضغط على ثقب الناي!")),
        );
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      ),
    );
  }
}
