package com.example.flutter_natcloud_service;

import android.app.Activity;
import android.content.Intent;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterNatcloudServicePlugin */
public class FlutterNatcloudServicePlugin implements MethodCallHandler {
  private Activity activity;
  private MethodChannel channel;

  public FlutterNatcloudServicePlugin(Activity activity,MethodChannel channel) {
    this.activity = activity;
    this.channel = channel;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_natcloud_service");
    channel.setMethodCallHandler(new FlutterNatcloudServicePlugin(registrar.activity(),channel));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("start")) {
      result.success("success");
    } else {
      result.notImplemented();
    }
  }
}
