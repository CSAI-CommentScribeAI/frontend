import 'package:flutter/material.dart';
import 'package:frontend/owner/screens/address_screen.dart';
import 'package:frontend/user/screens/tossPayments_screen.dart';
import 'package:frontend/user/widgets/cart_widget.dart';
import 'package:frontend/user/widgets/orderAndPay_widget.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isChecked = false;
  bool ownerChecked = false;
  bool riderChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: CloseButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          '주문 / 결제',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF374AA3),
        actions: const [
          // 홈 화면으로 이동
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            children: [
              // 고객 집 주소
              Card(
                color: Colors.white,
                shadowColor: const Color(0xFF374AA3),
                elevation: 3.0, // 그림자 설정
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '집 주소',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF808080),
                                ),
                              ),

                              // 주소 페이지로 이동
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddressPage(null, null),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  '수정',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7E7EB2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            '서울특별시 서초구 강남대로 583\n성결아파트 109동 807호',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 주소 입력 경고 컨테이너
                    Container(
                      width: double.infinity,
                      height: 39,
                      decoration: BoxDecoration(
                        color: const Color(0xFFAEAEE5).withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '주소가 잘못 입력된 경우 재배달 및 환불이 되지 않습니다.',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 17),

              // 주문 내용
              const CartWidget(),
              const SizedBox(height: 17),

              // 결제수단
              const Card(
                color: Colors.white,
                shadowColor: Color(0xFF374AA3),
                elevation: 3.0, // 그림자 설정
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '결제수단',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF808080),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text('선택한 결제수단'), // 나중에 페이 선택 시 나오게 구현 예정
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Text(
                            '페이로 결제 시 포인트 적립',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF808080),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 17),

              // 요청사항
              Card(
                color: Colors.white,
                shadowColor: const Color(0xFF374AA3),
                elevation: 3.0, // 그림자 설정
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '요청사항',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF808080),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                checkboxContainer(
                                  true,
                                  '일회용 수저, 포크 안주셔도 돼요',
                                  const Color(0xFF7E7EB2),
                                  Colors.white,
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  '가게 사장님께',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                checkboxContainer(
                                  false,
                                  '예) 견과류 빼주세요, 덜 맵게 해주세요',
                                  const Color(0xFFAEAEE5).withOpacity(0.3),
                                  const Color(0xFF808080).withOpacity(0.88),
                                ),
                                const SizedBox(height: 9),
                                checkboxTile(ownerChecked, '다음에도 사용', (value) {
                                  setState(() {
                                    ownerChecked = value!;
                                  });
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 라이더 요청사항 컨테이너
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFAEAEE5).withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '라이더님께',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF808080),
                              ),
                            ),
                            const SizedBox(height: 9),
                            checkboxContainer(false, '문 앞에 두고 벨 눌러주세요',
                                const Color(0xFF7E7EB2), Colors.white),
                            const SizedBox(height: 9),
                            checkboxTile(riderChecked, '이 주소에 다음에도 사용',
                                (value) {
                              setState(() {
                                riderChecked = value!;
                              });
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 약관동의 내용
              const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
                child: Text(
                  'CSAI는 통신판매중개자로서 통신판매의 당사자가 아니며, 판매자가 등록한 상품 정보, 상품의 품질 및 거래에 대해서 일체의 책임을 지지 않습니다. 회원은 주문 내용을 확인하였고, 결제에 동의합니다.',
                  style: TextStyle(
                    color: Color(0xFF808080),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const OrderAndPayBtn(
          '20000원 결제하기', TosspaymentsPage()), // '20000'에 totalPrice 변수 넣을 예정
    );
  }

  // 체크박스 컨테이너 위젯
  Widget checkboxContainer(
      bool ischeckedBox, String title, Color backgroundColor, Color textColor) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Row(
        children: [
          // 체크박스 들어있을 때 없을 때 boolean 생성해 삼항연산자 작성
          ischeckedBox
              ? Checkbox(
                  value: isChecked,
                  onChanged: ((value) {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  }),
                  activeColor: const Color(0xFFF3F3FF),
                  checkColor: const Color(0xFF7E7EB2),
                )
              : const SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              color: textColor,
            ),
          ),
          // Image.asset(
          //   'assets/images/plant.png',
          //   width: 1,
          //   height: 1,
          // ),
        ],
      ),
    );
  }

  // 주쇼 사용 체크박스 설정 위젯
  Widget checkboxTile(
      bool checked, String title, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: onChanged,
          activeColor: const Color(0xFFF3F3FF),
          checkColor: const Color(0xFF7E7EB2),
        ),
        Text(title),
      ],
    );
  }
}
