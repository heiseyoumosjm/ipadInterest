//
//  BaseViewController.h
//  zhenpin
//
//  Created by  miceky on 16/5/23.
//  Copyright © 2016年 miceky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ToolHelper.h"
#import "AppDelegate.h"
#import "HudHelper.h"
#import "UIView+Toast.h"
#import "SDWebImage.h"
#import "MJRefresh.h"



@interface BaseViewController : UIViewController

@property (strong, nonatomic)AppDelegate *appDelegate;

//- (NSURL *)placeImg:(NSString*)addr;
//- (NSURL *)placeAvatarImg:(NSString*)avatar;
- (UIImage *)placeDefaultImg;
- (void)dismiss;
- (void)closeVC;
- (NSString *)getApplicationName;
- (NSString *)getApplicationScheme;
- (BOOL)isBlankString:(NSString *)string;
- (UIColor *) colorWithHexString: (NSString *)color;
@end
