import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:biblioteka/consts/validator.dart';
import 'package:biblioteka/screens/auth/register.dart';
import 'package:biblioteka/screens/root_screen.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  bool _isLoading = false;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _loginFct() async {
    final isValid = _formkey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // OVO je bitno: idi na Root i skloni Login sa stack-a
      Navigator.of(context).pushNamedAndRemoveUntil(
        RootScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      // najčešće poruke (možeš dodati još)
      String msg = "Login failed.";
      if (e.code == "user-not-found") msg = "No user found for that email.";
      if (e.code == "wrong-password") msg = "Wrong password.";
      if (e.code == "invalid-email") msg = "Invalid email address.";
      if (e.code == "user-disabled") msg = "This user account is disabled.";

      _showSnack(msg);
    } catch (_) {
      if (!mounted) return;
      _showSnack("Something went wrong. Try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack("Enter your email first.");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      _showSnack("Password reset email sent.");
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String msg = "Couldn't send reset email.";
      if (e.code == "invalid-email") msg = "Invalid email address.";
      if (e.code == "user-not-found") msg = "No user found for that email.";
      _showSnack(msg);
    } catch (_) {
      if (!mounted) return;
      _showSnack("Something went wrong. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage("${AssetsManager.imagePath}/logo.png"),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Biblioteka",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TitelesTextWidget(label: "Welcome back!"),
                ),
                const SizedBox(height: 16),

                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email address",
                          prefixIcon: Icon(IconlyLight.message),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                        validator: MyValidators.emailValidator,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "***********",
                          prefixIcon: const Icon(IconlyLight.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => obscureText = !obscureText);
                            },
                          ),
                        ),
                        onFieldSubmitted: (_) => _loginFct(),
                        validator: MyValidators.passwordValidator,
                      ),

                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading ? null : _forgotPassword,
                          child: const SubtitleTextWidget(
                            label: "Forgot password?",
                            fontStyle: FontStyle.italic,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.login),
                          label: Text(_isLoading ? "Signing in..." : "Login"),
                          onPressed: _isLoading ? null : _loginFct,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SubtitleTextWidget(label: "New here?"),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterScreen.routName,
                                    );
                                  },
                            child: const SubtitleTextWidget(
                              label: "Sign up",
                              fontStyle: FontStyle.italic,
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  RootScreen.routeName,
                                );
                              },
                        child: const Text("Continue as Guest"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
