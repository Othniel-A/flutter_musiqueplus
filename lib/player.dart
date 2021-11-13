import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class MyPlayePage extends StatefulWidget {
  final Audio audio;

  const MyPlayePage({Key? key, required this.audio}) : super(key: key);

  @override
  _MyPlayePageState createState() => _MyPlayePageState();
}

class _MyPlayePageState extends State<MyPlayePage>
    with SingleTickerProviderStateMixin {
  late AnimationController iController;
  bool isAnimated = false;
  bool showPlay = false;
  bool showPause = false;
  AssetsAudioPlayer player = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    iController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    player.open(widget.audio, autoStart: false, showNotification: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Flutter Musique'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Icon(CupertinoIcons.backward_fill),
                onTap: () {
                  player.seekBy(Duration(seconds: -10));
                },
              ),
              GestureDetector(
                onTap: () {
                  AnimateIcon();
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: iController,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              InkWell(
                child: Icon(CupertinoIcons.forward_fill),
                onTap: () {
                  player.seekBy(Duration(seconds: 10));
                },
              ),
              InkWell(
                child: Icon(CupertinoIcons.stop_circle),
                onTap: () {
                  player.stop();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void AnimateIcon() {
    setState(() {
      isAnimated = !isAnimated;

      if (isAnimated) {
        iController.forward();
        player.play();
      } else {
        iController.reverse();
        player.pause();
      }
    });
  }

  @override
  void dispose() {
    iController.dispose();
    super.dispose();
  }
}
