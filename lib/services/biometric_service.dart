import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    if (!await _auth.canCheckBiometrics) return false;
    return _auth.authenticate(
      localizedReason: 'Verify your identity to open your profile',
      biometricOnly: true,
      persistAcrossBackgrounding: true,
    );
  }
}
