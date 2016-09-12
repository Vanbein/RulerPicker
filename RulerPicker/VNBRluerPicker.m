//
//  VNBRluerPicker.m
//  RulerPicker
//
//  Created by 王斌 on 16/9/12.
//  Copyright © 2016年 Vanbein. All rights reserved.
//

#import "VNBRluerPicker.h"

/*****  默认值 *****/
// 中间指示器顶部闭合三角形默认高度
#define kTriangle_Height_Default 0
// 中间指示器距离顶部默认距离
#define kIndicator_Pad_Top_Default 8
// 中间指示器距离底部默认距离
#define kIndicator_Pad_Bottom_Default 8
// 中间指示器默认颜色
#define kIndicator_Color_Default [UIColor redColor].CGColor
// 标尺刻度线两个刻度线的间距
#define kGraduated_Line_Spacing_Default 16
// 标尺刻度线隔上下的距离、上下间距一样
#define kGraduated_Line_Pad_Top_Bottom_Default 8
// 标尺刻度线大刻度线的高度
#define kGraduated_Main_Line_Height_Default 6
// 标尺小刻度线正中位置的刻度线高度
#define kGraduated_Secondary_Line_Mid_Height_Default 6
// 标尺刻度线小刻度线的高度
#define kGraduated_Secondary_Line_Normal_Height_Default 4
// 标尺刻度线大刻度线的颜色
#define kGraduated_Main_Line_Color_Default [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0].CGColor;
// 标尺刻度线小刻度线的颜色
#define kGraduated_Secondary_Line_Color_Default [UIColor colorWithRed:0.8163 green:0.8162 blue:0.8162 alpha:1.0].CGColor;
// 默认高度
#define kHeight_Delfault 70.0
// 默认宽度
#define kWidth_Delfault 300.0


@interface VNBRluerPicker ()<UIScrollViewDelegate>{
    
    CAShapeLayer *shapeLayerLine;
    CAGradientLayer *gradient;
}

/**
 *  总共有多少条刻度线，= numberOfBigUnit * numberOfSmallUnit，默认 144
 */
@property (nonatomic) NSUInteger numberOfGraduatedLines;

@property (nonatomic, strong) VNBRulerScrollView *rulerScrollView;

/**
 *  精确度，每一个小刻度间隔表示多大的数值，默认 10 分钟。（即每个大刻度是 1 小时，其有 6 个小刻度，每个小刻度为 10 分钟）
 */
@property (nonatomic) CGFloat valueOfSmallUnit;


@end

@implementation VNBRluerPicker


#pragma mark - Init self

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 设置初始值
        [self commonInitProperty];
        _rulerHeight = kHeight_Delfault;
        _rulerWidth = kWidth_Delfault;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 设置初始值
        [self commonInitProperty];
        _rulerHeight = frame.size.height;
        _rulerWidth = frame.size.width;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame BigUnit:(NSUInteger)bigUnits smallUnits:(NSUInteger)smallUnits{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 设置初始值
        [self commonInitProperty];
        _rulerHeight = frame.size.height;
        _rulerWidth = frame.size.width;
        _numberOfBigUnit = bigUnits;
        _numberOfSmallUnit = smallUnits;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    _rulerHeight = frame.size.height;
    _rulerWidth = frame.size.width;
    UIEdgeInsets edge = UIEdgeInsetsMake(0, _rulerWidth / 2.0 - 0, 0, _rulerWidth / 2.0);
    _rulerScrollView.frame = CGRectMake(0, 0, _rulerWidth, _rulerHeight);
    _rulerScrollView.contentInset = edge;
    _rulerScrollView.rulerHeight = _rulerHeight;
    _rulerScrollView.rulerWidth = _rulerWidth;
    //    _rulerScrollView.contentSize = CGSizeMake(_rulerScrollView.numberOfGraduatedLines * _lineSpacing, _rulerScrollView.rulerHeight);
    [super setFrame:frame];
    [self drawRacAndLine];
}

#pragma mark - Init Subviews & property

/**
 *  配置 RulerScrollView
 */
