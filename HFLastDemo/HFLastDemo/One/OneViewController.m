//
//  OneViewController.m
//  HFLastDemo
//
//  Created by wangtc on 2019/3/25.
//  Copyright © 2019 wtc. All rights reserved.
//

#import "OneViewController.h"
#import "SecondViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface OneViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
}
@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imagePickerController= [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = YES;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"跳转" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 240, 200, 50);
    btn2.backgroundColor = [UIColor redColor];
    btn2.tag = 666;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setTitle:@"打开相机" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(100, 340, 200, 50);
    btn3.backgroundColor = [UIColor redColor];
    btn3.tag = 6666;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setTitle:@"进入相册" forState:UIControlStateNormal];
    btn4.frame = CGRectMake(100, 440, 200, 50);
    btn4.backgroundColor = [UIColor redColor];
    btn4.tag = 66666;
    [btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}

- (void)btnClick:(UIButton *)sender {
    if (sender.tag == 66) {
        //默认一行代码调用
    } else if (sender.tag == 666) {
        SecondViewController *vc = [[SecondViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 6666) {
        //打开相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    } else if (sender.tag == 66666) {
        //进入相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }
}

#pragma mark -- UIImagePickerControllerDelegate
//拍照完成回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSLog(@"finish");
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//取消按钮时功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
