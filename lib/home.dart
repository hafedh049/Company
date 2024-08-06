import 'dart:convert';
import 'dart:ui';

import 'package:company/dumps_viewer.dart';
import 'package:company/utils/helpers/error.dart';
import 'package:company/utils/helpers/wait.dart';
import 'package:company/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'video_displayer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Map<String, dynamic>>> _load() async {
    return jsonDecode(await rootBundle.loadString("assets/jsons/data.json")).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: twentyEight,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _load(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final List<Map<String, dynamic>> data = snapshot.data!;
            return data.isEmpty
                ? Text("No Subjects Yet. 😁", style: GoogleFonts.itim(fontSize: 48, color: white, fontWeight: FontWeight.w500))
                : ListView.separated(
                    itemBuilder: (BuildContext context, int index) => GestureDetector(
                      child: Container(
                        margin: padding16,
                        padding: padding16,
                        decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(image: AssetImage("assets/images/${data[index]["BACKGROUND"]}"), fit: BoxFit.cover),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: padding8,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: Text(data[index]["NAME"], style: GoogleFonts.itim(fontSize: 24, color: white, fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(data[index]["DESCRIPTION"], style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 20),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runAlignment: WrapAlignment.start,
                              alignment: WrapAlignment.start,
                              runSpacing: 20,
                              spacing: 20,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DumpsViewer(dumps: data[index]["DUMPS"].cast<Map<String, dynamic>>()))),
                                  child: Container(
                                    padding: padding8,
                                    decoration: BoxDecoration(color: red.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const CircleAvatar(radius: 10, backgroundColor: red),
                                        const SizedBox(width: 10),
                                        Text("DUMPS", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VideoDisplayer(data: data[index]["VIDEOS"].cast<Map<String, dynamic>>()))),
                                  child: Container(
                                    padding: padding8,
                                    decoration: BoxDecoration(color: lightGreen.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const CircleAvatar(radius: 10, backgroundColor: lightGreen),
                                        const SizedBox(width: 10),
                                        Text("VIDEOS", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 30),
                    itemCount: data.length,
                  );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Wait();
          } else {
            return FError(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
