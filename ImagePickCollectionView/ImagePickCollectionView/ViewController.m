//
//  ViewController.m
//  ImagePickCollectionView
//
//  Created by XuHuan on 2017/8/18.
//  Copyright © 2017年 KingYon. All rights reserved.
//

#import "ViewController.h"
#import "AddImageCollectionView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AddImageCollectionView *add;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _add.type = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
