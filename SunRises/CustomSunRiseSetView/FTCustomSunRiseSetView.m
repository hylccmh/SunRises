//
//  Customview_1.m
//  扇形
//
//  Created by huyunlong on 2017/11/2.
//  Copyright © 2016年 huyunlong. All rights reserved.
//

#import "FTCustomSunRiseSetView.h"
#import <math.h>

@implementation FTCustomSunRiseSetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //左边的白点
        UIView *pointView_left = [[UIView alloc] initWithFrame:CGRectMake(50 - 7.5,self.frame.size.width / 2 - 40 - 7.5 , 15, 15)];
        pointView_left.backgroundColor = [UIColor whiteColor];
        pointView_left.layer.cornerRadius = 7.5;
        pointView_left.clipsToBounds = YES;
        [self addSubview:pointView_left];
        
        //右边的白点
        UIView *pointView_right = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50 - 7.5 ,self.frame.size.width / 2 - 40 - 7.5 , 15, 15)];
        pointView_right.backgroundColor = [UIColor whiteColor];
        pointView_right.layer.cornerRadius = 7.5;
        pointView_right.clipsToBounds = YES;
        [self addSubview:pointView_right];
        
        //白线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.width / 2 - 40 - 0.5 , self.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
				
        [self addSubview:lineView];
        
        //太阳
        [self addSubview:self.sunImgView];
        
        //日升时间
        [self addSubview:self.sunRiseLbl];
        
        //日落时间
        [self addSubview:self.sunSetLbl];
    }
    return self;
}

/**
 *  画图处理
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor  *color = [UIColor orangeColor];
    
    //设置虚线效果-------------------------****
    CGContextSetLineWidth(context, 1.0); //设置线的宽度
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);  //设置线的颜色
    CGFloat dashPattern[] = {2.0,.5};
    CGContextSetLineDash(context, 0.0, dashPattern, 1);
    
    //绘画半圆 ----------------------------------****
    color = [UIColor clearColor];
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextMoveToPoint(context, self.centerX, self.centerY); //中心点
    CGContextAddArc(context, self.centerX, self.centerY, self.radius, 180 * M_PI/180,  360* M_PI / 180, 0);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
				
	//绘画圆弧-----------------------------***
    color = self.sunRiseColor;
    CGContextAddArc(context, self.centerX, self.centerY, self.radius, M_PI, (180 + self.currAngle) * M_PI/180  , 0);
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextDrawPath(context, kCGPathFill);
    
    //绘画一个三角形-----------------------***
    float sin = fabsf(sinf((180 + self.currAngle) * M_PI / 180));
    float cos = fabsf(cosf((180 + self.currAngle) * M_PI / 180));
    
	float sunCenterX; //根据角度变化记录太阳的中心点X
    float sunCenterY; //根据角度变化记录太阳的中心点Y
    
    color = self.sunRiseColor;
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGPoint spoint[3];//建立4个点
    
    if(self.currAngle <= 90)
    {
        spoint[0] = CGPointMake(self.centerX - self.radius, self.centerY);
        spoint[1] = CGPointMake(self.centerX - cos * self.radius , self.centerY);
        spoint[2] = CGPointMake(self.centerX - cos * self.radius, self.centerY - sin * self.radius);//太阳的中心点
								
		sunCenterX = self.centerX - cos * self.radius;
		sunCenterY = self.centerY - sin * self.radius;
    }
    else
    {
        spoint[0] = CGPointMake(self.centerX - self.radius, self.centerY);
        spoint[1] = CGPointMake(self.centerX + cos * self.radius , self.centerY);
        spoint[2] = CGPointMake(self.centerX + cos * self.radius, self.centerY - sin * self.radius);//太阳的中心点
								
		sunCenterX = self.centerX + cos * self.radius;
		sunCenterY = self.centerY - sin * self.radius;
    }
    
    CGContextAddLines(context, spoint, 3);
    CGContextClosePath(context);//封起来(没有封闭起来的话就有会有一个开口)
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
				
	//太阳----------------------------------------***
    self.sunImgView.center = CGPointMake(sunCenterX, sunCenterY);//太阳位置
}

#pragma mark - private

- (void)setAnimation:(int)speed
{
	[self.sunImgView.layer removeAnimationForKey:@"FTRotate"];
				
	if (speed <=3)
	{
           speed += 3;
	}
				
	CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) ];
	rotationAnimation.repeatCount = MAXFLOAT;
				
	rotationAnimation.duration = 10 * M_PI / speed;
	[self.sunImgView.layer addAnimation:rotationAnimation forKey:@"FTRotate"];
}

#pragma mark - getter/setter

- (UIImageView *)sunImgView
{
    if(_sunImgView == nil)
    {
        _sunImgView = [[UIImageView alloc] init];
        _sunImgView.image = [UIImage imageNamed:@"litte_sun"];
        _sunImgView.frame = CGRectMake(50 - 7.5,self.frame.size.width / 2 - 40 - 7.5 , 25, 25);
    }
    
    return _sunImgView;
}

- (UILabel *)sunRiseLbl
{
    if(_sunRiseLbl == nil)
    {
        _sunRiseLbl = [[UILabel alloc] initWithFrame:CGRectMake(30 ,self.frame.size.width / 2 - 22 ,100 , 13)];
        _sunRiseLbl.font = [UIFont systemFontOfSize:14.0];
        _sunRiseLbl.textColor = [UIColor whiteColor];
		_sunRiseLbl.textAlignment = NSTextAlignmentLeft;
    }
    
    return  _sunRiseLbl;
}

- (UILabel *)sunSetLbl
{
    if(_sunSetLbl == nil)
    {
        _sunSetLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 131, self.frame.size.width / 2 - 22, 100, 13)];
        _sunSetLbl.font = [UIFont systemFontOfSize:14.0];
        _sunSetLbl.textColor = [UIColor whiteColor];
        _sunSetLbl.textAlignment = NSTextAlignmentRight;
    }
    return  _sunSetLbl;
}

@end















