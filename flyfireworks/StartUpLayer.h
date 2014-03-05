//
//  StartUpLayer.h
//  kuang
//
//  Created by garyliumac on 14-2-25.
//  Copyright 2014年 zlot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCenterManager.h"

@interface StartUpLayer : CCLayer <CCTouchAllAtOnceDelegate, GameCenterManagerDelegate>
{
    GameCenterManager *gameCenterManager;
}

@property(nonatomic, retain) GameCenterManager *gameCenterManager;
+(CCScene *) scene;

@end
