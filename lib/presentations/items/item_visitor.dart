import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// One visitor card: avatar, name, schedule, purpose and the status actions.
final class ItemVisitor extends StatelessWidget {
  const ItemVisitor({super.key, required this.visitor, this.onShowQr, this.onCheckIn, this.onCheckOut});

  final VisitorModel visitor;
  final VoidCallback? onShowQr;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;

  String _fmt(String pattern, DateTime date, String lang) {
    try {
      return DateFormat(pattern, lang).format(date);
    } catch (_) {
      return DateFormat(pattern).format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final compact = context.isMobile;
    final date = _fmt('MMM d', visitor.startTime, lang);
    final time = '${_fmt('hh:mm a', visitor.startTime, lang)} - ${_fmt('hh:mm a', visitor.endTime, lang)}';
    final avatar = compact ? 56.0 : 72.0;

    return Container(
      padding: EdgeInsets.all(compact ? 14 : 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: avatar,
                height: avatar,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.avatarBg, borderRadius: BorderRadius.circular(14)),
                child: Text(
                  visitor.initials,
                  style: TextStyle(
                    fontSize: compact ? 20 : 26,
                    fontWeight: FontWeight.w500,
                    color: AppColors.avatarText,
                  ),
                ),
              ),
              SizedBox(width: compact ? 12 : 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 18 : 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBody,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 22,
                      runSpacing: 6,
                      children: [
                        _Info(icon: Icons.calendar_today_outlined, text: date),
                        _Info(icon: Icons.schedule, text: time),
                        _Info(icon: Icons.meeting_room_outlined, text: '${tr(LocaleKeys.room)} ${visitor.room}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: AppColors.border),
          ),
          _buildFooter(context, lang),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, String lang) {
    final purpose = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.info_outline, size: 20, color: AppColors.textSub),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(visitor.purpose, style: const TextStyle(fontSize: 16, color: AppColors.textSub, height: 1.3)),
        ),
      ],
    );

    final actions = <Widget>[
      if (visitor.status != VisitorStatus.checkedOut && onShowQr != null)
        _ActionButton(
          icon: Icons.qr_code_2,
          label: tr(LocaleKeys.show_qr_code),
          color: AppColors.qrButton,
          onTap: onShowQr!,
        ),
      if (visitor.status == VisitorStatus.upcoming && onCheckIn != null)
        _ActionButton(icon: null, label: tr(LocaleKeys.check_in), color: Colors.black, onTap: onCheckIn!),
      if (visitor.status == VisitorStatus.onSite && onCheckOut != null)
        _ActionButton(icon: null, label: tr(LocaleKeys.check_out), color: AppColors.accent, onTap: onCheckOut!),
      if (visitor.status == VisitorStatus.checkedOut && visitor.checkOutAt != null)
        _Info(
          icon: Icons.logout,
          text: tr(LocaleKeys.checked_out_at, namedArgs: {'time': _fmt('hh:mm a', visitor.checkOutAt!, lang)}),
        ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final buttons = Wrap(spacing: 12, runSpacing: 8, alignment: WrapAlignment.end, children: actions);
        if (c.maxWidth < 560) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              purpose,
              if (actions.isNotEmpty) ...[const SizedBox(height: 12), Align(alignment: Alignment.centerRight, child: buttons)],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Expanded(child: purpose), const SizedBox(width: 16), buttons],
        );
      },
    );
  }
}

final class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.textSub),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16, color: AppColors.textSub)),
      ],
    );
  }
}

final class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  final IconData? icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20, color: Colors.white), const SizedBox(width: 8)],
              Text(
                label.toUpperCase(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
