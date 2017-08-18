//
//  AddImageCollectionView.h
//  WeiXInShareDemo
//
//  Created by XuHuan on 16/7/21.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddImageCollectionView;

typedef void(^AddImageBlock)(AddImageCollectionView *add,NSInteger index);

typedef enum : NSUInteger {
    AddImageAddButounTypeHead,
    AddImageAddButounTypeTrail
} AddImageAddButounType;



@interface AddImageCollectionView : UICollectionView

@property (weak, nonatomic) UIViewController *theViewController;//用于弹出图片选择controller
@property (strong, nonatomic) UIImage *addIcon;//添加按钮图片
@property (assign, nonatomic) NSInteger maxCount;//图片最大数
@property (assign, nonatomic) NSInteger numberOfLine;//每行个数
@property (assign, nonatomic) float interval;//间隔
@property (assign, nonatomic) AddImageAddButounType addButtonType;//添加图片按钮位置
@property (assign, nonatomic) NSInteger type;//0,编辑模式 other 非编辑模式


- (void)setActions:(AddImageBlock)finishAddImage shooseImage:(AddImageBlock)chooseImage;
- (void)setActionRemoveWebImage:(AddImageBlock)will;

//获取图片
- (NSArray *)getAllImagas;

//删除图片
- (void)removeImageAtIndex:(NSInteger) index;

- (void)setImages:(NSArray *)images;

@end
