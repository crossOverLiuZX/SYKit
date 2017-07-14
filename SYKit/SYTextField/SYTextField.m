//
//  SYTextField.m
//  sss
//
//  Created by 刘卓鑫 on 2017/6/27.
//  Copyright © 2017年 刘卓鑫. All rights reserved.
//

#import "SYTextField.h"


@implementation SYTextField

//setter
- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    if (self.placeholder) {
        self.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName: self.placeHolderFont?self.placeHolderFont:(self.font?self.font:[UIFont systemFontOfSize:16]), NSForegroundColorAttributeName: self.placeHolderColor?self.placeHolderColor:[UIColor lightGrayColor]}];
    }
}
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    if (self.placeholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: self.placeHolderColor}];
    }
}
- (void)setPlaceHolderFont:(UIFont *)placeHolderFont {
    _placeHolderFont = placeHolderFont;
    if (self.placeholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: self.placeHolderFont}];
    }
}
/// 新的rect
static inline CGRect
CGRectInsetEdges(CGRect rect, UIEdgeInsets insets) {
    rect.origin.x += insets.left;
    rect.origin.y += insets.top;
    rect.size.width -= UIEdgeInsetsGetHorizontalValue(insets);
    rect.size.height -= UIEdgeInsetsGetVerticalValue(insets);
    return rect;
}
//UIEdgeInsets的垂直方向上的值
static inline CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}
//水平
static inline CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds = CGRectInsetEdges(bounds, UIEdgeInsetsMake(self.topPadding, self.leftPadding, self.bottomPadding, self.rightPadding));
    CGRect resultRect = [super textRectForBounds:bounds];
    return resultRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds = CGRectInsetEdges(bounds, UIEdgeInsetsMake(self.topPadding, self.leftPadding, self.bottomPadding, self.rightPadding));
    return [super editingRectForBounds:bounds];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self SYInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self SYInit];
    }
    return self;
}
//定制化的一些内容
- (void)SYInit {
    [self addTarget:self action:@selector(changeEdit:) forControlEvents:UIControlEventEditingChanged];
    
}
#pragma mark - 输入相关
- (void) changeEdit:(SYTextField *) field {
    
    if (self.limitMaxWordCount && field.text.length > self.limitMaxWordCount) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"文本限制为%ld位", self.limitMaxWordCount] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        field.text = [field.text substringToIndex:self.limitMaxWordCount];
        
    }
    
}
#pragma mark ----------------华丽分割线------------------
//验证输入的是否是某一整数范围
- (BOOL) verifyInputIsIntergerRangeOFMin:(NSInteger) min Max:(NSInteger) max valueText:(NSString *) valueText {
    NSString *phoneRegex = @"^\\d{7,}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:valueText];
}
//验证输入的是否是正整数
-(BOOL)verifyInputIsInteger:(NSString *)str {
    NSString *phoneRegex = @"^[1-9]\\d*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:str];
    
}
//验证输入是否是正小数
- (BOOL) verifyInputIsFloat:(NSString *) str {
    NSString *phoneRegex = @"^[0-9]+(.[0-9]{1,10})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:str];
}
//验证输入的是否是中文 数字 字母的组合
- (BOOL) verifyInputIsChineseAndNumberAndABC:(NSString *) str {
    NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:str];
}
//验证输入是否是电话号码
- (BOOL) verifyInputIsPhontNumber:(NSString *) mobileNum {
    /**
     
     * 手机号码
     
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     * 联通：130,131,132,152,155,156,185,186
     
     * 电信：133,1349,153,180,189
     
     */
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     
     10         * 中国移动：China Mobile
     
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     
     12         */
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    
    /**
     
     15         * 中国联通：China Unicom
     
     16         * 130,131,132,152,155,156,185,186
     
     17         */
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     
     20         * 中国电信：China Telecom
     
     21         * 133,1349,153,180,189
     
     22         */
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     
     25         * 大陆地区固话及小灵通
     
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     
     27         * 号码：七位或八位
     
     28         */
    
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    //    return [phoneTest evaluateWithObject:str];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSPredicate *regextestct_phs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       
       || ([regextestcu evaluateWithObject:mobileNum] == YES)
       || ([regextestct_phs evaluateWithObject:mobileNum] == YES)
       )
        
    {
        
        return YES;
        
    }
    
    else
        
    {
        
        return NO;
        
    }
}
//验证输入是否是身份证号
- (BOOL) verifyInputIsIdcard:(NSString *) value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([value length] != 18) {
        
        return NO;
        
    }
    
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    
    NSString *leapMmdd = @"0229";
    
    NSString *year = @"(19|20)[0-9]{2}";
    
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![regexTest evaluateWithObject:value]) {
        
        return NO;
        
    }
    
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    
    NSInteger remainder = summary % 11;
    
    NSString *checkBit = @"";
    
    NSString *checkString = @"10X98765432";
    
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
    
}

@end
