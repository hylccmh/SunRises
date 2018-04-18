//
//  ViewController.m
//  SunRises
//
//  Created by huyunlong on 2017/11/12.
//  Copyright © 2018年 huyunlong. All rights reserved.
//

#import "ViewController.h"
#import "FTSunView.h"

#define ScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) FTSunView *sunView;

@end

@implementation ViewController

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgImgView.image = [UIImage imageNamed:@"time.jpg"];
    [self.view addSubview:bgImgView];
    
    [self.view addSubview:self.sunView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    [self initData];
}

#pragma mark - private

- (void)initData
{
    NSString *sunRiseTime = @"2018-02-12 07:12:00";  //日出时间
    NSString *sunSetTime = @"2018-02-12 17:46:00";   //日落时间
    NSString *currentTime = @"2018-02-12 15:11:05";  //当前时间（可以动态获取本地时间，为了演示，我写死一个数据）
    
    [self.sunView handleSunRiseAndSet:sunRiseTime sunSetTime:sunSetTime currentTime:currentTime];
}

#pragma mark - getter/setter

- (FTSunView *)sunView
{
    if(_sunView == nil)
    {
        _sunView = [[FTSunView alloc] initWithFrame:CGRectMake(0,200 , ScreenWidth, 300)];
    }
    
    return _sunView;
}


@end

















