import 'package:flute2/presentation/pages/flute_pages/insided_flute_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FlutePage extends StatelessWidget {
  final List flutePages = [
    {
      'title': 'نبذة عن آلة الناي',
      "content":
          'يعتبر الناي من أقدم الآلات الموسيقية الشرقية التي استخدمت في الثقافة الموسيقية العربية، والفارسية، والتركية، والناي عبارة عن قصبة مفرغة ومفتوحة من الطرفين، وقد كان يصنع قديماً من نبات القصب أو الريش أو الخيزران أو العاج، وفي الوقت الحالي فإن معظم آلات الناي يتم صنعها من البلاستيك، ويوجد في الناي عدد من الثقوب التي يتم المباعدة بينها عند الصنع حسب نسب وحسابات موسيقية معينة، كما يختلف الناي العربي عن الفارسي والتركي اللذين يختلفان عن بعضهما البعض أيضاً، كما يعتبر الناي أحد أنواع آلة الفلوت؛ إلا أن الفرق بينهما يعود إلى زيادة عدد الثقوب في آلة الفلوت واستخدام بعض المواد المعدنية في صناعة الفلوت.'
    },
    {
      'title': 'أصول آلة الناي في التاريخ',
      "content":
          'يوجد لآلة الناي أصول تاريخية قديمة تعود إلى ما قبل التاريخ؛ حيث تم إيجاد لوحات مرسوم فيها آلة الناي في الكهوف التي تعود للحضارة المصرية القديمة، وتعود هذه الرسوم في تاريخها إلى 5000 عام قبل الميلاد؛ وكان المصريون القدامى يستخدمون آلة الناي في التراتيل والمناسبات الدينية، بالإضافة إلى استخدام السومريين لهذه الآلة في تلك الحقبة الزمنية.'
    },
    {
      'title': ' الأجزاء الرئيسية لناي الفلوت',
      "content":
          """ يتكون ناي الفلوت البسيط من أجزاء رئيسية وبسيطة وفيما يلي نذكرها:
                
قطعة الفم-أنبوب الفم (Mouth piece): وهي الفتحة التي توضع في الفم ويتم النفخ من خلالها، وتسمى أيضاً أنبوب الفم.
                
مفصل الرأس-قطعة النفخ (Head joint): وتسمى أيضاً بالطرف العلوي، أو الطرف القريب، أو الطرف الشمال، وهي عبارة عن نهاية الناي الذي يتم النفخ فيه.
                
مفصل جسم الآلة (body joint): وهو مجسم آلة الفلوت التي تحتوي الثقوب، وقطعة البلوك.
                
قطعة البلوك (Block): وهي قطعة توجد في أنواع معينة من الفلوت، وتعتبر قطعة قابلة للإزالة وتلعب دوراً هاماً في صنع الصوت داخل مجسم الفلوت؛ حيث تقوم بتوجيه الهواء داخل الناي كما تسمى أيضاً بالعصفور أو قطعة التوقف.
                
المَسكن (nest): وهي القطعة التي توجد على سطح ناي الفلوت والتي توجد بداخلها قطعة البلوك.
                
ثقوب الأصابع (Finger holes): وهي الثقوب التي توضع عليها الأصابع وترفع بشكل متوازن عند عزف النوتات على ناي الفلوت، وتسمى أيضاً ثقوب النوتات.
                
مفصل القدم (foot joint): وهو الجزء البعيد أو النهائي من ناي الفلوت ويسمى أيضاً بالقاع أو الطرف الشمالي أو الطرف البعيد.
                
                
                      """
    },
    {
      'title': "أشهر عازفي الناي في العالم",
      "content": """ فيما يلي نذكر أشهر أسماء عازفي الناي في العالم:
عمر بيلديك (Ömer Bildik)
ميركان ديدي (Mercan Dede)
قدسي إرغونر (Kudsi Erguner)
      """
    }
  ];
  FlutePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  // opacity: .9,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/flute9.jpg'))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: screenWidth * .3,
                children: [
                  IconButton(
                      padding: EdgeInsets.only(right: 10),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25,
                      )),
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(
                        'Flute',
                        textStyle: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: flutePages.length,
                itemBuilder: (context, index) {
                  return Opacity(
                    opacity: .8,
                    child: Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InsidedFlutePage(
                                      title: flutePages[index]['title'],
                                      description: flutePages[index]
                                          ['content']))),
                          title: Text(
                            flutePages[index]['title'],
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 3),
                          ),
                          subtitle: Text(
                            flutePages[index]['content'],
                            maxLines: 1,
                            style: TextStyle(
                              wordSpacing: 4,
                              fontSize: 18,
                            ),
                          ),
                        )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
