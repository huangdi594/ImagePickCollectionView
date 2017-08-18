//
//  AddImageCollectionViewCell.h
//  WeiXInShareDemo
//
//  Created by XuHuan on 16/7/21.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddImageCellBlock)(NSInteger index);

@interface AddImageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *image;//**<  */
@property (assign, nonatomic) NSInteger index;
- (void)hiddenDelete:(BOOL) hidden;
- (void)setDeleteImageBlock:(AddImageCellBlock)deleteImage;
- (void)setImageBy:(id)image;

- (UIImage *)getCellImage;
@end
