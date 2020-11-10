//
//  MECoverView.m
//  Yosemite_teacher
//
//  Created by 陈建才 on 2017/11/11.
//  Copyright © 2017年 liufangyu@mmears.com. All rights reserved.
//

#import "MECoverView.h"
#import "FYMacro.h"
#import "AppDelegate.h"
#import "MECoverModel.h"
#import "NSView+FYLocation.h"
#import <pop/pop.h>
#import "MEBootVideoView.h"
#import "MECoverManger.h"
#import "MECoverBaseContentView.h"

@interface MECoverView ()<NSAnimationDelegate,NSWindowDelegate>

@property (nonatomic,assign)BOOL isAniamtion;

@property (nonatomic ,strong) NSView *coverView;

@property (nonatomic ,strong) NSView *containerView;

@property (nonatomic ,strong) NSView *topView;

@end

@implementation MECoverView

-(void)enterFullScreen{
    
    [self setFrame:CGRectMake(0, 0, FULL_SCREEN_WITDH, FULL_SCREEN_HEIGHT) display:NO];
    
    self.coverView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.showingView.oprationView.frame = CGRectMake(self.showingView.oprationView.x, (self.frame.size.height - self.showingView.oprationView.height)/2, self.showingView.oprationView.width, self.showingView.oprationView.height);
}

-(void)exitFullScreen{
    
    NSApplication *app = [NSApplication sharedApplication];
    
    AppDelegate *dele = (AppDelegate *)app.delegate;
    
    [self setFrame:CGRectMake(dele.nomalRect.origin.x, dele.nomalRect.origin.y, dele.nomalRect.size.width, dele.nomalRect.size.height-22) display:NO];
    
    self.coverView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.showingView.oprationView.frame = CGRectMake(self.showingView.oprationView.x, (self.frame.size.height - self.showingView.oprationView.height)/2, self.showingView.oprationView.width, self.showingView.oprationView.height);
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag animationType:(MECoverAnimationType)type{
    
    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag]) {
        
        self.alertViews = [NSMutableArray array];
        
        [self setConfigWithanimationType:type];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{

    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag]) {
        
        self.alertViews = [NSMutableArray array];
        
        [self setConfigWithanimationType:MECoverAnimationType_normal];
    }
    return self;
}

-(void)setConfigWithanimationType:(MECoverAnimationType)type{

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizedViewContentBoundsDidChange:) name:NSApplicationDidChangeScreenParametersNotification object:nil];
    
    self.backgroundColor = [NSColor clearColor];
    
    self.acceptsMouseMovedEvents = YES;
    self.ignoresMouseEvents = NO;
    
    
    NSView *cover = [[NSView alloc]init];
    
    cover.wantsLayer = YES;
    
    NSColor *color = [[MEEyeCareModeUtil sharedUtil] queryEyeCareModeStatus] ? [NSColor clearColor] : [NSColor blackColor];
    cover.layer.backgroundColor = color.CGColor;
    
    cover.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    
    self.coverView = cover;
    [self.contentView addSubview:cover];
    
    NSView *contain = [[NSView alloc] init];
    
    contain.wantsLayer = YES;
    contain.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    contain.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    
    self.containerView = contain;
    [self.contentView addSubview:contain];
    
    NSView *top = [[NSView alloc] init];
    
    top.wantsLayer = YES;
    top.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    top.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    
    self.topView = top;
    self.topView.hidden = YES;
    [self.contentView addSubview:top];
    
    if (type == MECoverAnimationType_normal) {
        
        cover.alphaValue = 0.0;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.duration = 0.3;
        animation.repeatCount = 1;
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:0.6];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [cover.layer addAnimation:animation forKey:@""];
    }else{
        
        cover.alphaValue = 0.6;
    }
}

- (BOOL)canBecomeKeyWindow{
    
    return YES;
}

-(void)coverHide{
    if ([[MEEyeCareModeUtil sharedUtil] queryEyeCareModeStatus]) {
           
        [[MEEyeCareModeUtil sharedUtil] switchEyeCareMode:NO window:self];
    }
    
    if (self.alertViews.count>0) {
        
        [self.alertViews removeAllObjects];
    }
    
    [self orderOut:nil];
    
}

-(void)setWaitToAlertModel:(MECoverModel *)waitToAlertModel{
    
    if (waitToAlertModel == nil) {
        
        _waitToAlertModel = waitToAlertModel;
        
        return;
    }
    
    if (self.isAniamtion == false) {
        
        _waitToAlertModel = waitToAlertModel;
        
        [MECoverManger verbNewView:self.showingView direction:NO];
        
        [self showAlertView];
    }else{
        
        if (_waitToAlertModel != nil) {
            
            [MECoverManger verbNewView:_waitToAlertModel direction:NO];
        }
        
        _waitToAlertModel = waitToAlertModel;
    }
}

