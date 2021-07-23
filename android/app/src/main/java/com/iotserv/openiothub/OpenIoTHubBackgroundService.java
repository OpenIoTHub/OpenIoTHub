package com.iotserv.openiothub;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import android.content.SharedPreferences;

import explorer.Explorer;

public class OpenIoTHubBackgroundService extends Service {
    Thread t1;
    private static final String SHARED_PREFERENCES_NAME = "FlutterSharedPreferences";
    private static final String PREFIX = "flutter.";
    SharedPreferences preferences;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    /**
     * 首次创建服务时，系统将调用此方法来执行一次性设置程序（在调用 onStartCommand() 或 onBind() 之前）。
     * 如果服务已在运行，则不会调用此方法。该方法只被调用一次
     */
    @Override
    public void onCreate() {
        Log.d("Service","onCreate invoke");
        final String path;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
            path = getNoBackupFilesDir().getAbsolutePath();
        } else{
            path = getFilesDir().getAbsolutePath();
        }
        t1= new Thread(){
            public void run(){
                Explorer.run(path);
            }
        };
        super.onCreate();
    }

    /**
     * 每次通过startService()方法启动Service时都会被回调。
     * @param intent
     * @param flags
     * @param startId
     * @return
     */
    @TargetApi(Build.VERSION_CODES.O)
//    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d("Service","onStartCommand invoke");
        t1.start();
        preferences = this.getSharedPreferences(SHARED_PREFERENCES_NAME, this.MODE_PRIVATE);
//        SharedPreferences.Editor editor = preferences.edit();
//        editor.putBoolean(PREFIX + "foreground",true);
//        editor.commit();
//        System.out.println("preferences.getBooean:" + preferences.getBoolean(PREFIX + "foreground", false));
        int i = 0;
        if(preferences.getBoolean(PREFIX + "foreground", false)){
            i = 1;
        }
        String CHANNEL_ONE_ID = "com.iotserv.openiothub";
        String CHANNEL_ONE_NAME = "Channel Two";
        NotificationChannel notificationChannel = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationChannel = new NotificationChannel(CHANNEL_ONE_ID,
                    CHANNEL_ONE_NAME, NotificationManager.IMPORTANCE_LOW);
            notificationChannel.enableLights(true);
            notificationChannel.setLightColor(Color.RED);
            notificationChannel.setShowBadge(true);
            notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
            NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            manager.createNotificationChannel(notificationChannel);
            PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, 0);
            Notification notification = new Notification.Builder(this)
                    .setChannelId(CHANNEL_ONE_ID)
                    .setTicker("Nature")
//                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setContentTitle("云易连(OpenIoTHub)")
                    .setContentText("云易连服务正在后台运行")
                    .setContentIntent(pendingIntent)
                    .build();
            notification.flags |= Notification.FLAG_NO_CLEAR;
            startForeground(i, notification);
        }else{
            PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, 0);
            Notification notification = new Notification.Builder(this)
                    .setTicker("Nature")
//                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setContentTitle("云易连(OpenIoTHub)")
                    .setContentText("云易连服务正在后台运行")
                    .setContentIntent(pendingIntent)
                    .build();
            notification.flags |= Notification.FLAG_NO_CLEAR;
            startForeground(i, notification);
        }
        return super.onStartCommand(intent, flags, startId);
    }

    /**
     * 服务销毁时的回调
     */
    @Override
    public void onDestroy() {
        Log.d("Service","onDestroy invoke");
        stopForeground(true);// 停止前台服务--参数：表示是否移除之前的通知
        t1.stop();
        super.onDestroy();
    }

}
