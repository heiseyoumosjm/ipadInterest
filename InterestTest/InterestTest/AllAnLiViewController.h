//
//  AllAnLiViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/5/10.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface AllAnLiViewController : BaseViewController
@property(strong,nonatomic)NSString *cateId;
@property(strong,nonatomic)NSString *type;
@property(strong,nonatomic)NSString *name;
@property(assign,nonatomic)NSInteger postion;
@property(strong,nonatomic)NSMutableArray *IdDateArr;
@end
