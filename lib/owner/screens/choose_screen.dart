import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/owner/screens/signup_screen.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  int _selectedIndex =
      -1; // -1을 초기 값으로 사용하는 것은 초기화되지 않은 상태를 나타내거나 아직 유효한 선택이 없음을 나타냄
  int _previousIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.black,
          ),
        ),
      ),
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
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text(
                  '당신은 어느 쪽이신가요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E7EB2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ToggleSwitch(
                  minWidth: 200.0,
                  minHeight: 60.0,
                  cornerRadius: 10.0,
                  activeBgColors: const [
                    [Colors.white],
                    [Colors.white]
                  ], // 토글 선택 시 선택된 토글 해당 색상으로 변경
                  activeFgColor: Colors.black,
                  inactiveBgColor: const Color(0xFFD6D6F8), // 토글 전체 색상 변경
                  activeBorders: [
                    Border.all(width: 5, color: const Color(0xFFD6D6F8))
                  ], // 전체 토글과 선택된 토글 사이의 간격 해당 색상으로 변경
                  inactiveFgColor: Colors.black,
                  initialLabelIndex: _selectedIndex,
                  totalSwitches: 2,
                  labels: const ['사장님', '고객'],
                  radiusStyle: true,
                  onToggle: (index) {
                    if (index == _previousIndex) {
                      // 사용자가 이전에 선택한 인덱스와 현재 선택한 인덱스가 같을 경우 함수를 종료
                      return;
                    }
                    setState(() {
                      _selectedIndex = index!;
                      _previousIndex =
                          index; // 선택된 인덱스를 _selectedIndex 변수에 저장하고, 이전 선택된 인덱스를 _previousIndex 변수에 저장
                    });
                  },
                  customTextStyles: [
                    for (int i = 0; i < 2; i++)
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            _selectedIndex == i ? Colors.black : Colors.black54,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 300),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(
                            // 0이면 사장님(ROLE_OWNER), 1이면 고객(ROLE_USER) 반환
                            userRole: _selectedIndex == 0
                                ? 'ROLE_OWNER'
                                : 'ROLE_USER',
                          ),
                        ),
                      );
                      print(_selectedIndex);
                    },
                    style: TextButton.styleFrom(),
                    child: const Text('다음으로 >',
                        style: TextStyle(
                          color: Color(0xFF7E7EB2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
