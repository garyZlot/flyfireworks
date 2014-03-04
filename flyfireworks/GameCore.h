//
//  GameCore.h
//  kuang
//
//  Created by garyliumac on 14-2-15.
//  Copyright (c) 2014年 zlot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SettingLayer.h"


@interface GameCore : NSObject{

CCLayer *mainView;
SettingLayer *settingView;

}

@property (nonatomic,retain) CCLayer *mainView;
@property (nonatomic,retain) SettingLayer *settingView;

- (GameCore *) init: (CCLayer *) layer;
- (void) initMainView;
- (void) handleClickEventFromMainViewAtPoint: (CGPoint) point;
- (void) enableMenu:(BOOL) isEnabled;

@end
