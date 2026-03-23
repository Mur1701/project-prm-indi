// ============================================================
// Dùng showCupertinoModalPopup + CupertinoPicker — hoàn toàn built-in
// ============================================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Mở Cupertino Picker Modal sẵn của Flutter
/// Trả về item được chọn, null nếu bấm Hủy
Future<T?> showWheelPickerSheet<T>({
  required BuildContext context,
  required List<T> items,
  required T? selected,
  required String Function(T) labelOf,
  required String title,
}) async {
  T current = selected ?? items.first;

  await showCupertinoModalPopup<void>(
    context: context,
    builder: (_) => CupertinoActionSheet(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.label,
        ),
      ),
      // Picker nằm trong message
      message: SizedBox(
        height: 200,
        child: StatefulBuilder(
          builder: (ctx, ss) => CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: items.indexOf(current).clamp(0, items.length - 1),
            ),
            itemExtent: 44,
            onSelectedItemChanged: (i) => ss(() => current = items[i]),
            children: items
                .map((e) => Center(
                      child: Text(
                        labelOf(e),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Xong',
            style: TextStyle(
              color: AppTheme.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          current = selected ?? items.first; // reset
          Navigator.pop(context);
        },
        child: const Text('Hủy'),
      ),
    ),
  );

  return current;
}

// WheelPicker widget inline (dùng trực tiếp trong settings)
class WheelPicker<T> extends StatefulWidget {
  final List<T> items;
  final T? selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final double itemHeight;

  const WheelPicker({
    super.key,
    required this.items,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.itemHeight = 44,
  });

  @override
  State<WheelPicker<T>> createState() => _WheelPickerState<T>();
}

class _WheelPickerState<T> extends State<WheelPicker<T>> {
  late FixedExtentScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    final idx = widget.selected != null
        ? widget.items.indexOf(widget.selected as T)
        : 0;
    _ctrl = FixedExtentScrollController(initialItem: idx.clamp(0, widget.items.length - 1));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.itemHeight * 5,
      child: CupertinoPicker(
        scrollController: _ctrl,
        itemExtent: widget.itemHeight,
        onSelectedItemChanged: (i) => widget.onChanged(widget.items[i]),
        children: widget.items
            .map((e) => Center(
                  child: Text(
                    widget.labelOf(e),
                    style: const TextStyle(fontSize: 15),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
