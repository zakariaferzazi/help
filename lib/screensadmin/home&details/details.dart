import 'dart:ui';
import 'package:Yemenaman/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class Details extends StatefulWidget {
  final item;

  const Details({super.key, this.item});

  @override
  State<Details> createState() => DdetailsState();
}

class DdetailsState extends State<Details> {
  final _controller = ScrollController();
  ScrollPhysics _physics = const ClampingScrollPhysics();
  bool appBarVAR = false;
  bool bottomBarImagesVAR = false;
  VideoPlayerController? _videocontroller;

  Future<void>? _initializeVideoPlayerFuture;
  final Uri _url =
      Uri.parse('https://play.google.com/store/apps/details?id=com.yemen.aman');

  Future run() async {
    await Future.delayed(const Duration(milliseconds: 350));
    setState(() {
      appBarVAR = true;
      bottomBarImagesVAR = true;
    });
  }

  @override
  void initState() {
    _videocontroller = VideoPlayerController.network(widget.item["video"]??'');
    _initializeVideoPlayerFuture = _videocontroller!.initialize();
    super.initState();

    try {
      run();
    } catch (e) {
      debugPrint("$e");
    }
    _controller.addListener(() {
      if (_controller.position.pixels <= 100) {
        setState(() => _physics = const ClampingScrollPhysics());
      } else {
        setState(() => _physics = const BouncingScrollPhysics());
      }
    });
  }

  @override
  void dispose() {
    _videocontroller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _controller,
            physics: _physics,
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  elevation: 4,
                  child: Hero(
                    tag: widget.item["title"],
                    child: Container(
                      height: displayHeight / 3,
                      width: displayWidth,
                      decoration: BoxDecoration(
                          color: Color(0xff140c47),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                          image: DecorationImage(
                              image: NetworkImage(widget.item["image"]),
                              fit: BoxFit.cover)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedCrossFade(
                            firstChild: Container(),
                            secondChild: appBar(),
                            crossFadeState: appBarVAR
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: displayWidth,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            width: displayWidth * 0.8,
                            child:  Column(
                              children: <Widget>[
                                 Text(
                                  widget.item["title"],
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 25,
                                    fontFamily: 'Markazi text',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            width: displayWidth * 0.8,
                            child:  Column(
                              children: <Widget>[
                                 Text(
                                  widget.item["text"],
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontFamily: 'Markazi text',
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                            Stack(children: [
                                  Container(
                                    child: FutureBuilder(
                                      future: _initializeVideoPlayerFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Center(
                                            child: AspectRatio(
                                                aspectRatio:
                                                    _videocontroller!.value.aspectRatio,
                                                child: Container(
                                                  height:
                                                      MediaQuery.of(context).size.height /
                                                          3,
                                                  width:
                                                      MediaQuery.of(context).size.width /
                                                          2,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(23.0),
                                                    child: VideoPlayer(_videocontroller!),
                                                  ),
                                                )),
                                          );
                                        } else {
                                          return Center(
                                              child: CircularProgressIndicator());
                                        }
                                      },
                                    ),

                                  ),
                                  
                                              Center(
                    child: InkWell(
                    onTap: () {
                setState(() {
                    if (_videocontroller!.value.isPlaying) {
                      _videocontroller!.pause();
                    } else {
                      _videocontroller!.play();
                    }
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: _videocontroller!.value.size.height*0.5,horizontal: _videocontroller!.value.size.width*0.5),
                decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  _videocontroller!.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 80,
                ),
              ),
                ),
                  )
                                ]),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  Widget appBar() {
    return Row(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.white,
                  child: const Icon(
                    FontAwesomeIcons.backward,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: (() {
            _launchUrl();
          }),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.white,
                  child: const Icon(
                    FontAwesomeIcons.star,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Share.share(
                'https://play.google.com/store/apps/details?id=com.yemen.aman');
          },
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.white,
                  child: const Icon(
                    FontAwesomeIcons.share,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
