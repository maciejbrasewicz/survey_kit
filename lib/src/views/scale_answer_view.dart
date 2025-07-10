import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/src/answer_format/scale_answer_format.dart';
import 'package:survey_kit/src/result/question/scale_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- Pytanie (większy, nowocześniejszy font) ----------
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

            // ---------- Aktualna wartość (opcjonalna) ----------
            if (_format.showValue)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _sliderValue.toInt().toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            // ---------- Opisy krańcowe ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _format.minimumValueDescription,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(.87),
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
                      color: Colors.white.withOpacity(.87),
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- Slider z nowoczesnym stylem ----------
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                inactiveTrackColor: Colors.white.withOpacity(.24),
                activeTrackColor: theme.colorScheme.primary,
                thumbColor: theme.colorScheme.primary,
                overlayColor: theme.colorScheme.primary.withOpacity(.18),
                tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
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
                onChanged: (double value) {
                  setState(() => _sliderValue = value);
                },
                onChangeEnd: (_) => HapticFeedback.heavyImpact(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
