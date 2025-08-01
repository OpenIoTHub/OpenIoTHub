#-keep class bykvm*.**
#-keep class com.bytedance.msdk.adapter.**{ public *; }
#-keep class com.bytedance.msdk.api.** {
# public *;
#}

# baidu sdk 不接入baidu sdk可以不引入
#-ignorewarnings
#-dontwarn com.baidu.mobads.sdk.api.**
#-keepclassmembers class * extends android.app.Activity {
#   public void *(android.view.View);
#}
#
#-keepclassmembers enum * {
#    public static **[] values();
#    public static ** valueOf(java.lang.String);
#}
#
#-keep class com.baidu.mobads.** { *; }
#-keep class com.style.widget.** {*;}
#-keep class com.component.** {*;}
#-keep class com.baidu.ad.magic.flute.** {*;}
#-keep class com.baidu.mobstat.forbes.** {*;}

#ks  不接入ks sdk可以不引入
#-keep class org.chromium.** {*;}
#-keep class org.chromium.** { *; }
#-keep class aegon.chrome.** { *; }
#-keep class com.kwai.**{ *; }
#-dontwarn com.kwai.**
#-dontwarn com.kwad.**
#-dontwarn com.ksad.**
#-dontwarn aegon.chrome.**

# Admob 不接入admob sdk可以不引入
#-keep class com.google.android.gms.ads.MobileAds {
# public *;
#}

#sigmob  不接入sigmob sdk可以不引入
#-dontwarn android.support.v4.**
#-keep class android.support.v4.** { *; }
#-keep interface android.support.v4.** { *; }
#-keep public class * extends android.support.v4.**
#
#-keep class sun.misc.Unsafe { *; }
#-dontwarn com.sigmob.**
#-keep class com.sigmob.**.**{*;}

#oaid 不同的版本混淆代码不太一致，你注意你接入的oaid版本 ，不接入oaid可以不添加
#-dontwarn com.bun.**
#-keep class com.bun.** {*;}
#-keep class a.**{*;}
#-keep class XI.CA.XI.**{*;}
#-keep class XI.K0.XI.**{*;}
#-keep class XI.XI.K0.**{*;}
#-keep class XI.vs.K0.**{*;}
#-keep class XI.xo.XI.XI.**{*;}
#-keep class com.asus.msa.SupplementaryDID.**{*;}
#-keep class com.asus.msa.sdid.**{*;}
#-keep class com.huawei.hms.ads.identifier.**{*;}
#-keep class com.samsung.android.deviceidservice.**{*;}
#-keep class com.zui.opendeviceidlibrary.**{*;}
#-keep class org.json.**{*;}
#-keep public class com.netease.nis.sdkwrapper.Utils {public <methods>;}


#Mintegral 不接入Mintegral sdk，可以不引入
#-keepattributes Signature
#-keepattributes *Annotation*
#-keep class com.mbridge.** {*; }
#-keep interface com.mbridge.** {*; }
#-keep class android.support.v4.** { *; }
#-dontwarn com.mbridge.**
#-keep class **.R$* { public static final int mbridge*; }