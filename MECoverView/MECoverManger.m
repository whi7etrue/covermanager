//
//  MECoverManger.m
//  MagicEar
//
//  Created by 陈建才 on 2017/11/16.
//  Copyright © 2017年 liufangyu@mmears.com. All rights reserved.
//

#import "MECoverManger.h"
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "MECoverView.h"
#import "MECoverModel.h"
#import "FYMacro.h"

@implementation MECoverManger

+ (void)addCoverViewWithLevel:(NSInteger)level animationType:(MECoverAnimationType)animationType setUpCoverView:(MEGetCoverViewBlock)getCoverViewBlock{

    NSView *showView;
    
    if (getCoverViewBlock) {
        
        showView = getCoverViewBlock();
    }
    
    MECoverModel *newModel = [[MECoverModel alloc] init];
    newModel.oprationView = showView;
    newModel.level = level;
    newModel.animationType = animationType;
    
    [self newAlertModelAddToQueen:newModel];
    
}

+ (void)addCoverViewWithLevel:(NSInteger)level viewClass:(Class)viewClass animationType:(MECoverAnimationType)animationType setUpCoverView:(MEGetCoverViewBlock)getCoverViewBlock{
    
    NSView *showView;
    
    if (getCoverViewBlock) {
        
        showView = getCoverViewBlock();
    }
    
    MECoverModel *newModel = [[MECoverModel alloc] init];
    newModel.oprationView = showView;
    newModel.level = level;
    newModel.animationType = animationType;
    newModel.classString = NSStringFromClass(viewClass);
    [self newAlertModelAddToQueen:newModel];
    
}

+ (void)addCoverViewWithAnimationType:(MECoverAnimationType)animationType setUpCoverView:(MEGetCoverViewBlock)getCoverViewBlock{
    
    MECoverView *nowCover = [self getCoverView];
    
    [nowCover.alertViews removeAllObjects];
    
    NSView *showView;
    
    if (getCoverViewBlock) {
        
        showView = getCoverViewBlock();
    }
    
    MECoverModel *newModel = [[MECoverModel alloc] init];
    newModel.oprationView = showView;
    newModel.level = 0;
    newModel.animationType = animationType;
    
    [nowCover.alertViews addObject:newModel];
    
    [self coverViewChange];
    
    //    [self newAlertModelAddToQueen:newModel];
}

+ (void)newAlertModelAddToQueen:(MECoverModel *)newModel{
    
    MECoverView *nowCover = [self getCoverView];
    
    if (nowCover == nil) {
        
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
        NSWindow *currentWindow = nil;
        switch (delegate.mainWindowController.currentWindowType) {
            case MECurrentWindowType_course:
                currentWindow = delegate.mainWindowController.courseWindow;
                break;
            case MECurrentWindowType_classroom:
                currentWindow = delegate.mainWindowController.classroomWindow;
                break;
            
            default:
                break;
        }
        
        NSUInteger style = NSWindowStyleMaskBorderless;
        
        if ((app.presentationOptions & NSApplicationPresentationFullScreen) == NSApplicationPresentationFullScreen) {

            nowCover = [[MECoverView alloc]initWithContentRect:currentWindow.frame styleMask:style backing:NSBackingStoreBuffered defer:YES animationType:newModel.animationType];
        }else{

            CGFloat coverHeight = 0;
            
            if (delegate.mainWindowController.currentWindowType == MECurrentWindowType_course) {
                
                coverHeight = currentWindow.frame.size.height - 22;
            }else{
            
                coverHeight = currentWindow.frame.size.height;
                
            }
            
            nowCover = [[MECoverView alloc]initWithContentRect:CGRectMake(currentWindow.frame.origin.x, currentWindow.frame.origin.y, currentWindow.frame.size.width, coverHeight) styleMask:style backing:NSBackingStoreBuffered defer:YES animationType:newModel.animationType];
        }
        
        [currentWindow addChildWindow:nowCover ordered:NSWindowAbove];
        
        [nowCover makeKeyWindow];
        
        if ([[MEEyeCareModeUtil sharedUtil] queryEyeCareModeStatus]) {

            [[MEEyeCareModeUtil sharedUtil] switchEyeCareMode:YES window:nowCover];
        }
        
        [nowCover.alertViews addObject:newModel];
        
        [nowCover showAlertView];
        
    }else{
        
        if (!nowCover.showingView) {
            
            [nowCover.alertViews addObject:newModel];
            
            [nowCover showAlertView];
            
            return;
        }
        
        if (newModel.level > nowCover.showingView.level) {
            
            if (nowCover.waitToAlertModel == nil) {
                
                nowCover.waitToAlertModel = newModel;
            }else{
                
                if (newModel.level > nowCover.waitToAlertModel.level) {
                    
                    nowCover.waitToAlertModel = newModel;
                }else{
                    
                    [self verbNewView:newModel direction:YES];
                }
            }
        }else{
            
            [self verbNewView:newModel direction:YES];
        }
    }
}

