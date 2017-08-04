//
//  UnitDispayActionViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"
#import "HxModel.h"

@interface UnitDispayActionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIImageView *UnitImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Img_width;
@property (strong,nonatomic)HxModel *hxModel;
@property (strong,nonatomic)NSString *pad_user_room_id;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;

- (IBAction)btnChooseType:(UIButton *)sender;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *basic_room_id;
@property (strong,nonatomic)NSString *building_id;
@property (strong,nonatomic)NSString *room_name;
@property(strong,nonatomic)NSMutableArray *roomModelArr;



@end
