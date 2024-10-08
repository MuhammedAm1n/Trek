import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_player/video_player.dart';

class Videoplayerz extends StatefulWidget {
  const Videoplayerz({super.key, required this.Path});
  static String id = 'videoplayz';
  final String Path;

  @override
  State<Videoplayerz> createState() => _VideoplayerzState();
}

class _VideoplayerzState extends State<Videoplayerz> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.Path));
    _videoPlayerController!.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _chewieVideoplyaer(),
    );
  }

  Widget _chewieVideoplyaer() {
    return _chewieController != null && _videoPlayerController != null
        ? Chewie(controller: _chewieController!)
        : const Center(
            child: CircularProgressIndicator(
              color: ColorsApp.naviGationbar,
            ),
          );
  }
}
