import 'package:flutter/material.dart';

class SelectionListTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const SelectionListTile({
    Key? key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_outlined,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(.60),
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyLarge?.color,
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

// class SelectionListTile extends StatelessWidget {
//   final String text;
//   final Function onTap;
//   final bool isSelected;

//   const SelectionListTile({
//     Key? key,
//     required this.text,
//     required this.onTap,
//     this.isSelected = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14.0),
//           child: ListTile(
//             title: Text(
//               text,
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     color: isSelected
//                         ? Theme.of(context).primaryColor
//                         : Theme.of(context).textTheme.headlineSmall?.color,
//                   ),
//             ),
//             trailing: isSelected
//                 ? Icon(
//                     Icons.check,
//                     size: 32,
//                     color: isSelected
//                         ? Theme.of(context).primaryColor
//                         : Colors.black,
//                   )
//                 : Container(
//                     width: 32,
//                     height: 32,
//                   ),
//             onTap: () => onTap.call(),
//           ),
//         ),
//         Divider(
//           color: Colors.grey,
//         ),
//       ],
//     );
//   }
// }
