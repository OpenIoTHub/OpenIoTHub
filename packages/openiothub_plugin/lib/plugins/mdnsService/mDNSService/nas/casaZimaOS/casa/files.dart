import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:openiothub_plugin/generated/assets.dart';
import 'package:openiothub_plugin/pages/videp_player.dart';
import 'package:openiothub_plugin/utils/toast.dart';
import 'package:openiothub_plugin/utils/web.dart';
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
  static const _num_one_row = 3;
  static const _picture_ext_names = [
    "bmp",
    "jpg",
    "png",
    "jpeg",
    "ico",
    "webp"
  ];
  static const _video_ext_names = ["mp4", "avi", "flv", "rmvb"];
  static const _music_ext_names = [
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
  String _current_path = "/DATA";
  List<Map<String, String>> _side_paths = [
    {"name": "Root", "path": "/"},
    {"name": "DATA", "path": "/DATA"},
    {"name": "Documents", "path": "/DATA/Documents"},
    {"name": "Downloads", "path": "/DATA/Downloads"},
    {"name": "Gallery", "path": "/DATA/Gallery"},
    {"name": "Media", "path": "/DATA/Media"}
  ];
  Widget _files_list_widget = TDLoading(
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
          title: Text("Files"),
        ),
        body: _buildPaginationSideBar(context));
  }

  Widget _buildPaginationSideBar(BuildContext context) {
    // 切页用法
    final list = <SideItemProps>[];

    for (var i = 0; i < _side_paths.length; i++) {
      list.add(SideItemProps(
        index: i,
        label: _side_paths[i]["name"],
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
                child: SingleChildScrollView(
                  child: getPathFileList(),
                  physics: AlwaysScrollableScrollPhysics(),
                )))
      ],
    );
  }

  void setCurrentPathByValue(int value) {
    // 显示文件列表
    _current_path = _side_paths[value]["path"]!;
    displayImageList(_current_path);
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
                itemCount: _current_path.split(RegExp(r'[/]')).length,
                builder: (index) {
                  return BreadCrumbItem(
                      content:
                          Text(_current_path.split(RegExp(r'[/]'))[index]));
                },
                divider: Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 16),
            // displayImageList(path)
            _files_list_widget
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
    String reqUri = "/v1/folder";
    try {
      final response = await dio.get(reqUri, queryParameters: {"path": path});
      if (response.data["success"] == 200) {
        List<Widget> _row_list = [];
        // 一行
        List<Widget> _item_list = [];
        for (int i = 0; i < response.data["data"]["content"].length; i++) {
          if ((i + 1) % _num_one_row == 0) {
            _item_list.add(displayImageItem(
                response.data["data"]["content"][i]["path"],
                response.data["data"]["content"][i]["name"],
                response.data["data"]["content"][i]["is_dir"],
                response.data["data"]["content"][i]));
            // 将所有行相加
            _row_list.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    _item_list.length, (index) => _item_list[index])));
            _item_list.clear();
            _row_list.add(
              const SizedBox(height: 18),
            );
          } else {
            _item_list.add(displayImageItem(
                response.data["data"]["content"][i]["path"],
                response.data["data"]["content"][i]["name"],
                response.data["data"]["content"][i]["is_dir"],
                response.data["data"]["content"][i]));
            // 如果遍历完了那这里就得拼接
            if (i + 1 == response.data["data"]["content"].length) {
              // 填充空组件好让最后一行靠前排列
              for (int i = 0;
                  i <
                      (_num_one_row -
                          (response.data["data"]["content"].length %
                              _num_one_row));
                  i++) {
                _item_list.add(_build_empty_placeholder());
              }
              // 将所有行相加
              _row_list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      _item_list.length, (index) => _item_list[index])));
              _item_list.clear();
              _row_list.add(
                const SizedBox(height: 18),
              );
            }
          }
        }
        setState(() {
          _files_list_widget = Column(
            children: _row_list,
          );
        });
      }
    } catch (e) {
      show_failed(e.toString(), context);
    }
  }

  // 文件(夹)图标
  Widget displayImageItem(
      String path, title, bool is_folder, Map<String, dynamic> content) {
    // 获取文件夹、文件图标
    String ico_file_path = "";
    // 获取文件网络路径uri，目前主要是图片
    String _image_url = "";
    // String _image_url_thumbnail = "";
    if (is_folder) {
      // 是文件夹
      ico_file_path = Assets.casaFolder;
    } else {
      if (path.indexOf(RegExp(r'[.]')) != -1 &&
          _picture_ext_names.contains(path.split(RegExp(r'[.]')).last)) {
        // 是图片
        var ico_file_uri = "/v1/image";
        _image_url =
            "${widget.baseUrl}${ico_file_uri}?path=${path}&token=${widget.data["data"]["token"]["access_token"]}";
      } else {
        // 是普通文件
        ico_file_path = Assets.casaFile;
      }
    }
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          child: ico_file_path.isEmpty
              ? _sizedContainer(
                  CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    ),
                    imageUrl: "${_image_url}&type=thumbnail",
                  ),
                )
              : Image.asset(
                  // TODO 显示图片预览缩略图、根据文件类型显示个性化文件图标
                  ico_file_path,
                  package: "openiothub_plugin",
                  width: 48,
                  height: 48,
                  // 确保路径正确且已在pubspec.yaml中声明
                ),
          onTap: () {
            // TODO 如果pc则双击，如果移动端则单击
            if (is_folder) {
              // 如果是文件夹则进入文件夹
              _current_path = path;
              displayImageList(_current_path);
            } else {
              //TODO 下载或预览文件
              // 预览文件,判断有扩展名
              // 通用的文件访问api，目前视频是使用这个
              var _file_url =
                  "${widget.baseUrl}/v3/file?path=${path}&token=${widget.data["data"]["token"]["access_token"]}";
              if (path.indexOf(RegExp(r'[.]')) != -1) {
                var _ext_name = path.split(RegExp(r'[.]')).last;
                if (_picture_ext_names.contains(_ext_name)) {
                  // 根据扩展名判断是图片，开始图片预览
                  var files = [_image_url];
                  TDImageViewer.showImageViewer(
                      context: context,
                      // 本文件夹所有图片列表，并定位到当前文件
                      images: files,
                      showIndex: true,
                      deleteBtn: true,
                      onDelete: (int index) {
                        _delete_file([files[index]]);
                      });
                } else if (_video_ext_names.contains(_ext_name)) {
                  // 根据扩展名判断是视频，开始视频预览,如果是移动平台则使用内置平台，如果是pc平台则使用系统浏览器？
                  if (Platform.isWindows || Platform.isLinux) {
                    launchURL(_file_url);
                  } else {
                    // 使用内置播放器
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return VideoPlayerPage(
                        key: UniqueKey(),
                        url: _file_url,
                      );
                    }));
                  }
                } else if (_music_ext_names.contains(_ext_name)) {
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
                  _delete_file([path]);
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

  _delete_file(List<String> filepaths) async {
    // status: restart,stop
    final dio = Dio(BaseOptions(baseUrl: widget.baseUrl, headers: {
      "Authorization": widget.data["data"]["token"]["access_token"],
      "Content-Type": "application/json"
    }));
    String reqUri = "/v1/batch";
    final response = await dio.deleteUri(Uri.parse(reqUri), data: filepaths);
    if (response.statusCode == 200) {
      show_success("Delete Success", context);
      displayImageList(_current_path);
    } else {
      show_failed("Delete Failed", context);
      displayImageList(_current_path);
    }
  }

  Widget _build_empty_placeholder() {
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
// "success": 200,
// "message": "ok",
// "data": {
// "content": [
// {
// "name": "AppData",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-14T14:37:32.476952054+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/AppData",
// "date": "2025-04-14T14:37:32.476952054+08:00",
// "extensions": null
// },
// {
// "name": "Documents",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-07T15:44:56.213992851+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/Documents",
// "date": "2025-04-07T15:44:56.213992851+08:00",
// "extensions": null
// },
// {
// "name": "Downloads",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-07T15:44:56.213992851+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/Downloads",
// "date": "2025-04-07T15:44:56.213992851+08:00",
// "extensions": null
// },
// {
// "name": "Gallery",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-07T15:44:56.213992851+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/Gallery",
// "date": "2025-04-07T15:44:56.213992851+08:00",
// "extensions": null
// },
// {
// "name": "Media",
// "size": 4096,
// "is_dir": true,
// "modified": "2025-04-07T15:44:56.213992851+08:00",
// "sign": "",
// "thumb": "",
// "type": 0,
// "path": "/DATA/Media",
// "date": "2025-04-07T15:44:56.213992851+08:00",
// "extensions": null
// }
// ],
// "total": 5,
// "index": 1,
// "size": 100000
// }
// }
