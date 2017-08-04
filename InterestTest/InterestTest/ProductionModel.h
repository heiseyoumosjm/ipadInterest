//
//  ProductionModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/16.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "goodsModel.h"
@interface ProductionModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *api_code;
@property (strong, nonatomic) NSString<Optional> *id;
//@property (strong, nonatomic) NSString<Optional> *recommended_layout;
//@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSMutableArray<goodsModel> *goods;
@end
