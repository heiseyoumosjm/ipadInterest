//
//  roomModel.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/25.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface roomModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *position;
@property (strong, nonatomic) NSMutableDictionary<Optional> *roomFunction;
@property (strong, nonatomic) NSString<Optional> *updated_at;

@end
