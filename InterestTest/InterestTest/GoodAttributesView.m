//
//  GoodAttributesView.m
//  AiMeiBang
//
//  Created by Lingxiu on 16/1/25.
//  Copyright © 2016年 zym. All rights reserved.
//

#import "GoodAttributesView.h"
#import "UIButton+Bootstrap.h"
#import "GoodAttrModel.h"
#import "UIImageView+WebCache.h"
#import "GlobalDefine.h"
#import "Constants.h"
#import "HudHelper.h"
#import "SDWebImage.h"

@interface GoodAttributesView ()
{
    UIButton *_selectedButton;
    NSMutableArray *_mutableArr;
    UILabel *_firstAttributeLbl;
    UILabel *_secondAttributeLbl;
    UILabel *_thridAttributeLbl;
    
    NSString *_goods_attr_value_1;
    NSString *_goods_attr_value_2;
    NSString *_goods_attr_value_3;
}
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *iconImgView;
@property (nonatomic, weak) UILabel *goodsNameLbl;
@property (nonatomic, weak) UILabel *goodsPriceLbl;
/** 购买数量Lbl */
@property (nonatomic, weak) UILabel *buyNumsLbl;
// 放置属性的scrollView
@property (nonatomic, weak) UIScrollView *scrollView;
// 存放buttons的数组
@property (nonatomic, strong) NSMutableArray *firstBtnsArr;
@property (nonatomic, strong) NSMutableArray *secondBtnsArr;
@property (nonatomic, strong) NSMutableArray *thridBtnsArr;
@property (nonatomic,strong)NSString *goods_id;
@end
@implementation GoodAttributesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5];
        
        [self setupBasicView];
    }
    return self;
}

/**
 *  设置视图的基本内容
 */
- (void)setupBasicView {
    // 添加手势，点击背景视图消失
    /** 使用的时候注意名字不能用错，害我定格了几天才发现。FK
     UIGestureRecognizer
     UITapGestureRecognizer // 点击手势
     UISwipeGestureRecognizer // 轻扫手势
     */
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tapBackGesture];
    
    UIView *contentView = [[UIView alloc] initWithFrame:(CGRect){280, 64+22, kScreenW-560, kScreenH-128-22}];
    contentView.backgroundColor = [UIColor whiteColor];
//        iconBackView.layer.borderWidth = 1;
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds=YES;
    // 添加手势，遮盖整个视图的手势，
    UITapGestureRecognizer *contentViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [contentView addGestureRecognizer:contentViewTapGesture];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIView *iconBackView = [[UIView alloc] initWithFrame:(CGRect){30, 30, 70, 70}];
    iconBackView.backgroundColor = kWhiteColor;
//    iconBackView.layer.borderColor = LXBorderColor.CGColor;
//    iconBackView.layer.borderWidth = 1;
//    iconBackView.layer.cornerRadius = 3;
    [contentView addSubview:iconBackView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, 82, 82}];
