//
//  MECoverView.h
//  Yosemite_teacher
//
//  Created by 陈建才 on 2017/11/11.
//  Copyright © 2017年 liufangyu@mmears.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MECoverModel.h"

@interface MECoverView : NSWindow

@property (nonatomic ,strong) NSMutableArray *alertViews;

@property (nonatomic ,strong) MECoverModel *waitToAlertModel;

@property (nonatomic ,strong) MECoverModel *showingView;

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag animationType:(MECoverAnimationType)type;

-(void)showAlertView;

-(void)coverViewChange;

-(void)coverHide;

-(void)enterFullScreen;
-(void)exitFullScreen;

-(void)showTokenInvalidView:(NSView *)hintView;

@end
