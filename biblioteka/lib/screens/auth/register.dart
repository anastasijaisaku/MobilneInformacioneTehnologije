import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:biblioteka/consts/validator.dart';
import 'package:biblioteka/screens/root_screen.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';

class RegisterScreen extends StatefulWidget {
  static const String routName = "/RegisterScreen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureText = true;
  bool obscureText2 = true;
  bool _isLoading = false;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _repeatPasswordController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _repeatPasswordFocusNode;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _registerFct() async {
    final isValid = _formkey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    if (_passwordController.text.trim() !=
        _repeatPasswordController.text.trim()) {
      _showSnack("Passwords do not match.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1) AUTH (ovo mora da prođe)
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = cred.user;
      if (user == null) {
        _showSnack("User not created. Try again.");
        return;
      }

      await user.updateDisplayName(_nameController.text.trim());

      // 2) FIRESTORE (ovo NE SME da blokira aplikaciju)
      try {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "role": "user",
          "isAdmin": false,
          "createdAt": FieldValue.serverTimestamp(),
        });
      } catch (e) {
        // Ako Firestore padne, korisnik je i dalje registrovan (Auth),
        // samo obavesti da profil nije upisan.
        _showSnack("Account created, but profile save failed (Firestore).");
      }

      if (!mounted) return;

      // 3) NAVIGACIJA (uvek posle Auth)
      Navigator.of(context).pushNamedAndRemoveUntil(
        RootScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String msg = "Sign up failed.";
      if (e.code == "email-already-in-use") msg = "Email is already in use.";
      if (e.code == "invalid-email") msg = "Invalid email address.";
      if (e.code == "weak-password") msg = "Password is too weak.";
      _showSnack(msg);
    } catch (_) {
      if (!mounted) return;
      _showSnack("Something went wrong. Try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage("${AssetsManager.imagePath}/logo.png"),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Biblioteka",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TitelesTextWidget(label: "Create account"),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: SubtitleTextWidget(label: "Enter your details below"),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: "Full name",
                          prefixIcon: Icon(IconlyLight.profile),
                        ),
                        validator: (value) {
                          final v = (value ?? "").trim();
                          if (v.isEmpty) return "Name is required";
                          if (v.length < 2) return "Name is too short";
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email address",
                          prefixIcon: Icon(IconlyLight.message),
                        ),
                        validator: MyValidators.emailValidator,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(IconlyLight.lock),
                          suffixIcon: IconButton(
                            icon: Icon(obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () =>
                                setState(() => obscureText = !obscureText),
                          ),
                        ),
                        validator: MyValidators.passwordValidator,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_repeatPasswordFocusNode);
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _repeatPasswordController,
                        focusNode: _repeatPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        obscureText: obscureText2,
                        decoration: InputDecoration(
                          hintText: "Repeat password",
                          prefixIcon: const Icon(IconlyLight.lock),
                          suffixIcon: IconButton(
                            icon: Icon(obscureText2
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () =>
                                setState(() => obscureText2 = !obscureText2),
                          ),
                        ),
                        validator: (value) {
                          final v = (value ?? "").trim();
                          if (v.isEmpty) return "Repeat password";
                          return null;
                        },
                        onFieldSubmitted: (_) => _registerFct(),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
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
                              : const Icon(Icons.person_add_alt_1),
                          label: Text(_isLoading ? "Creating..." : "Sign up"),
                          onPressed: _isLoading ? null : _registerFct,
                        ),
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
