import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';

Future<void> copyToClipboard(BuildContext context, String text) async {
  final value = text.trim();
  if (value.isEmpty) return;
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(context.l10n.copied)));
}

/// Text that can be copied from the icon or from the system selection menu.
class CopyableText extends StatelessWidget {
  const CopyableText({
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: textAlign == TextAlign.center
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: SelectableText(
            text,
            textAlign: textAlign,
            style: style,
            onTap: () => copyToClipboard(context, text),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: context.l10n.copy,
          icon: Icon(
            Icons.copy_outlined,
            size: 18,
            color: context.colorScheme.onSurfaceVariant,
          ),
          onPressed: () => copyToClipboard(context, text),
        ),
      ],
    );
  }
}
