//
//  AllPictureModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/4/11.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ScenePicture.h"
@interface AllPictureModel : JSONModel
//"created_at" = 1491876069;
//id = 11;
//scenePicture =             {
//    "created_at" = 1491382831;
//    "flat_img" = "/res/upload/1/05/1491382685552.jpg";
//    "goods_ids" = "252,253,254,256,257,258,259,260,262";
//    "goods_model_ids" = "<null>";
//    id = 12;
//    "room_product_id" = 4;
//    "scene_color_id" = 1;
//    "scene_picture_name" = "\U6e2f\U5f0f1-\U5ba2\U5385\U573a\U666f\U56fe5";
//    "space_img" = "";
//    "updated_at" = 1491392516;
//};
@property (strong, nonatomic) NSString<Optional> *is_like;
@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) ScenePicture<Optional> *scenePicture;
@end