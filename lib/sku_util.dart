import 'goods_details_model.dart';

class SkuUtil {
  /**
   * 算法入口
   *
   * @param initData 所有库存的hashMap组合
   * @return 拆分所有组合产生的所有情况（生成客户端自己的字典）
   */
  static Map<String, SkuModel> skuCollection(Map<String, SkuModel> initData) {
    //用户返回数据
    Map<String, SkuModel> result = new Map<String, SkuModel>();
    // 遍历所有库存
    for (var subKey in initData.keys) {
      SkuModel skuModel = initData[subKey];
      print(">>>>subKey：" + subKey);
      //根据；拆分key的组合
      List<String> skuKeyAttrs = subKey.split(";");

      //获取所有的组合
      List<List<String>> combArr = combInArray(skuKeyAttrs);
//      print("combArr+>>>：" + combArr.toString());

      // 对应所有组合添加到结果集里面
      for (int i = 0; i < combArr.length; i++) {
        add2SKUResult(result, combArr[i], skuModel);
      }

      // 将原始的库存组合也添加进入结果集里面
      String key = join(";", skuKeyAttrs);
      result[key] = skuModel;
    }
    return result;
  }

  static String join(String delimiter, List tokens) {
    StringBuffer sb = StringBuffer();
    bool firstTime = true;
    for (var token in tokens) {
      if (firstTime) {
        firstTime = false;
      } else {
        sb.write(delimiter);
      }
      sb.write(token);
    }
    return sb.toString();
  }

  /**
   * 获取所有的组合放到ArrayList里面
   *
   * @param skuKeyAttrs 单个key被； 拆分的数组
   * @return ArrayList
   */
  static List<List<String>> combInArray(List<String> skuKeyAttrs) {
    if (skuKeyAttrs == null || skuKeyAttrs.length <= 0) return null;
    int len = skuKeyAttrs.length;
    List<List<String>> aResult = List<List<String>>();
    for (int n = 1; n < len; n++) {
      List<List<int>> aaFlags = getCombFlags(len, n);

      for (int i = 0; i < aaFlags.length; i++) {
        List aFlag = aaFlags[i];
        List<String> aComb = new List<String>();
        for (int j = 0; j < aFlag.length; j++) {
          if (aFlag[j] == 1) {
            aComb.add(skuKeyAttrs[j]);
          }
        }
        aResult.add(aComb);
      }
    }
    return aResult;
  }

  /**
   * 算法拆分组合 用1和0 的移位去做控制
   * （这块需要你打印才能看的出来）
   *
   * @param len
   * @param n
   * @return
   */
  static List<List<int>> getCombFlags(int len, int n) {
    if (n <= 0) {
      return new List<List<int>>();
    }
    List<List<int>> aResult = List<List<int>>();
    List<int> aFlag = List(len);
    bool bNext = true;
    int iCnt1 = 0;
    //初始化
    for (int i = 0; i < len; i++) {
      aFlag[i] = i < n ? 1 : 0;
    }
    aResult.add(List<int>.from(aFlag));
    while (bNext) {
      iCnt1 = 0;
      for (int i = 0; i < len - 1; i++) {
        if (aFlag[i] == 1 && aFlag[i + 1] == 0) {
          for (int j = 0; j < i; j++) {
            aFlag[j] = j < iCnt1 ? 1 : 0;
          }
          aFlag[i] = 0;
          aFlag[i + 1] = 1;
          List<int> aTmp = List<int>.from(aFlag);
          aResult.add(aTmp);
          if (!join("", aTmp).substring(len - n).contains("0")) {
            bNext = false;
          }
          break;
        }
        if (aFlag[i] == 1) {
          iCnt1++;
        }
      }
    }
    return aResult;
  }

  /**
   * 添加到数据集合
   *
   * @param result
   * @param newKeyList
   * @param skuModel
   */
  static void add2SKUResult(Map<String, SkuModel> result, List<String> newKeyList, SkuModel skuModel) {
//    print("--->>>>newKeyList" + newKeyList.toString());
    String key = join2(";", newKeyList);
    print("key: " + key);
    if (result.keys.contains(key)) {
      result[key].price = skuModel.price;
      result[key].sku = skuModel.sku;
      result[key].price = skuModel.price;
      result[key].color = skuModel.color;
      result[key].count = result[key].count + skuModel.count;
    } else {
      result[key] =
          SkuModel(price: skuModel.price, color: skuModel.color, count: skuModel.count, sku: skuModel.sku);
    }
//    print("result:>>" + result.toString());
  }

  static String join2(String delimiter, Iterable tokens) {
    StringBuffer sb = StringBuffer();
    var it = tokens.iterator;
    if (it.moveNext()) {
      sb.write(it.current);
      while (it.moveNext()) {
        sb.write(delimiter);
        sb.write(it.current);
      }
    }
    return sb.toString();
  }
}
