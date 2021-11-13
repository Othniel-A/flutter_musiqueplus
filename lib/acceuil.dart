import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_musicpplus/PositionSeekWidget.dart';
import 'package:flutter_musicpplus/player.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //AssetsAudioPlayer player = AssetsAudioPlayer();
  late AnimationController iController;
  bool isAnimated = false;
  bool showPlay = false;
  bool showPause = false;
  Duration duration = Duration();
  Duration position = Duration();

  get value => position.inSeconds.toDouble();
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _assetsAudioPlayer.seek(newDuration);
  }

  List<Audio> audios = [
    Audio(
      "assets/ins.mp3",
      metas: Metas(
        id: 'Instrumental',
        title: 'Instrumental',
        artist: 'Florent Champigny',
        album: 'InstrumentalAlbum',
        image: MetasImage.network(
            'https://99designs-blog.imgix.net/blog/wp-content/uploads/2017/12/attachment_68585523.jpg'),
      ),
    ),
    Audio(
      'assets/hip.mp3',
      metas: Metas(
        id: 'Hiphop',
        title: 'HipHop',
        artist: 'Florent Champigny',
        album: 'HipHopAlbum',
        image: MetasImage.network(
            'https://beyoudancestudio.ch/wp-content/uploads/2019/01/apprendre-danser.hiphop-1.jpg'),
      ),
    ),
    Audio(
      'assets/elec.mp3',
      metas: Metas(
        id: 'Electronics',
        title: 'Electronic',
        artist: 'Florent Champigny',
        album: 'ElectronicAlbum',
        image: MetasImage.network(
            'https://99designs-blog.imgix.net/blog/wp-content/uploads/2017/12/attachment_68585523.jpg'),
      ),
    ),
  ];
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  // AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  @override
  void initState() {
    super.initState();
    iController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    openPlayerinitial();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    iController.dispose();
    print('dispose');
    super.dispose();
  }

  void openPlayerinitial() async {
    await _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: 0),
      showNotification: true,
      autoStart: false,
    );
  }

  openPlayer(Audio audio) async {
    iController.reverse();
    _assetsAudioPlayer.pause();
    await _assetsAudioPlayer.open(
      audio,
      showNotification: true,
      autoStart: false,
    );
  }

  void AnimateIcon() {
    isAnimated = !isAnimated;
    if (isAnimated) {
      iController.forward();
      _assetsAudioPlayer.play();
    } else {
      iController.reverse();
      _assetsAudioPlayer.pause();
    }
  }

  //Audio find(List<Audio> source, String fromPath) {
  //return source.firstWhere((element) => element.path == fromPath);
  //}

  @override
  Widget build(BuildContext context) {
    var hauteur = MediaQuery.of(context).size.height;
    var largeur = MediaQuery.of(context).size.width;
    print('la hauteur est :$hauteur');
    print('la largeur  est :$largeur');

    return Scaffold(
      appBar: AppBar(
        title: const Text(('Bienvenue Player')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(color: Colors.blue),
                height: (2 * hauteur) / 3,
                width: largeur,
                child: Column(
                  children: [
                    _assetsAudioPlayer.builderCurrent(
                      builder: (BuildContext context, Playing? playing) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: audios.length,
                            itemBuilder: (context, index) {
                              final item = audios[index];
                              final isPlaying =
                                  item.path == playing?.audio.assetAudioPath;
                              return ListTile(
                                title: Text(
                                  item.metas.title.toString(),
                                ),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (BuildContext context) {
                                  //return MyPlayePage(audio: item);
                                  // }));
                                  openPlayer(item);
                                },
                              );
                            });
                      },
                    )
                  ],
                )),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                jouer(),
                //_assetsAudioPlayer.builderCurrentPosition(
                //  builder: (context, duration) {return slider(duration);})
                _assetsAudioPlayer.builderRealtimePlayingInfos(
                    builder: (context, RealtimePlayingInfos? infos) {
                  return PositionSeekWidget(
                      currentPosition: infos!.currentPosition,
                      duration: infos.duration,
                      seekTo: (to) {
                        _assetsAudioPlayer.seek(to);
                      });
                })
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget jouer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Icon(CupertinoIcons.backward_fill),
              onTap: () {
                _assetsAudioPlayer.seekBy(Duration(seconds: -10));
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
                _assetsAudioPlayer.seekBy(Duration(seconds: 10));
              },
            ),
          ],
        )
      ],
    );
  }
}
