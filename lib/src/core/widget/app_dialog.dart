import 'package:flutter/material.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';

class AppDialogAction {
  const AppDialogAction({
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool primary;
  final bool destructive;
}

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.actions,
    this.message,
    this.content,
    super.key,
  });

  final String title;
  final String? message;
  final Widget? content;
  final List<AppDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: context.textTheme.headlineLarge),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(message!, style: context.textTheme.bodyLarge),
            ],
            if (content != null) ...[const SizedBox(height: 12), content!],
            const SizedBox(height: 20),
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _ActionButton(action: actions[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final AppDialogAction action;

  @override
  Widget build(BuildContext context) {
    if (!action.primary) {
      return OutlinedButton(
        onPressed: action.onPressed,
        child: Text(action.label),
      );
    }
    if (!action.destructive) {
      return ElevatedButton(
        onPressed: action.onPressed,
        child: Text(action.label),
      );
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.error,
        foregroundColor: Colors.white,
      ),
      onPressed: action.onPressed,
      child: Text(action.label),
    );
  }
}

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AppDialog(
      title: title,
      message: message,
      actions: [
        AppDialogAction(
          label: confirmLabel,
          primary: true,
          destructive: destructive,
          onPressed: () => Navigator.pop(context, true),
        ),
        AppDialogAction(
          label: cancelLabel,
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String actionLabel,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AppDialog(
      title: title,
      message: message,
      actions: [
        AppDialogAction(
          label: actionLabel,
          primary: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Future<String?> showInputDialog({
  required BuildContext context,
  required String title,
  required String hint,
  required String confirmLabel,
  required String cancelLabel,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _InputDialog(
      title: title,
      hint: hint,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      textCapitalization: textCapitalization,
    ),
  );
}

class _InputDialog extends StatefulWidget {
  const _InputDialog({
    required this.title,
    required this.hint,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.textCapitalization,
  });

  final String title;
  final String hint;
  final String confirmLabel;
  final String cancelLabel;
  final TextCapitalization textCapitalization;

  @override
  State<_InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<_InputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: widget.title,
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: widget.textCapitalization,
        decoration: InputDecoration(hintText: widget.hint),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        AppDialogAction(
          label: widget.confirmLabel,
          primary: true,
          onPressed: () => Navigator.pop(context, _controller.text),
        ),
        AppDialogAction(
          label: widget.cancelLabel,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
