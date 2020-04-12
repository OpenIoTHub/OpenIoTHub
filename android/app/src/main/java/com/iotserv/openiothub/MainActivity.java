package com.iotserv.openiothub;

import android.content.Intent;
import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//      add by Farry
        Intent it=new Intent(this, OpenIoTHubBackgroundService.class);
        this.startService(it);
//      add by Farry over
    }
}
