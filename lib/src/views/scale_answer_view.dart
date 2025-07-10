import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/src/answer_format/scale_answer_format.dart';
import 'package:survey_kit/src/result/question/scale_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

/// ---------------------------------------------------------------------------
///  Thumb: pusta biała obwódka
/// ---------------------------------------------------------------------------
class _HollowThumbShape extends SliderComponentShape {
  const _HollowThumbShape({this.radius = 12});
  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter? labelPainter,
    required RenderBox? parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white.withOpacity(.90); // jasna ramka

    canvas.drawCircle(center, radius - 1.5, paint);
  }
}

/// ---------------------------------------------------------------------------
///  Widok kroku z suwakiem
/// ---------------------------------------------------------------------------
class ScaleAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final ScaleQuestionResult? result;

  const ScaleAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _ScaleAnswerViewState createState() => _ScaleAnswerViewState();
}

class _ScaleAnswerViewState extends State<ScaleAnswerView> {
  late final DateTime _startDate;
  late final ScaleAnswerFormat _format;
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _format = widget.questionStep.answerFormat as ScaleAnswerFormat;
    _sliderValue = widget.result?.result ?? _format.defaultValue;
    _startDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StepView(
      step: widget.questionStep,
      resultFunction: () => ScaleQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDate,
        endDate: DateTime.now(),
        valueIdentifier: _sliderValue.toString(),
        result: _sliderValue,
      ),
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium,
            )
          : widget.questionStep.content,
      child: Padding(
        //   ↓↓ mniejsze marginesy dla „dłuższego” suwaka
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- pytanie ----------
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                widget.questionStep.text,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // ---------- separator ----------
            Divider(
              height: 1,
              thickness: .8,
              color: Colors.white.withOpacity(.15),
            ),
            const SizedBox(height: 20),

            // ---------- opisy krańcowe ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _format.minimumValueDescription,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(.80),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    _format.maximumValueDescription,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(.80),
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- suwak ----------
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,                               // grubszy
                inactiveTrackColor: Colors.white.withOpacity(.24),
                activeTrackColor: Colors.white.withOpacity(.24), // brak kolorowego wypełnienia
                thumbShape: const _HollowThumbShape(radius: 12),
                overlayColor: theme.colorScheme.primary.withOpacity(.20),
                valueIndicatorColor: theme.colorScheme.primary,
                tickMarkShape: SliderTickMarkShape.noTickMark, // gładki tor
                valueIndicatorTextStyle: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Slider(
                value: _sliderValue,
                min: _format.minimumValue,
                max: _format.maximumValue,
                divisions: (_format.maximumValue - _format.minimumValue) ~/
                    _format.step,
                label: _sliderValue.toInt().toString(),
                onChangeStart: (_) => HapticFeedback.selectionClick(),
                onChanged: (double v) => setState(() => _sliderValue = v),
                onChangeEnd: (_) => HapticFeedback.heavyImpact(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
