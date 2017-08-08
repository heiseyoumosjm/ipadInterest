//
//  MickeyTools.m
//  zhenpin
//
//  Created by 商佳敏 on 16/9/8.
//  Copyright © 2016年 商佳敏. All rights reserved.
//

#import "MickeyTools.h"
@implementation MickeyTools
+(NSString *)getErrorStringWithError:(NSError *)error
{
    NSString *errString = nil;
    switch (error.code) {
        case NSURLErrorTimedOut:
            errString = @"请求超时";
            break;
        case NSURLErrorNotConnectedToInternet:
            errString = @"无法连接网络,请检查您的网络设置";
            break;
        case NSURLErrorBadServerResponse:
            errString = error.localizedDescription;
            if ([errString isEqualToString:@"Request failed: internal server error (500)"]) {
                
            }else{
                 errString = @"登陆信息过期,需要重新登陆";
//                [[UserDBHelper userDBHelper] executeUpdateSql:@"DELETE FROM user"];
//                [AppDelegate appDelegate].usertoken = nil;
//                [[RootHttpHelper httpHelper] setUserToken:[AppDelegate appDelegate].usertoken];
//                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//                [defaults removeObjectForKey:@"fileName"];
//                [defaults removeObjectForKey:@"fileDetaile"];
//                [defaults removeObjectForKey:@"usertoken"];
//                [defaults removeObjectForKey:@"pushState"];
//                [defaults synchronize];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
////                UINavigationController *nav=[[UINavigationController alloc]init];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"signIn" object:nil];
//                LoginHomeViewController *login=[[LoginHomeViewController alloc]init];
//                [nav.tabBarController.childViewControllers[tabBarController.selectedIndex] presentViewController:login animated:YES completion:^{
//                
//                }];
            
        }
            break;
        default:
            errString = error.localizedDescription;
            break;
    }
    return errString;
}
@end