- (VNBRulerScrollView *)configureRulerScrollView {
    
    VNBRulerScrollView *rulerScrollView = [[VNBRulerScrollView alloc] init];
    rulerScrollView.delegate = self;
    rulerScrollView.showsHorizontalScrollIndicator = NO;
    rulerScrollView.showsVerticalScrollIndicator = NO;
    
    // 设置初始值、
    rulerScrollView.lineSpacing               = self.lineSpacing;
    rulerScrollView.linePadTopBottom          = self.linePadTopBottom;
    rulerScrollView.mainLineColor             = self.mainLineColor;
    rulerScrollView.mainLineHeight            = self.mainLineHeight;
    rulerScrollView.secondaryLineColor        = self.secondaryLineColor;
    rulerScrollView.secondaryLineMidHeight    = self.secondaryLineMidHeight;
    rulerScrollView.secondaryLineNormalHeight = self.secondaryLineNormalHeight;
    rulerScrollView.numberOfBigUnit          = self.numberOfBigUnit;
    rulerScrollView.numberOfSmallUnit         = self.numberOfSmallUnit;
    rulerScrollView.valueOfSmallUnit          = self.valueOfSmallUnit;
//    rulerScrollView.accuracy                  = _accuracy;
    rulerScrollView.numberOfGraduatedLines    = self.numberOfGraduatedLines;
    rulerScrollView.rulerHeight               = self.rulerHeight;
    rulerScrollView.rulerWidth                = self.rulerWidth;
    rulerScrollView.rulerValue                = self.rulerValue;
    rulerScrollView.unitValue                 = self.unitValue;
    return rulerScrollView;
}

/**
 *  渐变效果、中间的指示器
 */
- (void)drawRacAndLine {
    
    [shapeLayerLine removeFromSuperlayer];
    [gradient removeFromSuperlayer];
    
    /***** 渐变 *****/
    if (self.isGradientEnabled) {
        gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor,
                            (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,
                            (id)[[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor];
        gradient.locations = @[[NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:0.5f]];
        gradient.startPoint = CGPointMake(0, 0.3);
        gradient.endPoint = CGPointMake(1.0, 0.3);
        [self.layer addSublayer:gradient];
    }
    
    /***** 中间指示器 *****/
    shapeLayerLine = [CAShapeLayer layer];
    shapeLayerLine.strokeColor = _indicatorColor; // 指示器颜色
    shapeLayerLine.fillColor = _indicatorColor; //三角颜色
    shapeLayerLine.lineWidth = 1.f;
    shapeLayerLine.lineCap = kCALineCapSquare;
    CGMutablePathRef pathLine = CGPathCreateMutable();
    // 底部起点
    CGPathMoveToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height - _indicatorPadBottom);
    // 顶部终点
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, _indicatorPadTop + _triangleHeight);
    //三角右边位置点
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 - _triangleHeight / 2, _indicatorPadTop);
    //三角左边位置点
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 + _triangleHeight / 2, _indicatorPadTop);
    //回到顶部终点
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, _indicatorPadTop + _triangleHeight);
    shapeLayerLine.path = pathLine;
    [self.layer addSublayer:shapeLayerLine];
}

/**
 *  初始化所有的属性值
 */
- (void)commonInitProperty{
    
    _triangleHeight            = kTriangle_Height_Default;
    _indicatorPadTop           = kIndicator_Pad_Top_Default;
    _indicatorPadBottom        = kIndicator_Pad_Bottom_Default;
    _indicatorColor            = kIndicator_Color_Default;
    _lineSpacing               = kGraduated_Line_Spacing_Default;
    _linePadTopBottom          = kGraduated_Line_Pad_Top_Bottom_Default;
    _mainLineColor             = kGraduated_Main_Line_Color_Default;
    _mainLineHeight            = kGraduated_Main_Line_Height_Default;
    _secondaryLineColor        = kGraduated_Secondary_Line_Color_Default;
    _secondaryLineMidHeight    = kGraduated_Secondary_Line_Mid_Height_Default;
    _secondaryLineNormalHeight = kGraduated_Secondary_Line_Normal_Height_Default;
    _roundingEnabled           = NO;
    _gradientEnabled           = YES;
    _numberOfBigUnit           = 24;
    _numberOfSmallUnit         = 6;
    _valueOfSmallUnit          = 10;
//    _accuracy                  = _valueOfSmallUnit;
    _numberOfGraduatedLines    = _numberOfBigUnit * _numberOfSmallUnit;
    _unitValue = 0;
    _rulerValue = @"00:00:00";
}

