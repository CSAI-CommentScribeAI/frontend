import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;

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
                    labelText: '이메일',
                    labelStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              const PasswordTextField(),
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
                        onPressed: () {
                        },
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
                        onPressed: () {
                        },
                        child:  Text(
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
                        ),),
                       TextButton(
                        onPressed: () {
                        },
                        child:  Text(
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
                          onPressed: () {
                          },
                           style: ButtonStyle(
                           backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff374AA3)),
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
                    },
                    child: const Text(
                      '사장님 앱이 처음이신가요?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      
                      ),
                    ),
                  ),
                )
          ]),
        ),
      ),
    );
  }
}


class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              labelText: '비밀번호',
              labelStyle: const TextStyle(fontSize: 13),
            ),
          ),
          Positioned(
            right: 0,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Text(
                _obscureText ? '보기' : '숨기기',
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

