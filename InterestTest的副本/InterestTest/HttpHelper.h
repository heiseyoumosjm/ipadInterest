//
//  HttpHelper.h
//  InterestTest
//
//  Created by 商佳敏 on 17/4/26.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "Constants.h"
@interface HttpHelper : NSObject<UIAlertViewDelegate>
//数据请求对象
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSString *trackViewUrl;
/*
 * 初始化方法
 */
+ (HttpHelper *)httpHelper;

/*
 * 传入userToken
 */
- (void)setUserToken:(NSString *)userToken;

/*
 * GET方法
 */
- (void)basicGetURL:(NSString *)requestURL andParams:(NSMutableDictionary *)requestParams andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock;


/*
 * POST方法
 */
- (void)basicPostURL:(NSString *)requestURL andParams:(NSMutableDictionary *)requestParams andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock;
- (void)basicPostURL1:(NSString *)requestURL andParams:(NSMutableDictionary *)requestParams andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock;
/*
 * items 的POST方法
 */
- (void)postAchieveListParamsURL:(NSString *)requestURL andParams:(NSMutableDictionary *)params andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock;

- (void)postAchieveListParamsURL1:(NSString *)requestURL andParams:(NSMutableDictionary *)params andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock;

/*
 * items 的GET方法
 */
- (void)getAchieveListParamsURL:(NSString *)requestURL andParams:(NSMutableDictionary *)params andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock;

/*
 * 图片
 */
- (void)uploadImg:(NSString *)requestURL andParameter:(NSDictionary *)parameter addImgDate:(UIImage *)avatar andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock;

///*
// * 微信授权后请求Token
// */
//- (void)fetchWXAccessToken:(NSString *)code andSuccess:(void (^) (WxLoginModel * wxLoginModel))successBlock andError:(void (^) (NSError *error))errorBlock;
//
///*
// * 微信请求Token后请求用户信息
// */
//- (void)fetchWXUserInfo:(WxLoginModel *)wxLoginModel;

/*
 * 发布作品
 */
- (void)postWorksURL:(NSString *)requestURL andImage:(NSMutableArray *)images andParams:(NSMutableDictionary *)params andSuccess:(void (^) (NSDictionary * successData))successBlock andError:(void (^) (NSError *error))errorBlock;

///*
// * 检验APP线上版本
// */
//- (void)updateApp;

@end

