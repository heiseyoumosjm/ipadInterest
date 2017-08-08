//
//  LoginViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)tologin:(UIButton *)sender;

- (IBAction)forgetPsw:(UIButton *)sender;

- (IBAction)toRegister:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property(strong,nonatomic)NSString *type;
@end
