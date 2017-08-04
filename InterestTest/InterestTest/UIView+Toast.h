//
//  UIView+Toast.h
//  zhenpin
//
//  Created by Sailor on 16/6/4.
//  Copyright © 2016年 iSailor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Toast)

- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point;

@end
