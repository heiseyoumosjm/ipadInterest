//
//  UnitDisplayViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/8.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"
#import "HxModel.h"

@interface UnitDisplayViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *unitImg;
@property (strong,nonatomic)HxModel *hxModel;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *basic_room_id;
@property (strong,nonatomic)NSString *building_id;
@property (strong,nonatomic)NSString *room_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@end
