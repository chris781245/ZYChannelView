//
//  ZYChannelButton.m
//  Investank
//
//  Created by 史泽东 on 2019/1/11.
//  Copyright © 2019 史泽东. All rights reserved.
//

#import "ZYChannelButton.h"

@interface ZYChannelButton ()

/// 普通状态字体
@property (nonatomic ,strong) UIFont *normalFont;

/// 选中状态字体
@property (nonatomic ,strong) UIFont *selectedFont;

@end

@implementation ZYChannelButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = self.selectedFont;
    } else {
        self.titleLabel.font = self.normalFont;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

+ (instancetype)zy_ButtonWithTitle:(NSString *)str normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont normalColor:(UIColor *)normalColor selectedColor:(UIColor *)slectedColor {
    ZYChannelButton *btn = [[self alloc] init];
    //初始化
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = normalFont;
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:slectedColor forState:UIControlStateSelected];
    btn.normalFont = normalFont;
    btn.selectedFont = selectedFont;
    return btn;
}

@end
