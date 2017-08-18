//
//  AddImageCollectionView.m
//  WeiXInShareDemo
//
//  Created by XuHuan on 16/7/21.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import "AddImageCollectionView.h"
#import "AddImageCollectionViewCell.h"
#import "XHImagePicker.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+EMWebCache.h"

#define IMAGE_MAX_SIZE_5k 5120*2880

static NSString * CellIdentifier = @"GradientCell";

@interface AddImageCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *imageArr;//**<  */
@property (copy, nonatomic) AddImageBlock finishAddImage;
@property (copy, nonatomic) AddImageBlock chooseImage;
@property (copy, nonatomic) AddImageBlock removeWebImageBlock;
@property (nonatomic,strong) NSMutableArray *webImages;

@property (nonatomic,strong) NSMutableArray *allImages;

@property (strong, nonatomic) UINavigationController *photoNavigationController;
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) NSMutableArray *photos;

@end


static float add_cell_width = 0;
@implementation AddImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setDefoultValue];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefoultValue];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefoultValue];
    }
    return self;
}

- (void)setDefoultValue {
    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [self registerClass:[AddImageCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self setDelegates];
    
    self.maxCount = 9;
    self.numberOfLine = 4;
    self.interval = 10;
    NSString *icon_path = [[NSBundle mainBundle] pathForResource:@"addImage_takePhoto" ofType:@"png"];
    self.addIcon = [UIImage imageWithContentsOfFile:icon_path];
//    self.addIcon = [UIImage imageNamed:@"tjcy_icon"];
    self.addButtonType = AddImageAddButounTypeTrail;
    self.scrollEnabled = NO;
}

- (void)setDelegates {
    self.dataSource = self;
    self.delegate = self;
}

- (void)setActions:(AddImageBlock)finishAddImage shooseImage:(AddImageBlock)chooseImage {
    self.finishAddImage = finishAddImage;
    self.chooseImage = chooseImage;
}

- (void)setActionRemoveWebImage:(AddImageBlock)will {
    self.removeWebImageBlock = will;
}

//获取图片
- (NSArray *)getAllImagas {
    if (!self.imageArr) {
        return @[];
    }
    return self.imageArr;
}

//移除图片
- (void)removeImageAtIndex:(NSInteger)index {
    if (self.allImages.count > index) {
        //删除本地图片
        if (index >= self.webImages.count) {
            NSInteger newIndex = index - self.webImages.count;
            [self.imageArr removeObjectAtIndex:newIndex];
            [self.allImages removeObjectAtIndex:index];
        } else {
        //删除webImage
            [self.webImages removeObjectAtIndex:index];
            [self.allImages removeObjectAtIndex:index];
            self.removeWebImageBlock(self,index);
        }
        [self reloadData];
        //图片数量变化
        if (self.finishAddImage) {
            self.finishAddImage(self,self.allImages.count);
        }
    }
}

- (void)setImages:(NSArray *)images {
    self.webImages = [NSMutableArray arrayWithArray:images];
    [self.allImages removeAllObjects];
    [self.allImages addObjectsFromArray:images];
    [self.allImages addObjectsFromArray:self.imageArr];
    [self reloadData];
    if (self.finishAddImage) {
        self.finishAddImage(self,self.allImages.count);
    }
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.type == 0) {
        return self.allImages.count == self.maxCount ? self.allImages.count : self.allImages.count + 1;
    } else {
        return self.allImages.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger addButtonIndex = self.allImages.count;
    NSInteger normalButtonIndex = indexPath.row;
    if (self.addButtonType == AddImageAddButounTypeHead) {
        //添加图片按钮在前
        addButtonIndex = 0;
        normalButtonIndex--;
    } else {
        //添加图片按钮在后
    }
    if (indexPath.row == addButtonIndex) {
        cell.image = self.addIcon;
        [cell hiddenDelete:YES];
    } else {
        [cell setImageBy:self.allImages[normalButtonIndex]];
        cell.index = normalButtonIndex;
        [cell hiddenDelete:NO];
        //cell删除按钮点击事件
        __block AddImageCollectionView *weekSelf = self;
        [cell setDeleteImageBlock:^(NSInteger index) {
            [weekSelf removeImageAtIndex:index];
        }];
    }
    
    //非编辑模式
    if (self.type != 0) {
        [cell hiddenDelete:YES];
    }
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (add_cell_width == 0) {
        float width = (self.bounds.size.width - (self.interval * (self.numberOfLine - 1))) / self.numberOfLine;
        add_cell_width = MIN(width, self.bounds.size.height);
        
        //跟新 numberofline
        self.numberOfLine =  self.bounds.size.width / (add_cell_width + self.interval);
        
    }
    return CGSizeMake(add_cell_width, add_cell_width);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger addButtonIndex = self.allImages.count;
    NSInteger normalButtonIndex = indexPath.row;
    if (self.addButtonType == AddImageAddButounTypeHead) {
        //添加图片按钮在前
        addButtonIndex = 0;
        normalButtonIndex--;
    } else {
        //添加图片按钮在后
    }
    
    
    __block AddImageCollectionView *weekSelf = self;
    if (indexPath.row == addButtonIndex) {//选择图片
        [XHImagePicker showImagePickerFromViewController:self.theViewController allowsVideo:NO maxCount:self.maxCount - self.allImages.count finishAction:^(NSArray *imageArr) {
            //获取图片刷新collectionView
            [weekSelf.imageArr addObjectsFromArray:imageArr];
            [weekSelf.allImages addObjectsFromArray:imageArr];
            [weekSelf reloadData];
            //告诉代理修改界面效果
            if (weekSelf.finishAddImage) {
                weekSelf.finishAddImage(weekSelf,weekSelf.allImages.count);
            }
            
        }];
    } else {
        //选中图片
        if (weekSelf.chooseImage) {
            weekSelf.chooseImage(weekSelf,normalButtonIndex);
        }
        if (self.type != 0) {
            //非编辑模式点击放大
            NSString *imagePath = self.webImages[indexPath.row];

            [self showBrowserWithImages:@[[NSURL URLWithString:imagePath]]];
        }
    }
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

- (NSMutableArray *)allImages {
    if (!_allImages) {
        _allImages = [[NSMutableArray alloc] init];
    }
    return _allImages;
}
- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

#pragma mark - showImage

- (void)showBrowserWithImages:(NSArray *)imageArray
{
    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                CGFloat imageSize = ((UIImage*)object).size.width * ((UIImage*)object).size.height;
                if (imageSize > IMAGE_MAX_SIZE_5k) {
                    photo = [MWPhoto photoWithImage:[self scaleImage:object toScale:(IMAGE_MAX_SIZE_5k)/imageSize]];
                } else {
                    photo = [MWPhoto photoWithImage:object];
                }
            }
            else if ([object isKindOfClass:[NSURL class]])
            {
                photo = [MWPhoto photoWithURL:object];
            }
            else if ([object isKindOfClass:[NSString class]])
            {
                
            }
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}
@end
