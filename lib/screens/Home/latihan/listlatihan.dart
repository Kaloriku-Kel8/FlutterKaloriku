import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

void main() {
  runApp(const ListLatihan());
}

class ListLatihan extends StatelessWidget {
  const ListLatihan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ListLatihanScreen(latihanType: 'Kardio'),
    );
  }
}

class ListLatihanScreen extends StatefulWidget {
  final String latihanType;

  const ListLatihanScreen({super.key, required this.latihanType});

  @override
  State<ListLatihanScreen> createState() => _ListLatihanScreenState();
}

class _ListLatihanScreenState extends State<ListLatihanScreen> {
  late List<Map<String, String>> latihanList;

  @override
  void initState() {
    super.initState();
    latihanList = _getLatihanList(widget.latihanType);
  }

  List<Map<String, String>> _getLatihanList(String latihanType) {
    if (latihanType == "Kardio") {
      return [
        {
          "name": "Jogging di Tempat",
          "desc": "Mulai dengan jogging di tempat selama 5-10 menit untuk pemanasan dan meningkatkan detak jantung",
          "image": "assets/images/home/jogging.png"
        },
        {
          "name": "Jumping Jacks",
          "desc": "Gerakan sederhana ini bisa dilakukan dengan melompat sambil melebarkan tangan dan kaki, dilakukan 10-15 kali dalam beberapa set.",
          "image": "assets/images/home/jumpingjack.png"
        },
        {
          "name": "Mountain Climbers",
          "desc": "Latihan ini efektif melatih otot inti dan membakar kalori, dilakukan dengan posisi seperti push-up sambil menekuk kaki bergantian. Lakukan selama 30 detik hingga 1 menit per set.",
          "image": "assets/images/home/mountainclimber.png"
        },
        {
          "name": "High Knees",
          "desc": "Latihan ini meningkatkan detak jantung dan membakar kalori dengan mengangkat lutut secara bergantian seperti berlari di tempat. Lakukan selama 30-60 detik.",
          "image": "assets/images/home/highknees.png"
        },
        {
          "name": "Burpees",
          "desc": "Gerakan burpees melibatkan squat, plank, dan loncatan untuk melatih kekuatan tubuh secara menyeluruh. Cocok dilakukan 10-15 kali per set.",
          "image": "assets/images/home/burpees.png"
        },
        {
          "name": "Squat Jump",
          "desc": "Untuk melatih otot kaki dan kekuatan tubuh, lakukan dengan posisi jongkok, lalu melompat dan kembali ke posisi squat.",
          "image": "assets/images/home/squatjump.png"
        },
        {
          "name": "Lompat Tali (Skipping)",
          "desc": "Jika tersedia, lompat tali adalah latihan yang sangat baik untuk kardio. Mulai dengan sesi singkat, 10-20 kali, dan bertahap meningkatkan waktu.",
          "image": "assets/images/home/skipping.png"
        },
      ];
    } else if (latihanType == "Upper Body") {
      return [
        {
          "name": "Push Up",
          "desc": "Gerakan dasar ini sangat efektif melatih dada, bahu, dan tricep. Mulai dengan posisi plank, turunkan tubuh, dan dorong kembali ke posisi awal. Lakukan sebanyak 20 kali.",
          "image": "assets/images/home/pushup.png"
        },
        {
          "name": "Lat Pulldown (jika memiliki resistance band atau akses ke gym)",
          "desc": "Latihan ini mengaktifkan otot punggung atas, terutama latisimus dorsi. Pegang band atau bar pada mesin lat pulldown, tarik hingga ke dada sambil menekan otot punggung, lakukan sebanyak 10 kali.",
          "image": "assets/images/home/latpulldown.png"
        },
        {
          "name": "Dumbbell Chest Fly",
          "desc": "Latihan ini fokus pada dada. Dengan dumbbell, angkat kedua tangan lurus di atas dada dan turunkan perlahan ke samping. Jangan terlalu rendah agar tidak cedera bahu, lakukan sebanyak 15 kali.",
          "image": "assets/images/home/dumbbell.png"
        },
        {
          "name": "Bicep Curl dengan Dumbbell",
          "desc": "Lakukan bicep curl untuk melatih otot bicep. Pastikan siku tetap dekat dengan tubuh saat menekuk dan meluruskan lengan, lakukan sebanyak 15 kali.",
          "image": "assets/images/home/dumbbellcurl.png"
        },
        {
          "name": "Overhead Shoulder Press",
          "desc": "Berdiri dengan dumbbell di tangan, angkat beban ke atas kepala untuk melatih bahu. Gerakan ini sangat baik untuk kekuatan bahu, lakukan sebanyak 20 kali.",
          "image": "assets/images/home/overhead.png"
        },
        {
          "name": "Bent Over Row",
          "desc": "Untuk punggung bagian tengah dan bawah, lakukan bent-over row dengan dumbbell. Tarik dumbbell ke arah pinggang sambil membungkuk sedikit, sehingga punggung tetap lurus, lakukan sebanyak 20 kali.",
          "image": "assets/images/home/bentover.png"
        },
      ];
    } else if (latihanType == "Lower Body") {
      return [
        {
          "name": "Squat",
          "desc": "Gerakan dasar yang memperkuat otot paha, glutes, dan betis. Berdiri dengan kaki selebar bahu, lalu turunkan tubuh seperti hendak duduk. Lakukan squat sebanyak 15 kali",
          "image": "assets/images/home/pushup.png"
        },
        {
          "name": "Lunges",
          "desc": "Memperkuat otot kaki dan keseimbangan. Mulai dengan kaki sejajar, melangkah satu kaki ke depan dan tekuk lutut hingga membentuk sudut 90 derajat. Lakukan lunges sebanyak 10 kali",
          "image": "assets/images/home/lunges.png"
        },
        {
          "name": "Glute Bridge",
          "desc": "Baik untuk mengaktifkan otot glutes dan hamstring. Berbaring dengan kaki ditekuk dan angkat pinggul hingga tubuh sejajar dari bahu hingga lutut. Lakukan sebanyak 20 kali",
          "image": "assets/images/home/glutebridge.png"
        },
        {
          "name": "Step Ups",
          "desc": "Melatih otot glutes dan paha. Berdiri di depan bangku, naikkan satu kaki ke bangku, dorong tubuh ke atas, lalu kembali ke posisi awal. Lakukan sebanyak 15 kali",
          "image": "assets/images/home/stepup.png"
        },
        {
          "name": "Calf Raises",
          "desc": "Untuk memperkuat otot betis. Berdiri tegak dengan kaki selebar bahu, angkat tubuh hingga bertumpu pada ujung jari kaki, lalu turunkan kembali. Lakukan sebanyak 10 kali",
          "image": "assets/images/home/calfraises.png"
        },
        {
          "name": "Side Lunge",
          "desc": "Melatih keseimbangan dan otot paha dalam. Berdiri dengan kaki lebar, lalu tekuk salah satu kaki ke samping sambil menekuk lutut dan pinggul. Lakukan sebanyak 20 kali",
          "image": "assets/images/home/sidelunge.png"
        },
      ];
    }
    return [];
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      title: Text(widget.latihanType),
      leading: IconButton(
        icon: const Icon(FluentIcons.arrow_left_12_regular),
        onPressed: () {
          Navigator.pop(context); // Go back to the previous screen
        },
      ),
    ),
    backgroundColor: Colors.white, // Set global background color
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: latihanList.length,
        itemBuilder: (context, index) {
          final latihan = latihanList[index];
          return Card(
            color: const Color.fromRGBO(248, 248, 248, 1.0), // Card background color
            elevation: 2, // Add elevation for shadow
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        latihan["image"]!,
                        width: 100, // Adjust image size
                        height: 100, // Adjust image size
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Title of the activity
                  Text(
                    latihan["name"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  // Description of the activity
                  Text(
                    latihan["desc"]!,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
  }
}
