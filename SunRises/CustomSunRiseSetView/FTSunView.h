//
//  FTSunView.h
//  SunRises
//
//  Created by huyunlong on 2017/11/12.
//  Copyright © 2018年 huyunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCustomSunRiseSetView.h"

@interface FTSunView : UIView

@property (nonatomic, strong) FTCustomSunRiseSetView * sunRiseSetView;
@property float totleAngle;  //太阳的升起的角度
@property (nonatomic, strong) NSTimer *timer;


/**
 根据日出日落时间绘图

 @param sunRiseTime 日出时间
 @param sunSetTime 日落时间
 @param currentTime 当前时间
 */
- (void)handleSunRiseAndSet:(NSString *)sunRiseTime   sunSetTime:(NSString *)sunSetTime  currentTime:(NSString *)currentTime;

@end
