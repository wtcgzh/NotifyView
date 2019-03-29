//
//  NotifyView.m
//  HengFu
//
//  Created by wangtc on 2019/3/15.
//  Copyright © 2019 wtc. All rights reserved.
//

#import "NotifyView.h"

#define notifyViewWaitDuration 1.0f;
#define viewAppearDuration 0.5f;
#define viewDisappearDuration 0.3f;

@interface NotifyView()<CAAnimationDelegate>

@property (nonatomic, strong) UIView *shadowView;   //父view，处理shadow
@property (nonatomic, strong) UILabel *textLabel;   //文字label
@property (nonatomic, strong) UIImageView *image;   //头像
@property (nonatomic, strong) UILabel *nameLabel;   //商户
@property (nonatomic, strong) UILabel *nowLabel;    //现在label
@property (nonatomic, strong) UIView *replyView;    //回复view
@property (nonatomic, strong) UILabel *replyLabel;  //回复label

@property (nonatomic, strong) NSString *notify;     //content
@property (nonatomic, strong) NSString *title;      //title
@property (nonatomic, assign) NSInteger count;

@end

@implementation NotifyView

+ (instancetype)sharedInstance {
    static NotifyView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NotifyView alloc] init];
    });
    return instance;
}

+ (void)showNotify:(NSString *)content withTitle:(NSString *)title {
    [[NotifyView sharedInstance] showNotify:content withTitle:title] ;
}

- (void)showNotify:(NSString *)string withTitle:(NSString *)title{
    //因为业务逻辑的原因，我们可能需要屏蔽某些页面，即在聊天页面或聊天列表页不弹出横幅消息
    Class nn = NSClassFromString(@"ChatViewController");
    Class hh = NSClassFromString(@"ChatListViewController");
    UIViewController *vc = [self currentViewController];
    if ([vc isKindOfClass:nn] || [vc isKindOfClass:hh]) {
        NSLog(@"聊天列表和聊天回话vc需要被禁");
        self.hidden = YES;
        return;
    }
    
    self.notify = string;
    self.title = title;
    
    [self initNotifyUI];
    [self initNotifyAnimation];
}

#pragma mark -- 初始化UI
- (void)initNotifyUI {
    while (self.subviews.count) {
        UIView *childView = self.subviews.lastObject;
        [childView removeFromSuperview];
    }
    
    self.hidden = NO;
    self.layer.shadowColor = [self colorWithHexString:@"3E3E3E"].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 6;
    
    CGFloat mainViewX = 0;
    CGFloat mainViewY = 0;
    CGFloat mainViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat mainViewH = 115 + EMALL_STATUS_BAR_HEIGHT - 20;
    self.frame = CGRectMake(mainViewX, mainViewY, mainViewW, mainViewH);
    
    //添加点击事件
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGR];
    [self setUserInteractionEnabled:YES];
    
    //初始化子控件
    [self initSubViewsUI];
    
    //只切bottom圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_shadowView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _shadowView.bounds;
    maskLayer.path = maskPath.CGPath;
    _shadowView.layer.mask = maskLayer;
    
    //覆盖statusBar,remove时要还原
    static UIWindow *newWindow;
    if (newWindow == nil) {
        newWindow = [[UIWindow alloc] initWithFrame:self.bounds];
    }
    // 大于UIWindowLevelStatusBar将会显示在statusBar的前面，后面隐藏的时候，需要将此值改为小于UIWindowLevelNormal
    newWindow.windowLevel = UIWindowLevelStatusBar + 100;
    [newWindow addSubview:self];
    [newWindow makeKeyAndVisible];
}

//横幅点击事件
- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    //对于模态类视图和相机相册等，点击横幅时需要先将其移除，不做跳转处理；
    //对于导航视图需要做跳转处理；
    //对于跳转可以用代理，e也可以用其他方法，这些就自己实现吧；
    UIViewController *vc = [self currentViewController];
    if ([vc isKindOfClass:[UIImagePickerController class]] || vc.presentedViewController) {
        NSLog(@"模态视图或相机相册");
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
    //防止点击多次，故点击一次就让横幅关闭；
    [self removeNoiifyViewFromSuperview];
}