#pragma mark - Show RulerScrollView Method


- (void)showTimeRulerView{
    // 配置 rulerScrollView
    _rulerScrollView = [self configureRulerScrollView];
    // 开始绘制刻度线
    [_rulerScrollView drawRulerGraduatedLine];
    [self addSubview:_rulerScrollView];
    [self drawRacAndLine];
}

#pragma mark - Seek To Offest

/**
 *  移到某个值对应位置
 */
- (void)seekToUnitValue:(CGFloat)unitValue{
    
    self.rulerScrollView.contentOffset = CGPointMake(_lineSpacing * (unitValue / _valueOfSmallUnit) - self.rulerWidth / 2.f, 0);
}

/**
 *  移到某个时间点对应位置
 */
- (void)seekToRulerValue:(NSString *)rulerValue{
    
    NSArray *dateArray = [rulerValue componentsSeparatedByString:@":"];
    NSInteger hour = [dateArray[0] integerValue];
    NSInteger minute = [dateArray[1] integerValue];
    NSInteger second = [dateArray[2] integerValue];
    
    float minuteNumber = hour * 60.0 + minute + second/60.0;
    float offest_x = _lineSpacing * (minuteNumber / _valueOfSmallUnit) - self.rulerWidth / 2.0;
    
    self.rulerScrollView.contentOffset = CGPointMake(offest_x, 0);
}


