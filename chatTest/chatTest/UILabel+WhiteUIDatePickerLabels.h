//
//  UILabel+WhiteUIDatePickerLabels.h
//  chatTest
//
//  Created by Simin Liu on 5/21/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//  UIDatePicker custmize 设置

#import <UIKit/UIKit.h>

@interface UILabel (WhiteUIDatePickerLabels)
+ (void)load;
-(void) swizzledSetTextColor:(UIColor *)textColor;
- (void) swizzledWillMoveToSuperview:(UIView *)newSuperview;
@end
