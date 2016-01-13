//
//  URTopPromptView.h
//  URTopPromptView
//
//  Created by 杨方明 on 15/10/26.
//  Copyright (c) 2015年 杨方明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^AnimatedCompleteBlock)();

@interface URTopPromptView : NSObject

+ (void)showTopPromptViewText:(NSString *)promptText
                         view:(UIView *)aView;

+ (void)showTopPromptViewText:(NSString *)promptText
                dissmissAfter:(float)interval
                         view:(UIView *)aView;

+ (void)showTopPromptViewText:(NSString *)promptText
                dissmissAfter:(float)interval
                         view:(UIView *)aView
                   startBlock:(void (^)())startBlock
                completeBlock:(AnimatedCompleteBlock)completeBlock;

+ (void)dismiss;

@end
