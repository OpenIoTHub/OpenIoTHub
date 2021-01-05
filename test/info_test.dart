//自动生成ios:Info.plist权限文件
import 'package:openiothub_plugin/plugins/mdnsService/mdnsType2ModelMap.dart';
void main() {
  print("	<array>");
  MDNS2ModelsMap.getAllmDnsType().forEach((String type) {
    print("		<string>$type</string>");
  });
  print("	</array>");
}
