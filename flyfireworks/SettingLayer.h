//
//  SettingLayer.h
//  kuang
//
//  Created by garyliumac on 14-3-1.
//  Copyright 2014年 zlot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingLayer : CCLayer {

    BOOL onmusic;
    BOOL onsound;
    CCMenu *menu;
}

@property BOOL onmusic;
@property BOOL onsound;
@property (nonatomic,retain) CCMenu *menu;

@end