//    [iconImgView setImage:[UIImage imageNamed:@"1"]];
    [iconBackView addSubview:iconImgView];
    iconImgView.contentMode=UIViewContentModeScaleAspectFit;
    self.iconImgView.contentMode=UIViewContentModeScaleAspectFit;
    self.iconImgView.clipsToBounds=YES;
    iconImgView.clipsToBounds=YES;
    self.iconImgView = iconImgView;
    
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    XBtn.frame = CGRectMake(kScreenW-560-20-20, 20, 20, 20);
    [XBtn setBackgroundImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    [XBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:XBtn];
    
    UILabel *goodsNameLbl = [[UILabel alloc] init];
    goodsNameLbl.text = @"商品名字";
    goodsNameLbl.textColor = UIColorFromRGB(0x3333);
    goodsNameLbl.font = [UIFont boldSystemFontOfSize:20];
    CGFloat goodsNameLblX = CGRectGetMaxX(iconBackView.frame) + 20;
    CGFloat goodsNameLblY = iconBackView.frame.origin.y+5;
//    CGSize size = [goodsNameLbl.text sizeWithFont:goodsNameLbl.font];
//    goodsNameLbl.frame = (CGRect){goodsNameLblX, goodsNameLblY, size};
    goodsNameLbl.frame=CGRectMake(goodsNameLblX, goodsNameLblY, 200, 40);
    [contentView addSubview:goodsNameLbl];
    self.goodsNameLbl = goodsNameLbl;
    
    UILabel *goodsPriceLbl = [[UILabel alloc] initWithFrame:(CGRect){goodsNameLblX, goodsNameLblY+25, 150, 45}];
    goodsPriceLbl.text = @"99元";
    goodsPriceLbl.textColor=colorHead;
    goodsPriceLbl.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:goodsPriceLbl];
    self.goodsPriceLbl = goodsPriceLbl;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = kMAINCOLOR;
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds=YES;
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"icon_log"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(80, contentView.frame.size.height-44-24, kScreenW-560-160, 44);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    
    UIScrollView *attrScrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, iconBackView.frame.origin.y+110, kScreenW-560,contentView.frame.size.height - 44-24-30-30-70-30 }];
    attrScrollView.bounces = YES;
    attrScrollView.backgroundColor = kWhiteColor;
    [contentView addSubview:attrScrollView];
    self.scrollView = attrScrollView;
}
- (void)setGood_img:(NSString *)good_img {
    _good_img = good_img;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",good_img]] placeholderImage:nil];
}
- (void)setGood_name:(NSString *)good_name {
    _good_name = good_name;
    self.goodsNameLbl.text = good_name;
}
- (void)setGood_price:(NSString *)good_price {
    _good_price = good_price;
    self.goodsPriceLbl.text = [NSString stringWithFormat:@"¥%@", good_price];
}
/**
 *  设置属性控件 - setter方法
    默认传的是两组属性
 */
