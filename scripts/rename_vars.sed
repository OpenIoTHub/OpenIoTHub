# SharedPreferencesKey member renames
s/SharedPreferencesKey\.DEVICE_CNAME_KEY/SharedPreferencesKey.deviceCnameKey/g
s/SharedPreferencesKey\.OPENIOTHUB_GO_AAR_CONFIG_KEY/SharedPreferencesKey.openiothubGoAarConfigKey/g
s/SharedPreferencesKey\.Mqtt_Server_List_CONFIG_KEY/SharedPreferencesKey.mqttServerListConfigKey/g
s/SharedPreferencesKey\.Device_AND_Service_Added_List_KEY/SharedPreferencesKey.deviceAndServiceAddedListKey/g
s/SharedPreferencesKey\.USER_NAME_KEY/SharedPreferencesKey.userNameKey/g
s/SharedPreferencesKey\.USER_EMAIL_KEY/SharedPreferencesKey.userEmailKey/g
s/SharedPreferencesKey\.USER_MOBILE_KEY/SharedPreferencesKey.userMobileKey/g
s/SharedPreferencesKey\.USER_AVATAR_KEY/SharedPreferencesKey.userAvatarKey/g
s/SharedPreferencesKey\.USER_TOKEN_KEY/SharedPreferencesKey.userTokenKey/g
s/SharedPreferencesKey\.Gateway_Jwt_KEY/SharedPreferencesKey.gatewayJwtKey/g
s/SharedPreferencesKey\.QR_Code_For_Mobile_Add_KEY/SharedPreferencesKey.qrCodeForMobileAddKey/g
s/SharedPreferencesKey\.Agreed_Privacy_Policy/SharedPreferencesKey.agreedPrivacyPolicy/g
s/SharedPreferencesKey\.FORGE_ROUND_TASK_ENABLE/SharedPreferencesKey.forgeRoundTaskEnable/g
s/SharedPreferencesKey\.START_GATEWAY_WHEN_APP_START/SharedPreferencesKey.startGatewayWhenAppStart/g
s/SharedPreferencesKey\.WAKE_LOCK/SharedPreferencesKey.wakeLockEnabled/g

# WeChatConfig/QQConfig member renames
s/WeChatConfig\.WECHAT_APPID/WeChatConfig.wechatAppId/g
s/WeChatConfig\.WECHAT_UNIVERSAL_LINK/WeChatConfig.wechatUniversalLink/g
s/QQConfig\.QQ_APPID/QQConfig.qqAppId/g
s/QQConfig\.QQ_UNIVERSAL_LINK/QQConfig.qqUniversalLink/g

# Constants member renames (used internally in constants.dart)
s/Constants\.DOC_WEBSITE_URL/Constants.docWebsiteUrl/g
s/Constants\.ARROW_ICON_WIDTH/Constants.arrowIconWidth/g

# MDNS2ModelsMap class rename
s/MDNS2ModelsMap/Mdns2ModelsMap/g

# Method renames in MDNS class
s/getAllmDnsServiceType/getAllMdnsServiceType/g
s/getAllmDnsType/getAllMdnsType/g

# OpenWithChoice constant renames
s/OpenWithChoice\.TAG_START/OpenWithChoice.tagStart/g
s/OpenWithChoice\.TAG_END/OpenWithChoice.tagEnd/g
s/OpenWithChoice\.TAG_CENTER/OpenWithChoice.tagCenter/g
s/OpenWithChoice\.TAG_BLANK/OpenWithChoice.tagBlank/g
s/OpenWithChoice\.IMAGE_ICON_WIDTH/OpenWithChoice.imageIconWidth/g

# build_global_actions.dart function rename
s/build_actions/buildActions/g
s/popupMenuEntrys/popupMenuEntries/g
