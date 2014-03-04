//
//  MainLayer.h
//  kuang
//
//  Created by garyliumac on 14-1-14.
//  Copyright 2014年 zlot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCore.h"


@interface MainLayer : CCLayer <CCTouchAllAtOnceDelegate>
{
    GameCore *gameCore;
    
}

@property (nonatomic,retain) GameCore *gameCore;

+(CCScene *) scene;

-(void) enableMenu:(BOOL) isEnabled;

@end
