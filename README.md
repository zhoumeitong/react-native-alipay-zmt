### 功能：
通过支付宝SDK实现APP支付宝支付功能

### 使用步骤：

#### 一、链接Alipay库

参考：https://reactnative.cn/docs/0.50/linking-libraries-ios.html#content

##### 手动添加：
1、添加react-native-alipay-zmt插件到你工程的node_modules文件夹下

2、添加Alipay库中的.xcodeproj文件在你的工程中

3、点击你的主工程文件，选择Build Phases，然后把刚才所添加进去的.xcodeproj下的Products文件夹中的静态库文件（.a文件），拖到Link Binary With Libraries组内。

##### 自动添加：
```
npm install react-native-alipay-zmt --save
或
yarn add react-native-alipay-zmt

react-native link
```

由于AppDelegate中使用Alipay库,所以我们需要打开你的工程文件，选择Build Settings，然后搜索Search Paths，然后添加库所在的目录`$(SRCROOT)/../node_modules/react-native-alipay-zmt/ios/Alipay`(包含头文件搜索和库文件搜索)

#### 二、开发环境配置
参考
https://doc.open.alipay.com/doc2/detail?treeId=59&articleId=103676&docType=1

1、引入系统库
左侧目录中选中工程名，在TARGETS->Build Phases-> Link Binary With Libaries中点击“+”按钮，在弹出的窗口中查找并选择所需的库（见下图），单击“Add”按钮，将库文件添加到工程中。

![](http://upload-images.jianshu.io/upload_images/2093433-0d20a15bea8a4016.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其中，需要注意的是：
如果是Xcode 7.0之后的版本，需要添加libc++.tbd、libz.tbd；
如果是Xcode 7.0之前的版本，需要添加libc++.dylib、libz.dylib（如下图）。

![](http://upload-images.jianshu.io/upload_images/2093433-1610b76227e68f9f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


2、环境配置
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所定义的名称

![](http://upload-images.jianshu.io/upload_images/2093433-8677477232f6648d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 三、配置plist文件

![](http://upload-images.jianshu.io/upload_images/2093433-784afb58dd0143aa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

iOS9为了增强数据访问安全，将所有的http请求都改为了https，为了能够在iOS9中正常使用地图SDK，请在"Info.plist"中进行如下配置，否则影响SDK的使用。
```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>

```

#### 四、简单使用

1、重写AppDelegate的openURL方法：
```
#import "Alipay.h"

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
if ([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"]   isEqualToString:@"com.alipay.iphoneclient"]) {
[Alipay aliPayParse:url];
return YES;
}else{
return NO;
}
}
```
2、js文件
```
/**
* Sample React Native App
* https://github.com/facebook/react-native
* @flow
*/

import React, { Component } from 'react';
// import { NativeModules } from 'react-native';
// var Alipay = NativeModules.Alipay;
import Alipay from 'react-native-alipay-zmt';

function show(title, msg) {
AlertIOS.alert(title+'', msg+'');
}

import {
AppRegistry,
StyleSheet,
Text,
View,
Dimensions,
AlertIOS,
ScrollView,
TouchableHighlight,
NativeAppEventEmitter
} from 'react-native';

class TextReactNative extends Component {

Alipay(){

Alipay.pay("body=\"商品订单支付\"&total_fee=\"1.6\"&seller_id=\"zhongkefuchuang@126.com\"&notify_url=\"http%3A%2F%2Fweb.jinlb.cn%2Feten%2Fapp%2Fcharge%2Falipay%2Fnotify\"&out_trade_no=\"PO2016081100000014\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&partner=\"2088211510687520\"&_input_charset=\"utf-8\"&subject=\"商品订单\"&sign=\"qMTEJRy%2FX3UpevA2b2mzdjLi8QSEp%2F69jpIT46vkOziWXDllEHXBUMqrJXdoAdiS2COodhXkMMwKrEy8FhK2XSQF6fFGsOkcS3duwPuHxsLcq5Q5JqsztWovIekPDvM8e9Yi%2BMzPethaxMQCJluiMuBvU9KBrK%2FlBUq20s2Pa5k%3D\"&sign_type=\"RSA\"")
.then(result => {
console.log("result is ", result);
show("result is ", result);
})
.catch(error => {
console.log(error);
show(error);
});

}


render() {
return (

<ScrollView contentContainerStyle={styles.wrapper}>

<Text style={styles.pageTitle}>Alipay SDK for React Native (iOS)</Text>

<TouchableHighlight
style={styles.button} underlayColor="#f38"
onPress={this.Alipay}>
<Text style={styles.buttonTitle}>Alipay</Text>
</TouchableHighlight>


</ScrollView>
);
}
}

const styles = StyleSheet.create({
wrapper: {
paddingTop: 60,
paddingBottom: 20,
alignItems: 'center',
},
pageTitle: {
paddingBottom: 40
},
button: {
width: 200,
height: 40,
marginBottom: 10,
borderRadius: 6,
backgroundColor: '#f38',
alignItems: 'center',
justifyContent: 'center',
},
buttonTitle: {
fontSize: 16,
color: '#fff'
}

});


AppRegistry.registerComponent('TextReactNative', () => TextReactNative);
```

