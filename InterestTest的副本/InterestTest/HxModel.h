//
//  HxModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/14.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RoomFunctionModel.h"

@interface HxModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *api_code;
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *foor_plan_name;
@property (strong, nonatomic) NSString<Optional> *img;

@property (strong, nonatomic) NSString<Optional> *img_width;
@property (strong, nonatomic) NSString<Optional> *img_height;
@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *updated_at;
@property (strong, nonatomic) NSMutableArray<RoomFunctionModel> *room_function;

@end
