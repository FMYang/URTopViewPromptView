//
//  URTopPromptView.m
//  URTopPromptView
//
//  Created by 杨方明 on 15/10/26.
//  Copyright (c) 2015年 云润大数据. All rights reserved.
//

#import "URTopPromptView.h"
#import "UIColor+Expand.h"

@interface URTopPromptView ()

@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) NSTimer *dismissTimer;

@end

@implementation URTopPromptView
@synthesize overlayWindow = _overlayWindow;
@synthesize promptLabel = _promptLabel;

+ (URTopPromptView *)sharedInstance {
    static dispatch_once_t once;
    static URTopPromptView *sharedInstance;
    dispatch_once(&once, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if(self = [super init])
    {
        //do nothing
    }
    return self;
}

+ (void)showTopPromptViewText:(NSString *)promptText view:(UIView *)aView
{
    [[self sharedInstance] showTopPromptViewText:promptText view:aView];
}

- (void)showTopPromptViewText:(NSString *)promptText view:(UIView *)aView
{
    self.promptLabel.text = promptText;
//    [self.overlayWindow setHidden:NO];
    [self animatedWithView:aView];
}

+ (void)showTopPromptViewText:(NSString *)promptText
                dissmissAfter:(float)interval
                         view:(UIView *)aView
{
    [[self sharedInstance] showTopPromptViewText:promptText dissmissAfter:interval view:aView];
    [self dismissAfter:interval];
}


- (void)showTopPromptViewText:(NSString *)promptText
                dissmissAfter:(float)interval
                         view:(UIView *)aView
{
    self.promptLabel.text = promptText;
//    [self.overlayWindow setHidden:NO];
    [self animatedWithView:aView];
}

+ (void)dismiss
{
    [[self sharedInstance] dismissWithAnimated:YES];
}

+ (void)dismissAfter:(float)interval
{
    [[self sharedInstance] setDismissTimerWithInterval:interval];
}

- (void)dismissWithAnimated:(BOOL)animated
{
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _promptLabel.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [_promptLabel removeFromSuperview];
        _promptLabel = nil;
//        [self.overlayWindow removeFromSuperview];
//        [self.overlayWindow setHidden:YES];
//        self.overlayWindow.rootViewController = nil;
//        _overlayWindow = nil;
    }];
}

- (void)setDismissTimerWithInterval:(NSTimeInterval)interval;
{
    [self.dismissTimer invalidate];
    self.dismissTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]
                                                 interval:0 target:self selector:@selector(dismissWithAnimated:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.dismissTimer forMode:NSRunLoopCommonModes];
}

- (UILabel *)promptLabel
{
    if(_promptLabel == nil)
    {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.backgroundColor = [UIColor colorWithHex:0xd7e8f8];
        _promptLabel.textColor = [UIColor colorWithHex:0x3b9cd3];
        _promptLabel.font = [UIFont systemFontOfSize:12];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 30);
    }
    
    return _promptLabel;
}

- (void)animatedWithView:(UIView *)aView
{
//    [self.overlayWindow.rootViewController.view addSubview:self.promptLabel];
    [aView addSubview:_promptLabel];
    
    //缩放弹出动画
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_promptLabel.layer addAnimation:animation forKey:nil];
}

#pragma mark Lazy views
//- (UIWindow *)overlayWindow;
//{
//    if(_overlayWindow == nil) {
//        self.overlayWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        self.overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.overlayWindow.backgroundColor = [UIColor clearColor];
//        self.overlayWindow.userInteractionEnabled = NO;
//        self.overlayWindow.windowLevel = UIWindowLevelStatusBar+1;
//        self.overlayWindow.rootViewController = [[UIViewController alloc] init];
//        self.overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
//        self.overlayWindow.clipsToBounds = YES;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
//        _overlayWindow.rootViewController.wantsFullScreenLayout = YES;
//#endif
//        
////        [self updatePromptLabelFrame];
//
//    }
//    return _overlayWindow;
//}

@end
