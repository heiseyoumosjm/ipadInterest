//
//  MickeyTools.h
//  zhenpin
//
//  Created by 商佳敏 on 16/9/8.
//  Copyright © 2016年 商佳敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MickeyTools : NSObject
/**
 *  获取错误描述
 *
 *  @param error
 *
 *  @return 返回错误描述
 */
+(NSString *)getErrorStringWithError:(NSError *)error;
@end
