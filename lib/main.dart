import "package:flutter/material.dart";
import 'package:provider_sku/sku_dialog.dart';
import 'goods_details_model.dart';
import 'sku_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SkuProvider skuProvider;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> json = {
      "skus": [
        {"sku": "5.5寸;16G;红色", "color": Colors.red, "price": 101, "count": 10},
        {"sku": "5.5寸;16G;黄色", "color": Colors.yellow, "price": 102, "count": 1},
        {"sku": "5.5寸;32G;黑色", "color": Colors.black, "price": 103, "count": 6},
        {"sku": "5.5寸;32G;红色", "color": Colors.red, "price": 104, "count": 0},
        {"sku": "5.5寸;32G;黄色", "color": Colors.yellow, "price": 105, "count": 0},
        {"sku": "4.7寸;16G;黑色", "color": Colors.black, "price": 106, "count": 16},
        {"sku": "4.7寸;16G;红色", "color": Colors.red, "price": 107, "count": 17},
        {"sku": "4.7寸;16G;黄色", "color": Colors.yellow, "price": 108, "count": 18},
        {"sku": "4.7寸;32G;黑色", "color": Colors.black, "price": 109, "count": 0},
        {"sku": "4.7寸;32G;红色", "color": Colors.red, "price": 110, "count": 20},
        {"sku": "4.7寸;32G;黄色", "color": Colors.yellow, "price": 111, "count": 21},
        {"sku": "6.0寸;16G;黑色", "color": Colors.black, "price": 112, "count": 0},
        {"sku": "6.0寸;16G;红色", "color": Colors.red, "price": 113, "count": 23},
        {"sku": "6.0寸;16G;黄色", "color": Colors.yellow, "price": 114, "count": 24},
        {"sku": "6.0寸;32G;黑色", "color": Colors.black, "price": 115, "count": 0},
        {"sku": "6.0寸;32G;红色", "color": Colors.red, "price": 116, "count": 26},
        {"sku": "6.0寸;32G;黄色", "color": Colors.yellow, "price": 117, "count": 27}
      ],
      "goods": [
        {
          "name": "尺寸",
          "items": ["5.5寸", "4.7寸", "6.0寸"]
        },
        {
          "name": "内存",
          "items": ["16G", "32G"]
        },
        {
          "name": "颜色",
          "items": ["黑色", "红色", "黄色"]
        }
      ]
    };
    GoodsDetailsModel goodsDetailsModel = GoodsDetailsModel.fromJson(json);
    skuProvider = SkuProvider(goodsDetailsModel);
    var list = goodsDetailsModel.goods.map((item) => item.name).toList();
    skuProvider.selectedSku = "请选择\t${list.join("，")}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("sku")),
      body: ChangeNotifierProvider.value(
        value: skuProvider,
        child: Consumer<SkuProvider>(builder: (context, provider, _) {
          return Column(
            children: <Widget>[
              Text(provider.selectedSku ?? ''),
              MaterialButton(onPressed: () => showSkuDialog(), child: Text("购买"), color: Colors.red)
            ],
          );
        }),
      ),
    );
  }

  void showSkuDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Color(0x3e000000),
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
            //底部弹出动画
            position: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
            child: ChangeNotifierProvider.value(value: skuProvider, child: SkuDialog())));
  }
}
