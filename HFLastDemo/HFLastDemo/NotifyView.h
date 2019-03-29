//
//  NotifyView.h
//  HengFu
//
//  Created by wangtc on 2019/3/15.
//  Copyright © 2019 wtc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface NotifyView : UIView

/*
 *显示通知
 *@param content 消息内容
 *@param title 标题消息
 */

+ (void)showNotify:(NSString *)content withTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
