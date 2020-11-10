//
//  MECoverModel.h
//  MagicEar
//
//  Created by 陈建才 on 2017/11/16.
//  Copyright © 2017年 liufangyu@mmears.com. All rights reserved.
//

/**
 弹窗视图模型
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MECoverLevel){

    MECoverLevelVersionUpdate = 3,
    MECoverLevelDeviceCheck = 2,
    MECoverLevelSystemAlert = 1,
    MECoverLevelUserAction = 0,
};

typedef NS_ENUM(NSInteger,MECoverAnimationType) {
    
    MECoverAnimationType_normal = 0,
    
    MECoverAnimationType_fade = 1
};

@class NSView;

@interface MECoverModel : NSObject

/**
 弹窗View
 */
@property (nonatomic ,strong) NSView *oprationView;

/**
 弹窗等级
 */
@property (nonatomic ,assign) MECoverLevel level;

/**
 弹窗动画
 */
@property (nonatomic ,assign) MECoverAnimationType animationType;

/**
 弹窗类，移除弹窗时判断
 */
@property (nonatomic ,strong) NSString *classString;

@end
