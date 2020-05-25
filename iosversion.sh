cd ./ios
#更新版本号到与git版本一致
version=`git describe --abbrev=0 --tags`
agvtool new-marketing-version ${version#v}
#自动增加编译号
agvtool next-version -all
cd ../