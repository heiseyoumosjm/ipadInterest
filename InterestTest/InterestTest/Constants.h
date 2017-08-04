 //
//  Constants.h
//  zhenpin
//
//  Created by mickey on 16/5/23.
//  Copyright © 2016年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>


#define wtdAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

#ifdef DEBUG
#define FLOG(fmt,...)    NSLog((@"[%@][%d] " fmt),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,##__VA_ARGS__)
#else
#define FLOG(str, args...) ((void)0)
#endif

#define iOS7gt ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

#define GetImage(imageName)  [UIImage imageNamed:imageName]
#define XG_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )

#define isIPad() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone() (!isIPad())

#define isIPhone5() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone4() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIOS7() ([[UIDevice currentDevice].systemVersion doubleValue]>= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0)

#define isIOS6() ([[UIDevice currentDevice].systemVersion doubleValue]>= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NavBarFrame self.navigationController.navigationBar.frame

//NavBar高度
#define NavigationBar_HEIGHT 64
//TabBar高度
#define TabBar_HEIGHT 44
//segmentControl高度
#define Segment_HEIGHT 35
#define Segment_Custom_HEIGHT 40


//表情相关
#define CHAT_EMOJ_COL 7     //emoj键盘的列数
#define CHAT_EMOJ_ROW 4
#define CHAT_EMOJ_SIZE 28   //emoj图像的大小
#define CHAT_EMOJ_VECTICAL_PADDING 9  //btn距离上下缘的距离
#define CHAT_MORE_VIEW_H    80
#define CHAT_EMOJ_VIEW_H    216
#define CHAT_RECORD_VIEW_H    216
#define CHAT_EMOJ_VIEW_PAGE_CNTL_H   18
#define EMOJI_FONT [UIFont fontWithName:@"AppleColorEmoji" size:CHAT_EMOJ_SIZE]


//获取版本
#define appBuild [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue]

//主色调
#define colorHead [UIColor colorWithRed:195.0/255.0 green:13.0/255.0 blue:35.0/255.0 alpha:1.0]
#define colorGroom [UIColor colorWithRed:218.0/255.0 green:47.0/255.0 blue:41.0/255.0 alpha:1.0]
#define colorTitleText [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0]
#define colorPlaceholder [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:195.0/255.0 alpha:1.0]

#define colorInform [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]
#define colorBackgroundInform [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]
#define colorPitchOnInteract [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0]

#define colorLetterGray [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]

//分享
#define colorShare [UIColor colorWithRed:0.0/255.0 green:186.0/255.0 blue:253.0/255.0 alpha:1.0]

#define ZOOM_FACTOR 0.1
//颜色（RGB）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/*
 * Authorization:Bearer jwt-token
 * Accept:application/vnd.rehe.v1+json
 */
//请求数据相关
extern NSString * const DATAAPI;
extern NSString * const IMGAPI;
extern NSString * const Authorization;
extern NSString * const BearerValue;    //拼接在token前面
extern NSString * const Accept;
extern NSString * const Origin;
extern NSString * const AcceptValue;
extern NSString * const APIVersion;     //版本
extern NSString * const TransferType;   //传输数据类型
extern NSString * const AppName;        //App名称
extern NSString * const APPDomain;
extern NSString * const APPDeveloper;
extern NSString * const linkurl;

//应用的相关信息
extern NSString * const APPID;
extern NSString * const APPRENEWURL;

//获取API权限的用户名密码
extern NSString * const APIEmail;
extern NSString * const APIPassword;

//ItemName
extern NSString * const ThemeItemName;
extern NSString * const SearchItemName;
extern NSString * const UserItemName;

//搜索提示
extern NSString * const NavigationpLaceholder;

//日期格式
extern NSString * const TimeStyle;
extern NSString * const TimeDetailedStyle;

//加载与刷新
extern NSString * const headerPullToRefreshText;
extern NSString * const headerReleaseToRefreshText;
extern NSString * const headerRefreshingText;

extern NSString * const footerPullToRefreshText;
extern NSString * const footerReleaseToRefreshText;
extern NSString * const footerRefreshingText;

//Weibo
extern NSString * const kwbAppKey;
extern NSString * const kwbScheme;
extern NSString * const kwbSecret;
extern NSString * const kwbRedirectURI;
//Weixin
extern NSString * const kwxAppId;
extern NSString * const kwxScheme;
extern NSString * const kwxSecret;
extern NSString * const wxTokenApi;
extern NSString * const userInfoApi;
//授权域
extern NSString * const kwxAuthScope;
extern NSString * const kwxAuthOpenID;
extern NSString * const kwxAuthState;
//QQ
extern NSString * const kqqAppId;
extern NSString * const kqqAppKey;
extern NSString * const kqqScheme;

extern NSString * const kqqSchemeLogin;
extern NSString * const kqqSchemeShare;
extern NSString * const kqqSecret;
//个推
extern NSString * const kGtAppId;
extern NSString * const kGtAppKey;
extern NSString * const kGtAppSecret;
//PinterestSDK
extern NSString * const kPintAppId;
extern NSString * const kPintScheme;
extern NSString * const kPintAppSecret;

extern NSString * const kTLSAppid;
extern NSString * const kSdkAppId;
extern NSString * const kSdkAccountType;


//个人简介字数限制
extern NSString * const resumeWordCount;

//弹出框
extern NSInteger const numberOfItemsInRow;

//提示位置
extern NSString * const ToastDefaultPosition;
//顶部位置
extern NSString * const ToastDefaultPositionTop;

//修改文件夹成功代理方法
@protocol ChangeLayoutDelegate <NSObject>

- (void) ChangeLayout:(NSString *)layoutid;

@end
//修改文件夹成功代理方法
@protocol ChangeGoodsDelegate <NSObject>

- (void) ChangeGoods:(NSString *)layoutid;

@end
//修改文件夹成功代理方法
@protocol AddGoodsDelegate <NSObject>

- (void) AddGoods:(NSDictionary *)goodsDic;

@end

//自定义消息类型
typedef NS_ENUM(NSInteger, ImCustomMsgModelType)
{
    IM_TYPE_ENTER               = 6,   //进入房间//
    IM_TYPE_EXIT                = 7,   //退出房间//
    IM_TYPE_LIVE_LICK           = 9,   //点赞//
    IM_TYPE_NEW_MESSAGE         = 10,  //新消息到达//
    IM_TYPE_LIVE_END            = 11,  //直播结束//
};

@interface Constants : NSObject

@end
