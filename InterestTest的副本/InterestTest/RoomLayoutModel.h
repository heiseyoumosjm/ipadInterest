//
//  RoomLayoutModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/16.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RoomProductModel.h"

@interface RoomLayoutModel : JSONModel
//"api_code" = 200;
//"created_at" = 1489457380;
//icon = "/res/upload/1/55/14895406073520.png";
//id = 1;
//position = "<null>";
//roomProduct =     (
//                   {
//                       id = 1;
//                       name = "\U5ba2\U5385\U63a8\U8350\U5e03\U5c40";
//                       "recommended_layout" = "/res/upload/1/e6/14895803088007.jpg";
//                   },
//                   {
//                       id = 2;
//                       name = "\U5ba2\U5385\U63a8\U8350\U5e03\U5c402";
//                       "recommended_layout" = "/res/upload/1/f4/14895803295737.jpg";
//                   },
//                   {
//                       id = 3;
//                       name = "\U5ba2\U5385\U63a8\U8350\U5e03\U5c403";
//                       "recommended_layout" = "/res/upload/1/b4/14895803568656.jpg";
//                   }
//                   );
//"room_name" = "\U5367\U5ba4";
//"updated_at" = 1489540609;
@property (strong, nonatomic) NSString<Optional> *api_code;
//@property (strong, nonatomic) NSString<Optional> *created_at;
//@property (strong, nonatomic) NSString<Optional> *icon;
//@property (strong, nonatomic) NSString<Optional> *id;
//@property (strong, nonatomic) NSString<Optional> *position;
@property (strong, nonatomic) NSMutableArray<RoomProductModel> *data;
@end
