# RulerPicker

一个刻度尺类型的时间选择控件，可用于选择时间点

### 效果图：

![](/image/screenshot_1.png)

![](/image/screenshot_2.png)

![](/image/demo_screentshot.gif)


> 控件的**可定制度较高**，后续会慢慢优化

### 使用：

1 . 将 RulerPicker 目录下的 `VNBRluerPicker` 文件添加到你的工程中
2 . 在需要使用的地方 #import "VNBRluerPicker.h"
3 . 创建并显示：

```
VNBRluerPicker myRulerPicker = [[VNBRluerPicker alloc] initWithFrame:CGRectMake(10, 160, 300, 70) BigUnit:24 smallUnits:6];
myRulerPicker.rulerValue = @"12:00:00";
myRulerPicker.delegate = self;
myRulerPicker.triangleHeight = 5;
[myRulerPicker show];
[self.view addSubview:myRulerPicker];
```        

4 . VNBTimeRulerDelegate , 默认提供了 4 个代理方法，你可以根据自己的需求继续添加

```
- (void)rulerScrollViewWillBeginDragging:(VNBRluerPicker *)rulerPicker;
- (void)rulerScrollViewDidScroll:(VNBRluerPicker *)rulerPicker;
- (void)rulerScrollViewDidEndDecelerating:(VNBRluerPicker *)rulerPicker;
- (void)rulerScrollViewDidEndDragging:(VNBRluerPicker *)rulerPicker willDecelerate:(BOOL)decelerate;
```

### 自定义外观

留了很多的属性可以自定义，但是要记得操作顺序为先 `initWithFrame`，后设置各种需要自定义的属性，最后调用 `show` 方法


> 如果有任何疑问和建议，欢迎交流。
