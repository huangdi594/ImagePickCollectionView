//
//  XHActionSheet.h
//  WeiXInShareDemo
//
//  Created by XuHuan on 16/7/22.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, XHActionSheetViewType) {
    XHActionSheetViewTypeDefault = 0,
    XHActionSheetViewTypeEqualSeparete, //等间距分隔线

};





@class XHActionSheet;

@protocol XHActionSheetDelegate <NSObject>

@optional
/*
 * @brief 按钮点击事件
 * 按钮点击的时候，提示框自动消失
 */
- (void)xhActionSheet:(nonnull XHActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index;

@end


@interface XHActionSheet : UIView
///代理
@property (nullable, nonatomic, assign) id<XHActionSheetDelegate>delegate;

/*
 * 初始化方法
 * @brief 初始的时候指定标题以及按钮
 * @param title 暂时无效传nil
 * @param others传入一个数组，数组内容为NSString
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title cancleButtonTitle:(nonnull NSString *)cancleTitle otherButtonTitles:(nonnull NSArray *)others type:(XHActionSheetViewType)type;
/*
 *设置取消按钮颜色
 */
- (void)setCancleButtonTitleColor:(nonnull UIColor *)color;

- (void)show;

@end
