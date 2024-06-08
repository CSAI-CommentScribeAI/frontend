import 'package:flutter/material.dart';
import 'package:frontend/all/screens/signup_screen.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  int _selectedIndex = -1; // 초기 값 설정
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
                  ],
                  activeFgColor: Colors.black,
                  inactiveBgColor: const Color(0xFFD6D6F8),
                  activeBorders: [
                    Border.all(width: 5, color: const Color(0xFFD6D6F8))
                  ],
                  inactiveFgColor: Colors.black,
                  initialLabelIndex: _selectedIndex,
                  totalSwitches: 2,
                  labels: const ['사장님', '고객'],
                  radiusStyle: true,
                  onToggle: (index) {
                    if (index == _previousIndex) {
                      return;
                    }
                    setState(() {
                      _selectedIndex = index!;
                      _previousIndex = index;
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
                          userRole:
                              _selectedIndex == 0 ? 'ROLE_OWNER' : 'ROLE_USER',
                        ),
                      ),
                    );
                    print(_selectedIndex);
                  },
                  style: TextButton.styleFrom(),
                  child: const Text(
                    '다음으로 >',
                    style: TextStyle(
                      color: Color(0xFF7E7EB2),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