- (void)setGoodAttrsArr:(NSMutableArray *)goodAttrsArr {
    _goodAttrsArr = goodAttrsArr;
    NSArray *old_Attrs=[[NSArray alloc]init];
    old_Attrs=[_old_attr_str componentsSeparatedByString:@","];
    // 第一组属性
    self.goods_attr_1 = ((GoodAttrModel *)goodAttrsArr[0]).attr_id;
    _firstAttributeLbl=[[UILabel alloc] initWithFrame:CGRectMake(kSmallMargin, 5, kScreenW-560, kBigMargin)];
    _firstAttributeLbl.text = ((GoodAttrModel *)goodAttrsArr[0]).attr_name;
    _firstAttributeLbl.textColor=UIColorFromRGB(0x333333);
    _firstAttributeLbl.font= kContentTextFont;
    [self.scrollView addSubview:_firstAttributeLbl];
    
    NSMutableArray *attrValueArr0 = ((GoodAttrModel *)goodAttrsArr[0]).attr_value;
    CGFloat one_btnsX = kBigMargin;
   // CGFloat one_btnY =kBigMargin;
    CGFloat one_btnY = CGRectGetMaxY(_firstAttributeLbl.frame) + 15;
    for (int i = 0; i < attrValueArr0.count ; i++) {
        NSString *btnTittle = ((GoodAttrValueModel *)attrValueArr0[i]).attr_value;
        CGSize size = [btnTittle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kButtonTextFont, NSFontAttributeName, nil]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *img=[[UIImageView alloc]init];
//       [btn.layer setBorderWidth:5];//设置边界的宽度
//       [btn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
       [btn.layer setCornerRadius:5];
        //第二种方法如下:
        btn.layer.borderColor=[UIColor whiteColor].CGColor;
       [btn setTitle:btnTittle forState:UIControlStateNormal];
        if ([btnTittle isEqualToString:old_Attrs[0]]) {
            _goods_attr_value_1=btnTittle;
            btn.selected=YES;
        }
        if ([_firstAttributeLbl.text isEqualToString:@"颜色"]) {
            NSString *str=[_colorDic objectForKey:btnTittle];
            
            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",str]] ];
//            img.backgroundColor=[UIColor redColor];
//            [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",str]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(attrs1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
             btn.tag = i;
             btn.titleLabel.font=[UIFont systemFontOfSize:10];
            btn.frame = CGRectMake(one_btnsX, one_btnY,  40, 40);
            img.frame=CGRectMake(6, 6, 28, 28);
           [img.layer setCornerRadius:2.5];
            img.layer.masksToBounds=YES;
            one_btnsX += kBigMargin +  kBigMargin;
            
            while (one_btnsX  > kScreenW-560) {
                one_btnsX = kBigMargin;
                one_btnY += 45;
                if ((one_btnsX +  30) > kScreenW-560) {
                    one_btnsX = kBigMargin;
                    break;
                }
                btn.frame = CGRectMake(one_btnsX, one_btnY, 40, 40);
                img.frame=CGRectMake(6, 6, 28, 28);
                one_btnsX += 15 +  kBigMargin;
            }

        }else{
//        NSString *str=[_colorDic objectForKey:btnTittle];
//        
//        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",str]] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:8];
        btn.tag = i;

        [btn addTarget:self action:@selector(attrs1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(one_btnsX, one_btnY, size.width+15 +20+ 40, 40);
        one_btnsX += kBigMargin +  size.width+15 + kBigMargin+20;
        
        while (one_btnsX  > kScreenW-560) {
            one_btnsX = kBigMargin;
            one_btnY += 60;
            if ((one_btnsX + size.width+15 +  30+20) > kScreenW-560) {
                one_btnsX = kBigMargin;
                break;
            }
            btn.frame = CGRectMake(one_btnsX, one_btnY, size.width +15+ 40+20, 40);
            one_btnsX += 15 + size.width+15 +  kBigMargin;
        }
        }
       [btn defaultStyleWithNormalTitleColor:HX_RGB(136, 137, 138) andHighTitleColor:colorHead andBorderColor:LXBorderColor andBackgroundColor:kWhiteColor andHighBgColor:kMAINCOLOR andSelectedBgColor:[UIColor whiteColor] withcornerRadius:5];
        if (btn.selected) {
            
            btn.layer.borderColor = [colorHead CGColor];
        }
        [self.scrollView addSubview:btn];
        [self.firstBtnsArr addObject:btn];
        [btn addSubview:img];
    }
    // 获取 第一个属性中最后一个按钮
    UIButton *btn = (UIButton *)[self.firstBtnsArr lastObject];
    
//    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(kSmallMargin, CGRectGetMaxY(btn.frame)+kSmallMargin, kScreenW-kBigMargin, 1)];
//    line1.backgroundColor=HX_RGB(226, 228, 229);
//    [self.scrollView addSubview:line1];
    if (_goodAttrsArr.count>1) {
    // 第二组属性
    self.goods_attr_2 = ((GoodAttrModel *)goodAttrsArr[1]).attr_id;
    _secondAttributeLbl=[[UILabel alloc] initWithFrame:CGRectMake(kSmallMargin,  CGRectGetMaxY(btn.frame)+kSmallMargin, kScreenW, kBigMargin)];
    _secondAttributeLbl.text = ((GoodAttrModel *)goodAttrsArr[1]).attr_name;
    _secondAttributeLbl.font=kContentTextFont;
    _secondAttributeLbl.textColor=UIColorFromRGB(0x333333);;
    [self.scrollView addSubview:_secondAttributeLbl];
    
    NSMutableArray *attrValueArr1 = ((GoodAttrModel *)goodAttrsArr[1]).attr_value;
    CGFloat two_btnX = kBigMargin;
    CGFloat two_btnY = CGRectGetMaxY(_secondAttributeLbl.frame) + 15;
    for (int i = 0; i < attrValueArr1.count ; i++) {
        NSString *btnTittle = ((GoodAttrValueModel *)attrValueArr1[i]).attr_value;
//        if ([btnTittle isEqualToString:old_Attrs[1]]) {
//            _goods_attr_value_2=btnTittle;
//            btn.selected=YES;
//        }
        CGSize size = [btnTittle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kButtonTextFont, NSFontAttributeName, nil]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTittle forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        btn.tag = i;
        if ([btnTittle isEqualToString:old_Attrs[1]]) {
            _goods_attr_value_2=btnTittle;
            btn.selected=YES;
        }
//        if (i==0) {
//            btn.selected=YES;
//            _goods_attr_value_2=btnTittle;
//        }
//        if (btn.selected) {
//            
//            btn.layer.borderColor = [colorHead CGColor];
//        }
        [btn addTarget:self action:@selector(attrs2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
         btn.frame = CGRectMake(two_btnX, two_btnY, size.width+15 + 40+20, 40);
         two_btnX += kBigMargin + size.width+16 + kBigMargin+20;
        
        while (two_btnX > kScreenW-560) {
            two_btnX = kBigMargin;
            two_btnY += 45;
            if ((two_btnX + size.width + 30+15+20) > kScreenW-560) {
                two_btnX = kBigMargin;
                break;
            }
            btn.frame = CGRectMake(two_btnX, two_btnY, size.width+15 + 40+20, 40);
            two_btnX +=kBigMargin + size.width+15 + kBigMargin+20;
        }
        [btn defaultStyleWithNormalTitleColor:HX_RGB(136, 137, 138) andHighTitleColor:colorHead andBorderColor:LXBorderColor andBackgroundColor:kWhiteColor andHighBgColor:colorHead andSelectedBgColor:[UIColor whiteColor] withcornerRadius:5];
        if (btn.selected) {
            
            btn.layer.borderColor = [colorHead CGColor];
        }
//        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        [self.scrollView addSubview:btn];
        [self.secondBtnsArr addObject:btn];
        
//        UIButton *btn2 = (UIButton *)[self.secondBtnsArr lastObject];
    }
    
//    UIButton *btn2 = (UIButton *)[self.secondBtnsArr lastObject];
    } if(_goodAttrsArr.count>2){
         UIButton *btn2 = (UIButton *)[self.secondBtnsArr lastObject];
        self.goods_attr_3 = ((GoodAttrModel *)goodAttrsArr[2]).attr_id;
        _thridAttributeLbl=[[UILabel alloc] initWithFrame:CGRectMake(kSmallMargin,  CGRectGetMaxY(btn2.frame)+kSmallMargin, kScreenW, kBigMargin)];
        _thridAttributeLbl.text = ((GoodAttrModel *)goodAttrsArr[2]).attr_name;
        _thridAttributeLbl.font=kContentTextFont;
        _thridAttributeLbl.textColor=UIColorFromRGB(0x333333);;
        [self.scrollView addSubview:_thridAttributeLbl];
        
        NSMutableArray *attrValueArr2 = ((GoodAttrModel *)goodAttrsArr[2]).attr_value;
        CGFloat two_btnX = kBigMargin;
        CGFloat two_btnY = CGRectGetMaxY(_thridAttributeLbl.frame) + 15;
        for (int i = 0; i < attrValueArr2.count ; i++) {
            NSString *btnTittle = ((GoodAttrValueModel *)attrValueArr2[i]).attr_value;
//            if ([btnTittle isEqualToString:old_Attrs[2]]) {
//                _goods_attr_value_3=btnTittle;
//                btn.selected=YES;
//            }
            CGSize size = [btnTittle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kButtonTextFont, NSFontAttributeName, nil]];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:btnTittle forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:15];
            btn.tag = i;
            if ([btnTittle isEqualToString:old_Attrs[2]]) {
                _goods_attr_value_3=btnTittle;
                btn.selected=YES;
            }
//            if (i==0) {
//                btn.selected=YES;
//                _goods_attr_value_3=btnTittle;
//            }
            //        if (btn.selected) {
            //
            //            btn.layer.borderColor = [colorHead CGColor];
            //        }
            [btn addTarget:self action:@selector(attrs3BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(two_btnX, two_btnY, size.width+15 + 40+20, 40);
            two_btnX += kBigMargin + size.width+16 + kBigMargin+20;
            
            while (two_btnX > kScreenW-560) {
                two_btnX = kBigMargin;
                two_btnY += 45;
                if ((two_btnX + size.width+15 + 30+20) > kScreenW-560) {
                    two_btnX = kBigMargin;
                    break;
                }
                btn.frame = CGRectMake(two_btnX, two_btnY, size.width+15 + 40+20, 40);
                two_btnX += kBigMargin + size.width+16 + kBigMargin+20;
            }
            [btn defaultStyleWithNormalTitleColor:HX_RGB(136, 137, 138) andHighTitleColor:colorHead andBorderColor:LXBorderColor andBackgroundColor:kWhiteColor andHighBgColor:colorHead andSelectedBgColor:[UIColor whiteColor] withcornerRadius:5];
            if (btn.selected) {
                
                btn.layer.borderColor = [colorHead CGColor];
            }
            //        btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = YES;
            [self.scrollView addSubview:btn];
            [self.thridBtnsArr addObject:btn];
            
//            UIButton *btn2 = (UIButton *)[self.secondBtnsArr lastObject];
        }
        
        
    }

//    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(kSmallMargin, CGRectGetMaxY(btn2.frame)+kSmallMargin, kScreenW-kBigMargin, 1)];
//    line2.backgroundColor=HX_RGB(226, 228, 229);
//    [self.scrollView addSubview:line2];
    
//    UILabel *numLab=[[UILabel alloc] initWithFrame:CGRectMake(kSmallMargin, CGRectGetMaxY(line2.frame)+5, 80, kBigMargin)];
//    [numLab setText:@"购买数量"];
//    numLab.font=kContentTextFont;
//    numLab.textColor=HX_RGB(136, 137, 138);
//    [self.scrollView addSubview:numLab];
//    
//    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
//    CGFloat minusBtnWH = 35;
//    CGFloat minusBtnX = kBigMargin;
//    CGFloat minusBtnY = CGRectGetMaxY(numLab.frame)+15;
//    minusBtn.frame = CGRectMake(minusBtnX, minusBtnY, minusBtnWH, minusBtnWH);
//    [minusBtn defaultStyleWithNormalTitleColor:[UIColor blackColor] andHighTitleColor:HX_RGB(125, 125, 125) andBorderColor:LXBorderColor andBackgroundColor:HX_RGB(250, 250, 250) andHighBgColor:HX_RGB(220, 220, 220) withcornerRadius:1];
//    [minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.scrollView addSubview:minusBtn];
//    
//    // count
//    UILabel *buyNumsLbl = [[UILabel alloc] init];
//    buyNumsLbl.text = [NSString stringWithFormat:@"%d", self.buyNum];
//    buyNumsLbl.textAlignment = NSTextAlignmentCenter;
//    buyNumsLbl.layer.borderWidth = 1;
//    buyNumsLbl.layer.borderColor = LXBorderColor.CGColor;
//    CGFloat buyNumsLblW = minusBtnWH * 2;
//    CGFloat buyNumsLblH = minusBtnWH;
//    CGFloat buyNumsLblX = CGRectGetMaxX(minusBtn.frame) - 1;
//    CGFloat buyNumsLblY = minusBtnY;
//    buyNumsLbl.frame = CGRectMake(buyNumsLblX, buyNumsLblY, buyNumsLblW, buyNumsLblH);
//    [self.scrollView addSubview:buyNumsLbl];
//    self.buyNumsLbl = buyNumsLbl;
    
//    // +
//    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
//    CGFloat plusBtnWH = 35;
//    CGFloat plusBtnX = CGRectGetMaxX(buyNumsLbl.frame);
//    CGFloat plusBtnY = minusBtnY;
//    plusBtn.frame = CGRectMake(plusBtnX, plusBtnY, plusBtnWH, plusBtnWH);
//    [plusBtn defaultStyleWithNormalTitleColor:[UIColor blackColor] andHighTitleColor:HX_RGB(125, 125, 125) andBorderColor:LXBorderColor andBackgroundColor:HX_RGB(250, 250, 250) andHighBgColor:HX_RGB(220, 220, 220) withcornerRadius:1];
//    [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.scrollView addSubview:plusBtn];
//    
//    UIView *line3=[[UIView alloc] initWithFrame:CGRectMake(kSmallMargin, CGRectGetMaxY(buyNumsLbl.frame)+kBigMargin, kScreenW-kBigMargin, 1)];
//    line3.backgroundColor=HX_RGB(226, 228, 229);
//    [self.scrollView addSubview:line3];
    
//    CGFloat contentHeight = CGRectGetMaxY(btn2.frame) + kSmallMargin;
    _scrollView.showsVerticalScrollIndicator = FALSE;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.contentSize = CGSizeMake(kScreenW-560, self.contentView.frame.size.height-24-44-30);
}


- (void)showInView:(UIView *)view {
    [view addSubview:self];
//    self.contentView.hidden=NO;

}
- (void)removeView {
//      __weak typeof(self) _weakSelf = self;

     [self removeFromSuperview];
//    [UIView animateWithDuration:0.3 animations:^{
//        _weakSelf.backgroundColor = [UIColor clearColor];
//        _weakSelf.contentView.frame = CGRectMake(0, kScreenH, kScreenW, kATTR_VIEW_HEIGHT);
//    } completion:^(BOOL finished) {
//        [_weakSelf removeFromSuperview];
//    }];
}
- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
#pragma mark - 按钮点击事件
- (void)sureBtnClick {
//    // 购买数量
//    NSString *num = self.buyNumsLbl.text;
    // 属性ID str
//    NSString *attr_id1 = [NSString stringWithFormat:@"%@-%@", _goods_attr_1, _goods_attr_value_1];
//    NSString *attr_id2 = [NSString stringWithFormat:@"%@-%@", _goods_attr_2, _goods_attr_value_2];
//    NSString *attr_id = [NSString stringWithFormat:@"%@|%@", attr_id1, attr_id2];
    if (self.sureBtnsClick) {
        switch (_attrArr.count) {
                
            case 0:
                
                break;
            case 1:
            {
                if ([self isBlankString:self.goods_attr_value_1]) {
                     [[HudHelper hudHepler] showTips:self.contentView tips:[NSString stringWithFormat:@"请选择%@",[_attrArr[0] objectForKey:@"name"]]];
                }else{
                    for (NSMutableDictionary *dic in _goodModelArr) {
                        if ([[dic objectForKey:@"attr_str"]isEqualToString:[NSString stringWithFormat:@"%@",self.goods_attr_value_1]]) {
                             _goods_id=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                        }
                    }
       
                    if ([self isBlankString:_goods_id]) {
                        
                        [[HudHelper hudHepler] showTips:self.contentView tips:@"暂无该组合的商品"];
                        
                    }else{
                         self.sureBtnsClick(_goods_id);
                        [self removeView];
                    }
            
                }
            }
                break;
            case 2:
            {
                if ([self isBlankString:self.goods_attr_value_1]) {
                     [[HudHelper hudHepler] showTips:self.contentView tips:[NSString stringWithFormat:@"请选择%@",[_attrArr[0] objectForKey:@"name"]]];
                }
                else if ([self isBlankString:self.goods_attr_value_2]) {
                     [[HudHelper hudHepler] showTips:self.contentView tips:[NSString stringWithFormat:@"请选择%@",[_attrArr[1] objectForKey:@"name"]]];
                    
                }else{
                    for (NSMutableDictionary *dic in _goodModelArr) {
                        if ([[dic objectForKey:@"attr_str"]isEqualToString:[NSString stringWithFormat:@"%@,%@",self.goods_attr_value_1,self.goods_attr_value_2]]) {
                        _goods_id=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                        }
                    }
                    if ([self isBlankString:_goods_id]) {
                        
                        [[HudHelper hudHepler] showTips:self.contentView tips:@"暂无该组合的商品"];
                        
                    }else{
                        self.sureBtnsClick(_goods_id);
                        [self removeView];
                    }

                }
            }
                
                break;
                case 3:
            {
                if ([self isBlankString:self.goods_attr_value_1]) {
                     [[HudHelper hudHepler] showTips:self.contentView tips:[NSString stringWithFormat:@"请选择%@",[_attrArr[0] objectForKey:@"name"]]];
                }
                else if ([self isBlankString:self.goods_attr_value_2]) {
                     [[HudHelper hudHepler] showTips:self.contentView tips:[NSString stringWithFormat:@"请选择%@",[_attrArr[1] objectForKey:@"name"]]];
                    
                }else if([self isBlankString:self.goods_attr_value_3]){
                    [[HudHelper hudHepler] showTips:self.contentView tips:[NSString stringWithFormat:@"请选择%@",[_attrArr[2] objectForKey:@"name"]]];
                }else{
                    for (NSMutableDictionary *dic in _goodModelArr) {
                        if ([[dic objectForKey:@"attr_str"]isEqualToString:[NSString stringWithFormat:@"%@,%@,%@",self.goods_attr_value_1,self.goods_attr_value_2,self.goods_attr_value_3]]) {
                            _goods_id=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                        }
                    }
                    if ([self isBlankString:_goods_id]) {
                        
                        [[HudHelper hudHepler] showTips:self.contentView tips:@"暂无该组合的商品"];
                        
                    }else{
                        self.sureBtnsClick(_goods_id);
                        [self removeView];
                    }
                }

            }
                break;
                
            default:
                break;
        }
     
//        self.sureBtnsClick(self.goods_attr_value_1, self.goods_attr_value_2,self.goods_attr_value_3);
    }
//    [self removeView];
}
- (void)changeGoodsImg{
    
    switch (_attrArr.count) {
            
        case 0:
            
            break;
        case 1:
        {
            if ([self isBlankString:self.goods_attr_value_1]) {
             
            }else{
                for (NSMutableDictionary *dic in _goodModelArr) {
                    if ([[dic objectForKey:@"attr_str"]isEqualToString:[NSString stringWithFormat:@"%@",self.goods_attr_value_1]]) {
//                        _goods_id=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",[dic objectForKey:@"imgs"][0]]] placeholderImage:nil];
                        //    attributesView.good_name = self.goodDetailModel.goods_name;
                        self.goodsPriceLbl.text= [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"price"]];
                        self.goodsNameLbl.text= [dic objectForKey:@"name"];
                    }
                }
                
                
            }
        }
            break;
        case 2:
        {
            if ([self isBlankString:self.goods_attr_value_1]) {
                
            }
            else if ([self isBlankString:self.goods_attr_value_2]) {
            
                
            }else{
                for (NSMutableDictionary *dic in _goodModelArr) {
                    if ([[dic objectForKey:@"attr_str"]isEqualToString:[NSString stringWithFormat:@"%@,%@",self.goods_attr_value_1,self.goods_attr_value_2]]) {
//                        _goods_id=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",[dic objectForKey:@"imgs"][0]]] placeholderImage:nil];
                        //    attributesView.good_name = self.goodDetailModel.goods_name;
                       self.goodsPriceLbl.text= [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"price"]];
                       self.goodsNameLbl.text= [dic objectForKey:@"name"];
                    }
                }
                
            }
        }
            
            break;
        case 3:
        {
            if ([self isBlankString:self.goods_attr_value_1]) {
                
            }
            else if ([self isBlankString:self.goods_attr_value_2]) {
                
                
            }else if([self isBlankString:self.goods_attr_value_3]){
               
            }else{
                for (NSMutableDictionary *dic in _goodModelArr) {
                    if ([[dic objectForKey:@"attr_str"]isEqualToString:[NSString stringWithFormat:@"%@,%@,%@",self.goods_attr_value_1,self.goods_attr_value_2,self.goods_attr_value_3]]) {
                        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://injia-dev.image.alimmdn.com",[dic objectForKey:@"imgs"][0]]] placeholderImage:nil];
                        self.goodsNameLbl.text= [dic objectForKey:@"name"];
                        self.goodsPriceLbl.text= [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"price"]];
                    }
                }
                
            }
            
        }
            break;
            
        default:
            break;
    }
    

}
/**
 *     第一组按钮的点击事件
 */
-(void)attrs1BtnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        for (UIButton *btn in self.firstBtnsArr) {
            btn.selected = NO;
            btn.layer.borderColor = [LXBorderColor CGColor];
        }
        UIButton *btn = [self.firstBtnsArr objectAtIndex:button.tag];
        btn.selected = YES;
        
        self.goods_attr_value_1 = button.titleLabel.text;
        button.layer.borderColor = [colorHead CGColor];
    } else {
        self.goods_attr_value_1 = nil;
        button.layer.borderColor = [LXBorderColor CGColor];
    }
    [self changeGoodsImg];
   //    for (int i=0; i<_goodModelArr.count;i++) {
