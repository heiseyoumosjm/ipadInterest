//
//  GoodAttributesView.h
//  AiMeiBang
//
//  Created by Lingxiu on 16/1/25.
//  Copyright © 2016年 zym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodAttributesView : UIView

@property (nonatomic, copy) NSString *good_img;
@property (nonatomic, copy) NSString *good_name;
@property (nonatomic, copy) NSString *good_price;
@property (nonatomic, strong) NSString *old_attr_str;

/** 购买数量 */
@property (nonatomic, assign) int buyNum;
/** 属性名1 */
@property (nonatomic, copy) NSString *goods_attr_1;
/** 属性名2 */
@property (nonatomic, copy) NSString *goods_attr_2;
/** 属性名2 */
@property (nonatomic, copy) NSString *goods_attr_3;
/** 属性值1 */
@property (nonatomic, copy) NSString *goods_attr_value_1;
/** 属性值2 */
@property (nonatomic, copy) NSString *goods_attr_value_2;
/** 属性值2 */
@property (nonatomic, copy) NSString *goods_attr_value_3;
@property (nonatomic, strong) NSMutableArray *goodAttrsArr;
@property (nonatomic, strong) NSMutableArray *goodModelArr;
@property (nonatomic, strong) NSMutableArray *attrArr;
@property (nonatomic, strong) NSMutableDictionary *colorDic;
@property (nonatomic, copy) void (^sureBtnsClick)( NSString *goodid);
/**
 *  显示属性选择视图
 *
 *  @param view 要在哪个视图中显示
 */
- (void)showInView:(UIView *)view;
/**
 *  属性视图的消失
 */
- (void)removeView;

@end
