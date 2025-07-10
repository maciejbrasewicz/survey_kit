import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_kit/src/controller/survey_controller.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/step.dart' as surveystep;

/// ------------ helpers -----------------------------------------------------

bool _isEmptyTitle(Widget w) {
  if (w is SizedBox) return true;
  if (w is Text) return (w.data?.trim().isEmpty ?? true);
  if (w is Padding || w is Center || w is Align) {
    final child = (w as dynamic).child as Widget?;
    return child == null ? true : _isEmptyTitle(child);
  }
  return false;
}

/// ------------ widok pojedynczego kroku ------------------------------------

class StepView extends StatelessWidget {
  final surveystep.Step step;
  final Widget title;
  final Widget child;
  final QuestionResult Function() resultFunction;
  final bool isValid;
  final bool showNextButton;                 // <— NOWE
  final SurveyController? controller;

  const StepView({
    Key? key,
    required this.step,
    required this.child,
    required this.title,
    required this.resultFunction,
    this.controller,
    this.isValid = true,
    this.showNextButton = true,              // domyślnie tak jak wcześniej
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SurveyController surveyController =
        controller ?? context.read<SurveyController>();

    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: _buildColumn(context, surveyController),
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(BuildContext context, SurveyController surveyController) {
    final bool hasTitle = !_isEmptyTitle(title);

    return Column(
      mainAxisAlignment:
          hasTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasTitle)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: title,
          ),

        child,

        // -------------- Next ----------------------------------------------
        if (showNextButton)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: OutlinedButton(
              onPressed: (isValid || step.isOptional)
                  ? () {
                      if (FocusScope.of(context).hasFocus) {
                        FocusScope.of(context).unfocus();
                      }
                      surveyController.nextStep(context, resultFunction);
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
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:survey_kit/src/controller/survey_controller.dart';
// import 'package:survey_kit/src/result/question_result.dart';
// import 'package:survey_kit/src/steps/step.dart' as surveystep;

// /// ---------------------------------------------------------------------------
// ///  Helpers
// /// ---------------------------------------------------------------------------

// /// Prawdziwy, wizualny „brak tytułu”.
// bool _isEmptyTitle(Widget w) {
//   if (w is SizedBox) return true;                                // 1) SizedBox.shrink()
//   if (w is Text)   return (w.data?.trim().isEmpty ?? true);      // 2) pusty / spacja
//   if (w is Padding || w is Center || w is Align) {               // 3) jednowidżetowe powłoki
//     final child = (w as dynamic).child as Widget?;
//     return child == null ? true : _isEmptyTitle(child);
//   }
//   return false;                                                  // 4) coś widać
// }

// /// ---------------------------------------------------------------------------
// ///  Widok jednego kroku
// /// ---------------------------------------------------------------------------

// class StepView extends StatelessWidget {
//   final surveystep.Step step;
//   final Widget title;
//   final Widget child;
//   final QuestionResult Function() resultFunction;
//   final bool isValid;
//   final SurveyController? controller;

//   const StepView({
//     Key? key,
//     required this.step,
//     required this.child,
//     required this.title,
//     required this.resultFunction,
//     this.controller,
//     this.isValid = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final SurveyController surveyController =
//         controller ?? context.read<SurveyController>();

//     return SizedBox.expand(
//       child: Container(
//         color: Theme.of(context).colorScheme.background,
//         // ------------- UWAGA: Align zamiast Center -------------
//         // TopCenter sprawia, że cała kolumna startuje pod AppBarem,
//         // a nie pośrodku ekranu.
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: SingleChildScrollView(
//             child: _buildColumn(context, surveyController),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Kolumna z tytułem, treścią i przyciskiem
//   Widget _buildColumn(BuildContext context, SurveyController surveyController) {
//     final bool hasTitle = !_isEmptyTitle(title);

//     return Column(
//       // Jeśli nie ma tytułu – zaczynaj od góry; jeżeli jest – możesz wycentrować.
//       mainAxisAlignment:
//           hasTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         if (hasTitle)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 32),
//             child: title,
//           ),

//         // ---------- główna zawartość kroku ----------
//         child,

//         // ---------- przycisk „Dalej / Next” ----------
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 32),
//           child: OutlinedButton(
//             onPressed: (isValid || step.isOptional)
//                 ? () {
//                     if (FocusScope.of(context).hasFocus) {
//                       FocusScope.of(context).unfocus();
//                     }
//                     surveyController.nextStep(context, resultFunction);
//                   }
//                 : null,
//             child: Text(
//               context.read<Map<String, String>?>()?['next'] ??
//                   step.buttonText ??
//                   'Next',
//               style: TextStyle(
//                 color: (isValid || step.isOptional)
//                     ? Theme.of(context).primaryColor
//                     : Colors.grey,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
