import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.grey[200],
        child: PageView(
          children: [
            Card(
              child: ListTile(
                  contentPadding: EdgeInsets.all(8.r),
                  title: Text(
                    'التدريب على أداء مهارة النغمات الممتدة:',
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 3),
                  ),
                  subtitle: Text(
                      style: TextStyle(
                        wordSpacing: 4,
                        fontSize: 8.sp,
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
                    style:
                        TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/flute.png',
                        height: 140.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(top: 35.h, left: 63.5.w, child: NoteHole()),
                      Positioned(top: 33.h, left: 217.w, child: NoteHole()),
                      Positioned(top: 33.h, left: 194.w, child: NoteHole()),
                      Positioned(top: 33.h, left: 238.w, child: NoteHole()),
                      Positioned(top: 33.h, left: 263.w, child: NoteHole()),
                      Positioned(top: 33.h, left: 282.w, child: NoteHole()),
                      Positioned(top: 33.h, left: 308.w, child: NoteHole())
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
