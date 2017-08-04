//
//  ToolHelper.h
//  zhenpin
//
//  Created by Sailor on 16/5/23.
//  Copyright © 2016年 iSailor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ToolHelper : NSObject

NSMutableAttributedString *GetAttributedText(NSString *value);

/**
 *  初始化方法
 */
+ (ToolHelper*)toolHelper;

/**
 *  生成随机字符串
 */
- (NSString*)randomString;

/**
 *  裁剪图片
 */
- (UIImage*)cropImage:(UIImage*)image;
- (int)charactersInString:(NSString*)string;
/**
 *  分割字符串
 *
 *  @param string 被分割的字符串
 *  @param sep    分隔符
 *
 *  @return 返回可变数组
 */
-(NSMutableArray*)stringToArr:(NSString*)string seprate:(NSString*)sep;
/**
 *  分割数组
 *  生成字符串
 */
- (NSString *)stringToString:(NSMutableArray*)array seprate:(NSString*)sep;

-(UIImage*)scaleToScreenWidth:(UIImage*)origin;

/**
 *  格式化时间戳
 */
- (NSString*)formatDate:(NSUInteger)time style:(NSString*)style;
- (NSString*)rangeDate:(NSInteger)timeInt;

/**
 *  标记是否为第一次打开App
 */
-(BOOL)firstLaunch;
-(BOOL)firstLogin;

//当前时间
- (NSString*)nonceTime;

/**
 *  过滤html
 */
- (NSString *)flattenHTML:(NSString *)html;

/**
 *  友好化距离显示
 */
- (NSString *)formatDistance:(float)distance;

/**
 *  验证邮箱
 */
- (BOOL)validateEmail:(NSString *)email;

/**
 *  验证手机号
 */
- (BOOL)validatePhone:(NSString *)phone;
/**
 *  验证手机号
 */
- (BOOL)validateName:(NSString *)name;

/*
 * MD5加密
 */
- (NSString *)encryptMD5:(NSString *)string;

/*
 * 计算文字长度
 */
- (CGSize)sizeWithString:(NSString *)string andSize:(NSInteger)size;

/*
 * 替换某个范围的子串
 */
- (NSString *)byReplacingCharActer:(NSString *)phone;

/*
 * 截取一定长度的串
 */
- (NSString *)interceptReplacingString:(NSString *)time;

/*
 * 判断是否有http://子串
 */
- (BOOL)ReplacingCharActer:(NSString *)portrait;

/*
 * 判断是否无值
 */
- (BOOL)isBlankString:(NSString *)string;
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
NSMutableAttributedString *GetAttributedText(NSString *value);
- (CGFloat)calculateMeaasgeHeightWithText:(NSString *)string andWidth:(CGFloat)width andFont:(UIFont *)font;

@end
