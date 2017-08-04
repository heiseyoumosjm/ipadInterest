//
//  NewLoginViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface NewLoginViewController : BaseViewController

@property (nonatomic,strong) NSString *type;//1为注册 2为登录
@property (nonatomic,strong) NSString *typeinfp;//1为注册 2为登录
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@property (weak, nonatomic) IBOutlet UITextField *phoneLab;
- (IBAction)next:(UIButton *)sender;

- (IBAction)goLogin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end
