import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isEmailValid = true; // 이메일 유효성
  bool _isPasswordValid = true; // 비밀번호 유효성
  bool _isPasswordVisible = false; // 비밀번호 가시성
  bool _isPasswordConfirmed = true; // 비밀번호 확인 유효성
  late TextEditingController _passwordController; // 비밀번호 입력 필드 제어 위해서
  late TextEditingController _confirmPasswordController; // 두 번째 비밀번호 입력 필드 제어 위해서

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(); // 컨트롤러는 비밀번호 입력 필드를 제어, 필요한 경우 입력된 텍스트를 가져올 있도록
    _confirmPasswordController = TextEditingController(); // 두 번째 비밀번호(일치여부) 입력 필드의 컨트롤러 초기화


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
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
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
                    labelText: '이름',
                    labelStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 55,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: _isEmailValid ? '이메일 주소' : '',
                    labelStyle: const TextStyle(fontSize: 13),
                    errorText: _isEmailValid ? null : '올바른 이메일 형식이 아닙니다.', // _isEmailValid가 false이면 '올바른 이메일 형식이 아닙니다.'가 표시
                  ),
                  onChanged: (value) {
                    setState(() {
                      // 사용자가 입력한 텍스트(value)가 비어있는지 확인
                      if(value.isEmpty) {
                        // 만약 비어있다면, 유효한 이메일이 아니라고 판단
                        _isEmailValid = true;
                      } else {
                        // 값이 비어있지 않다면, EmailValidator.validate 함수를 사용하여 이메일 유효성을 검사
                        _isEmailValid = EmailValidator.validate(value);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              PasswordTextField( // 비밀번호 입력 필드
                isPasswordValid: _isPasswordValid,
                isPasswordVisible: _isPasswordVisible,
                isPasswordConfirmed: _isPasswordConfirmed,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty ||
                        value.length < 10 ||
                        !RegExp(
                                r'(?=.*[a-zA-Z])(?=.*[!@#$%^&*()_+])(?=.*[0-9]).{10,}')
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
              const SizedBox(height: 10.0),
              SizedBox(
                height: 55,
                child: TextField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  onChanged: (value) {
                    setState(() {
                      _isPasswordConfirmed = _passwordController.text == value;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: _isPasswordConfirmed ? '비밀번호 확인' : '',
                    labelStyle: const TextStyle(fontSize: 13),
                    errorText: _isPasswordConfirmed ? null : '비밀번호가 일치하지 않습니다.'
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 55,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                    NumberFormatter()],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: '휴대폰 번호',
                    labelStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: SizedBox(
                  height: 45,
                  width: 400,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color(0xff374AA3)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final bool isPasswordValid; // 비밀번호의 유효성
  final bool isPasswordVisible; // 현재 비밀번호가 보이는지 여부
  final ValueChanged<String> onChanged; // 텍스트가 변경될 때 호출되는 콜백 함수
  final VoidCallback? onVisibilityToggle; // 보이기/숨기기 토글 버튼이 눌렸을 때 호출되는 콜백 함수
  final TextEditingController controller; // 텍스트 필드의 컨트롤러
  final bool isPasswordConfirmed; // 비밀번호 확인의 유효성

  const PasswordTextField({
    super.key,
    required this.isPasswordValid,
    required this.isPasswordVisible,
    required this.onChanged,
    this.onVisibilityToggle,
    required this.controller,
    required this.isPasswordConfirmed,
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
            obscureText: !isPasswordVisible, // 보이기/숨기기 플래그에 따라 비밀번호를 가리킴
            onChanged: onChanged, // 텍스트가 변경될 때 onChanged 콜백을 호출
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              labelText: isPasswordValid ? '비밀번호' : '', // 비밀번호가 유효하면 라벨을 표시
              labelStyle: const TextStyle(fontSize: 13),
              errorText: isPasswordValid
                  ? null // 비밀번호가 유효하면 오류 메시지를 표시하지 않음
                  : '비밀번호는 적어도 하나의 영문자, 특수문자 포함 10자 이상이어야 합니다.', // 비밀번호가 유효하지 않으면 오류 메시지를 표시
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

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate( // formatEditUpdate 메서드는 사용자가 텍스트를 입력할 때마다 호출
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text; // 새로 입력된 텍스트를 가져옴

    // 입력된 텍스트가 커서 위치에 있는지 확인합니다.
    if (newValue.selection.baseOffset == 0) {
      return newValue; // 커서가 맨 앞에 있다면 변환을 수행하지 않고 새로운 값을 반환
    }

    var buffer = StringBuffer(); // 문자열을 임시로 저장할 StringBuffer를 생성
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]); // 입력된 텍스트를 buffer에 추가
      var nonZeroIndex = i + 1; // 0이 아닌 문자의 인덱스를 계산
      if (nonZeroIndex <= 3) { // 첫 번째 세 자리 그룹에 있는 경우
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // 세 자리마다 하이픈을 추가
        }
      } else { // 그 이후의 경우
        if (nonZeroIndex % 7 == 0 && nonZeroIndex != text.length && nonZeroIndex > 4) {
          buffer.write('-'); // 일곱 자리마다 하이픈을 추가
        }
      }
    }

    var string = buffer.toString(); // 형식화된 문자열을 가져옴
    return newValue.copyWith(
        text: string, // 형식화된 문자열로 새로운 값으로 설정
        selection: TextSelection.collapsed(offset: string.length)); // 커서 위치를 문자열의 끝으로 설정
  }
}

