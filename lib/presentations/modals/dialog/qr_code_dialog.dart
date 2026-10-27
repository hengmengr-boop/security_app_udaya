import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// Shows the visitor's QR code (scanned at the gate to check in).
final class QrCodeDialog extends StatelessWidget with ModalUtilsMixin {
  const QrCodeDialog({super.key, required this.visitor});

  final VisitorModel visitor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr(LocaleKeys.qr_title), style: CustomTextStyle.titleTextStyle(color: AppColors.textBody)),
              const SizedBox(height: 4),
              Text(visitor.name, style: CustomTextStyle.bodyTextStyle(color: AppColors.textSub)),
              const SizedBox(height: Dimen.defaultSpace),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: QrImageView(
                  data: visitor.qrData,
                  version: QrVersions.auto,
                  size: 220,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.primary),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: Dimen.mediumSpace),
              Text(visitor.id, style: CustomTextStyle.titleTextStyle(color: AppColors.primary, fontSize: 16)),
              const SizedBox(height: Dimen.smallSpace),
              Text(
                tr(LocaleKeys.qr_hint),
                textAlign: TextAlign.center,
                style: CustomTextStyle.captionTextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: Dimen.largeSpace),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => dismiss(context: context),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(tr(LocaleKeys.close)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showQrCodeDialog(BuildContext context, VisitorModel visitor) {
  return showDialog<void>(context: context, builder: (_) => QrCodeDialog(visitor: visitor));
}
