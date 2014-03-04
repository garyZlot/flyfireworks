//
//  MainLayer.m
//  kuang
//
//  Created by garyliumac on 14-1-14.
//  Copyright 2014年 zlot. All rights reserved.
//

#import "MainLayer.h"
#import "Block.h"
#import "SimpleAudioEngine.h"
#import "GameCore.h"
#import "SettingLayer.h"

@implementation MainLayer

@synthesize gameCore;

+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    MainLayer *layer = [MainLayer node];
    [scene addChild:layer z:0 tag:0];
    return scene;
}

-(id) init
{
    if (self = [super init]) {
        gameCore = [[GameCore alloc] init:self];
        [gameCore initMainView];
        //[self scheduleUpdate];
    }
    return self;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    if ([scene getChildByTag:110]) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint gestureStartPoint = [[CCDirector sharedDirector] convertToGL:location];
    
    if (touches.count == 1) {
        [gameCore handleClickEventFromMainViewAtPoint:gestureStartPoint];
    }
}

-(void) enableMenu:(BOOL) isEnabled
{
    SettingLayer *sv = [[self gameCore] settingView];
    [[sv menu] setTouchEnabled:isEnabled];
    [[self gameCore] enableMenu:isEnabled];
}

@end
