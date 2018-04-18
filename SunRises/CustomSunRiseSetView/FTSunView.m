//
//  FTSunView.m
//  SunRises
//
//  Created by huyunlong on 2017/11/12.
//  Copyright © 2018年 huyunlong. All rights reserved.
//

#import "FTSunView.h"

#define ScreenWidth   [[UIScreen mainScreen] bounds].size.width

@implementation FTSunView

#pragma mark - lifeCycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self addView];
    }
    
    return self;
}

#pragma mark - private
/**
 根据日出日落时间绘图
 */
- (void)handleSunRiseAndSet:(NSString *)sunRiseTime  sunSetTime:(NSString *)sunSetTime  currentTime:(NSString *)currentTime
{
    
    NSRange range = NSMakeRange (11, 5);
    
    self.sunRiseSetView.sunRiseLbl.text = [sunRiseTime substringWithRange:range];
    self.sunRiseSetView.sunSetLbl.text = [sunSetTime substringWithRange:range];
    
   
    if ([self dateTimeDifferenceWithStartTime:sunRiseTime endTime:currentTime] <= 0) //当前时间 - 日出时间  <= 0 （太阳在 日出点）
    {
        self.sunRiseSetView.currAngle = 0;
        [self.sunRiseSetView setNeedsDisplay];
    }
    else if([self dateTimeDifferenceWithStartTime:sunRiseTime endTime:currentTime] > 0 && [self dateTimeDifferenceWithStartTime:currentTime endTime:sunSetTime] > 0) //太阳在日出之后，日落之前
    {
        //绘画太阳动画
        [self.sunRiseSetView setAnimation:15];
        
        //日出到日落共多少分钟
        int minute = [self dateTimeDifferenceWithStartTime:sunRiseTime endTime:sunSetTime];
        float anglePerMinute = 180.0/minute; //每分钟对应的度数
        self.totleAngle = anglePerMinute * [self dateTimeDifferenceWithStartTime:sunRiseTime endTime:currentTime]; //总度数
        
        //放到子线程中绘画
        [self performSelector:@selector(setTimer) withObject:nil afterDelay:0.5];
    }
    else //太阳日落点
    {
        self.sunRiseSetView.currAngle = 180;
        [self.sunRiseSetView setNeedsDisplay];
    }
}

//设置定时器
- (void)setTimer
{
    if(!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawSunPosition) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

//绘图
- (void)drawSunPosition
{
    self.sunRiseSetView.currAngle = self.sunRiseSetView.currAngle + 0.5;
    
    if(self.sunRiseSetView.currAngle > self.totleAngle)
    {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    [self.sunRiseSetView setNeedsDisplay];
}


//计算时间差 --- 开始时间   --- 结束时间
- (int)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    //    int minute = (int)value /60;  // 分钟
    return value;
}

#pragma mark - addView

- (void)addView
{
    self.backgroundColor = [UIColor colorWithRed:3/255.0 green:63/255.0 blue:149/255.0 alpha:1.0];
    
    //Sun
    UILabel *txtLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, ScreenWidth - 40, 20)];
    txtLbl.text = @"Sun";
    txtLbl.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0f];
    txtLbl.textColor = [UIColor whiteColor];
    [self addSubview:txtLbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50,ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    [self addSubview:lineView];
    
    //太阳的位置
    [self addSubview:self.sunRiseSetView];
}


#pragma mark - getter/setter

- (FTCustomSunRiseSetView *)sunRiseSetView
{
    if(_sunRiseSetView == nil)
    {
        _sunRiseSetView = [[FTCustomSunRiseSetView alloc]initWithFrame: CGRectMake(0, 60 + 30, ScreenWidth, ScreenWidth/2 )];
        _sunRiseSetView.backgroundColor = [UIColor clearColor];
        _sunRiseSetView.centerX = ScreenWidth/2;
        _sunRiseSetView.centerY = ScreenWidth/ 2 - 40;
        _sunRiseSetView.radius = ScreenWidth/ 2 - 50;
        _sunRiseSetView.sunRiseColor = [UIColor colorWithRed:187/255.0 green:207/255.0 blue:144/255.0 alpha:1.0];
        _sunRiseSetView.currAngle = 0;
        _sunRiseSetView.sunImgView.image = [UIImage imageNamed:@"litte_sun"];
    }
    
    return _sunRiseSetView;
}

@end















