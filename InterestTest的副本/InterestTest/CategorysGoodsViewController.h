//
//  CategorysGoodsViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/4/1.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface CategorysGoodsViewController : BaseViewController
@property(strong,nonatomic)NSString *cateId;
@property(strong,nonatomic)NSString *type;
@property(strong,nonatomic)NSString *name;
//代理
@property (strong, nonatomic) id <AddGoodsDelegate> delegate;
@end