+ (void)verbNewView:(MECoverModel *)newModel direction:(BOOL)equal{
    
    MECoverView *nowCover = [self getCoverView];
    
    if (nowCover.alertViews.count == 0) {
        
        [nowCover.alertViews addObject:newModel];
    }else{
        
        NSArray *tempArray = nowCover.alertViews.copy;
        
        for (int i=0; i<tempArray.count; i++) {
            
            MECoverModel *tempModel = tempArray[i];
            
            if (equal) {
                //新元素第一次加入  相同的元素放在最后面
                if (newModel.level > tempModel.level) {
                    
                    [nowCover.alertViews insertObject:newModel atIndex:i];
                    
                    break;
                }else{
                    
                    if (i == tempArray.count-1) {
                        
                        [nowCover.alertViews addObject:newModel];
                    }
                }
                
            }else{
                
                //被高level顶掉的元素  相同的元素放到最前面
                
                if (newModel.level >= tempModel.level) {
                    
                    [nowCover.alertViews insertObject:newModel atIndex:i];
                    
                    break;
                }else{
                    
                    if (i == tempArray.count-1) {
                        
                        [nowCover.alertViews addObject:newModel];
                    }
                }
                
            }
        }
    }
}

+ (void)tokenInvalidSetUpCoverView:(MEGetCoverViewBlock)getCoverViewBlock{
    
    MECoverView *nowCover = [self getCoverView];
    
    NSView *showView;
    
    if (getCoverViewBlock) {
        
        showView = getCoverViewBlock();
    }
    
    if (nowCover == nil) {
        
        NSApplication *app = [NSApplication sharedApplication];
        //
        //        AppDelegate *dele = (AppDelegate *)app.delegate;
        //
        //        NSWindow *mainWindow = dele.mainWindowController.window;
        //
        AppDelegate *delegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
        NSWindow *currentWindow = nil;
        switch (delegate.mainWindowController.currentWindowType) {
            case MECurrentWindowType_course:
                currentWindow = delegate.mainWindowController.courseWindow;
                break;
            case MECurrentWindowType_classroom:
                currentWindow = delegate.mainWindowController.classroomWindow;
                break;
                
            default:
                break;
        }
        
        NSUInteger style = NSWindowStyleMaskBorderless;
        
        //        nowCover = [[MECoverView alloc]initWithContentRect:mainWindow.frame styleMask:style backing:NSBackingStoreBuffered defer:YES animationType:newModel.animationType];
        
        //        NSLog(@"cover view frame: %@",NSStringFromRect(mainWindow.frame));
        
        if ((app.presentationOptions & NSApplicationPresentationFullScreen) == NSApplicationPresentationFullScreen) {
            
            nowCover = [[MECoverView alloc]initWithContentRect:currentWindow.frame styleMask:style backing:NSBackingStoreBuffered defer:YES animationType:MECoverAnimationType_normal];
        }else{
            
            CGFloat coverHeight = 0;
            
            if (delegate.mainWindowController.currentWindowType == MECurrentWindowType_course) {
                
                coverHeight = currentWindow.frame.size.height - 22;
            }else{
                
                coverHeight = currentWindow.frame.size.height;
                
            }
            
            nowCover = [[MECoverView alloc]initWithContentRect:CGRectMake(currentWindow.frame.origin.x, currentWindow.frame.origin.y, currentWindow.frame.size.width, coverHeight) styleMask:style backing:NSBackingStoreBuffered defer:YES animationType:MECoverAnimationType_normal];
        }
        
        [currentWindow addChildWindow:nowCover ordered:NSWindowAbove];
        
        [nowCover makeKeyWindow];
        
        if ([[MEEyeCareModeUtil sharedUtil] queryEyeCareModeStatus]) {

            [[MEEyeCareModeUtil sharedUtil] switchEyeCareMode:YES window:nowCover];
        }
    }
    
    [nowCover showTokenInvalidView:showView];
}

+ (void)gotoCourseAndClearCover{
    
    MECoverView *nowCover = [self getCoverView];
    
    [nowCover coverHide];
}

+(void)coverViewChange{

    MECoverView *nowCover = [self getCoverView];
    
    [nowCover coverViewChange];
}

+ (void)coverViewChangeWithClass:(Class)viewClass{
    
    MECoverView *nowCover = [self getCoverView];
    
    MECoverModel *oprationModel = nil;

    for (MECoverModel *coverModel in nowCover.alertViews) {
        
        if ([coverModel.classString isEqualToString:NSStringFromClass(viewClass)]) {
            
            oprationModel = coverModel;
            break;
        }
    }
    if (oprationModel) {
        
        if (oprationModel.oprationView == nowCover.showingView.oprationView) {
            
            [nowCover coverViewChange];
        } else {
            
            [nowCover.alertViews removeObject:oprationModel];
        }
    } else {
        
        [nowCover coverViewChange];
    }
}

+ (void)coverViewHide{
    
    MECoverView *nowCover = [self getCoverView];
    
    [nowCover coverHide];
}

+(MECoverView *)getCoverView{

    AppDelegate *delegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    NSWindow *currentWindow = nil;
    switch (delegate.mainWindowController.currentWindowType) {
        case MECurrentWindowType_course:
            currentWindow = delegate.mainWindowController.courseWindow;
            break;
        case MECurrentWindowType_classroom:
            currentWindow = delegate.mainWindowController.classroomWindow;
            break;
        
        default:
            break;
    }
    
    MECoverView *coverView;
    
    for (NSWindow *window in currentWindow.childWindows) {
        
        if ([window isKindOfClass:[MECoverView class]]) {
            
            coverView = (MECoverView *)window;
        }
    }
    
    return coverView;
}

+(void)enterFullScreenAdaptFrame{
    
    [[self getCoverView] enterFullScreen];
}
+(void)exitFullScreenAdaptFrame{
    
    [[self getCoverView] exitFullScreen];
}

@end
