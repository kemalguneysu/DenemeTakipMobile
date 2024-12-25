import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/user-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class KayitOlScreen extends StatefulWidget {
  const KayitOlScreen({Key? key}) : super(key: key);

  @override
  _KayitOlScreenState createState() => _KayitOlScreenState();
}

class _KayitOlScreenState extends State<KayitOlScreen> {

  final TextEditingController _emailController = TextEditingController();
  final _emailKey = const FormKey<String>(#email);
  final TextEditingController _usernameController = TextEditingController();
  final _usernameKey = const FormKey<String>(#username);
  final TextEditingController _passwordController = TextEditingController();
  final _passwordKey = const FormKey<String>(#password);
  final TextEditingController _passwordControlController = TextEditingController();
  final _passwordControlKey = const FormKey<String>(#passwordControl);
  CheckboxState _policy = CheckboxState.unchecked;
  CheckboxState _emailConfirmation = CheckboxState.unchecked;
  final userService=UserService();
  void submitRegister() {
    var user=User(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      passwordConfirm: _passwordControlController.text,
      getEmailConfirmation: _emailConfirmation==CheckboxState.checked,
    );
    userService.createUser(user.toJson(),Navigator.of(context).context, callBackFunction: () {
      successToast("Kayıt Başarılı", "Kullanıcı Başarıyla Oluşturuldu",context);
        context.go("/giris-yap");
    });
  }
 @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      child: Column(
        children: [
          FormField<String>(
            key: _emailKey,
            label: Text(
              "Email",
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
              controller: _emailController,
            ),
          ),
          FormField<String>(
            key: _usernameKey,
            label: Text(
              "Kullanıcı adı",
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
              controller: _usernameController,
            ),
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
            child: TextField(
              obscureText: true,
              style: TextStyle(
                color: themeData.colorScheme.foreground,
                fontSize: 14,
              ),
              controller: _passwordController,
            ),
          ),
          FormField<String>(
            padding: const EdgeInsets.only(top: 12.0),
            key: _passwordControlKey,
            label: Text(
              "Şifre Tekrar",
              style: TextStyle(
                color: themeData.colorScheme.foreground,
                fontSize: 14,
              ),
            ),
            child: TextField(
              obscureText: true,
              style: TextStyle(
                color: themeData.colorScheme.foreground,
                fontSize: 14,
              ),
              controller: _passwordControlController,
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Checkbox(
                state: _policy,
                onChanged: (value) {
                  setState(() {
                    _policy = value!;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Theme.of(context).colorScheme.foreground, fontSize: 14),
                    children: [
                      const TextSpan(text: "Gizlilik Politikası'nı "),
                      TextSpan(
                        text: 'Gizlilik Politikası\'nı',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                'https://www.denemetakip.com/yasal/gizlilik-politikasi'));
                          },
                      ),
                      const TextSpan(text: ' ve '),
                      TextSpan(
                        text: 'Kullanım Şartları\'nı',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                'https://www.denemetakip.com/yasal/kullanim-sartlari'));
                          },
                      ),
                      const TextSpan(
                        text:
                            ' okuduğunuzu ve kabul ettiğinizi onaylıyorsunuz.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                state: _emailConfirmation,
                onChanged: (value) {
                  setState(() {
                    _emailConfirmation = value;
                  });
                },
              ),
              Expanded(
                child: Text(
                  'Yeni özellikler, kampanyalar ve özel içerikler hakkında bilgilendirilmek için e-posta almak istiyorum.',
                  style: TextStyle(color: Theme.of(context).colorScheme.foreground, fontSize: 14),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            width: double.infinity,
            child: PrimaryButton(
              onPressed: () async {
                submitRegister();
              },
              child: const Text('Kayıt Ol'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.6,
                child: Text(
                  "Hesabınız var mı?",
                  style: TextStyle(
                    color: themeData.colorScheme.foreground,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.go("/giris-yap");
                },
                child: Text(
                  "Giriş Yap",
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