//        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//        dic=_goodModelArr[i];
//        NSArray  *array = [[dic objectForKey:@"attr_str"] componentsSeparatedByString:@","];
//        //UIButton *btn=self.secondBtnsArr[i];
////        UIButton *btn1=self.thridBtnsArr[i];
//        if ([array containsObject:self.goods_attr_value_1]) {
//            GoodAttrModel *model=_goodAttrsArr[1];
//            for (int j=0; j<model.attr_value.count; j++) {
//                  UIButton *btn=self.secondBtnsArr[j];
//                GoodAttrValueModel *vauModel=model.attr_value[j];
//                if ([array containsObject:vauModel.attr_value]) {
//                    btn.enabled=true;
//                }else{
//                    btn.enabled=false;
//                }
//                
//            }
//        }else{
////            btn.userInteractionEnabled=false;
////            btn1.userInteractionEnabled=false;
//            }
//        }

//    for (UIButton *btn in self.secondBtnsArr) {
//         btn.userInteractionEnabled=true;
//        for (NSMutableDictionary *dic in _goodModelArr) {
//            NSArray  *array = [[dic objectForKey:@"attr_str"] componentsSeparatedByString:@","];
//            if ([array containsObject:self.goods_attr_value_1]) {
//                btn.userInteractionEnabled=true;
//            }else{
//                btn.userInteractionEnabled=false;
//            }
//        }
//
//    }
}
/**
 *     第二组按钮的点击事件
 */
