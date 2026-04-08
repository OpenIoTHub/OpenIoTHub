import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:openiothub/plugin/generated/assets.dart';
import 'package:openiothub/plugin/pages/media/network_video_player_page.dart';
import 'package:openiothub/utils/common/toast.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/utils/plugin/web.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key, required this.baseUrl, required this.data});

  final String baseUrl;
  final Map<String, dynamic> data;

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  // 根据页面宽度确定一行展示几个文件(夹)
  static const _numOneRow = 3;
  static const _pictureExtNames = [
    "bmp",
    "jpg",
    "png",
    "jpeg",
    "ico",
    "webp"
  ];
  static const _videoExtNames = ["mp4", "avi", "flv", "rmvb"];
  static const _musicExtNames = [
    "mp3",
    "wav",
    "aac",
    "m4a",
    "flac",
    "ogg",
    "wma",
    "aiff" "aif",
    "amr",
    "m4r"
  ];
  static const List<String> _sidePathRoutes = [
    '/media/ZimaOS-HD',
    '/media/ZimaOS-HD/Documents',
    '/media/ZimaOS-HD/Downloads',
    '/media/ZimaOS-HD/Gallery',
    '/media/ZimaOS-HD/Media',
    '/media/ZimaOS-HD/Backup',
  ];

  String _currentPath = _sidePathRoutes[1];

  static String _zimaSideBarLabel(int index, OpenIoTHubLocalizations l10n) {
    switch (index) {
      case 0:
        return l10n.nas_files_sidebar_zima_hd;
      case 1:
        return l10n.nas_files_sidebar_documents;
      case 2:
        return l10n.nas_files_sidebar_downloads;
      case 3:
        return l10n.nas_files_sidebar_gallery;
      case 4:
        return l10n.nas_files_sidebar_media;
      case 5:
        return l10n.nas_files_sidebar_backup;
      default:
        return index >= 0 && index < _sidePathRoutes.length
            ? _sidePathRoutes[index]
            : '';
    }
  }
  Widget _filesListWidget = TDLoading(
    size: TDLoadingSize.small,
    icon: TDLoadingIcon.point,
    iconColor: Colors.grey,
  );
  var currentValue = 1;
  final _sideBarController = TDSideBarController();

  @override
  void initState() {
    setCurrentPathByValue(currentValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(OpenIoTHubLocalizations.of(context).nas_files),
        ),
        body: openIoTHubDesktopConstrainedBody(
          maxWidth: 1200,
          child: _buildPaginationSideBar(context),
        ),
    );
  }

  Widget _buildPaginationSideBar(BuildContext context) {
    // 切页用法
    final list = <SideItemProps>[];
    final l10n = OpenIoTHubLocalizations.of(context);

    for (var i = 0; i < _sidePathRoutes.length; i++) {
      list.add(SideItemProps(
        index: i,
        label: _zimaSideBarLabel(i, l10n),
        value: i,
      ));
    }

    // list[1].badge = const TDBadge(TDBadgeType.redPoint);
    // list[2].badge = const TDBadge(
    //   TDBadgeType.message,
    //   count: '8',
    // );

    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon,
                    textStyle: TextStyle(fontSize: 12)))
                .toList(),
            onSelected: setCurrentPathByValue,
          ),
        ),
        Expanded(
            child: SizedBox(
                height: demoHeight,
                child: Scrollbar(
                  thumbVisibility: openIoTHubUseDesktopHomeLayout,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: getPathFileList(),
                  ),
                )))
      ],
    );
  }

  void setCurrentPathByValue(int value) {
    // 显示文件列表
    _currentPath = _sidePathRoutes[value];
    displayImageList(_currentPath);
  }

  // 文件夹内文件列表页面
  Widget getPathFileList() {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
              child: BreadCrumb.builder(
                itemCount: _currentPath.split(RegExp(r'[/]')).length,
                builder: (index) {
                  return BreadCrumbItem(
                      content:
                          Text(_currentPath.split(RegExp(r'[/]'))[index]));
                },
                divider: Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 16),
            // displayImageList(path)
            _filesListWidget
          ],
        ));
  }

  // Widget getAnchorDemo(int index) {
  //   return Container(
  //     decoration: const BoxDecoration(color: Colors.white),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
  //           child: TDText('标题$index',
  //               style: const TextStyle(
  //                 fontSize: 14,
  //               )),
  //         ),
  //         const SizedBox(height: 16),
  //         displayImageList()
  //       ],
  //     ),
  //   );
  // }
  // 文件列表
  void displayImageList(String path) async {
    // TODO 根据api获取文件(夹)列表
    final dio = Dio(BaseOptions(baseUrl: widget.baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"]
    }));
    String reqUri = "/v2_1/files/file";
    try {
      final response = await dio.get(reqUri, queryParameters: {"path": path});
      if (!mounted) return;
      if (response.statusCode == 200) {
        List<Widget> rowList = [];
        // 一行
        List<Widget> itemList = [];
        for (int i = 0; i < response.data["content"].length; i++) {
          if ((i + 1) % _numOneRow == 0) {
            itemList.add(displayImageItem(
                response.data["content"][i]["path"],
                response.data["content"][i]["name"],
                response.data["content"][i]["is_dir"],
                response.data["content"][i]));
            // 将所有行相加
            rowList.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    itemList.length, (index) => itemList[index])));
            itemList.clear();
            rowList.add(
              const SizedBox(height: 18),
            );
          } else {
            itemList.add(displayImageItem(
                response.data["content"][i]["path"],
                response.data["content"][i]["name"],
                response.data["content"][i]["is_dir"],
                response.data["content"][i]));
            // 如果遍历完了那这里就得拼接
            if (i + 1 == response.data["content"].length) {
              // 填充空组件好让最后一行靠前排列
              for (int i = 0;
                  i <
                      (_numOneRow -
                          (response.data["content"].length % _numOneRow));
                  i++) {
                itemList.add(_buildEmptyPlaceholder());
              }
              // 将所有行相加
              rowList.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      itemList.length, (index) => itemList[index])));
              itemList.clear();
              rowList.add(
                const SizedBox(height: 18),
              );
            }
          }
        }
        setState(() {
          _filesListWidget = Column(
            children: rowList,
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      showFailed(e.toString(), context);
    }
  }

  // 文件(夹)图标
  Widget displayImageItem(
      String path, title, bool isFolder, Map<String, dynamic> content) {
    // 获取文件夹、文件图标
    String icoFilePath = "";
    // 获取文件网络路径uri，目前主要是图片
    String imageUrl = "";
    // String _imageUrl_thumbnail = "";
    if (isFolder) {
      // 是文件夹
      icoFilePath = Assets.casaFolder;
    } else {
      if (path.contains(RegExp(r'[.]')) &&
          _pictureExtNames.contains(path.split(RegExp(r'[.]')).last)) {
        // 是图片
        var icoFileUri = "/v2_1/files/thumbnail";
        imageUrl =
            "${widget.baseUrl}$icoFileUri?path=$path&token=${widget.data["data"]["token"]["access_token"]}";
      } else {
        // 是普通文件
        icoFilePath = Assets.casaFile;
      }
    }
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          child: icoFilePath.isEmpty
              ? _sizedContainer(
                  CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    ),
                    imageUrl: "$imageUrl&type=thumbnail",
                  ),
                )
              : Image.asset(
                  // TODO 显示图片预览缩略图、根据文件类型显示个性化文件图标
                  icoFilePath,
                  width: 48,
                  height: 48,
                  // 确保路径正确且已在pubspec.yaml中声明
                ),
          onTap: () {
            // TODO 如果pc则双击，如果移动端则单击
            if (isFolder) {
              // 如果是文件夹则进入文件夹
              _currentPath = path;
              displayImageList(_currentPath);
            } else {
              //TODO 下载或预览文件
              // 预览文件,判断有扩展名
              // 通用的文件访问api，目前视频是使用这个
              var fileUrl =
                  "${widget.baseUrl}/v3/file?files=$path&token=${widget.data["data"]["token"]["access_token"]}&action=preview";
              if (path.contains(RegExp(r'[.]'))) {
                var extName = path.split(RegExp(r'[.]')).last;
                if (_pictureExtNames.contains(extName)) {
                  // 根据扩展名判断是图片，开始图片预览
                  var files = [fileUrl];
                  TDImageViewer.showImageViewer(
                      context: context,
                      // 本文件夹所有图片列表，并定位到当前文件
                      images: files,
                      showIndex: true,
                      deleteBtn: true,
                      onDelete: (int index) {
                        showSuccess(
                          OpenIoTHubLocalizations.of(context)
                              .plugin_delete_success,
                          context,
                        );
                        _deleteFile([files[index]]);
                      });
                } else if (_videoExtNames.contains(extName)) {
                  // 根据扩展名判断是视频，开始视频预览,如果是移动平台则使用内置平台，如果是pc平台则使用系统浏览器？
                  if (Platform.isWindows || Platform.isLinux) {
                    launchUrl(fileUrl);
                  } else {
                    // 使用内置播放器
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return VideoPlayerPage(
                        key: UniqueKey(),
                        url: fileUrl,
                      );
                    }));
                  }
                } else if (_musicExtNames.contains(extName)) {
                  // 播放音乐，原则上说应该将本文件夹所有音乐都加入播放列表
                } else {
                  // TODO 未知的文件类型默认提示下载或其他方式
                }
              }
            }
          },
          // TODO 长按或者右键显示菜单:下载，拷贝路径，重新命名，剪切，复制，删除
          onLongPress: () {
            //   长按操作界面
            TDActionSheet(context,
                visible: true,
                description: "File Operation",
                items: [
                  TDActionSheetItem(
                    label: 'Delete',
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                ], onSelected: (TDActionSheetItem item, int index) {
              switch (index) {
                case 0:
                  // 确认操作
                  _deleteFile([path]);
                  break;
              }
            });
          },
        ),
        const SizedBox(height: 8),
        TDText(
          '$title',
          style: const TextStyle(fontSize: 12),
        )
      ],
    ));
  }

  _deleteFile(List<String> filepaths) async {
    // status: restart,stop
    final dio = Dio(BaseOptions(baseUrl: widget.baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"],
      "Content-Type": "application/json"
    }));
    String reqUri = "/v2_1/files/file/trash";
    final response = await dio.deleteUri(Uri.parse(reqUri), data: filepaths);
    if (!mounted) return;
    if (response.statusCode == 200) {
      showSuccess(
        OpenIoTHubLocalizations.of(context).plugin_delete_success,
        context,
      );
      displayImageList(_currentPath);
    } else {
      showFailed(
        OpenIoTHubLocalizations.of(context).delete_failed,
        context,
      );
      displayImageList(_currentPath);
    }
  }

  Widget _buildEmptyPlaceholder() {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        width: 48,
        height: 48,
      )
    ]));
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(child: child),
    );
  }
}

