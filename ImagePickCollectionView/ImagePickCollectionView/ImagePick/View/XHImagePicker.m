//
//  XHImagePicker.m
//  WeiXInShareDemo
//
//  Created by XuHuan on 16/7/21.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import "XHImagePicker.h"
#import "XHActionSheet.h"
#import "ELCImagePickerHeader.h"

@interface XHImagePicker ()<XHActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) UIViewController *viewController;
@property (assign, nonatomic)NSInteger maxCount;
@property (nonatomic, copy) XHImagePickerFilishAction finishAction;
@property (assign, nonatomic) BOOL allowsVideo;

@end

static XHImagePicker *imagePicke;

@implementation XHImagePicker

+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                              allowsVideo:(BOOL)allowsVideo
                                 maxCount:(NSInteger)maxCount
                             finishAction:(XHImagePickerFilishAction)finishAction {
    if (!imagePicke) {
        imagePicke = [[XHImagePicker alloc] init];
    }
    [imagePicke showImagePickerFromViewController:viewController allowsVideo:allowsVideo maxCount:(NSInteger)maxCount finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController
                              allowsVideo:(BOOL)allowsVideo
                                 maxCount:(NSInteger)maxCount
                             finishAction:(XHImagePickerFilishAction)finishAction {
    self.viewController = viewController;
    self.finishAction = finishAction;
    self.allowsVideo = allowsVideo;
    self.maxCount = maxCount;
    [self show];
}

- (void)show {
    XHActionSheet *actionSheet;
    if (self.allowsVideo) {
        actionSheet = [[XHActionSheet alloc] initWithTitle:nil cancleButtonTitle:@"取消" otherButtonTitles:@[@"小视频",@"拍照",@"从相册选择"] type:XHActionSheetViewTypeDefault];
    } else {
        actionSheet = [[XHActionSheet alloc] initWithTitle:nil cancleButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从相册选择"] type:XHActionSheetViewTypeDefault];
        [actionSheet setCancleButtonTitleColor:[UIColor blueColor]];
    }
    actionSheet.delegate = self;
    [actionSheet show];
}

#pragma mark - XHActionSheetDelegate 
- (void)xhActionSheet:(XHActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index {
    if (!self.allowsVideo) {
        index ++;
    }
    
    switch (index) {
        case 0://小视屏
            
            break;
        case 1://拍照
            [self takePhoto];
            break;
        default://从相册选择
        {
            // Create the image picker
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = self.maxCount; //Set the maximum number of images to select, defaults to 4
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
            elcPicker.imagePickerDelegate = self;
            //Present modally
            [[self getPresentedViewController] presentViewController:elcPicker animated:YES completion:nil];
        }
            break;
    }
}

- (void)takePhoto
{
    UIImagePickerControllerSourceType sourcType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = sourcType;
        [[self getPresentedViewController] presentViewController:picker animated:YES completion:^{
            
        }];
    
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);{
    NSArray *imageArr = @[image];
    self.finishAction(imageArr);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSArray *imageArr = [info mutableArrayValueForKey:@"UIImagePickerControllerOriginalImage"];
    self.finishAction(imageArr);
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

@end
