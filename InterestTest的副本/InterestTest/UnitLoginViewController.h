//
//  UnitLoginViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/6.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface UnitLoginViewController : BaseViewController
- (IBAction)chooseLP:(UIButton *)sender;

- (IBAction)chooseUnit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *lplab;
@property (weak, nonatomic) IBOutlet UITextField *unitLab;
- (IBAction)check:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

@property (weak, nonatomic) IBOutlet UIView *hxView;

@property (weak, nonatomic) IBOutlet UIView *HxNumView;

- (IBAction)hxName:(UIButton *)sender;

- (IBAction)chooseHxOk:(UIButton *)sender;

- (IBAction)choosehxNumOk:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *lpBtnView;

- (IBAction)cancal:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet UIButton *chooseNumBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

- (IBAction)cancalHxNumView:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *hxNumName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hxnumHeight;
@property (weak, nonatomic) IBOutlet UIView *hxnumBtnView;
@property (weak, nonatomic) IBOutlet UIButton *chooseLpBtn;

@end
