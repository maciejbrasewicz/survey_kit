import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/src/answer_format/single_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/text_choice.dart';
import 'package:survey_kit/src/result/question/single_choice_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/selection_list_tile.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class SingleChoiceAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final SingleChoiceQuestionResult? result;

  const SingleChoiceAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _SingleChoiceAnswerViewState createState() => _SingleChoiceAnswerViewState();
}

class _SingleChoiceAnswerViewState extends State<SingleChoiceAnswerView> {
  late final DateTime _startDate;
  late final SingleChoiceAnswerFormat _answerFormat;
  TextChoice? _selectedChoice;

  @override
  void initState() {
    super.initState();
    _answerFormat =
        widget.questionStep.answerFormat as SingleChoiceAnswerFormat;
    _selectedChoice =
        widget.result?.result ?? _answerFormat.defaultSelection;
    _startDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () => SingleChoiceQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDate,
        endDate: DateTime.now(),
        valueIdentifier: _selectedChoice?.value ?? '',
        result: _selectedChoice,
      ),
      isValid: widget.questionStep.isOptional || _selectedChoice != null,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium,
            )
          : widget.questionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- Pytanie ----------
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                widget.questionStep.text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),

            // ---------- cienka linia + odstęp ----------
            Divider(
              height: 1,
              thickness: .8,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(.12),
            ),
            const SizedBox(height: 12),

            // ---------- Lista odpowiedzi ----------
            ..._answerFormat.textChoices.map(
              (tc) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SelectionListTile(
                  text: tc.text,
                  isSelected: _selectedChoice == tc,
                  onTap: () {
                    // MOCNIEJSZA haptyka
                    HapticFeedback.heavyImpact();

                    setState(() {
                      _selectedChoice =
                          _selectedChoice == tc ? null : tc;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:survey_kit/src/answer_format/single_choice_answer_format.dart';
// import 'package:survey_kit/src/answer_format/text_choice.dart';
// import 'package:survey_kit/src/result/question/single_choice_question_result.dart';
// import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
// import 'package:survey_kit/src/views/widget/selection_list_tile.dart';
// import 'package:survey_kit/src/views/widget/step_view.dart';

// class SingleChoiceAnswerView extends StatefulWidget {
//   final QuestionStep questionStep;
//   final SingleChoiceQuestionResult? result;

//   const SingleChoiceAnswerView({
//     Key? key,
//     required this.questionStep,
//     required this.result,
//   }) : super(key: key);

//   @override
//   _SingleChoiceAnswerViewState createState() => _SingleChoiceAnswerViewState();
// }

// class _SingleChoiceAnswerViewState extends State<SingleChoiceAnswerView> {
//   late final DateTime _startDate;
//   late final SingleChoiceAnswerFormat _singleChoiceAnswerFormat;
//   TextChoice? _selectedChoice;

//   @override
//   void initState() {
//     super.initState();
//     _singleChoiceAnswerFormat =
//         widget.questionStep.answerFormat as SingleChoiceAnswerFormat;
//     _selectedChoice =
//         widget.result?.result ?? _singleChoiceAnswerFormat.defaultSelection;
//     _startDate = DateTime.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StepView(
//       step: widget.questionStep,
//       resultFunction: () => SingleChoiceQuestionResult(
//         id: widget.questionStep.stepIdentifier,
//         startDate: _startDate,
//         endDate: DateTime.now(),
//         valueIdentifier: _selectedChoice?.value ?? '',
//         result: _selectedChoice,
//       ),
//       isValid: widget.questionStep.isOptional || _selectedChoice != null,
//       title: widget.questionStep.title.isNotEmpty
//           ? Text(
//               widget.questionStep.title,
//               style: Theme.of(context).textTheme.displayMedium,
//               textAlign: TextAlign.center,
//             )
//           : widget.questionStep.content,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 32.0),
//               child: Text(
//                 widget.questionStep.text,
//                 style: Theme.of(context).textTheme.bodyMedium,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Column(
//               children: [
//                 Divider(
//                   color: Colors.grey,
//                 ),
//                 ..._singleChoiceAnswerFormat.textChoices.map(
//                   (TextChoice tc) {
//                     return SelectionListTile(
//                       text: tc.text,
//                       onTap: () {
//                         if (_selectedChoice == tc) {
//                           _selectedChoice = null;
//                         } else {
//                           _selectedChoice = tc;
//                         }
//                         setState(() {});
//                       },
//                       isSelected: _selectedChoice == tc,
//                     );
//                   },
//                 ).toList(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
