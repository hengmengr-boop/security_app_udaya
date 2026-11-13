import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

typedef VisitorFilter = ({String? room, bool todayOnly});

/// Returns the chosen filter, or `null` when dismissed without applying.
Future<VisitorFilter?> showFilterBottomSheet(
  BuildContext context, {
  required List<String> rooms,
  String? room,
  bool todayOnly = false,
}) {
  return showModalBottomSheet<VisitorFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: modalBottomSheetShape,
    backgroundColor: Colors.white,
    constraints: const BoxConstraints(maxWidth: 520),
    builder: (_) =>
        _FilterSheet(rooms: rooms, room: room, todayOnly: todayOnly),
  );
}

final class _FilterSheet extends StatefulWidget {
  const _FilterSheet(
      {required this.rooms, required this.room, required this.todayOnly});

  final List<String> rooms;
  final String? room;
  final bool todayOnly;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

final class _FilterSheetState extends State<_FilterSheet> with ModalUtilsMixin {
  late String? _room = widget.room;
  late bool _todayOnly = widget.todayOnly;

  Widget _chip(
      {required String label,
      required bool selected,
      required VoidCallback onTap}) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: const Color(0xFFF4F5FA),
      labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.textBody,
          fontWeight: FontWeight.w600),
      onSelected: (_) => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr(LocaleKeys.filter),
                style: CustomTextStyle.largeTitleTextStyle(
                    color: AppColors.textBody)),
            const SizedBox(height: Dimen.defaultSpace),
            Text(tr(LocaleKeys.filter_room),
                style: CustomTextStyle.bodyTextStyle(
                    bold: true, color: AppColors.textSub)),
            const SizedBox(height: Dimen.smallSpace),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(
                    label: tr(LocaleKeys.filter_all),
                    selected: _room == null,
                    onTap: () => setState(() => _room = null)),
                for (final r in widget.rooms)
                  _chip(
                    label: '${tr(LocaleKeys.room)} $r',
                    selected: _room == r,
                    onTap: () => setState(() => _room = r),
                  ),
              ],
            ),
            const SizedBox(height: Dimen.defaultSpace),
            Text(tr(LocaleKeys.filter_date),
                style: CustomTextStyle.bodyTextStyle(
                    bold: true, color: AppColors.textSub)),
            const SizedBox(height: Dimen.smallSpace),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(
                  label: tr(LocaleKeys.filter_all),
                  selected: !_todayOnly,
                  onTap: () => setState(() => _todayOnly = false),
                ),
                _chip(
                  label: tr(LocaleKeys.filter_today),
                  selected: _todayOnly,
                  onTap: () => setState(() => _todayOnly = true),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _room = null;
                      _todayOnly = false;
                    }),
                    child: Text(tr(LocaleKeys.filter_reset)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => dismiss(
                        context: context,
                        result: (room: _room, todayOnly: _todayOnly)),
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: Text(tr(LocaleKeys.filter_apply)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
