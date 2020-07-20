# OpenIoTHUb
[![Build Status](https://travis-ci.com/OpenIoTHub/OpenIoTHub.svg?branch=master)](https://travis-ci.com/OpenIoTHub/OpenIoTHub)

[README](README.md) | [中文文档](README_zh.md)

#### What is OpenIoTHub
💖A free IoT platform and private cloud platform

#### Download OpenIoTHub App：
  * Android,Windows,Linux,Darwin version：https://github.com/OpenIoTHub/OpenIoTHub/releases
  * iOS version：https://apps.apple.com/cn/app/%E4%BA%91%E6%98%93%E8%BF%9E/id1501554327
#### OpenIoTHub Gateway Download:
  * Windows,Linux,Darwin version：https://github.com/OpenIoTHub/gateway-go/releases
  * Android version：https://github.com/OpenIoTHub/GateWay/releases
> #### self hosted server for OpenIoTHub（high level）：
> * https://github.com/OpenIoTHub/server-go/releases
> * The server should configure its own port and secret key. The gateway can use the self built server by using the information and public network address you have configured
---
#### course：
  * 简书：https://www.jianshu.com/u/b312a876d66e
---
#### supported features：
- [x] 1.find [gateway](https://github.com/OpenIoTHub/gateway-go)
- [x] 2.Support configuration saving, and load the old configuration directly before the next startup
- [x] 3. Support direct opening of Intranet website port
- [x] 4. Support offline download of aria2 using intranet directly
- [x] 5. Support SSH terminals with direct access to Intranet
- [x] 6. Support file access via intranet SSH (upload and download)
- [x] 7. Support to open VNC desktop of Intranet machine directly
- [x] 8. Support calling mobile phone Rd client to open the desktop of Intranet windows
- [x] 9. Support mapping FTP protocol
- [x] 10. Network boot (WOL)
- [ ] 11. Directly back up the address book to the private cloud
- [x] 12. Support the discovery and control of smart home devices ([IOT device]（ https://github.com/iotdevice/todo-list )

---
#### 开发：
#### Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

---
#### preview
  * smart home control(https://github.com/iotdevice/esp8266-switch)

<img src="./screen/智能设备开关控制.png" width = "50%" height = "50%" alt="智能设备开关控制"/>

  * remote network list

<img src="./screen/远程网络列表.png" width = "50%" height = "50%" alt="远程网络列表"/>

  * mdns service find list

<img src="./screen/内网由mDNS声明的服务.png" width = "50%" height = "50%" alt="内网由mDNS声明的服务"/>

  * device manager

<img src="./screen/设备管理器.png" width = "50%" height = "50%" alt="设备管理器"/>

  * device list

<img src="./screen/设备列表.png" width = "50%" height = "50%" alt="设备列表"/>

  * common devices

<img src="./screen/普通设备的服务.png" width = "50%" height = "50%" alt="普通设备的服务"/>

  * tcp service of common device

<img src="./screen/普通设备的TCP服务.png" width = "50%" height = "50%" alt="普通设备的TCP服务"/>

  * the tcp open method of common device

<img src="./screen/TCP端口打开方式.png" width = "50%" height = "50%" alt="TCP端口打开方式"/>

  * me

<img src="./screen/我.png" width = "50%" height = "50%" alt="我"/>
