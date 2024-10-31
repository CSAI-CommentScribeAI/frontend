import 'package:frontend/user/models/orderMenu_model.dart';

class OrderModel {
  final int orderId;
  final int storeId;
  final int userId;
  final String storeName;
  String orderStatus;
  final String storeImageUrl;
  final List<OrderMenu> orderMenus;
  final int totalPrice;
  final String userAddress;
  final String createdAt;

  OrderModel({
    required this.orderId,
    required this.storeId,
    required this.userId,
    required this.storeName,
    required this.orderStatus,
    required this.storeImageUrl,
    required this.orderMenus,
    required this.totalPrice,
    required this.userAddress,
    required this.createdAt,
  });

  // JSON 데이터를 OrderModel 객체로 변환하는 팩토리 메서드
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // JSON에서 orderMenus 필드를 가져와서 List<OrderMenu>로 변환
    var orderMenusFromJson = json['orderMenus'] as List;
    // 각 주문 메뉴 데이터를 OrderMenu 객체로 변환하여 리스트로 생성
    List<OrderMenu> orderMenusList = orderMenusFromJson
        .map((orderMenu) => OrderMenu.fromJson(orderMenu))
        .toList();

    return OrderModel(
      orderId: json['orderId'],
      storeId: json['storeId'],
      userId: json['userId'],
      storeName: json['storeName'],
      orderStatus: json['orderStatus'],
      storeImageUrl: json['storeImageUrl'],
      orderMenus: orderMenusList,
      totalPrice: json['totalPrice'],
      userAddress: json['userAddress'],
      createdAt: json['createdAt'],
    );
  }
}
