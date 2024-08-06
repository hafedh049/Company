import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'result.dart';
import 'utils/shared.dart';

class DumpsViewer extends StatefulWidget {
  const DumpsViewer({super.key, required this.dumps});
  final List<Map<String, dynamic>> dumps;
  @override
  State<DumpsViewer> createState() => _DumpsViewerState();
}

class _DumpsViewerState extends State<DumpsViewer> {
  final List<String> _alphabets = const <String>["A", "B", "C", "D", "E", "F", "G"];

  Duration _duration = const Duration(minutes: 65);

  int _currentQuestion = 0;

  final GlobalKey<State<StatefulWidget>> _nexprevKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _numberKey = GlobalKey<State<StatefulWidget>>();

  final PageController _questionsController = PageController();

  @override
  void dispose() {
    _questionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: twentyEight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.1)),
                  alignment: Alignment.center,
                  padding: padding16,
                  width: MediaQuery.sizeOf(context).width * .4,
                  constraints: const BoxConstraints(maxHeight: 550),
                  child: PageView.builder(
                    controller: _questionsController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int value) {
                      _nexprevKey.currentState!.setState(() => _currentQuestion = value);
                      _numberKey.currentState!.setState(() {});
                    },
                    itemBuilder: (BuildContext context, int index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(widget.dumps[index]["question"], style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                        if (widget.dumps[index]["code"].isNotEmpty) ...<Widget>[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: HighlightView(
                              padding: padding24,
                              textStyle: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500),
                              widget.dumps[index]["code"],
                              language: "dart",
                              tabSize: 4,
                              theme: a11yDarkTheme,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                for (final String choice in widget.dumps[index]["choices"]) ...<Widget>[
                                  InkWell(
                                    onTap: () {
                                      _(
                                        () {
                                          if (!widget.dumps[index]["multiple"]) {
                                            if (widget.dumps[index]["selectedAnswers"].contains(choice)) {
                                              widget.dumps[index]["selectedAnswers"] = const <String>[];
                                            } else {
                                              widget.dumps[index]["selectedAnswers"] = <String>[choice];
                                            }
                                          } else {
                                            if (widget.dumps[index]["selectedAnswers"].contains(choice)) {
                                              widget.dumps[index]["selectedAnswers"].remove(choice);
                                            } else {
                                              widget.dumps[index]["selectedAnswers"].add(choice);
                                            }
                                          }
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: padding8,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: widget.dumps[index]["selectedAnswers"].contains(choice) ? white.withOpacity(.1) : transparent),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            padding: padding4,
                                            decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                                            child: Text(_alphabets[widget.dumps[index]["choices"].indexOf(choice)], style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(choice, style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (widget.dumps[index]["choices"].last != choice) const SizedBox(height: 20),
                                ],
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return InkWell(
                                highlightColor: transparent,
                                splashColor: transparent,
                                hoverColor: transparent,
                                onTap: () => _(() => widget.dumps[index]["pin"] = !widget.dumps[index]["pin"]),
                                child: AnimatedContainer(
                                  duration: 300.ms,
                                  padding: padding8,
                                  decoration: BoxDecoration(border: Border.all(width: 2, color: widget.dumps[index]["pin"] ? Colors.orangeAccent : transparent), borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      if (widget.dumps[index]["pin"]) ...<Widget>[
                                        const Icon(FontAwesome.map_pin_solid, size: 15, color: white),
                                        const SizedBox(width: 10),
                                      ],
                                      Text("PIN${widget.dumps[index]["pin"] ? "ED" : ""}", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    itemCount: widget.dumps.length,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            StatefulBuilder(
              key: _numberKey,
              builder: (BuildContext context, void Function(void Function()) _) {
                return Container(
                  padding: padding8,
                  decoration: BoxDecoration(color: blue.withOpacity(.2), borderRadius: BorderRadius.circular(10)),
                  child: Math.tex(
                    r"Question : \frac{x}{y}".replaceFirst('x', (_currentQuestion + 1).toString()).replaceFirst("y", widget.dumps.length.toString()),
                    textStyle: GoogleFonts.itim(fontSize: 22, color: white, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: StatefulBuilder(
                key: _nexprevKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        highlightColor: transparent,
                        splashColor: transparent,
                        hoverColor: transparent,
                        onTap: _currentQuestion == 0
                            ? null
                            : () {
                                _questionsController.previousPage(curve: Curves.linear, duration: 300.ms);
                                _(() {});
                              },
                        child: AnimatedContainer(
                          duration: 300.ms,
                          padding: padding8,
                          decoration: BoxDecoration(color: _currentQuestion == 0 ? blue.withOpacity(.4) : blue, borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(FontAwesome.chevron_left_solid, size: 15, color: white),
                              const SizedBox(width: 10),
                              Text("PREVIOUS", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      _currentQuestion == (widget.dumps.length - 1)
                          ? InkWell(
                              highlightColor: transparent,
                              splashColor: transparent,
                              hoverColor: transparent,
                              onTap: () {
                                if (widget.dumps.any((Map<String, dynamic> element) => element["selectedAnswers"].isEmpty)) {
                                  final List<Map<String, dynamic>> notAnswered = widget.dumps.where((Map<String, dynamic> element) => element["selectedAnswers"].isEmpty).toList();
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: transparent,
                                    builder: (BuildContext context) => Container(
                                      padding: padding16,
                                      decoration: BoxDecoration(color: twentyEight, borderRadius: BorderRadius.circular(15)),
                                      child: ListView.separated(
                                        itemBuilder: (BuildContext context, int index) => Container(
                                          padding: padding8,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white.withOpacity(.1)),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                padding: padding4,
                                                decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                                                child: Text("Question N° ${index + 1}", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                                              ),
                                              const SizedBox(width: 10),
                                              const Icon(FontAwesome.circle_xmark, size: 20, color: red),
                                            ],
                                          ),
                                        ),
                                        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                                        itemCount: notAnswered.length,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Result(data: widget.dumps)));
                                }
                              },
                              child: AnimatedContainer(
                                duration: 300.ms,
                                padding: padding8,
                                decoration: BoxDecoration(color: widget.dumps.any((Map<String, dynamic> element) => element["selectedAnswers"].isEmpty) ? lightGreen.withOpacity(.4) : lightGreen, borderRadius: BorderRadius.circular(10)),
                                child: Text("FINISH", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                              ),
                            )
                          : InkWell(
                              highlightColor: transparent,
                              splashColor: transparent,
                              hoverColor: transparent,
                              onTap: _currentQuestion == (widget.dumps.length - 1)
                                  ? null
                                  : () {
                                      _questionsController.nextPage(curve: Curves.linear, duration: 300.ms);
                                      _(() {});
                                    },
                              child: AnimatedContainer(
                                duration: 300.ms,
                                padding: padding8,
                                decoration: BoxDecoration(color: _currentQuestion == (widget.dumps.length - 1) ? blue.withOpacity(.4) : blue, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("NEXT", style: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 10),
                                    const Icon(FontAwesome.chevron_right_solid, size: 15, color: white),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) _) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: LinearProgressBar(
                        maxSteps: 65.minutes.inSeconds,
                        progressType: LinearProgressBar.progressTypeLinear,
                        currentStep: (65.minutes - _duration).inSeconds,
                        progressColor: red,
                        backgroundColor: grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideCountdownSeparated(
                      duration: 65.minutes,
                      shouldShowDays: (Duration p0) => false,
                      showZeroValue: true,
                      separatorStyle: GoogleFonts.itim(fontSize: 16, color: white, fontWeight: FontWeight.w500),
                      onChanged: (Duration value) => _(() => _duration = value),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: const Icon(FontAwesome.clock, size: 30, color: red).animate(key: ValueKey<Duration>(_duration)).shake(),
                      ),
                      onDone: () {},
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
