import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:frontend/screens/Choose_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isPasswordVisible = false;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '배달반도',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 55,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: _isEmailValid ? '이메일' : '',
                    labelStyle: const TextStyle(fontSize: 13),
                    errorText: _isEmailValid ? null : '올바른 이메일 형식이 아닙니다.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        _isEmailValid = true;
                      } else {
                        _isEmailValid = EmailValidator.validate(value);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              PasswordTextField(
                isPasswordValid: _isPasswordValid,
                isPasswordVisible: _isPasswordVisible,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty ||
                        value.length < 10 ||
                        !RegExp(r'(?=.*[a-zA-Z])(?=.*[!@#$%^&*()_+])(?=.*[0-9]).{10,}')
                            .hasMatch(value)) {
                      _isPasswordValid = false;
                    } else {
                      _isPasswordValid = true;
                    }
                  });
                },
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                controller: _passwordController,
              ),
              const SizedBox(height: 1.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          '자동로그인',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '아이디',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '|',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '비밀번호',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '찾기',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: SizedBox(
                  height: 45,
                  width: 400,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff374AA3)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChoosePage(),
                      ),
                    );
                  },
                  child: const Text(
                    '처음이신가요?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

class PasswordTextField extends StatelessWidget {
  final bool isPasswordValid;
  final bool isPasswordVisible;
  final ValueChanged<String> onChanged;
  final VoidCallback? onVisibilityToggle;
  final TextEditingController controller;

  const PasswordTextField({
    super.key,
    required this.isPasswordValid,
    required this.isPasswordVisible,
    required this.onChanged,
    this.onVisibilityToggle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            onChanged: onChanged,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              labelText: isPasswordValid ? '비밀번호' : '',
              labelStyle: const TextStyle(fontSize: 13),
              errorText: isPasswordValid
                  ? null
                  : '비밀번호는 적어도 하나의 영문자, 특수문자 포함 10자 이상이어야 합니다.',
            ),
          ),
          Positioned(
            right: 0,
            top: isPasswordValid ? 6 : -10,
            child: TextButton(
              onPressed: onVisibilityToggle,
              child: Text(
                isPasswordVisible ? '숨기기' : '보기',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
