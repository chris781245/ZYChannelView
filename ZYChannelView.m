//
//  ZYChannelView.m
//  Investank
//
//  Created by 史泽东 on 2019/1/11.
//  Copyright © 2019 史泽东. All rights reserved.
//

#import "ZYChannelView.h"
#import "ZYChannelButton.h"

@interface ZYChannelView ()

///按钮数组
@property (nonatomic ,strong) NSArray <ZYChannelButton *> *buttonArray;

///滚动条
@property (nonatomic ,strong) UIView *twigView;

///上一个选中Button
@property (nonatomic ,strong) ZYChannelButton *lastSelectedButton;

@end


@implementation ZYChannelView {
    UIColor *_twigViewColor;
}

// MARK: 属性有关
//颜色
- (UIColor *)normalColor {
    if (_normalColor == nil) {
        _normalColor = [UIColor groupTableViewBackgroundColor];
    }
    return _normalColor;
}

- (UIColor *)selectedColor {
    if (_selectedColor == nil) {
        _selectedColor = [UIColor darkTextColor];
    }
    return _selectedColor;
}

- (UIColor *)twigViewColor {
    if (_twigViewColor == nil) {
        _twigViewColor = self.selectedColor;
    }
    return _twigViewColor;
}

- (void)setTwigViewColor:(UIColor *)twigViewColor {
    _twigViewColor = twigViewColor;
    _twigView.backgroundColor = twigViewColor;
}

//字体
- (UIFont *)normalFont {
    if (_normalFont == nil) {
        _normalFont = [UIFont systemFontOfSize:15];
    }
    return _normalFont;
}

- (UIFont *)selectedFont {
    if (_selectedFont == nil) {
        _selectedFont = self.normalFont;
    }
    return _selectedFont;
}

- (UIView *)twigView {
    if (_twigView == nil) {
        _twigView = [UIView new];
        _twigView.backgroundColor = self.twigViewColor;
    }
    return _twigView;
}

- (void)setBtnTag:(NSInteger)btnTag {
    _btnTag = btnTag;
    if (btnTag > self.buttonArray.count - 1) {
        return;
    }
    [self selectedBtnWithTag:btnTag];
}

- (void)reloadData {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[ZYChannelButton class]]) {
            [subView removeFromSuperview];
        }
    }
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i  = 0; i < self.titleArray.count; i++) {
        ZYChannelButton *btn = [ZYChannelButton zy_ButtonWithTitle:self.titleArray[i] normalFont:self.normalFont selectedFont:self.selectedFont normalColor:self.normalColor selectedColor:self.selectedColor];
        btn.tag = i;
        [btn sizeToFit];
        [arrayM addObject:btn];
    }
    self.buttonArray = arrayM.copy;
}

// 计算SubView的frame
- (void)setButtonArray:(NSArray *)buttonArray {
    _buttonArray = buttonArray;
    if (buttonArray.count != 0) {
        CGFloat lastX = _intervalHeader;
        for (int i = 0; i < buttonArray.count; i++) {
            ZYChannelButton *btn = ((ZYChannelButton *)buttonArray[i]);
            [btn addTarget:self action:@selector(btnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {//初始化第一个btn的选中状态
                btn.selected = YES;
                self.lastSelectedButton = btn;
                self.btnTag = 0;
                if (!_twigView) {
                    [self addSubview:self.twigView];
                }
                [self updateTwigView];
            }
            [self addSubview:btn];
            //x
            CGFloat X = lastX;
            //y
            CGFloat Y = 0.0;
            //w
            CGFloat W = btn.frame.size.width;
            [self layoutIfNeeded];
            CGFloat H = self.bounds.size.height;
            btn.center = CGPointMake(X + W / 2, Y + H / 2);
            btn.bounds = CGRectMake(0, 0, W, H);
            lastX = X + W + self.intervalInLine;
        }
        //这个时候应该是没有height的.暂不做处理
        self.contentSize = CGSizeMake(lastX - self.intervalInLine + self.intervalFooter, self.bounds.size.height);
        [self scrollRectToVisible:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.chancelSelectedBlock) {
                self.chancelSelectedBlock(self.btnTag);
            }
        });
    } else {
        [self.twigView removeFromSuperview];
        self.twigView = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < _buttonArray.count; i++) {
        ZYChannelButton *btn = ((ZYChannelButton *)_buttonArray[i]);
        CGPoint center = btn.center;
        CGFloat height = self.bounds.size.height;
        [btn sizeToFit];
        CGFloat width = btn.bounds.size.width;
        btn.center = CGPointMake(center.x, center.y);
        btn.bounds = CGRectMake(0, 0, width, height);
        [self updateTwigView];
    }
}

- (void)setupUI {
    self.showsHorizontalScrollIndicator = 0;
    self.bounces = NO;
}

- (void)btnClickWithBtn:(ZYChannelButton *)btn {
    [self selectedBtnWithTag:btn.tag];
    if (self.chancelSelectedBlock) {
        self.chancelSelectedBlock(btn.tag);
    }
}

- (void)updateTwigView {
    CGFloat twigViewWidth;
    if (self.twigViewEqualToButtonWidth) {
        twigViewWidth = self.lastSelectedButton.bounds.size.width;
    } else {
        twigViewWidth = self.twigViewWidth;
    }
    if (self.twigViewHidden) {
        self.twigView.hidden = YES;
    } else {
        self.twigView.frame = CGRectMake(0, 0, twigViewWidth, self.twigViewHeight);
        self.twigView.center = CGPointMake(self.lastSelectedButton.center.x, self.bounds.size.height - self.twigViewHeight / 2);
        self.twigView.layer.cornerRadius = self.twigViewCornerRadius;
        self.twigView.layer.masksToBounds = YES;
        [self.twigView layoutIfNeeded];
    }
}

/**
 根据tag滚动twigView,以及选中Btn
 
 @param tag 按钮编号
 */
- (void)selectedBtnWithTag:(NSInteger)tag {
    //取出btn
    ZYChannelButton *btn = _buttonArray[tag];
    if (btn != _lastSelectedButton) {
        _lastSelectedButton.selected = !_lastSelectedButton.isSelected;
        btn.selected = !btn.isSelected;
        _lastSelectedButton = btn;
        CGPoint point = CGPointMake(btn.center.x, 0);
        if (point.x - btn.bounds.size.width / 2 - self.bounds.size.width / 2 + _intervalHeader <= 0) {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        } else if (point.x + btn.bounds.size.width / 2 + self.bounds.size.width / 2 + _intervalFooter >= self.contentSize.width) {
            if (self.contentSize.width <= self.bounds.size.width) {
                [self setContentOffset:CGPointMake(0, 0) animated:YES];
            } else {
                [self setContentOffset:CGPointMake(self.contentSize.width - self.bounds.size.width, 0) animated:YES];
            }
        } else {
            [self setContentOffset:CGPointMake(point.x - self.bounds.size.width / 2 , 0) animated:YES];
        }
        [UIView animateWithDuration:.25 animations:^{
            [self updateTwigView];
        }];
        [self layoutSubviews];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
