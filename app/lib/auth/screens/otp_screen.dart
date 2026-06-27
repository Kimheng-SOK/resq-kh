import 'package:app/models/user_model.dart';
import 'package:app/services/api/auth_api_service.dart';
import 'package:app/services/auth_storage_service.dart';
import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final String? email;
  final String phoneNumber;

  const OtpScreen({super.key, this.email, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterOtp)));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await AuthApiService.verifyOtp(
        email: widget.email,
        phoneNumber: widget.phoneNumber,
        otp: otp,
      );
      final data = result['data'] as Map<String, dynamic>;
      final token = data['access_token'] as String;
      await AuthStorageService.saveToken(token);

      // Cache the full user profile immediately so the header shows the
      // user's name even if the backend profile fetch is slow/offline.
      final userJson = data['user'] as Map<String, dynamic>?;
      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        await AuthStorageService.saveUser(user);
        await AuthStorageService.saveUserId(user.id);
      }

      if (!mounted) return;

      context.go('/location-permission');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(title: Text(l10n.verifyOtp), centerTitle: true),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Icon(Icons.sms, size: 100, color: Color(0xFFD32F2F)),

                const SizedBox(height: 24),

                Text(
                  l10n.verificationCode,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text(
                  l10n.enterOtpSent,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: l10n.otpLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : _verifyOtp,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            l10n.verifyOtp,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    // TODO:
                    // Resend OTP
                  },
                  child: Text(l10n.resendOtp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
