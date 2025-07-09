import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_kit/src/controller/survey_controller.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/step.dart' as surveystep;

/// Zwraca `true`, gdy przekazany widget jest „pustym” tytułem
/// (SizedBox.shrink(), Text('') lub Text(' '), ewentualnie Padding/Center
/// zawierające taki pusty Text).
bool _isEmptyTitle(Widget w) {
  // 1) pusty SizedBox
  if (w is SizedBox) return true;

  // 2) pusty lub „spacja” w Text
  if (w is Text) return (w.data?.trim().isEmpty ?? true);

  // 3) opakowania jednowidżetowe (Padding, Center, Align)
  if (w is Padding || w is Center || w is Align) {
    final Widget? child =
        w is Padding ? w.child : (w as dynamic).child as Widget?;
    return child == null ? true : _isEmptyTitle(child);
  }

  // 4) wszystko inne traktujemy jako widoczny tytuł
  return false;
}

class StepView extends StatelessWidget {
  final surveystep.Step step;
  final Widget title;
  final Widget child;
  final QuestionResult Function() resultFunction;
  final bool isValid;
  final SurveyController? controller;

  const StepView({
    Key? key,
    required this.step,
    required this.child,
    required this.title,
    required this.resultFunction,
    this.controller,
    this.isValid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SurveyController surveyController =
        controller ?? context.read<SurveyController>();

    return _content(surveyController, context);
  }

  Widget _content(SurveyController surveyController, BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------- tytuł (wyświetlony tylko gdy nie-pusty) ----------
                if (!_isEmptyTitle(title))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: title,
                  ),

                // ---------- główna zawartość kroku ----------
                child,

                // ---------- przycisk „Dalej / Next” ----------
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: OutlinedButton(
                    onPressed: (isValid || step.isOptional)
                        ? () {
                            if (FocusScope.of(context).hasFocus) {
                              FocusScope.of(context).unfocus();
                            }
                            surveyController.nextStep(
                              context,
                              resultFunction,
                            );
                          }
                        : null,
                    child: Text(
                      context.read<Map<String, String>?>()?['next'] ??
                          step.buttonText ??
                          'Next',
                      style: TextStyle(
                        color: (isValid || step.isOptional)
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
