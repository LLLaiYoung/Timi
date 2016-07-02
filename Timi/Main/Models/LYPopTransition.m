//
//  LYPopTransition.m
//  3DTransitioningAnimation
//
//  Created by chairman on 16/6/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "LYPopTransition.h"
/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
@implementation LYPopTransition
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        fromView.frame = CGRectMake(0, -SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
                     }
                     completion:^(BOOL finished) {
                       [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
