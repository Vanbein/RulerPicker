//
//  VNBRluerPicker.h
//  RulerPicker
//
//  Created by 王斌 on 16/9/12.
//  Copyright © 2016年 Vanbein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VNBRluerPicker;

@protocol VNBTimeRulerDelegate <NSObject>

- (void)rulerScrollViewWillBeginDragging:(VNBRluerPicker *)rulerPicker;
- (void)rulerScrollViewDidScroll:(VNBRluerPicker *)rulerPicker;
- (void)rulerScrollViewDidEndDecelerating:(VNBRluerPicker *)rulerPicker;
- (void)rulerScrollViewDidEndDragging:(VNBRluerPicker *)rulerPicker willDecelerate:(BOOL)decelerate;

@end

@interface VNBRluerPicker : UIView



@property (nonatomic, assign) id <VNBTimeRulerDelegate> delegate;

/**
 *  中间指示器顶部闭合三角形高度，默认 0
 */
@property (nonatomic) float triangleHeight;

/**
 *  中间指示器距顶部距离，默认 8
 */
@property (nonatomic) float indicatorPadTop;

/**
 *  中间指示器距底部距离，默认 8
 */
@property (nonatomic) float indicatorPadBottom;
/**
 *  中间指示器颜色，默认 #f76720
 */
@property (nonatomic) CGColorRef indicatorColor;

/**
 *  是否四舍五入后重新调整 offest，默认 NO
 */
@property (nonatomic, getter=isRoundingEnabled) BOOL roundingEnabled;

/**
 *  是否有两侧的渐变效果，默认为 YES
 */
@property (nonatomic, getter=isGradientEnabled) BOOL gradientEnabled;


/**
 *  标尺两条刻度线的间距，默认 16
 */
@property (nonatomic) CGFloat lineSpacing;

/**
 *  标尺刻度线隔上下的距离、上下间距一样，默认 8
 */
@property (nonatomic) CGFloat linePadTopBottom;

/**
 *  标尺刻度线大刻度的线条高度，默认 6
 */
@property (nonatomic) CGFloat mainLineHeight;

/**
 *  标尺刻度线大刻度线的颜色， 默认 #999999
 */
@property (nonatomic) CGColorRef mainLineColor;

/**
 *  标尺刻度线小刻度线的颜色，默认 #d9d9d9
 */
@property (nonatomic) CGColorRef secondaryLineColor;


/**
 *  标尺小刻度线正中位置的刻度线高度、默认和大刻度线高度同高、只是颜色不一样，默认 6
 */
@property (nonatomic) CGFloat secondaryLineMidHeight;

/**
 *  标尺刻度线小刻度线的高度，默认 4
 */
@property (nonatomic) CGFloat secondaryLineNormalHeight;

/**
 *  多少个大刻度单位，默认为 24 ，即一整天有 24 个小时
 */
@property (nonatomic) NSUInteger numberOfBigUnit;

/**
 *  一个大刻度包含多少个小刻度，默认为 6 。（即每个小时均分为 6 段，每段 10 分钟）
 */
@property (nonatomic) NSUInteger numberOfSmallUnit;

/**
 *  精确度，默认 = valueOfSmallUnit = 10，为 10 分钟，即刻度尺的 value 最小改变量，必须不大于 valueOfSmallUnit
 */
//@property (nonatomic) CGFloat accuracy;

/**
 *  刻度尺宽度，默认 300
 */
@property (nonatomic) NSUInteger rulerWidth;

/**
 *  刻度尺高度，默认 70
 */
@property (nonatomic) NSUInteger rulerHeight;

/**
 *  获取刻度尺当前的值，即多少个最小刻度
 */
@property (nonatomic) CGFloat unitValue;

/**
 *  获取刻度线当前的值，默认为一个时间点，其格式为 HH:mm:ss
 */
@property (nonatomic, copy) NSString *rulerValue;

/**
 *  初始化刻度尺
 *
 *  @param frame      frame
 *  @param bigUnits   大刻度数量
 *  @param smallUnits 小刻度数量
 *  @param value      刻度尺默认的值
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame BigUnit:(NSUInteger)bigUnits smallUnits:(NSUInteger)smallUnits;

/**
 *  显示，必须要先初始化、再设置属性、最后才显示
 */
- (void)showTimeRulerView;

/**
 *  设置 UnitValue 值，并将 rulerView 移到对应的 offest
 *
 *  @param value 目标值
 */
- (void)seekToUnitValue:(CGFloat)unitValue;


/**
 *  设置 RulerValue 值，并将 rulerView 移到对应的 offest
 *
 *  @param value 目标值
 */
- (void)seekToRulerValue:(NSString *)rulerValue;



@end


/*****************************************/
/**********  VNBRulerScrollView **********/
/*****************************************/

@interface VNBRulerScrollView : UIScrollView


// 标尺两条刻度线的间距
@property (nonatomic) CGFloat lineSpacing;

// 标尺刻度线隔上下的距离、上下间距一样
@property (nonatomic) CGFloat linePadTopBottom;

// 标尺刻度线大刻度的线条高度
@property (nonatomic) CGFloat mainLineHeight;

// 标尺刻度线大刻度线的颜色
@property (nonatomic) CGColorRef mainLineColor;

// 标尺刻度线小刻度线的颜色
@property (nonatomic) CGColorRef secondaryLineColor;

// 标尺小刻度线正中位置的刻度线高度、默认和大刻度线高度同高、只是颜色不一样
@property (nonatomic) CGFloat secondaryLineMidHeight;

// 标尺刻度线小刻度线的高度
@property (nonatomic) CGFloat secondaryLineNormalHeight;

// 多少个大刻度单位，默认为 24 ，即一整天有 24 个小时
@property (nonatomic) NSUInteger numberOfBigUnit;

// 一个大刻度包含多少个小刻度，默认为 6 。（即每个小时均分为 6 段，每段 10 分钟）
@property (nonatomic) NSUInteger numberOfSmallUnit;

// 总共有多少条刻度线，= numberOfBigUnit * numberOfSmallUnit
@property (nonatomic) NSUInteger numberOfGraduatedLines;

// 精确度，每一个小刻度间隔表示多大的数值，默认 10 分钟。（即每个大刻度是 1 小时，其有 6 个小刻度，每个小刻度为 10 分钟）
@property (nonatomic) CGFloat valueOfSmallUnit;

// 精确度，默认 = valueOfSmallUnit ，为 10 分钟，即刻度尺的 value 最小改变量，必须不大于 valueOfSmallUnit
//@property (nonatomic) CGFloat accuracy;

// 刻度尺宽度，
@property (nonatomic) NSUInteger rulerWidth;

// 刻度尺高度
@property (nonatomic) NSUInteger rulerHeight;

// 刻度尺当前的值，默认单位为分钟，表示多少分钟
@property (nonatomic) CGFloat unitValue;

// 刻度线当前的值，默认为一个时间点：HH:mm:ss
@property (nonatomic, copy) NSString *rulerValue;

/**
 *  绘制刻度线
 */
- (void)drawRulerGraduatedLine;


@end

