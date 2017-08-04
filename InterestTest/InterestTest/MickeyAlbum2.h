//
//  MickeyAlbum2.h
//  InterestTest
//
//  Created by 商佳敏 on 17/5/11.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
typedef enum
{
    MickeyAlbumOutImgViewPointLeftUp1 =1,
    MickeyAlbumOutImgViewPointRightUp1,
    MickeyAlbumOutImgViewPointLeftDown1,
    MickeyAlbumOutImgViewPointRightDown1
}MickeyAlbumOutImgViewPointType1;
#define myScreenHeight  [UIScreen mainScreen].bounds.size.height
#define myScreenWidth [UIScreen mainScreen].bounds.size.width

@protocol MickeyAlbumDelegate2 <NSObject>
- (void)getCurPage:(NSInteger)curPage;

@end

@interface MickeyAlbum2:UIViewController<UIScrollViewDelegate>
@property (nonatomic,assign)CGRect photoFrame;
@property (nonatomic,strong)id<MickeyAlbumDelegate2>myDelegate;
-(id)initWithImgUrlArr:(NSArray*)array CurPage:(NSInteger)curpage;
-(id)initWithImgULocationArr:(NSArray*)array CurPage:(NSInteger)curpage;
@end

