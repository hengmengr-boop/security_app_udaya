import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// Clean QR code dialog containing ONLY the QR Code and top-right close button.
final class QrCodeDialog extends StatelessWidget with ModalUtilsMixin {
  const QrCodeDialog({super.key, required this.visitor});

  final VisitorModel visitor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top-Right Close Button Only
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => dismiss(context: context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F3F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 20, color: Color(0xFF69758F)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Prominent QR Code ONLY
              Center(
                child: QrImageView(
                  data: visitor.qrData,
                  version: QrVersions.auto,
                  size: 260,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppColors.primary,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppColors.primary,
                  ),
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
  return showDialog<void>(
    context: context,
    builder: (_) => QrCodeDialog(visitor: visitor),
  );
}
