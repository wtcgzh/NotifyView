//
//  TabBarViewController.m
//  HFLastDemo
//
//  Created by wangtc on 2019/3/22.
//  Copyright © 2019 wtc. All rights reserved.
//

#import "TabBarViewController.h"
#import "One/OneViewController.h"
#import "Two/TwoViewController.h"
#import "Three/ThreeViewController.h"

#import "NotifyView.h"

@interface TabBarViewController ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    OneViewController *one = [[OneViewController alloc] init];
    TwoViewController *two = [[TwoViewController alloc] init];
    ThreeViewController *three = [[ThreeViewController alloc] init];
    
    UINavigationController *navOne = [[UINavigationController alloc] initWithRootViewController:one];
    UINavigationController *navTwo = [[UINavigationController alloc] initWithRootViewController:two];
    UINavigationController *navThree = [[UINavigationController alloc] initWithRootViewController:three];
    
    navOne.title = @"首页";
    navTwo.title = @"详情";
    navThree.title = @"我的";
    
    NSArray *array = [NSArray arrayWithObjects:navOne, navTwo, navThree,nil];
    self.viewControllers = array;
    
    
    //模拟场景-打开
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(5.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        [self notifyView];
    });
    dispatch_resume(self.timer);
}

- (void)notifyView {
    [NotifyView showNotify:@"这是一条好消息啊！！！！！！" withTitle:@"消息标题"];
}

@end
