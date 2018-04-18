//
//  Customview_1.h
//  扇形
//
//  Created by huyunlong on 2017/11/2.
//  Copyright © 2016年 huyunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTCustomSunRiseSetView : UIView

@property float centerX;  //半圆的中心点位置--X
@property float centerY;  //半圆的中心点位置--Y
@property float radius;   //半径--R
@property (nonatomic, strong) UIImageView *sunImgView; //太阳
@property (nonatomic, strong) UILabel *sunRiseLbl; //日出时间
@property (nonatomic, strong) UILabel *sunSetLbl; //日落时间
@property (nonatomic, strong) UIColor *sunRiseColor; //太阳升起后的颜色

@property float currAngle; //当前太阳的度数

- (void)setAnimation:(int)speed;

@end
