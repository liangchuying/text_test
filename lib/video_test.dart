import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fvp/fvp.dart' as fvp;

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    fvp.registerWith();
    String url =
        'https://cs-example.obs.cn-south-1.myhuaweicloud.com/t45/%E7%B3%BB%E7%BB%9F%E6%96%87%E4%BB%B6/%E4%B8%9A%E5%8A%A1%E6%96%87%E4%BB%B6/11111111/%E9%99%84%E4%BB%B6/p7021777816249180654-102-180421.mp4?AccessKeyId=HKXFQ7HJT01TX8USG2RX&Expires=1733651918&Signature=cuYAVJIRRyP3crqJUnGsIB82ZBM%3D';
    String url2 =
        'https://cs-example.obs.cn-south-1.myhuaweicloud.com:443/t45/%E7%B3%BB%E7%BB%9F%E6%96%87%E4%BB%B6/%E4%B8%9A%E5%8A%A1%E6%96%87%E4%BB%B6/11111111/%E9%99%84%E4%BB%B6/123459.mp4?AccessKeyId=HKXFQ7HJT01TX8USG2RX&Expires=1733648273&Signature=Uloyis%2BlShRC3OEPaJ10L862yCc%3D';

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url2))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('video player'),
      ),
      body: Center(
        child: videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: VideoPlayer(videoPlayerController),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            videoPlayerController.value.isPlaying
                ? videoPlayerController.pause()
                : videoPlayerController.play();
          });
        },
        child: Icon(
          videoPlayerController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
}
