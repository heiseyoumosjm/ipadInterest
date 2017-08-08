//
//  RoomProductModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/16.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol RoomProductModel
@end

@interface RoomProductModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *img_height;
@property (strong, nonatomic) NSString<Optional> *img_width;
@property (strong, nonatomic) NSString<Optional> *recommended_layout;

@end
