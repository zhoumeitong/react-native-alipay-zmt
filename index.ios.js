/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import { NativeModules } from 'react-native';


var Alipay = NativeModules.Alipay;

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

      Alipay.pay("body=\"商品订单支付\"&total_fee=\"0.01\"&seller_id=\"zhongkefuchuang@126.com\"&notify_url=\"http%3A%2F%2Fweb.jinlb.cn%2Feten%2Fapp%2Fcharge%2Falipay%2Fnotify\"&out_trade_no=\"PO2016072900000071\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&partner=\"2088211510687520\"&_input_charset=\"utf-8\"&subject=\"商品订单\"&sign=\"f7oDTfExzbFjGWCj94weGWEEi3nZ6tTY7lZq%2Fpz%2Fl%2BUSm69Ara74E8K5dZInuYGNX4NyauAQBnkgRjmWcoPHFB3E6wQnJdD5eF%2FgPIHq4%2FrzN7mTC3fmhngHuU%2FbmKu6NzofZwz2nfloR8MCKnsCueNcDHWIECUQ5zBRzx3aBsw%3D\"&sign_type=\"RSA\"")
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
