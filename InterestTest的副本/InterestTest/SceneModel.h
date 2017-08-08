//
//  SceneModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/26.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SceneModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *scene_picture_name;
@property (strong, nonatomic) NSString<Optional> *room_product_id;
@property (strong, nonatomic) NSString<Optional> *scene_color_id;
@property (strong, nonatomic) NSString<Optional> *goods_ids;
@property (strong, nonatomic) NSString<Optional> *goods_model_ids;
@property (strong, nonatomic) NSString<Optional> *flat_img;
@property (strong, nonatomic) NSString<Optional> *space_img;
@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *updated_at;
@property (strong, nonatomic) NSString<Optional> *api_code;
@end
