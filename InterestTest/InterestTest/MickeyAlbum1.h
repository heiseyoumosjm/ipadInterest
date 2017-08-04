//
//  MickeyAlbum1.h
//  InterestTest
//
//  Created by 商佳敏 on 17/3/28.
//  Copyright © 2017年 商佳敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"

typedef enum
{
    MickeyAlbumOutImgViewPointLeftUp =1,
    MickeyAlbumOutImgViewPointRightUp,
    MickeyAlbumOutImgViewPointLeftDown,
    MickeyAlbumOutImgViewPointRightDown
}MickeyAlbumOutImgViewPointType;
#define myScreenHeight  [UIScreen mainScreen].bounds.size.height
#define myScreenWidth [UIScreen mainScreen].bounds.size.width

@protocol MickeyAlbumDelegate1 <NSObject>
- (void)getCurPage:(NSInteger)curPage;

@end

@interface MickeyAlbum1:UIViewController<UIScrollViewDelegate>
@property (nonatomic,assign)CGRect photoFrame;
@property (nonatomic,strong)id<MickeyAlbumDelegate1>myDelegate;
-(id)initWithImgUrlArr:(NSArray*)array CurPage:(NSInteger)curpage;
-(id)initWithImgULocationArr:(NSArray*)array CurPage:(NSInteger)curpage;
@end
