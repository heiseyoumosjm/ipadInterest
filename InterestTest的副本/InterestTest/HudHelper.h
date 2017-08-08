//
//  HudHelper.h
//  zhenpin
//
//  Created by Sailor on 16/5/23.
//  Copyright © 2016年 iSailor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HudHelper : NSObject

+(HudHelper*)hudHepler;
-(void)ShowHUDAlert:(UIView*)view;
-(void)HideHUDAlert:(UIView*)view;
-(void)showStillShortTips:(UIView *)view tips:(NSString*)message;
-(void)showShortTips:(UIView*)view tips:(NSString*)message;
-(void)showTips:(UIView*)view tips:(NSString*)message;
-(void)showLongTips:(UIView*)view tips:(NSString*)message;
-(void)showUIAlert:(NSString*)title;

@end
