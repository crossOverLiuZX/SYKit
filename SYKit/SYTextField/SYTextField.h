//
//  SYTextField.h
//  sss
//
//  Created by 刘卓鑫 on 2017/6/27.
//  Copyright © 2017年 刘卓鑫. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface SYTextField : UITextField

/**
 * 距离左边的间距
 */
@property (nonatomic, assign) CGFloat leftPadding;
/**
 * 距离右边的间距
 */
@property (nonatomic, assign) CGFloat rightPadding;
/**
 * 距离顶部的间距
 */
@property (nonatomic, assign) CGFloat topPadding;
/*
 * 底部的间距
 */
@property (nonatomic, assign) CGFloat bottomPadding;
/**
 * 占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeHolderColor;
/**
 * 占位文字字体
 */
@property (nonatomic, strong) UIFont *placeHolderFont;

/**
 * 限制文字数 不设置就不限制
 */
@property (nonatomic, assign) NSInteger limitMaxWordCount;





@end
