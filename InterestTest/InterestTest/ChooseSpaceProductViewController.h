//
//  ChooseSpaceProductViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/12.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseSpaceProductViewController : BaseViewController
//代理
@property (strong, nonatomic) id <ChangeGoodsDelegate> delegate;
@property(strong,nonatomic)NSString *goods_id;
@property(strong,nonatomic)NSString *layout_id;
@property(strong,nonatomic)NSString *layout_id_unband;
@property(strong,nonatomic)NSString *position;
@end
