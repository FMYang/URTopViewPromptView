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
@property (nonatomic, strong) UIView  *promptView;
@property (nonatomic, strong) AnimatedCompleteBlock animatedCompleteBlock;

@end

@implementation URTopPromptView
@synthesize overlayWindow = _overlayWindow;
@synthesize promptLabel = _promptLabel;
@synthesize promptView = _promptView;
@synthesize animatedCompleteBlock;

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
    [self animatedWithView:aView];
}

+ (void)showTopPromptViewText:(NSString *)promptText
                dissmissAfter:(float)interval
                         view:(UIView *)aView
                   startBlock:(void (^)())startBlock
                completeBlock:(AnimatedCompleteBlock)completeBlock
{
    [[self sharedInstance] showTopPromptViewText:promptText dissmissAfter:interval view:aView startBlock:startBlock completeBlock:completeBlock];
    [self dismissAfter:interval];
}

- (void)showTopPromptViewText:(NSString *)promptText
                dissmissAfter:(float)interval
                         view:(UIView *)aView
                   startBlock:(void (^)())startBlock
                completeBlock:(AnimatedCompleteBlock)completeBlock
{
    self.promptLabel.text = promptText;
    startBlock();
    animatedCompleteBlock = completeBlock;
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

//add view
- (void)animatedWithView:(UIView *)aView
{
    [self.promptView addSubview:_promptLabel];
    [aView addSubview:_promptView];
    
    [UIView animateWithDuration:0.4 animations:^{
        _promptView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    } completion:^(BOOL finished) {
        
    }];
}

//remove view
- (void)dismissWithAnimated:(BOOL)animated
{
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _promptView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        
    } completion:^(BOOL finished) {
        if(finished)
        {
            [_promptView removeFromSuperview];
            _promptView = nil;
            
            if(animatedCompleteBlock)
            {
                animatedCompleteBlock();
            }
        }
    }];
}

- (void)setDismissTimerWithInterval:(NSTimeInterval)interval;
{
    [self.dismissTimer invalidate];
    self.dismissTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]
                                                 interval:0 target:self selector:@selector(dismissWithAnimated:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.dismissTimer forMode:NSRunLoopCommonModes];
}

- (UIView *)promptView
{
    if(_promptView == nil)
    {
        _promptView = [[UILabel alloc]init];
        _promptView.backgroundColor = [UIColor colorWithHex:0xd7e8f8];
        _promptView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        _promptView.clipsToBounds = YES;
    }
    return _promptView;
}

- (UILabel *)promptLabel
{
    if(_promptLabel == nil)
    {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.backgroundColor = [UIColor colorWithHex:0xd7e8f8];
        _promptLabel.textColor = [UIColor colorWithHex:0x3b9cd3];
        _promptLabel.font = [UIFont systemFontOfSize:14];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    }
    
    return _promptLabel;
}


//    //缩放弹出动画
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.4;
//    
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [_promptLabel.layer addAnimation:animation forKey:nil];


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
