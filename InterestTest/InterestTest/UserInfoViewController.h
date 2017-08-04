//
//  UserInfoViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/2.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *mobile;

- (IBAction)chooseSex:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *women;
@property (weak, nonatomic) IBOutlet UIButton *men;
- (IBAction)checkBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UITextField *sexLab;
@property (strong,nonatomic)NSString *type;  
@end
