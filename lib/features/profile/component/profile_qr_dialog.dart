import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_color_extension.dart';
import '../../../core/theme/typography.dart';

class ProfileQrDialog extends StatefulWidget {
  final String loginId;

  const ProfileQrDialog({super.key, required this.loginId});

  @override
  State<ProfileQrDialog> createState() => _ProfileQrDialogState();
}

class _ProfileQrDialogState extends State<ProfileQrDialog> {
  static const int _totalSeconds = 180;

  Timer? _timer;
  int _remainingSeconds = _totalSeconds;

  String get qrData {
    return jsonEncode({
      'loginId': widget.loginId,
      'crtfcSeCd': 'QR',
      'loginTy': 'STUDENT',
    });
  }

  String get _timerText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();

        if (!mounted) return;

        Navigator.of(context).pop();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: context.colors.textPrimary),
          ),
        ),

        Text(
          '학생 QR',
          style: Typo.bodyLBold.copyWith(color: context.colors.textPrimary),
        ),

        const SizedBox(height: 8),

        Text(
          '로그인에 사용할 QR 코드입니다.',
          style: Typo.bodyS.copyWith(color: context.colors.textSecondary),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 220,
            backgroundColor: Colors.white,
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: context.colors.primary100,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule, size: 16, color: context.colors.primary500),

              const SizedBox(width: 6),

              Text(
                '$_timerText',
                style: Typo.bodySBold.copyWith(
                  color: context.colors.primary500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Text(
          widget.loginId,
          style: Typo.bodyS.copyWith(color: context.colors.textSecondary),
        ),
      ],
    );
  }
}
