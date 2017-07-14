//
//  UIView+SYView.h
//  
//
//  Created by LiuZX on 16/4/12.
//
//

#import <UIKit/UIKit.h>


//动画类型的宏
typedef enum : NSUInteger {
    SY_PageCurl,     //向上翻一页
    SY_PageUnCurl,   //向下翻一页
    SY_RippleEffect, //滴水效果
    SY_SuckEffect,   //收缩效果，如一块布被抽走
    SY_Cube,         //立方体效果
    SY_OglFlip,      //上下翻转效果
    SY_Fade,          //交叉淡化过渡
    SY_MoveIn,       //新视图移到旧视图上面
    SY_Push,          //新视图把旧视图推出去
    SY_Reveal        //将旧视图移开,显示下面的新视图
    
} SYTransitionType;


//动画方向
typedef enum : NSUInteger {
    SY_UP,
    SY_DOWN,
    SY_LEFT,
    SY_RIGHT
} SYTransitionDirection;


@interface UIView(SYView)
//声明需要添加的方法
- (void)addTransitionAnimationWithDurection:(NSTimeInterval)durection anitionType:(SYTransitionType)type direction:(SYTransitionDirection)direction;

@end
