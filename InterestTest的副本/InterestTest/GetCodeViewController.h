//
//  GetCodeViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface GetCodeViewController : BaseViewController
@property(nonatomic,strong)NSString *type;//1为注册获取验证码 2为忘记密码获取验证码
@property(nonatomic,strong)NSString *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UITextField *codelab;
- (IBAction)getCode:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;
- (IBAction)tologin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *auteCodeBut;
-(NSString *)getErrorStringWithError:(NSError *)error;
@end
