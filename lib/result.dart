import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

import 'utils/shared.dart';

class Result extends StatefulWidget {
  const Result({super.key, required this.data});
  final List<Map<String, dynamic>> data;
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final Map<String, List<Map<String, dynamic>>> _filteredData = <String, List<Map<String, dynamic>>>{
    "Correct": <Map<String, dynamic>>[],
    "Wrong": <Map<String, dynamic>>[],
  };

  @override
  void initState() {
    _filteredData["Correct"] = widget.data.where((Map<String, dynamic> element) => listEquals(element["answers"]..sort(), element["selectedAnswers"]..sort())).toList();
    _filteredData["Wrong"] = widget.data.where((Map<String, dynamic> element) => !listEquals(element["answers"]..sort(), element["selectedAnswers"]..sort())).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: twentyEight,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PrimerProgressBar(
              barStyle: const SegmentedBarStyle(),
              segments: <Segment>[
                Segment(
                  value: _filteredData["Correct"]!.length,
                  color: lightGreen,
                  label: Text("Correct", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                  valueLabel: Text("( ${_filteredData["Correct"]!.length.toString()} )", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                ),
                Segment(
                  value: _filteredData["Wrong"]!.length,
                  color: red,
                  label: Text("Wrong", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                  valueLabel: Text("( ${_filteredData["Wrong"]!.length.toString()} )", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                ),
              ],
              legendStyle: const SegmentedBarLegendStyle(maxLines: 2),
              legendEllipsisBuilder: (int truncatedItemCount) {
                return LegendItem(
                  segment: Segment(
                    value: _filteredData.keys.elementAt(truncatedItemCount).length,
                    color: grey,
                    label: const Text("Other"),
                    valueLabel: Text("${_filteredData.keys.elementAt(truncatedItemCount).length}%"),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
