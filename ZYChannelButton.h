//
//  ZYChannelButton.h
//  Investank
//
//  Created by 史泽东 on 2019/1/11.
//  Copyright © 2019 史泽东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYChannelButton : UIButton

/**
 创建按钮方法
 
 @param str 按钮文字
 @param normalFont 按钮普通状态字体
 @param selectedFont 按钮选中状态字体
 @param normalColor 按钮普通状态颜色
 @param slectedColor 按钮选中状态颜色
 @return 按钮
 */
+ (instancetype)zy_ButtonWithTitle:(NSString *)str normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont normalColor:(UIColor *)normalColor selectedColor:(UIColor *)slectedColor;

@end

NS_ASSUME_NONNULL_END
