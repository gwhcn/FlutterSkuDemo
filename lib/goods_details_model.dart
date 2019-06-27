import 'package:flutter/material.dart';


class GoodsDetailsModel {
  List<SkuModel> skus;
  List<Goods> goods;

  GoodsDetailsModel({this.skus, this.goods});

  GoodsDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['skus'] != null) {
      skus = new List<SkuModel>();
      json['skus'].forEach((v) {
        skus.add(new SkuModel.fromJson(v));
      });
    }
    if (json['goods'] != null) {
      goods = new List<Goods>();
      json['goods'].forEach((v) {
        goods.add(new Goods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.skus != null) {
      data['skus'] = this.skus.map((v) => v.toJson()).toList();
    }
    if (this.goods != null) {
      data['goods'] = this.goods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goods {
  String name;
  List<String> items;

  Goods({this.name, this.items});

  Goods.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    items = json['items'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['items'] = this.items;
    return data;
  }
}

class SkuModel {
  Color color;
  int price;
  int count;
  String sku;

  SkuModel({this.color, this.price, this.count, this.sku});

  SkuModel.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    price = json['price'];
    count = json['count'];
    sku = json['sku'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['price'] = this.price;
    data['count'] = this.count;
    data['sku'] = this.sku;
    return data;
  }
}