- (void)initSubViewsUI {
    //处理阴影
    _shadowView = [[UIView alloc] initWithFrame:self.frame];
    _shadowView.backgroundColor = [self colorWithHexString:@"F6F6F6"];
    [self addSubview:_shadowView];
    
    //头像
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15 + EMALL_STATUS_BAR_HEIGHT - 20, 20, 20)];
    _image.image = [UIImage imageNamed:@"titleHeadImage"];
    [_shadowView addSubview:_image];
    
    //商户名
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 15.5 + EMALL_STATUS_BAR_HEIGHT - 20, 200, 18.5)];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [self colorWithHexString:@"666666"];
    _nameLabel.text = self.title;
    [_shadowView addSubview:_nameLabel];
    
    //现在
    _nowLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 30 - 18.5, 17.5 + EMALL_STATUS_BAR_HEIGHT - 20, 30, 18.5)];
    _nowLabel.font = [UIFont systemFontOfSize:13];
    _nowLabel.textColor = [self colorWithHexString:@"666666"];
    _nowLabel.text = @"现在";
    [_shadowView addSubview:_nowLabel];
    
    //消息
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45 + EMALL_STATUS_BAR_HEIGHT - 20, KScreenWidth - 30, 20)];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [self colorWithHexString:@"333333"];
    _textLabel.text = self.notify;
    
    _textLabel.numberOfLines = 1;
    [_shadowView addSubview:_textLabel];
    
    //回复
    _replyView = [[UIView alloc] initWithFrame:CGRectMake(15, 70 + EMALL_STATUS_BAR_HEIGHT - 20, KScreenWidth - 30, 30)];
    _replyView.backgroundColor = [self colorWithHexString:@"FFFFFF"];
    _replyView.layer.cornerRadius = 5;
    _replyView.layer.masksToBounds = YES;
    [_shadowView addSubview:_replyView];
    
    _replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 60, 20)];
    _replyLabel.font = [UIFont systemFontOfSize:14];
    _replyLabel.textColor = [self colorWithHexString:@"999999"];
    _replyLabel.text = @"回复TA";
    [_replyView addSubview:_replyLabel];
}

#pragma mark -- 初始化动画
- (void)initNotifyAnimation {
    CGPoint fromPoint = self.center;
    fromPoint.y = -self.frame.size.height;
    CGPoint oldPoint = self.center;
    
    CFTimeInterval settlingDuratoin = 0.f;
    
    CABasicAnimation *fillAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    fillAnim.fromValue = [NSValue valueWithCGPoint:fromPoint];
    fillAnim.toValue = [NSValue valueWithCGPoint:oldPoint];
    fillAnim.removedOnCompletion = NO;
    fillAnim.fillMode = kCAFillModeForwards;
    fillAnim.duration = viewAppearDuration;
    [self.layer addAnimation:fillAnim forKey:nil];
    
    settlingDuratoin = 0.5;
    
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnim.duration = viewDisappearDuration;
    basicAnim.beginTime = CACurrentMediaTime() + settlingDuratoin + notifyViewWaitDuration;
    
    basicAnim.fromValue = [NSValue valueWithCGPoint:oldPoint];
    basicAnim.toValue = [NSValue valueWithCGPoint:fromPoint];
    basicAnim.removedOnCompletion = NO;
    basicAnim.fillMode = kCAFillModeForwards;
    basicAnim.delegate = self;
    [self.layer addAnimation:basicAnim forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeNoiifyViewFromSuperview];
}

#pragma mark - 删除视图
- (void)removeNoiifyViewFromSuperview {
    //千万注意：windows[0],此处为0,因为0为项目最底层window;
    // 设置windows的windowLevel小于UIWindowLevelNormal;
    //[UIApplication sharedApplication].keyWindow 获取当前的window，先移除，再将原window展示出来
    
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal - 1;
    [[UIApplication sharedApplication].keyWindow removeFromSuperview];
    
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
}

#pragma mark -- 获取当前控制器
- (UIViewController *)atPersentViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self atPersentViewController:vc.presentedViewController];
    }
    
    else if ([vc isKindOfClass:[UIImagePickerController class]]) {
        return vc;
    }
    
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0) {
            return [self atPersentViewController:svc.topViewController];
        } else {
            return vc;
        }
    }
    
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0) {
            return [self atPersentViewController:svc.selectedViewController];
        } else {
            return vc;
        }
    }
    
    else {
        return vc;
    }
}

- (UIViewController *)currentViewController {
    UIViewController *vc = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    return [self atPersentViewController:vc];
}

#pragma mark -- hexColor
- (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3:
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4:
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6:
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8:
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            [NSException raise:@"Invalid color value" format:@"Color value %@ is invalid.", hexString];
            break;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (CGFloat)colorComponentFrom:(NSString *)string start:(NSInteger)start length:(NSInteger)length {
    NSString *subString = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? subString : [NSString stringWithFormat:@"%@%@", subString, subString];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

@end
