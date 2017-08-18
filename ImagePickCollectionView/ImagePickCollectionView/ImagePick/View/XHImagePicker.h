//
//  XHImagePicker.h
//  WeiXInShareDemo
//
//  Created by XuHuan on 16/7/21.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XHImagePicker : NSObject

typedef void (^XHImagePickerFilishAction)(NSArray *imageArr);

/**
 @param viewController  用于present UIImagePickerController对象
 @param allowsVideo     是否允包含video获取 
 @param maxCount        最大图片数量，当allowsVideo为yes时，该参数无效
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                              allowsVideo:(BOOL)allowsVideo
                                 maxCount:(NSInteger)maxCount
                             finishAction:(XHImagePickerFilishAction)finishAction;

@end
