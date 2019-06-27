import 'package:flutter/material.dart';
import 'package:provider_sku/goods_details_model.dart';
import 'package:provider_sku/sku_util.dart';

class SkuProvider with ChangeNotifier {
  final GoodsDetailsModel detailsModel;
  Map<String, SkuModel> _skus;
  List<GroupProvider> groups = [];
  String selectedSku;
  SkuModel selectedSkuModel;

  SkuProvider(this.detailsModel) {
    _initSku();
    _initRadioGroupData();
  }

  void _initSku() {
    Map<String, SkuModel> map = Map<String, SkuModel>();
    detailsModel?.skus?.forEach((item) => map[item.sku] = item);
    _skus = SkuUtil.skuCollection(map);
    _skuMatching();
  }

  void _initRadioGroupData() {
    detailsModel?.goods?.forEach((value) {
      GroupProvider group = GroupProvider(value.name);
      for (var radio in value.items) {
        RadioProvider childItem = RadioProvider(radio);
        group.addRadio(childItem);
      }
      groups.add(group);
      group.addListener(_skuMatching);
    });
  }

  void _skuMatching() {
    int count = 0; //记录还有多少个按钮组没有被选中
    int lastUnselectedIndex = 0; //最后一个没有被选中的按钮组

    List skuList = [], unselectedItemNames = []; //选中的属性放入集合,没有选择的把itemName放数组
    for (var index = 0; index < groups.length; ++index) {
      var group = groups[index];
      //把禁用的按钮变激活
      group.radios.where((radio) => radio.isDisabled).forEach((radio) => radio.setDisabled(false));

      //没有选择的组
      if (!group.isSelect) {
        count += 1;
        lastUnselectedIndex = index;
        unselectedItemNames.add(group.groupName);
      } else {
        skuList.add(group.selectedValue);
      }
    }

    //当只有一组属性没选时
    if (count == 1) {
      GroupProvider lastUncheckGroup = groups[lastUnselectedIndex];
      for (var radio in lastUncheckGroup.radios) {
        List sku = List();
        var radioName = radio.radioName;
        //那到选中组里面的值，去和未选中组里面的所以值组合sku去匹配
        for (var j = 0; j < groups.length; ++j) {
          if (j != lastUnselectedIndex)
            sku.add(groups[j].selectedValue);
          else
            sku.add(radioName);
        }
        //没有找到变灰
        var skuModel = _skus[sku.join(';')];
        if (skuModel == null || skuModel.count <= 0) {
          radio.setDisabled(true);
        }
      }
      //当所有属性都有选时
    } else if (count == 0) {
      for (var group in groups) {
        //拿到按钮组里没有没选中的
        group.radios.where((radio) => group.selectedValue != radio.radioName).forEach((radio) {
          List sku = List();
          //选中的和其他组所有未选中的组成sku，去匹配
          for (var tempItem in groups) {
            if (!identical(group, tempItem))
              sku.add(tempItem.selectedValue);
            else
              sku.add(radio.radioName);
          }

          //没有找到变灰
          var skuModel = _skus[sku.join(';')];
          if (skuModel == null || skuModel.count <= 0) {
            radio.setDisabled(true);
          }
        });
      }
    }

    var sku = skuList.join(";");
    selectedSkuModel = _skus[sku];
    //显示价格等
    if (count != 0) {
      selectedSku = "请选择\t${unselectedItemNames.join("，")}";
    } else {
      selectedSku = "已选\t${skuList.join("，")}";
    }
    //刷新
    notifyListeners();
  }
}

class GroupProvider with ChangeNotifier {
  List<RadioProvider> radios;
  final String groupName;
  String selectedValue;

  bool get isSelect => selectedValue != null;

  GroupProvider(this.groupName) {
    radios = [];
  }

  void addRadio(RadioProvider radioButton) {
    radios.add(radioButton);
  }

  void changeSelectValue(String value) {
    this.selectedValue = value;
    notifyListeners();
  }
}

class RadioProvider with ChangeNotifier {
  bool isDisabled = false;
  final String radioName;

  RadioProvider(this.radioName);

  void setDisabled(bool isDisabled) {
    this.isDisabled = isDisabled;
    notifyListeners();
  }
}
