import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/main.dart';
import 'package:mobil_denemetakip/services/auth-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../services/userAuth-service.dart';

class GirisYapScreen extends StatefulWidget {
  const GirisYapScreen({Key? key}) : super(key: key);

  @override
  _GirisYapScreenState createState() => _GirisYapScreenState();
}

class _GirisYapScreenState extends State<GirisYapScreen> {
  final TextEditingController _usernameOrEmail = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final authService = AuthService();
  bool _obscurePassword = true;
  final userAuthService = UserAuthService();
  final _usernameOrEmailKey = const FormKey<String>(#usernameOrEmail);
  final _passwordKey = const FormKey<String>(#password);
  void submitLogin() {
    userAuthService.login(_usernameOrEmail.text, _password.text, context,
        callBackFunction: () {
      authService.identityCheck();
      successToast("Giriş Başarılı", "Kullanıcı girişi başarıyla sağlanmıştır.",
          Navigator.of(context).context);
      context.go("/");
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      child: Column(
        children: [
          FormField<String>(
            key: _usernameOrEmailKey,
            label: Text(
              "Email veya kullanıcı adı",
              style: TextStyle(
                color: themeData.colorScheme.foreground,
                fontSize: 14,
              ),
            ),
            child: TextField(
              style: TextStyle(
                color: themeData.colorScheme.foreground,
                fontSize: 14,
              ),
              controller: _usernameOrEmail,
            ),
            validator: LengthValidator(
                min: 1, message: "Email veya kullanıcı adı gereklidir."),
            showErrors: const {FormValidationMode.initial},
          ),
          FormField<String>(
            padding: const EdgeInsets.only(top: 12.0),
            key: _passwordKey,
            label: Text(
              "Şifre",
              style: TextStyle(
                color: themeData.colorScheme.foreground,
                fontSize: 14,
              ),
            ),
            
            validator: LengthValidator(min: 1, message: "Şifre gereklidir."),
            showErrors: const {FormValidationMode.changed},
            child: TextField(
                obscureText: _obscurePassword,
                style: TextStyle(
                  color: themeData.colorScheme.foreground,
                  fontSize: 14,
                ),
                controller: _password,
                trailing: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? LucideIcons.eye
                        : LucideIcons.eyeOff, // Gizli/ Açık göz ikonları
                  ),
                  variance: ButtonVariance.ghost,
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )),
          ),
          TextButton(
            onPressed: () {
              context.go("/sifremi-unuttum");
            },
            child: Text(
              "Şifremi Unuttum",
              style: TextStyle(
                color: themeData.colorScheme.foreground,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            width: double.infinity,
            child: PrimaryButton(
              onPressed: () async {
                submitLogin();
              },
              child: const Text('Giriş Yap'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.6,
                child: Text(
                  "Hesabınız yok mu?",
                  style: TextStyle(
                    color: themeData.colorScheme.foreground,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.go("/kayit-ol");
                },
                child: Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    color: themeData.colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
