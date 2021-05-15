#import "FlutterNatcloudServicePlugin.h"

@implementation FlutterNatcloudServicePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_natcloud_service"
            binaryMessenger:[registrar messenger]];
  FlutterNatcloudServicePlugin* instance = [[FlutterNatcloudServicePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"start" isEqualToString:call.method]) {
      //NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
      //                                                          NSUserDomainMask,
      //                                                         YES) objectAtIndex:0];
      //ExplorerRun(path);
    //NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(method:) object:@"方式一启动"];
    [[NSThread alloc]initWithTarget:self selector:@selector(method:) object:@"方式一启动"];
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void)method:(NSString*)name{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                              NSUserDomainMask,
                                                              YES) objectAtIndex:0];
    ExplorerRun(path);
}
@end
