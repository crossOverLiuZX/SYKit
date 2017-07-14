//
//  SYLabel.m
//
//
//  Created by 刘卓鑫 on 2017/4/5.
//  Copyright © 2017年 刘卓鑫. All rights reserved.
//

#import "SYLabel.h"
//设置内边距+自适应需要限制行1 并打开adjust。。。
@implementation SYLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
