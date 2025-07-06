class SharedPreferencesKey {
// SharedPreferences  KEY
//设备和服务的别名
  static final String DEVICE_CNAME_KEY = "device_cname";

//  golang的后台服务需要的配置
  static final String OPENIOTHUB_GO_AAR_CONFIG_KEY = "allconfig";

//  mqtt服务器的配置，用于从mqtt服务器中获取和操控设备
  static final String Mqtt_Server_List_CONFIG_KEY =
      "Mqtt_Server_List_CONFIG_KEY";

//  手动添加的设备和服务列表
  static final String Device_AND_Service_Added_List_KEY =
      "Device_AND_Service_Added_List_KEY";

//  用户和登录信息保存
//     string Name = 1;
//     string Email = 2;
//     string Mobile = 3;
//     string Avatar = 4;
  static final String USER_NAME_KEY = "USER_NAME_KEY";
  static final String USER_EMAIL_KEY = "USER_EMAIL_KEY";
  static final String USER_MOBILE_KEY = "USER_MOBILE_KEY";
  static final String USER_AVATAR_KEY = "USER_AVATAR_KEY";
//  用户Token
  static final String USER_TOKEN_KEY = "USER_TOKEN_KEY";

  static final String Gateway_Jwt_KEY = "GATEWAY_JWT_KEY";
  static final String QR_Code_For_Mobile_Add_KEY = "QR_Code_For_Mobile_Add";
}