-(void)attrs2BtnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        for (UIButton *btn in self.secondBtnsArr) {
            btn.selected = NO;
            btn.layer.borderColor = [LXBorderColor CGColor];
        }
        UIButton *btn = [self.secondBtnsArr objectAtIndex:button.tag];
        btn.selected = YES;
        
        self.goods_attr_value_2 = button.titleLabel.text;
        button.layer.borderColor = [colorHead CGColor];
    } else {
        self.goods_attr_value_2 = nil;
        button.layer.borderColor = [LXBorderColor CGColor];
    }
    [self changeGoodsImg];
}
/**
 *     第二组按钮的点击事件
 */
-(void)attrs3BtnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        for (UIButton *btn in self.thridBtnsArr) {
            btn.selected = NO;
            btn.layer.borderColor = [LXBorderColor CGColor];
        }
        UIButton *btn = [self.thridBtnsArr objectAtIndex:button.tag];
        btn.selected = YES;
        
        self.goods_attr_value_3 = button.titleLabel.text;
        button.layer.borderColor = [colorHead CGColor];
    } else {
        self.goods_attr_value_3 = nil;
        button.layer.borderColor = [LXBorderColor CGColor];
    }
    [self changeGoodsImg];
}


- (void)minusBtnClick {
    if (self.buyNum == 1) return;
    
    self.buyNumsLbl.text = [NSString stringWithFormat:@"%d", --self.buyNum];
}

- (void)plusBtnClick {
    self.buyNumsLbl.text = [NSString stringWithFormat:@"%d", ++self.buyNum];
}
#pragma mark - 懒加载
- (NSMutableArray *)firstBtnsArr
{
    if (!_firstBtnsArr) {
        self.firstBtnsArr  = [[NSMutableArray alloc] init];
    }
    return _firstBtnsArr;
}
- (NSMutableArray *)secondBtnsArr
{
    if (!_secondBtnsArr) {
        self.secondBtnsArr  = [[NSMutableArray alloc] init];
    }
    return _secondBtnsArr;
}
- (NSMutableArray *)thridBtnsArr
{
    if (!_thridBtnsArr) {
        self.thridBtnsArr  = [[NSMutableArray alloc] init];
    }
    return _thridBtnsArr;
}
- (int)buyNum
{
    if (!_buyNum) {
        self.buyNum = 1;
    }
    return _buyNum;
}

@end
