//
//  AddImageCollectionViewCell.m
//  WeiXInShareDemo
//
//  Created by XuHuan on 16/7/21.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import "AddImageCollectionViewCell.h"
#import "UIImageView+EMWebCache.h"

static UIImage *deleteImage;
@interface AddImageCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;//**<  */
@property (strong, nonatomic) UIImageView *deleteImageView;
@property (strong, nonatomic) UIButton *deleteButton;
@property (copy, nonatomic) AddImageCellBlock deleteBlock;

@end

@implementation AddImageCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setCellSubView];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setCellSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setCellSubView];
    }
    return self;
}

- (void)setCellSubView {
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:self.imageView];
    //添加小图片
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    if (!deleteImage) {
        NSString *icon_path = [[NSBundle mainBundle] pathForResource:@"addImage_delete" ofType:@"png"];
        deleteImage = [UIImage imageWithContentsOfFile:icon_path];
    }
    UIImageView *deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width * 3 / 4 , 0, width / 4, width / 4)];
    deleteImageView.image = deleteImage;
    [self.contentView addSubview:deleteImageView];
    self.deleteImageView = deleteImageView;
    
    //添加删除按钮
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(width / 2, 0, width / 2, height / 2)];
    [self.contentView addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton = deleteButton;
}

- (void)setImageBy:(id)image {
    if ([image isKindOfClass:[UIImage class]]) {
        self.imageView.image = image;
    } else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:image]];
    }
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}


- (UIImage *)getCellImage {
    return self.imageView.image;
}

- (void)deleteButtonClicked:(UIButton *)button {
    self.deleteBlock(self.index);
}

- (void)hiddenDelete:(BOOL)hidden {
    self.deleteButton.hidden = hidden;
    self.deleteImageView.hidden = hidden;
}

- (void)setDeleteImageBlock:(AddImageCellBlock)deleteImage {
    self.deleteBlock = deleteImage;
}
@end
