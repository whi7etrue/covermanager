//
//  METokenInvalidTool.m
//  MagicEar
//
//  Created by 陈建才 on 2019/3/5.
//  Copyright © 2019年 mmears. All rights reserved.
//

#import "METokenInvalidTool.h"
#import "AppDelegate.h"
#import "MELoginMangerViewController.h"
#import "MECoverManger.h"
#import "FYCommonMethods.h"
#import "InTheCourseController.h"
#import "FYBaseController.h"
#import "MEMaskTransformWindow.h"
#import "MECloudTransformWindow.h"
#import "MEImageLineAlertView.h"
#import "FYMacro.h"

@implementation METokenInvalidTool

+(void)tokenInvalidHintShow{
    
    if ([FYCommonMethods isFullScreen]){
        
        [MDSeviceManger getSeviceManger].fullScreenTokenInvalid = YES;
        
        [FYCommonMethods setToggleFullScreen:NO];
        
    }else{
        
        [self hintViewShow];
    }
}

+(void)hintViewShow{
    
    [MECoverManger tokenInvalidSetUpCoverView:^NSView *{
        
        MEImageLineAlertView * tipView = [[MEImageLineAlertView alloc] initWithfinished:^(id object) {
            
            [self actionClickCamera];
        }];
        
        [tipView updateTitle:[MDSeviceManger getSeviceManger].tokenInvalidHint headerView:@"pop_userCenterImages_crybunny"];
        
        return tipView;
    }];
    
    [self incoursevcLeaveChannel];
}

+(void)actionClickCamera{
    
    [self popViewControllerToLogin];
}

+(void)incoursevcLeaveChannel{
    
    NSApplication *app = [NSApplication sharedApplication];
    AppDelegate *dele = (AppDelegate *)app.delegate;
    
    NSViewController *inCourseController = dele.mainWindowController.classroomWindow.contentViewController;
    
    if ([inCourseController isKindOfClass:[InTheCourseController class]]) {
        
        InTheCourseController *courseVC = (InTheCourseController *)inCourseController;
        
        [courseVC leaveChannel];
    }
}

+(void)popViewControllerToLogin{
    
    //取消登录状态
    [[UserInfo shareInfo] logOut];
    
    //清除所有弹框
    [MECoverManger gotoCourseAndClearCover];
    
    //清空所有的注册事件
    [MECoursePopTool cancelRegisterAction:MECoursePopToolCourseType_All];
    
    //移出转场动画
    [MEMaskTransformWindow removeMaskTransformWindowFinish:nil];
    [MECloudTransformWindow removeCloudTransformViewAnimationFinish:nil];
    
    [[[MEKeyedArchiverManger alloc] init] keyedArchiverWithObject:[UserInfo shareInfo]];
    
    NSApplication *app = [NSApplication sharedApplication];
    
    AppDelegate *dele = (AppDelegate *)app.delegate;
    
    NSViewController *inCourseController = dele.mainWindowController.classroomWindow.contentViewController;
    
    if ([inCourseController isKindOfClass:[InTheCourseController class]]) {
        
        InTheCourseController *courseVC = (InTheCourseController *)inCourseController;
        
        [courseVC tokenInvalidAndLeave];
        
        [courseVC dismissController:nil];
    }
    
    while (true) {
        
        NSViewController *courseListController = dele.mainWindowController.contentViewController;
        
        if (courseListController.childViewControllers.count>0) {
            
            [courseListController removeChildViewControllerAtIndex:0];
        }
        
        if ([courseListController isKindOfClass:[MELoginMangerViewController class]]) {
            
            return;
        }
        
        if ([courseListController isKindOfClass:[FYBaseController class]]) {
            
            FYBaseController *courseVC = (FYBaseController *)courseListController;
            
            [courseVC tokenInvalidAndLeave];
        }
        
        [courseListController dismissController:nil];
    }
    
}

@end
