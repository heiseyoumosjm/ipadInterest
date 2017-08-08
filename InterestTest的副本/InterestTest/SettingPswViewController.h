//
//  SettingPswViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingPswViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property(nonatomic,strong)NSString *type; //1创建密码 2 重置密码
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *code;
- (IBAction)tologin:(UIButton *)sender;
- (IBAction)register1:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UITextField *pswLab;
@end
