import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/src/answer_format/scale_answer_format.dart';
import 'package:survey_kit/src/result/question/scale_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

/// ------------------------------
///  Pusty, biały thumb
/// ------------------------------
class _HollowThumbShape extends SliderComponentShape {
  const _HollowThumbShape({this.radius = 12});
  final double radius;

  @override
  Size getPreferredSize(bool _, bool __) => Size.fromRadius(radius);

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
    context.canvas.drawCircle(
      center,
      radius - 1.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white.withOpacity(.90),
    );
  }
}

/// ------------------------------
///  Tor z delikatną ramką
/// ------------------------------
class _BorderTrackShape extends RoundedRectSliderTrackShape {
  const _BorderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    required TextDirection textDirection,
  }) {
    // standardowe malowanie toru
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      textDirection: textDirection,
    );

    // ramka (ultra-cienka)
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    ).shift(offset);

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(4)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8
        ..color = Colors.white.withOpacity(.20),
    );
  }
}

/// ------------------------------
///  Widok kroku ze skalą
/// ------------------------------
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- Pytanie ----------
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

            Divider(height: 1, thickness: .8, color: Colors.white.withOpacity(.15)),
            const SizedBox(height: 20),

            // ---------- Opisy krańcowe ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _format.minimumValueDescription,
                    maxLines: 3,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(.80),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    _format.maximumValueDescription,
                    maxLines: 3,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(.80),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- Slider ----------
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                trackShape: const _BorderTrackShape(),
                inactiveTrackColor: Colors.white.withOpacity(.24),
                activeTrackColor: Colors.white.withOpacity(.24), // brak wypełnienia
                thumbShape: const _HollowThumbShape(radius: 12),
                overlayColor: theme.colorScheme.primary.withOpacity(.20),
                tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
                activeTickMarkColor: Colors.white.withOpacity(.50),
                inactiveTickMarkColor: Colors.white.withOpacity(.30),
                valueIndicatorColor: theme.colorScheme.primary,
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
                onChanged: (v) => setState(() => _sliderValue = v),
                onChangeEnd: (_) => HapticFeedback.heavyImpact(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
