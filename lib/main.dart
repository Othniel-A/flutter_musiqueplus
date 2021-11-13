import 'package:flutter/material.dart';
import 'package:flutter_musicpplus/acceuil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class Acceuil extends StatefulWidget {
  const Acceuil({Key? key}) : super(key: key);

  @override
  _AcceuilState createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = Tween(begin: 0.0, end: 0.9).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
    /* Timer(
        Duration(seconds: 6),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage())));*/
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  image: AssetImage('assets/image/mi.jpeg'),
                  fit: BoxFit.cover)),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  SlideTransition(
                    position:
                        Tween(begin: const Offset(0.0, -0.9), end: Offset.zero)
                            .animate(controller),
                    child: Container(
                      //decoration: BoxDecoration(color: Colors.blue),
                      child: const Text(
                        'Musique Pour Tous',
                        style: TextStyle(fontFamily: 'Agne', fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