// {
// "content": [
// {
// "extensions": {
// "mounted": false
// },
// "is_dir": true,
// "modified": 1746263932,
// "name": "AppData",
// "path": "/media/ZimaOS-HD/AppData",
// "size": 4096
// },
// {
// "extensions": {
// "mounted": false,
// "pin": true
// },
// "is_dir": true,
// "modified": 1744525252,
// "name": "Backup",
// "path": "/media/ZimaOS-HD/Backup",
// "size": 4096
// },
// {
// "extensions": {
// "mounted": false,
// "pin": true
// },
// "is_dir": true,
// "modified": 1744525252,
// "name": "Documents",
// "path": "/media/ZimaOS-HD/Documents",
// "size": 4096
// },
// {
// "extensions": {
// "mounted": false,
// "pin": true
// },
// "is_dir": true,
// "modified": 1744525252,
// "name": "Downloads",
// "path": "/media/ZimaOS-HD/Downloads",
// "size": 4096
// },
// {
// "extensions": {
// "mounted": false,
// "pin": true
// },
// "is_dir": true,
// "modified": 1744525252,
// "name": "Gallery",
// "path": "/media/ZimaOS-HD/Gallery",
// "size": 4096
// },
// {
// "extensions": {
// "mounted": false,
// "pin": true
// },
// "is_dir": true,
// "modified": 1744525252,
// "name": "Media",
// "path": "/media/ZimaOS-HD/Media",
// "size": 4096
// },
// {
// "extensions": {
// "mounted": false
// },
// "is_dir": true,
// "modified": 1744525252,
// "name": "rauc",
// "path": "/media/ZimaOS-HD/rauc",
// "size": 4096
// }
// ],
// "index": 1,
// "size": 10000,
// "total": 7
// }
