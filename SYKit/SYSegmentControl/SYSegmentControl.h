//
//  SYSegmentControl.h
//  
//
//  Created by lzx on 16/4/12.
//
//

#import <UIKit/UIKit.h>

@interface SYSegmentControl : UIView



//选中分段的下标
@property(nonatomic, assign) NSUInteger selectedSegmentIndex;

//选中颜色
@property(nonatomic, strong) UIColor * selectedColor;
//正常状态颜色
@property(nonatomic, strong) UIColor *nomalColor;
//是否显示下面的线条
@property(nonatomic, assign) BOOL isShowLine;

//通过items去创建segmentControl对象
- (instancetype)initWithItems:(NSArray *)items;
//添加事件
- (void)addTarget:(id)target action:(SEL)action;

@end
