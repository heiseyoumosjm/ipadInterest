
//
//  Constants.m
//  zhenpin
//
//  Created by mickey on 16/5/23.
//  Copyright © 2016年 mickey. All rights reserved.
//

#import "Constants.h"

/*
 * Authorization:Bearer jwt-token
 * Accept:application/vnd.rehe.v1+json
 */
//请求数据相关
NSString * const DATAAPI =@"http://api.zhiqin-hz.com/";
//@"http://api.zhiqin-hz.com/";//http://118.178.17.44:5056http://api.zhiqin-hz.com/
NSString * const IMGAPI = @"http://api.zhiqin-hz.com/";
NSString * const Authorization = @"Authorization";
NSString * const BearerValue = @"Bearer ";
NSString * const Accept = @"Accept";
NSString * const Origin = @"ios/langju";
//NSString * const AcceptValue = @"application/vnd.rehe.";
NSString * const AcceptValue = @"application/json";
NSString * const APIVersion = @"v1";
NSString * const TransferType = @"+json";
NSString * const AppName = @"In家";
NSString * const APPDomain = @"杭州风远科技";
NSString * const APPDeveloper = @"Mickey";
NSString * const linkurl = @"http://test-api.zhiqin-hz.com/";

//应用的相关信息
NSString * const APPID = @"1135286084";
NSString * const APPRENEWURL = @"http://itunes.apple.com/lookup?id=";

//获取API权限的用户名密码
NSString * const APIEmail = @"admin@admin.com";
NSString * const APIPassword = @"admin";

//ItemName
NSString * const ThemeItemName = @"话题";
NSString * const SearchItemName = @"搜索";
NSString * const UserItemName = @"我的";

//搜索提示
NSString * const NavigationpLaceholder = @"输入搜索内容";

//日期格式
NSString * const TimeStyle = @"YYYY-MM-dd";
NSString * const TimeDetailedStyle = @"YYYY-MM-dd HH:mm:ss";

//加载与刷新
NSString * const headerPullToRefreshText = @"下拉刷新";
NSString * const headerReleaseToRefreshText = @"松开马上刷新";
NSString * const headerRefreshingText = @"正在赶来...";

NSString * const footerPullToRefreshText = @"上拉加载";
NSString * const footerReleaseToRefreshText = @"松开马上加载";
NSString * const footerRefreshingText = @"正在赶来...";

//Weibo
NSString * const kwbAppKey = @"1638356372";
NSString * const kwbScheme = @"wb1638356372";
NSString * const kwbSecret = @"2ac6a94445e567d29b7d4f1b5825c566";
NSString * const kwbRedirectURI = @"https://api.weibo.com/oauth2/default.html";
//Weixin
NSString * const kwxAppId = @"wxb8cbcd623fbc0604";
NSString * const kwxScheme = @"wxb8cbcd623fbc0604";
NSString * const kwxSecret = @"d4091ed2200148f441e369bdc9e7881c";
NSString * const wxTokenApi = @"https://api.weixin.qq.com/sns/oauth2/access_token";
NSString * const userInfoApi = @"https://api.weixin.qq.com/sns/userinfo";
//授权域
NSString * const kwxAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
NSString * const kwxAuthOpenID = @"wxb8cbcd623fbc0604";
NSString * const kwxAuthState = @"Mickey";
//QQ
NSString * const kqqAppId = @"1105380703";
NSString * const kqqAppKey = @"Ht8tE1RgKMwSz33h";

NSString * const kqqScheme = @"tencent1105380703";
NSString * const qqScheme = @"QQ41E2C55F";
NSString * const kqqSchemeLogin = @"tencent1105380703";
NSString * const kqqSchemeShare = @"QQ41E2C55F";

//个推
//NSString * const kGtAppId = @"ZCYC8BNAGT7VAzzGPJT4x";
//NSString * const kGtAppKey = @"gyMGO78usa9BjTb0oeunA1";
//NSString * const kGtAppSecret = @"N9o66qjFTJ9593JXXIimI1";

//生产环境
NSString * const kGtAppId = @"ZCYC8BNAGT7VAzzGPJT4x";
NSString * const kGtAppKey = @"gyMGO78usa9BjTb0oeunA1";
NSString * const kGtAppSecret = @"N9o66qjFTJ9593JXXIimI1";
////开发环境
//NSString * const kGtAppId = @"iHuIRVJWBC82IEttMJqr27";
//NSString * const kGtAppKey = @"NXzbhu3Xsn5dsBCABOVPi2";
//NSString * const kGtAppSecret = @"375uFEXtNJ8GZalanzMis5";

////PinterestSDK
//NSString * const kPintAppId = @"4842038942979074975";
//NSString * const kPintScheme = @"pdk4842038942979074975";
//NSString * const kPintAppSecret = @"c4719e867b2da290625367916cc6389bc200522ef77d24b9554f42ec516b2de5";
//NewPinterestSDK
NSString * const kPintAppId = @"4832945793295992216";
NSString * const kPintScheme = @"pdk4832945793295992216";
NSString * const kPintAppSecret = @"f5cc7b5a1e63bdeee7485e02fea92c8bba4dda34f7280d3602f04450ca450860";
//NSString * const kPintAppId = @"4850434548818788979";
//NSString * const kPintScheme = @"pdk4850434548818788979";
//NSString * const kPintAppSecret = @"2c4d41d5d5dbe9b694b7c89c006fa7e9fdab98fd1b66ddd6f2027234a614bda1";

//腾讯IMSDK
NSString * const kTLSAppid = @"1400014921";
NSString * const kSdkAppId = @"1400014921";
NSString * const kSdkAccountType = @"7537";


//个人简介字数限制
NSString * const resumeWordCount = @"40";
//弹出框
NSInteger const numberOfItemsInRow = 3;
//提示位置
NSString * const ToastDefaultPosition = @"center";
//顶部位置
NSString * const ToastDefaultPositionTop = @"top";

@implementation Constants

@end