#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(VNBRulerScrollView *)rulerScrollView{
    
    if ([self.delegate respondsToSelector:@selector(rulerScrollViewWillBeginDragging:)]) {
        [self.delegate rulerScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidScroll:(VNBRulerScrollView *)scrollView {
    
    CGFloat offSetX = scrollView.contentOffset.x + self.rulerWidth / 2 - 0;
    
    //    NSLog(@" offSetX : %f ",offSetX);
    
    // 移动了多少个刻度线
    float numberOfUnit = offSetX / _lineSpacing;
    
    CGFloat realUnitValue = numberOfUnit * _valueOfSmallUnit;
    if (realUnitValue < 0.f) {
        return;
    } else if (realUnitValue > _numberOfGraduatedLines * _valueOfSmallUnit) {
        return;
    }
    //    NSLog(@"realUnitValue old : %f",realUnitValue);
    if (self.isRoundingEnabled) {
        if ([self valueIsInteger:[NSNumber numberWithFloat:_valueOfSmallUnit]]) {
            
            if (_valueOfSmallUnit == 10) {
                // 针对精确度为 10 分钟做特殊处理
                realUnitValue = [self notRounding:realUnitValue/10 afterPoint:0];
                realUnitValue = realUnitValue * 10;
            } else {
                realUnitValue = [self notRounding:realUnitValue afterPoint:0];
            }
        }
        else {
            realUnitValue = [self notRounding:realUnitValue afterPoint:1];
        }
        //        NSLog(@"ruleValue new : %f",ruleValue);
    }
    
    NSString *tmpRulerValue = [self getTimeBySmallUnitOffest:realUnitValue];
    self.rulerValue = tmpRulerValue;
    self.unitValue = realUnitValue;
    
    if ([self.delegate respondsToSelector:@selector(rulerScrollViewDidScroll:)]) {
        scrollView.rulerValue = tmpRulerValue;
        scrollView.unitValue = realUnitValue;
        [self.delegate rulerScrollViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDecelerating:(VNBRulerScrollView *)scrollView {
    [self animationSetOffest:scrollView];
    if ([self.delegate respondsToSelector:@selector(rulerScrollViewDidEndDecelerating:)]) {
        [self.delegate rulerScrollViewDidEndDecelerating:self];
    }
    
}

- (void)scrollViewDidEndDragging:(VNBRulerScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self animationSetOffest:scrollView];
    if ([self.delegate respondsToSelector:@selector(rulerScrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate rulerScrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

/**
 *  根据最后的位置重新调整 offest，
 */
- (void)animationSetOffest:(VNBRulerScrollView *)scrollView {
    
    if (!self.isRoundingEnabled) {
        return;
    }

//    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 ;
//    CGFloat rulerEndValue = (offSetX / _lineSpacing) * _valueOfSmallUnit;
    
//    if ([self valueIsInteger:[NSNumber numberWithFloat:_valueOfSmallUnit]]) {
//        if (_valueOfSmallUnit == 10) {
//            // 针对精确度为 10 分钟做特殊处理
//            rulerEndValue = [self notRounding:rulerEndValue/10 afterPoint:0];
//            rulerEndValue = rulerEndValue * 10;
//        } else {
//            rulerEndValue = [self notRounding:rulerEndValue afterPoint:0];
//        }
//    } else {
//        rulerEndValue = [self notRounding:rulerEndValue afterPoint:1];
//    }
//    CGFloat realOffestX = (rulerEndValue / _valueOfSmallUnit) * _lineSpacing - self.frame.size.width / 2;
    // scrollViewDidScroll: 已经做过处理了，直接使用 unitValue 
    CGFloat realOffestX = (scrollView.unitValue / _valueOfSmallUnit) * _lineSpacing - self.frame.size.width / 2;
    [UIView animateWithDuration:0.2f animations:^{
        scrollView.contentOffset = CGPointMake(realOffestX, 0);
    }];
    
}

#pragma mark - Set Method

- (void)setNumberOfSmallUnit:(NSUInteger)numberOfSmallUnit{
    _numberOfSmallUnit = numberOfSmallUnit;
    if (numberOfSmallUnit <= 0) {
        _valueOfSmallUnit = 60.0;
        _numberOfGraduatedLines = _numberOfBigUnit;
        return;
    }
    _valueOfSmallUnit = 60.0 / numberOfSmallUnit;
    _numberOfGraduatedLines = _numberOfBigUnit * _numberOfSmallUnit;
}

- (void)setNumberOfBigUnit:(NSUInteger)numberOfBigUnit{
    _numberOfBigUnit = numberOfBigUnit;
    if (numberOfBigUnit <= 0) {
        // 恢复默认值
        _numberOfBigUnit = 24;
        _numberOfSmallUnit = 6;
        _numberOfGraduatedLines = _numberOfBigUnit * _numberOfSmallUnit;
        _valueOfSmallUnit = 60.0 / _numberOfSmallUnit;
    }
    _numberOfGraduatedLines = _numberOfBigUnit * _numberOfSmallUnit;
}

- (void)setLineSpacing:(CGFloat)lineSpacing{
    _lineSpacing = lineSpacing;
    if (lineSpacing <= 0) {
        _lineSpacing = kGraduated_Line_Spacing_Default;
    }
}


#pragma mark - Tool method

/**
 *  四舍五入，转化为整型刻度值
 */
- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * ouncesDecimal;
    NSDecimalNumber * roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces floatValue];
}

/**
 *  判断是否为整型
 *  根据小数点后是否全部为0进行判断
 */
- (BOOL)valueIsInteger:(NSNumber *)number {
    NSString *value = [NSString stringWithFormat:@"%f",[number floatValue]];
    if (value != nil) {
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *temp = nil;
        for(int i =0; i < [valueEnd length]; i++)
        {
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}

/**
 *  根据偏移值获取对应的日期
 */
- (NSString *)getTimeBySmallUnitOffest:(CGFloat)unitOffest{
    
    float secondPoint = unitOffest - (NSInteger)unitOffest;
    NSInteger hour = unitOffest / 60;
    NSInteger minute = (NSInteger)unitOffest % 60;
    NSInteger second = (NSInteger)(secondPoint * 60);
    
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
    return time;
}

@end


/*****************************************/
/**********  VNBRulerScrollView **********/
/*****************************************/

@implementation VNBRulerScrollView


#pragma mark - Set Method

- (void)setRulerValue:(NSString *)rulerValue{
    NSLog(@"rulerValue : %@",rulerValue);
    _rulerValue = rulerValue;
}

- (void)setUnitValue:(CGFloat)unitValue{
    _unitValue = unitValue;
}

#pragma mark - Draw Ruler Lines

- (void)drawRulerGraduatedLine{
    
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    // 主刻度
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = _mainLineColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 1.f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    // 次级刻度
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = _secondaryLineColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 1.f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    for (int i = 0; i <= _numberOfGraduatedLines; i++) {
        
        if (i % _numberOfSmallUnit == 0) {
            
            // 大刻度线
            UILabel *rule = [[UILabel alloc] init];
            rule.textColor = [UIColor blackColor];
            [rule setFont:[UIFont systemFontOfSize:13.0]];
            rule.text = [NSString stringWithFormat:@"%02d:00",i/6];
            CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
            
            // 顶部刻度线
            CGPathMoveToPoint(pathRef1, NULL, 0 + _lineSpacing * i , _linePadTopBottom);
            CGPathAddLineToPoint(pathRef1, NULL, 0 + _lineSpacing * i, _linePadTopBottom + _mainLineHeight);
            
            // 底部刻度线
            CGPathMoveToPoint(pathRef1, NULL, 0 + _lineSpacing * i , self.rulerHeight -_linePadTopBottom );
            CGPathAddLineToPoint(pathRef1, NULL, 0 + _lineSpacing * i, self.rulerHeight - (_linePadTopBottom + _mainLineHeight));
            
            //  中间的时间点 text
            rule.frame = CGRectMake(0 + _lineSpacing * i - textSize.width / 2, (self.rulerHeight - textSize.height)/2.0, 0, 0);
            [rule sizeToFit];
            [self addSubview:rule];
            
        } else if (_numberOfSmallUnit % 2 == 0 && _numberOfSmallUnit > 0 && (i % _numberOfSmallUnit == _numberOfSmallUnit/2)) {
            // 小刻度的正中间位置刻度线
            // 顶部刻度线
            CGPathMoveToPoint(pathRef2, NULL, 0 + _lineSpacing * i , _linePadTopBottom);
            CGPathAddLineToPoint(pathRef2, NULL, 0 + _lineSpacing * i, _linePadTopBottom + _secondaryLineMidHeight);
            
            // 底部刻度线
            CGPathMoveToPoint(pathRef2, NULL, 0 + _lineSpacing * i , self.rulerHeight -_linePadTopBottom );
            CGPathAddLineToPoint(pathRef2, NULL, 0 + _lineSpacing * i, self.rulerHeight - (_linePadTopBottom + _secondaryLineMidHeight));
        } else {
            // 普通小刻度线
            // 顶部刻度线
            CGPathMoveToPoint(pathRef2, NULL, 0 + _lineSpacing * i , _linePadTopBottom );
            CGPathAddLineToPoint(pathRef2, NULL, 0 + _lineSpacing * i, _linePadTopBottom + _secondaryLineNormalHeight);
            
            // 底部刻度线
            CGPathMoveToPoint(pathRef2, NULL, 0 + _lineSpacing * i , self.rulerHeight -_linePadTopBottom );
            CGPathAddLineToPoint(pathRef2, NULL, 0 + _lineSpacing * i, self.rulerHeight - (_linePadTopBottom + _secondaryLineNormalHeight));
        }
    }
    
    shapeLayer1.path = pathRef1;
    shapeLayer2.path = pathRef2;
    
    [self.layer addSublayer:shapeLayer1];
    [self.layer addSublayer:shapeLayer2];
    
    self.frame = CGRectMake(0, 0, self.rulerWidth, self.rulerHeight);
    
    // 设置初始偏移值
    float defaultOffest = 0;
    if (self.rulerValue) {
        NSArray *array = [self.rulerValue componentsSeparatedByString:@":"];
        NSInteger hour = [array[0] integerValue];
        NSInteger minute = [array[1] integerValue];
        NSInteger second = [array[2] integerValue];
        
        defaultOffest = hour * 60 + minute + second/60;
    }
    if (self.unitValue > 0) {
        defaultOffest = self.unitValue;
    }
    // 设置刻度尺两端的空白，由于此处会出发 scrollView 的 scrollViewDidScroll: 方法，故需要先保存默认的偏移值
    UIEdgeInsets edge = UIEdgeInsetsMake(0, self.rulerWidth / 2.0 - 0, 0, self.rulerWidth / 2.0 - 0);
    self.contentInset = edge;
    self.contentOffset = CGPointMake(_lineSpacing * (defaultOffest / _valueOfSmallUnit) - self.rulerWidth / 2.f, 0);
    self.contentSize = CGSizeMake(self.numberOfGraduatedLines * _lineSpacing, self.rulerHeight);
}



@end













