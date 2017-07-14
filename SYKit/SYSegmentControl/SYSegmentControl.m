//
//  SYSegmentControl.m
//  
//
//  Created by lzx on 16/4/12.
//
//

#import "SYSegmentControl.h"

#define BUTTON_Tag 100

@interface SYSegmentControl()


//每个分段的title
@property(nonatomic, strong) NSArray * items;

@end

@implementation SYSegmentControl{
    //效应消息的对象
    id _target;
    //消息
    SEL _action;
    
    //滑块
    UIView * _sliderView;
}

#pragma mark - 通过items创建初始化分段选择器
- (instancetype)initWithItems:(NSArray *)items{

    if (self = [super init]) {
        
        //给items属性赋值
        _items = items;
        
        //=========做一些初始化工作=========
        //默认的选中颜色
        _selectedColor = [UIColor redColor];
        
        _nomalColor = [UIColor blackColor];
        
        _isShowLine = NO;
        
    }
    
    return self;
}




#pragma mark - 重写选中下标的set方法
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex{

    _selectedSegmentIndex = selectedSegmentIndex;
    
    //将选中下标对应的按钮变成选中状态
    UIButton * btn = (UIButton *)[self viewWithTag:_selectedSegmentIndex + BUTTON_Tag];
    //设置成选中状态
    btn.selected = YES;
    //关闭用户交互
    btn.userInteractionEnabled = NO;
    
    //改变滑块的中心点
    [UIView animateWithDuration:0.3f animations:^{
        
        _sliderView.center = CGPointMake(btn.center.x, self.frame.size.height - _sliderView.frame.size.height/2.0f);
    }];
    
    
    
}

#pragma mark - 创建按钮
//通过items去创建按钮
- (void)createButton{
    
    //====================创建按钮=====================
    //宽度
    CGFloat W = self.frame.size.width / _items.count;
    //高度
    CGFloat H = self.frame.size.height;
    //Y坐标
    CGFloat Y = 0;

    //遍历items创建对应的按钮
    int  i = 0;
    for (NSString * title in _items) {
        
        //X坐标
        CGFloat X = i * W;
        
        //1.创建按钮并且设置frame
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        
        //2.设置按钮文字
        [button setTitle:title forState:UIControlStateNormal];
        
        //3.设置按钮文字颜色
        //正常状态
        [button setTitleColor:_nomalColor forState:UIControlStateNormal];
        
        //选中状态
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
        
        //5.添加按钮点击事件
        [button addTarget:self action:@selector(onclicked:) forControlEvents:UIControlEventTouchDown];
        
        
        //设置tag
        button.tag = i + BUTTON_Tag;
        
        //4.显示在界面上
        [self addSubview:button];

        i++;
    }
    
    //=================创建滑块==================
    CGFloat SW = W * 0.8;
    CGFloat SH = 5;
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SW, SH)];
    _sliderView.backgroundColor = _selectedColor;
    [self addSubview:_sliderView];
    
    //===============创建底部的线================

    
    CGFloat LH = 1.5;
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, H - LH, self.frame.size.width, LH)];
    line.backgroundColor = _selectedColor;
    [self addSubview:line];
    
    //根据是否严重线条的属性来确定是否要隐藏线条
    if (_isShowLine) {
        line.hidden = NO;
    } else {
        line.hidden = YES;
    }
    
    
}

#pragma mark - 按钮点击
- (void)onclicked:(UIButton *)button{



    //通过选中下标拿到当前选中的按钮
    UIButton * selectedBtn = (UIButton *)[self viewWithTag:_selectedSegmentIndex + BUTTON_Tag];
    //将之前选中的变成非选中状态
    selectedBtn.selected = NO;
    //让按钮可以点击
    selectedBtn.userInteractionEnabled = YES;
    

    self.selectedSegmentIndex = button.tag - BUTTON_Tag;
    
    
    //选中下标的值发生改变，让响应消息的对象去响应消息
    //先判断事件对应的方法有没有实现
    if ([_target respondsToSelector:_action]) {
        
        [_target performSelector:_action withObject:self];

    }else{
    
        NSLog(@"警告:事件方法没有实现");
    }
    
    
}

#pragma mark - 添加事件
- (void)addTarget:(id)target action:(SEL)action{

    _target = target;
    _action = action;
    
}


- (void)layoutSubviews{

    [self createButton];
    
    //设置选中下标
    self.selectedSegmentIndex = _selectedSegmentIndex;
    
    
}


@end
