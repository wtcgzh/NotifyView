//
//  SecondViewController.m
//  HengFu
//
//  Created by wangtc on 2019/3/18.
//  Copyright © 2019 wtc. All rights reserved.
//

#import "SecondViewController.h"
#import "ChatListViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Second";
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"跳转到聊天列表" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 340, 200, 50);
    btn2.backgroundColor = [UIColor redColor];
    btn2.tag = 666;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)btnClick:(UIButton *)sender {
    ChatListViewController *vc = [[ChatListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
