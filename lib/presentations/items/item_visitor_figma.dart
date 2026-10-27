import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// Mobile visitor card matching the supplied Figma visitor list screens.
final class ItemVisitor extends StatelessWidget {
  const ItemVisitor(
      {super.key,
      required this.visitor,
      this.onShowQr,
      this.onCheckIn,
      this.onCheckOut});

  final VisitorModel visitor;
  final VoidCallback? onShowQr;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;

  String _fmt(String pattern, DateTime date, String languageCode) {
    try {
      return DateFormat(pattern, languageCode).format(date);
    } catch (_) {
      return DateFormat(pattern).format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final date = _fmt('MMM d', visitor.startTime, lang);
    final time =
        '${_fmt('hh:mm a', visitor.startTime, lang)} - ${_fmt('hh:mm a', visitor.endTime, lang)}';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC8CAD3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _Avatar(initials: visitor.initials),
          const SizedBox(width: 20),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(visitor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 24,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111))),
                const SizedBox(height: 12),
                Wrap(spacing: 18, runSpacing: 10, children: [
                  _Info(icon: Icons.calendar_today_outlined, text: date),
                  _Info(icon: Icons.schedule_outlined, text: time),
                ]),
                const SizedBox(height: 12),
                _Info(
                    icon: Icons.meeting_room_outlined,
                    text: '${tr(LocaleKeys.room)} ${visitor.room}'),
              ])),
        ]),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(height: 1, color: Color(0xFFC8CAD3))),
        LayoutBuilder(builder: (context, constraints) {
          final action = _action();
          if (constraints.maxWidth < 430) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Purpose(text: visitor.purpose),
                  if (action != null) ...[
                    const SizedBox(height: 14),
                    Align(alignment: Alignment.centerRight, child: action)
                  ],
                ]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(child: _Purpose(text: visitor.purpose)),
            if (action != null) ...[const SizedBox(width: 16), action],
          ]);
        }),
      ]),
    );
  }

  Widget? _action() {
    if (visitor.status == VisitorStatus.upcoming && onCheckIn != null) {
      return _ActionButton(
          label: tr(LocaleKeys.check_in),
          color: Colors.black,
          onTap: onCheckIn!);
    }
    if (visitor.status == VisitorStatus.onSite && onCheckOut != null) {
      return _ActionButton(
          label: tr(LocaleKeys.check_out),
          color: const Color(0xFFFF1111),
          onTap: onCheckOut!);
    }
    if (visitor.status == VisitorStatus.checkedOut &&
        visitor.checkOutAt != null) {
      return _Info(
          icon: Icons.logout_outlined,
          text: tr(LocaleKeys.checked_out_at, namedArgs: {
            'time': DateFormat('hh:mm a').format(visitor.checkOutAt!)
          }));
    }
    return null;
  }
}

final class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});
  final String initials;
  @override
  Widget build(BuildContext context) => Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xFF141A2F),
            borderRadius: BorderRadius.circular(16)),
        child: Text(initials,
            style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7A849E))),
      );
}

final class _Purpose extends StatelessWidget {
  const _Purpose({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
            padding: EdgeInsets.only(top: 1),
            child:
                Icon(Icons.info_outline, size: 21, color: Color(0xFF4D4F5A))),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 16, height: 1.35, color: Color(0xFF4D4F5A)))),
      ]);
}

final class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 21, color: const Color(0xFF4D4F5A)),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(fontSize: 16, color: Color(0xFF4D4F5A))),
      ]);
}

final class _ActionButton extends StatelessWidget {
  const _ActionButton(
      {required this.label, required this.color, required this.onTap});
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: color,
        borderRadius: BorderRadius.circular(5),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Text(label.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.white)),
            )),
      );
}