-(void)showAlertView{
    
    self.isAniamtion = YES;
    
    if ([self.showingView.oprationView isKindOfClass:[MECoverBaseContentView class]]) {
        
        MECoverBaseContentView *contentView = (MECoverBaseContentView *)self.showingView.oprationView;
        
        contentView.isShow = NO;
    }

    if (self.showingView != nil) {
        
        [self.showingView.oprationView pop_removeAnimationForKey:@"M_position"];
        
        [self.showingView.oprationView removeFromSuperview];
        
        self.showingView = nil;
    }
    
    if (self.waitToAlertModel != nil) {

        self.showingView = self.waitToAlertModel;
        self.waitToAlertModel = nil;
    }else{
        
        self.showingView = self.alertViews[0];
        [self.alertViews removeObjectAtIndex:0];
    }
    
//    self.showingView.oprationView.userInteractionEnabled = NO;
    [self.containerView addSubview:self.showingView.oprationView];
    
    
    [self alertViewShowWithAnimation];
}

-(void)alertViewShowWithAnimation{
    
    switch (self.showingView.animationType) {
        case MECoverAnimationType_normal:{
            
            [self springAnimation];
        }
            break;
            
        case MECoverAnimationType_fade:{
            
            [self fadeAnimation];
        }
            
        default:
            break;
    }
}

-(void)fadeAnimation{
    
    self.showingView.oprationView.frame = CGRectMake((self.frame.size.width - self.showingView.oprationView.width)/2, (self.frame.size.height - self.showingView.oprationView.height)/2, self.showingView.oprationView.width, self.showingView.oprationView.height);
    
    self.showingView.oprationView.alphaValue = 0;
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        
        [context setDuration:0.2];
        
        [[self.showingView.oprationView animator] setAlphaValue:1.0];
        
        
    }completionHandler:^{
        
        self.isAniamtion = NO;
        [self animationFinish];
        
    }];
}

- (void)springAnimation{
    
    self.showingView.oprationView.x = (self.frame.size.width - self.showingView.oprationView.width)/2;
    self.showingView.oprationView.y = self.frame.size.height;
    
    CGRect toRect = CGRectMake(self.showingView.oprationView.x, (self.frame.size.height - self.showingView.oprationView.height)/2, self.showingView.oprationView.width, self.showingView.oprationView.height);
    
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    anSpring.fromValue = @(0);
    anSpring.toValue = [NSValue valueWithRect:toRect];
    
    anSpring.removedOnCompletion = NO;
    
    anSpring.springBounciness = 8.0f;
    
    
    [self.showingView.oprationView pop_addAnimation:anSpring forKey:@"M_position"];
    
    @weakify(self);
    
    [anSpring setCompletionBlock:^(POPAnimation *spring, BOOL Completion) {
        
        @strongify(self);
        
        [self.showingView.oprationView pop_removeAnimationForKey:@"M_position"];
        
        self.isAniamtion = NO;
        
        [self animationFinish];
        
        
        NSLog(@"animation finish %d",Completion);
        
    }];
    
    
    
//    [self.showingView.oprationView pop_removeAnimationForKey:@"M_position"];
}

-(void)animationFinish{
    
//    self.showingView.oprationView.userInteractionEnabled = YES;
    
    self.isAniamtion = NO;
    
    if ([self.showingView.oprationView isKindOfClass:[MECoverBaseContentView class]]) {
        
        MECoverBaseContentView *contentView = (MECoverBaseContentView *)self.showingView.oprationView;
        
        contentView.isShow = YES;
    }
    
    if (self.waitToAlertModel != nil && self.showingView) {
        
        
        [MECoverManger verbNewView:self.showingView direction:NO];
        
        [self showAlertView];
    }
    
}

-(void)coverViewChange{
    
    if (self.alertViews.count == 0) {
        
        [self coverHide];
        
        return;
    }
    
    [self showAlertView];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidChangeScreenParametersNotification object:nil];
}

-(void)showTokenInvalidView:(NSView *)hintView{
    
    hintView.x = (self.frame.size.width - hintView.width)/2;
    hintView.y = (self.frame.size.height - hintView.height)/2;
    
    self.topView.hidden = NO;
    [self.topView addSubview:hintView];
}

@end
