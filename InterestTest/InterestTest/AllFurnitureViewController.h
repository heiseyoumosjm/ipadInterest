//
//  AllFurnitureViewController.h
//  InterestTest
//
//  Created by 商佳敏 on 17/5/9.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import "BaseViewController.h"

@interface AllFurnitureViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *goodDetailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property(strong,nonatomic)NSString *type;
@end