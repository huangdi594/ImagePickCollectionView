//
//  XHActionSheet.m
//  WeiXInShareDemo
//
//  Created by XuHuan on 16/7/22.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import "XHActionSheet.h"


#define SHEETCOLOR(r, g, b) [UIColor colorWithRed: r/255.f green: g/255.f blue: b/255.f alpha: 1]
#define BUTTONMAGIN 10   // 按钮间距
#define BUTTONHEIGHT 45 // 按钮高度
#define SHEETWIDTH [UIScreen mainScreen].bounds.size.width
#define SEPERATE_LINE SHEETCOLOR(204, 211, 216)
#define CANCLEBUTTONTAG 1991
#define NORMALBUTTONTAG 2016

@interface XHActionSheet ()

@property (strong, nonatomic) UIView *actionSheetView;//**< 弹出框 */
@property (strong, nonatomic) UIButton *cancleButton;//**< 取消按钮 */
@property (assign, nonatomic) XHActionSheetViewType type;

@end

@implementation XHActionSheet

- (instancetype)initWithTitle:(NSString *)title cancleButtonTitle:(NSString *)cancleTitle otherButtonTitles:(NSArray *)others type:(XHActionSheetViewType)type{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.type = type;
        //背景设置
        CATransition *backTransition = [[CATransition alloc] init];
        backTransition.duration = 0.3;
        backTransition.type = kCATransitionReveal;
        [self.layer addAnimation:backTransition forKey:nil];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        [self setSubViewCanleTtilte:cancleTitle ohtersTitle:others];
    }
    return self;
}

- (void)setSubViewCanleTtilte:(NSString *)cancleTitle ohtersTitle:(NSArray *)others {
    //设置弹出层
    self.actionSheetView = [[UIView alloc] init];
    self.actionSheetView.backgroundColor = SEPERATE_LINE;
    CATransition *sheetTransition = [[CATransition alloc] init];
    sheetTransition.duration = 0.2;
    sheetTransition.type = kCATransitionPush;
    sheetTransition.subtype = kCATransitionFromTop;
    [self.actionSheetView.layer addAnimation:sheetTransition forKey:nil];
    [self addSubview:self.actionSheetView];
    CGFloat actionSheetHeight;
    CGFloat cancleButtonX;
    CGFloat cancleButtonY;
    CGFloat buttonWidht = SHEETWIDTH;
    
    if (self.type == XHActionSheetViewTypeEqualSeparete) {
        actionSheetHeight = others.count * (BUTTONHEIGHT + BUTTONMAGIN) + BUTTONHEIGHT + BUTTONMAGIN * 2;
        cancleButtonX = BUTTONMAGIN;
        cancleButtonY = actionSheetHeight - BUTTONHEIGHT - BUTTONMAGIN;
        buttonWidht = SHEETWIDTH - 20;
    } else {
        actionSheetHeight = others.count * BUTTONHEIGHT + 20 + BUTTONHEIGHT;
        cancleButtonX = 0;
        cancleButtonY = actionSheetHeight - BUTTONHEIGHT;
        
    }
    //设置弹出层
    self.actionSheetView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - actionSheetHeight, SHEETWIDTH, actionSheetHeight);
    //设置取消按钮
    self.cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(cancleButtonX,cancleButtonY, buttonWidht, BUTTONHEIGHT)];
    self.cancleButton.backgroundColor = [UIColor whiteColor];
    [self.cancleButton setTitle:cancleTitle forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleButton.tag = CANCLEBUTTONTAG;
    [self.actionSheetView addSubview:self.cancleButton];
    if (self.type == XHActionSheetViewTypeEqualSeparete) {
        self.cancleButton.layer.cornerRadius = 5.0;
        [self.cancleButton.layer masksToBounds];
    }
    //设置其他按钮
    for (int i = 0; i < others.count; i++) {
        CGFloat normalButtonY;
        if (self.type == XHActionSheetViewTypeEqualSeparete) {
            normalButtonY = i * (BUTTONHEIGHT + BUTTONMAGIN) + BUTTONMAGIN;
        } else {
            normalButtonY = i * BUTTONHEIGHT;
        }
        UIButton *normalBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancleButtonX, normalButtonY, buttonWidht, BUTTONHEIGHT - 1)];
        normalBtn.backgroundColor = [UIColor whiteColor];
        [normalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [normalBtn setTitle:others[i] forState:UIControlStateNormal];
        [normalBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        normalBtn.tag = NORMALBUTTONTAG + i;
        if (self.type == XHActionSheetViewTypeEqualSeparete) {
            normalBtn.layer.cornerRadius = 5.0;
            [normalBtn.layer masksToBounds];
        }
        [self.actionSheetView addSubview:normalBtn];
    }
}

- (void)setCancleButtonTitleColor:(UIColor *)color {
    [self.cancleButton setTitleColor:color forState:UIControlStateNormal];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)hide
{
    [UIView animateWithDuration: 0.2 animations:^{
        CGRect rect = self.actionSheetView.frame;
        rect.origin.y += rect.size.height;
        self.actionSheetView.frame = rect;
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)buttonClicked:(UIButton *)sender {
    [self hide];
    if (sender.tag > CANCLEBUTTONTAG && [self.delegate respondsToSelector:@selector(xhActionSheet:clickedButtonAtIndex:)]) {
        [self.delegate xhActionSheet:self clickedButtonAtIndex:sender.tag - NORMALBUTTONTAG];
    }
    
}

@end
