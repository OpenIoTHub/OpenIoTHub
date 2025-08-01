# openiothub_plugin

#### 云易连APP的UI部分插件，通过添加UI插件以支持更多的

[物联网设备](./lib/plugins/mdnsService/devices)和[私有云服务](./lib/plugins/mdnsService/mDNSService)

#### 开发云易连插件需要包含三步：

* 在[设备模型目录](./lib/plugins/mdnsService/devices)或者
  [私有云服务目录](./lib/plugins/mdnsService/mDNSService)创建对应的界面模型
* 将上述创建的页面引入到[components.dart](./lib/plugins/mdnsService/components.dart)
* 将创建的页面在[modelsMap.dart](./lib/plugins/mdnsService/modelsMap.dart)中的map里面注册(map的key是设备或者模型的名称，值是页面)

#### 例如：

创建一个[oneKeySwitch.dart](lib/plugins/mdnsService/devices/local/oneKeySwitch.dart)页面  
然后在[components.dart](./lib/plugins/mdnsService/components.dart#L5)引入  
然后在[modelsMap.dart](./lib/plugins/mdnsService/modelsMap.dart#L9)中注册

#### 插件规范：

目前插件规范是引入一个PortService模型，页面根据PortService中保存的信息进行操作  
页面一个设一个名叫modelName的静态常亮，这是该模型的唯一ID  
具体参考目前的插件页面例子

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/), a library module containing code that can be
shared easily across multiple Flutter or Dart projects.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on
mobile development, and a full API reference.
