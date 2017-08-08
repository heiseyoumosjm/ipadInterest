//
//  AppDelegate.m
//  InterestTest
//
//  Created by 商佳敏 on 17/2/28.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "AppDelegate.h"
#import "ThemeViewController.h"
#import "SWRevealViewController.h"
#import "LeftViewController.h"
#import "WSMovieController.h"
#import "UserInfoViewController.h"
#import "IQKeyboardManager.h"
#import "NewInterestTestViewController.h"

@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    

    UserInfoViewController *user=[[UserInfoViewController alloc]init];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:user];
    self.window.rootViewController = frontNavigationController;
    [self.window makeKeyAndVisible];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    
//    //是第一次
//    WSMovieController *wsCtrl = [[WSMovieController alloc]init];
//    NSLog(@"%@",[[NSBundle mainBundle]pathForResource:@"qidong" ofType:@"mp4"]);
//    wsCtrl.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"qidong"ofType:@"mp4"]];
//    self.window.rootViewController = wsCtrl;
//    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirstLogin"];
    
//    ThemeViewController *theme=[[ThemeViewController alloc]init];
//    LeftViewController  *left=[[LeftViewController alloc]init];
//    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:theme];
//    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:left];
//    
//    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//    revealController.delegate = self;
//    
//    self.window.rootViewController = revealController;
//    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark ------------------------ 初始化AppDelegate --------------------------
+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
