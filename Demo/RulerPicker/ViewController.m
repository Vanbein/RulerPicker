//
//  ViewController.m
//  RulerPicker
//
//  Created by 王斌 on 16/9/12.
//  Copyright © 2016年 Vanbein. All rights reserved.
//

#import "ViewController.h"
#import "VNBRluerPicker.h"
#import "Masonry.h"

#define kTopRulerPickerTag 1000
#define kBottomRulerPickerTag 1001


@interface ViewController ()<VNBTimeRulerDelegate>

@property (nonatomic, strong) UILabel *topRulerLabel;
@property (nonatomic, strong) UILabel *topUnitLabel;
@property (nonatomic, strong) VNBRluerPicker *topRulerPicker;

@property (nonatomic, strong) UILabel *bottomrulerLabel;
@property (nonatomic, strong) UILabel *bottomUnitLabel;
@property (nonatomic, strong) VNBRluerPicker *bottomRoundingRulerPicker;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RulerPicker";
    
    [self configureSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configuer Subviews

- (void)configureSubviews{
    
    UILabel *rulerTitle = [[UILabel alloc] init];
    [self.view addSubview:rulerTitle];
    [rulerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [rulerTitle setFont:[UIFont systemFontOfSize:14.0]];
    [rulerTitle setTextAlignment:NSTextAlignmentCenter];
    [rulerTitle setText:@"ruler vlaue :"];
//    rulerTitle.backgroundColor = [UIColor orangeColor];
    
    self.topRulerLabel = [[UILabel alloc] init];
    [self.view addSubview:self.topRulerLabel];
    [self.topRulerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rulerTitle.mas_right).mas_offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(rulerTitle.mas_centerY);
    }];
    [self.topRulerLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.topRulerLabel setTextAlignment:NSTextAlignmentCenter];
//    self.rulerLabel.backgroundColor = [UIColor orangeColor];

    UILabel *unitTitle = [[UILabel alloc] init];
    [self.view addSubview:unitTitle];
    [unitTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(rulerTitle.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [unitTitle setFont:[UIFont systemFontOfSize:14.0]];
    [unitTitle setTextAlignment:NSTextAlignmentCenter];
    [unitTitle setText:@"unit vlaue :"];
//    unitTitle.backgroundColor = [UIColor orangeColor];
    
    self.topUnitLabel = [[UILabel alloc] init];
    [self.view addSubview:self.topUnitLabel];
    [self.topUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(unitTitle.mas_right).mas_offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(unitTitle.mas_centerY);
    }];
    [self.topUnitLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.topUnitLabel setTextAlignment:NSTextAlignmentCenter];
    
    // 上半方的 RulerPicker
    self.topRulerPicker = [[VNBRluerPicker alloc] initWithFrame:CGRectMake(10, 160, 300, 70) BigUnit:24 smallUnits:6];
    self.topRulerPicker.rulerValue = @"12:00:00";
    self.topRulerPicker.delegate = self;
//    self.topRulerPicker.triangleHeight = 5;
//    self.topRulerPicker.numberOfSmallUnit = 4;
    [self.topRulerPicker showTimeRulerView];
    [self.view addSubview:self.topRulerPicker];
    self.topRulerPicker.tag = kTopRulerPickerTag;
    [self.topRulerPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unitTitle.mas_bottom).mas_offset(30.0);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(70);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
 
    // 下半部分
    UILabel *bottomrulerTitle = [[UILabel alloc] init];
    [self.view addSubview:bottomrulerTitle];
    [bottomrulerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.topRulerPicker.mas_bottom).mas_offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [bottomrulerTitle setFont:[UIFont systemFontOfSize:14.0]];
    [bottomrulerTitle setTextAlignment:NSTextAlignmentCenter];
    [bottomrulerTitle setText:@"ruler vlaue :"];

    self.bottomrulerLabel = [[UILabel alloc] init];
    [self.view addSubview:self.bottomrulerLabel];
    [self.bottomrulerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomrulerTitle.mas_right).mas_offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(bottomrulerTitle.mas_centerY);
    }];
    [self.bottomrulerLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.bottomrulerLabel setTextAlignment:NSTextAlignmentCenter];

    UILabel *bottomUnitTitle = [[UILabel alloc] init];
    [self.view addSubview:bottomUnitTitle];
    [bottomUnitTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(bottomrulerTitle.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [bottomUnitTitle setFont:[UIFont systemFontOfSize:14.0]];
    [bottomUnitTitle setTextAlignment:NSTextAlignmentCenter];
    [bottomUnitTitle setText:@"unit vlaue :"];
    
    self.bottomUnitLabel = [[UILabel alloc] init];
    [self.view addSubview:self.bottomUnitLabel];
    [self.bottomUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomUnitTitle.mas_right).mas_offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(bottomUnitTitle.mas_centerY);
    }];
    [self.bottomUnitLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.bottomUnitLabel setTextAlignment:NSTextAlignmentCenter];

    self.bottomRoundingRulerPicker = [[VNBRluerPicker alloc] initWithFrame:CGRectMake(10, 320, 300, 70) BigUnit:24 smallUnits:6];
    [self.view addSubview:self.bottomRoundingRulerPicker];
    [self.bottomRoundingRulerPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomUnitTitle.mas_bottom).mas_offset(30.0);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(70);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    self.bottomRoundingRulerPicker.roundingEnabled = YES;
    self.bottomRoundingRulerPicker.rulerValue = @"12:00:00";
    self.bottomRoundingRulerPicker.delegate = self;
    [self.bottomRoundingRulerPicker showTimeRulerView];
    self.bottomRoundingRulerPicker.tag = kBottomRulerPickerTag;
}

#pragma mark - VNBTimeRulerDelegate
- (void)rulerScrollViewWillBeginDragging:(VNBRluerPicker *)rulerPicker{
    NSLog(@" %s ", __FUNCTION__);
}

- (void)rulerScrollViewDidScroll:(VNBRluerPicker *)rulerPicker{
//    NSLog(@" %s ", __FUNCTION__);
    NSLog(@"rulerScrollView.tag : %ld",(long)rulerPicker.tag);
    if ([rulerPicker isEqual:self.topRulerPicker]) {
        self.topRulerLabel.text = rulerPicker.rulerValue;
        self.topUnitLabel.text = [NSString stringWithFormat:@"%f", rulerPicker.unitValue];
        return;
    }
    self.bottomrulerLabel.text = rulerPicker.rulerValue;
    self.bottomUnitLabel.text = [NSString stringWithFormat:@"%f", rulerPicker.unitValue];

}

- (void)rulerScrollViewDidEndDecelerating:(VNBRluerPicker *)rulerPicker{
    NSLog(@" %s ", __FUNCTION__);

}

- (void)rulerScrollViewDidEndDragging:(VNBRluerPicker *)rulerPicker willDecelerate:(BOOL)decelerate{
    NSLog(@" %s ", __FUNCTION__);
}


@end
