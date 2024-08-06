import 'dart:ui';

import 'package:company/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'utils/helpers/video_view.dart';

class VideoDisplayer extends StatefulWidget {
  const VideoDisplayer({super.key, required this.data});
  final List<Map<String, dynamic>> data;
  @override
  State<VideoDisplayer> createState() => _VideoDisplayerState();
}

class _VideoDisplayerState extends State<VideoDisplayer> {
  final List<Map<String, dynamic>> _data = <Map<String, dynamic>>[];

  final PageController _videosController = PageController();

  final GlobalKey<State<StatefulWidget>> _infoKey = GlobalKey<State<StatefulWidget>>();

  int _currentIndex = 0;

  @override
  void initState() {
    _data.clear();

    for (final Map<String, dynamic> module in widget.data) {
      for (final Map<String, dynamic> block in module["CHILDREN"]) {
        for (final String video in block["CHILDREN"]) {
          _data.add(
            <String, dynamic>{
              "MODULE": module["MODULE"],
              "DESCRIPTION": module["DESCRIPTION"],
              "BLOCK": block["BLOCK"],
              "BLOCK DESCRIPTION": block["DESCRIPTIONS"][block["CHILDREN"].indexOf(video)],
              "VIDEO": video,
            },
          );
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _videosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: twentyEight,
      body: Padding(
        padding: padding8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: StatefulBuilder(
                  key: _infoKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: padding8,
                              decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(5)),
                              child: Text("MODULE", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(width: 20),
                            Text(_data[_currentIndex]["MODULE"], style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: padding8,
                              decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(5)),
                              child: Text("DESCRIPTION", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(width: 20),
                            Text(_data[_currentIndex]["DESCRIPTION"], style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: padding8,
                              decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(5)),
                              child: Text("BLOCK", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(width: 20),
                            Text(_data[_currentIndex]["BLOCK"], style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: padding8,
                              decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(5)),
                              child: Text("BLOCK DESCRIPTION", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(width: 20),
                            Text(_data[_currentIndex]["BLOCK DESCRIPTION"], style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: PageView.builder(
                      itemBuilder: (BuildContext context, int index) => VideoView(video: _data[index]["VIDEO"]),
                      onPageChanged: (int value) => _infoKey.currentState!.setState(() => _currentIndex = value),
                      controller: _videosController,
                      itemCount: _data.length,
                    ),
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () async {
                              await _videosController.previousPage(curve: Curves.linear, duration: 300.ms);
                              _(() {});
                            },
                            icon: Icon(FontAwesome.circle_chevron_left_solid, color: _currentIndex == 0 ? grey : white, size: 48),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {
                              await _videosController.nextPage(curve: Curves.linear, duration: 300.ms);
                              _(() {});
                            },
                            icon: Icon(FontAwesome.circle_chevron_right_solid, color: _currentIndex == (_data.length - 1) ? grey : white, size: 48),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
