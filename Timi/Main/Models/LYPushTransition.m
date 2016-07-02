//
//  LYPushTransition2.m
//  3DTransitioningAnimation
//
//  Created by chairman on 16/6/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "LYPushTransition.h"
/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
@implementation LYPushTransition
/** 动画时间 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}
/** 动画内容(如何转场) */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    /**
     *
     1.transitionContext 过渡内容上下文,可以通过它调用`viewControllerForKey:`拿到对应的过渡控制器
     key:UITransitionContextToViewControllerKey 目的控制器
     UITransitionContextFromViewControllerKey 开始控制器
     2.拿到对应的过渡控制器之后需要设置view的frame
     `finalFrameForViewController:` 可以拿到最后的frame,最后即完成动画后的frame
     `initialFrameForViewController:` 拿到初始化的frame,开始动画之前的frame
     3.然后添加到`transitionContext的containerView`
     
     4.设置动画的其他附带属性动画
     
     5.做动画... `UIView的block动画`
     
     6.在动画结束后我们必须向context报告VC切换完成，是否成功。系统在接收到这个消息后，将对VC状态进行维护。
     *
     */
    
    //1...
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    
    //2...
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    //(dx, dy) eg:dx偏移多少
    toView.frame = CGRectOffset(finalFrame, 0, -SCREEN_SIZE.height);
    //3....
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    //4...
    
    //5...
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toView.frame = finalFrame;
    } completion:^(BOOL finished) {
        //6...
        [transitionContext completeTransition:YES];
    }];
}
@end
