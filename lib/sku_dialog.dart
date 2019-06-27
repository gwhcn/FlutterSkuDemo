import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sku/sku_provider.dart';

class SkuDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
          color: Colors.transparent,
          child: Consumer<SkuProvider>(builder: (context, provider, _) {
            return Container(
              color: Colors.white,
              constraints: BoxConstraints(minHeight: 300, maxHeight: 500, maxWidth: double.infinity),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                SizedBox(height: 20),
                _buildInfo(provider),
                SizedBox(height: 20),
                for (var group in provider.groups)
                  ChangeNotifierProvider<GroupProvider>.value(
                    value: group,
                    child: _RadioGroupItem(),
                  ),
              ]),
            );
          })),
    );
  }

  _buildInfo(SkuProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          color: provider?.selectedSkuModel?.color ?? Colors.black,
          height: 40,
          width: 40,
        ),
        SizedBox(width: 20),
        Text("库存：${provider?.selectedSkuModel?.count ?? 0}"),
        SizedBox(width: 20),
        Text(provider.selectedSku ?? "请选择"),
      ],
    );
  }
}

class _RadioGroupItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var group = Provider.of<GroupProvider>(context);
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16, bottom: 14),
              child: Text(group.groupName, style: TextStyle(fontSize: 14))),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 16,
            runSpacing: 12,
            children: <Widget>[
              for (var radio in group.radios)
                ChangeNotifierProvider<RadioProvider>.value(
                  value: radio,
                  child: _RadioButton(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadioButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var radio = Provider.of<RadioProvider>(context);
    var group = Provider.of<GroupProvider>(context);
    bool isSelect = radio.radioName == group.selectedValue;
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: FlatButton(
        child: Text(radio.radioName, style: TextStyle(fontSize: 12)),
        onPressed: radio.isDisabled
            ? null
            : () {
                if (group.selectedValue != radio.radioName) {
                  //选中
                  group.changeSelectValue(radio.radioName);
                } else {
                  //重复点击取消选中
                  group.changeSelectValue(null);
                }
              },
        color: isSelect ? Color(0x1AFF6631) : Color(0xFFF7F7F7),
        textColor: isSelect ? Color(0xFFFF6732) : Color(0xff333333),
        disabledTextColor: Color(0xff999999),
        shape: StadiumBorder(
            side: BorderSide(
                style: BorderStyle.solid, color: isSelect ? Color(0xFFFF6732) : Color(0xFFF7F7F7))),
      ),
    );
  }
}
