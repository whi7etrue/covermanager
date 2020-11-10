//
//  MECoverManger.h
//  MagicEar
//
//  Created by 陈建才 on 2017/11/16.
//  Copyright © 2017年 liufangyu@mmears.com. All rights reserved.
//

/**
 弹窗视图管理类
 */

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "MECoverView.h"
#import "MECoverModel.h"

typedef NSView *(^MEGetCoverViewBlock)(void);

typedef NS_ENUM(NSInteger, CoverViewLevel) {
    CoverViewLevelZero = 0,
    CoverViewLevelOne,
    CoverViewLevelTwo,
};

@interface MECoverManger : NSObject

/**
 添加弹窗

 @param level 弹窗等级
 @param animationType 动画类型
 @param getCoverViewBlock 返回弹窗视图
 */
+ (void)addCoverViewWithLevel:(NSInteger)level animationType:(MECoverAnimationType)animationType setUpCoverView:(MEGetCoverViewBlock)getCoverViewBlock;

/**
 添加弹窗
 
 @param level 弹窗等级
 @param viewClass 视图类
 @param animationType 动画类型
 @param getCoverViewBlock 返回弹窗视图
 */
+ (void)addCoverViewWithLevel:(NSInteger)level viewClass:(Class)viewClass animationType:(MECoverAnimationType)animationType setUpCoverView:(MEGetCoverViewBlock)getCoverViewBlock;

/**
 添加弹窗

 @param animationType 动画类型
 @param getCoverViewBlock 返回弹窗视图
 */
+ (void)addCoverViewWithAnimationType:(MECoverAnimationType)animationType setUpCoverView:(MEGetCoverViewBlock)getCoverViewBlock;


/**
 存储model

 @param newModel 数据模型
 @param equal 排列顺序
 */
+ (void)verbNewView:(MECoverModel *)newModel direction:(BOOL)equal;


+ (void)tokenInvalidSetUpCoverView:(MEGetCoverViewBlock)getCoverViewBlock;

/**
 隐藏弹窗
 */
+ (void)gotoCourseAndClearCover;

/**
 切换下一个弹窗
 */
+(void)coverViewChange;

/**
 切换下一个弹窗
 @param viewClass 视图类
 */
+ (void)coverViewChangeWithClass:(Class)viewClass;


/**
 获取当前弹窗

 @return 当前弹窗
 */
+(MECoverView *)getCoverView;

//+ (void)coverViewHide;

+(void)enterFullScreenAdaptFrame;
+(void)exitFullScreenAdaptFrame;

@end
