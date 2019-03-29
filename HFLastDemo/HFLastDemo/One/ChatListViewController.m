//
//  ChatListViewController.m
//  HengFu
//
//  Created by wangtc on 2019/3/18.
//  Copyright © 2019 wtc. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"

@interface ChatListViewController ()
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"跳转到聊天页面" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 340, 200, 50);
    btn2.backgroundColor = [UIColor redColor];
    btn2.tag = 666;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
- (void)btnClick:(UIButton *)sender {
    ChatViewController *vc = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
