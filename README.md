# OpenIoTHUb
### Remote access to your network services (behind a NAT or firewall) with p2p transport

[README](README.md) | [中文文档](README_zh.md)

[Download from releases](https://github.com/OpenIoTHub/OpenIoTHub/releases)

[![Get it from the App Store](.github/assets/badge-download-on-the-app-store.svg)](https://apps.apple.com/cn/app/id1501554327)
<a target="_blank" href="https://play.google.com/store/apps/details?id=com.iotserv.openiothub"><img border="0" src=".github/assets/google-play.png" alt="Get it from the Google Play" title="Google Play" width="150" height="75"></a>

#### What is OpenIoTHub
💖A free IoT platform and private cloud platform, help you access remote services and IoT Devices.

#### Download OpenIoTHub App：
  * Android,Windows,Linux,Darwin version：https://github.com/OpenIoTHub/OpenIoTHub/releases
  * iOS version：https://apps.apple.com/cn/app/id1501554327
#### OpenIoTHub Gateway Download（Continuously running on the LAN to receive access requests）:
  * Windows,Linux,Darwin version：https://github.com/OpenIoTHub/gateway-go/releases
  * This App(OpenIoTHub) also has a **Built in** gateway provides QR code addition method
###### OpenIoTHub Server Download（high level, common user not necessary）:
> ##### self hosted server for OpenIoTHub（high level）：
> * https://github.com/OpenIoTHub/server-go/releases
> * The server should configure its own port and secret key. The gateway can use the self built server by using the information and public network address you have configured
---
#### course：
 * BiliBili：https://space.bilibili.com/1222749704
---
#### supported features：
- [x] Support ipv4 p2p
- [x] Support ipv6 p2p
- [x] scan [gateway](https://github.com/OpenIoTHub/gateway-go) QR add a gateway
- [x] find [gateway](https://github.com/OpenIoTHub/gateway-go)
- [x] Support configuration saving, and load the old configuration directly before the next startup
- [x] Support direct opening of Intranet website port
- [x] Support offline download of aria2 using intranet directly
- [x] Support SSH terminals with direct access to Intranet
- [x] Support file access via intranet SSH (upload and download)
- [x] Support to open VNC desktop of Intranet machine directly
- [x] Support calling mobile phone RDP client to open the desktop of Intranet windows
- [x] Support mapping FTP protocol
- [x] Network boot (WOL)
- [ ] Directly back up the address book to the private cloud
- [x] Support the discovery and control of smart home devices ([IOT device]（ https://github.com/iotdevice/todo-list )

---

#### Preview
  * gateway list

<img src="screen/gateway-list.jpg" width = "50%" height = "50%" alt="gateway-list"/>

  * remote host in LAN list

<img src="screen/remote-host-list.jpg" width = "50%" height = "50%" alt="screen/remote-host-list.jpg"/>

  * remote ports in LAN list

<img src="screen/remote-ports-list.jpg" width = "50%" height = "50%" alt="remote-ports-list"/>

  * remote mdns service

<img src="screen/remote-mdns-service.jpg" width = "50%" height = "50%" alt="remote-mdns-service"/>
