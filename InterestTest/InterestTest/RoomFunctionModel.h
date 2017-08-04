//
//  RoomFunctionModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/14.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol RoomFunctionModel
@end

@interface RoomFunctionModel : JSONModel

//{
//    "foor_plan_id" = 1;
//    id = 1;
//    "point_height" = "185.60";
//    "point_width" = "145.00";
//    "point_x_coordinate" = "96.00";
//    "point_y_coordinate" = "88.20";
//    position = 1;
//    "room_function_id" = 1;
//    "room_name" = "\U5367\U5ba4";
//    rooms =             (
//                         {
//                             id = 1;
//                             "room_name" = "\U5367\U5ba4";
//                         }
//                         );
//},

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *room_function_id;
@property (strong, nonatomic) NSString<Optional> *foor_plan_id;
@property (strong, nonatomic) NSString<Optional> *point_x_coordinate;
@property (strong, nonatomic) NSString<Optional> *point_y_coordinate;
@property (strong, nonatomic) NSString<Optional> *point_width;
@property (strong, nonatomic) NSString<Optional> *point_height;
@property (strong, nonatomic) NSString<Optional> *room_name;
@property (strong, nonatomic) NSString<Optional> *position;
@property (strong, nonatomic) NSMutableArray<Optional> *rooms;
@end
