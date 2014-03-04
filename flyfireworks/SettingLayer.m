//
//  SettingLayer.m
//  kuang
//
//  Created by garyliumac on 14-3-1.
//  Copyright 2014年 zlot. All rights reserved.
//

#import "SettingLayer.h"
#import "MainLayer.h"
#import "SimpleAudioEngine.h"
#import "HelpLayer.h"


@implementation SettingLayer


@synthesize onmusic;
@synthesize onsound;
@synthesize menu;


- (id) init
{
    if (self = [super init]) {
        [self setOnmusic:YES];
        [self setOnsound:YES];

        
        //music on/off toggle
        CCMenuItem *musicOnItem = [CCMenuItemImage itemWithNormalImage:@"music.png"
                                                         selectedImage:@"music.png"
                                                                target:nil
                                                              selector:nil];
        
        CCMenuItem *musicOffItem = [CCMenuItemImage itemWithNormalImage:@"nomusic.png"
                                                          selectedImage:@"nomusic.png"
                                                                 target:nil
                                                               selector:nil];
        
        CCMenuItemToggle *musicToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                                    selector:@selector(toggleMusic)
                                                                       items:musicOnItem, musicOffItem, nil];
        
        //sound on/off toggle
        CCMenuItem *soundOnItem = [CCMenuItemImage itemWithNormalImage:@"sound.png"
                                                         selectedImage:@"sound.png"
                                                                target:nil
                                                              selector:nil];
        
        CCMenuItem *soundOffItem = [CCMenuItemImage itemWithNormalImage:@"nosound.png"
                                                          selectedImage:@"nosound.png"
                                                                 target:nil
                                                               selector:nil];
        
        CCMenuItemToggle *soundToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                                    selector:@selector(toggleSound)
                                                                       items:soundOnItem, soundOffItem, nil];
        
        
        CCSprite *help = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"help.png"]];
        CCSprite *selectedHelp = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"help.png"]];
        [selectedHelp setScale:1.2];
        CCMenuItem *helpItem = [CCMenuItemSprite itemWithNormalSprite:help selectedSprite:selectedHelp target:self selector:@selector(showHelpView)];
        
        
        menu = [CCMenu menuWithItems:musicToggleItem, soundToggleItem, helpItem, nil];
        [menu alignItemsHorizontallyWithPadding:10];
        menu.touchEnabled = YES;
        menu.position = ccp(80,20);
        [self addChild:menu z:8 tag:109];
    }
    return self;
}


- (void) toggleMusic
{
    if (onmusic) {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        [self setOnmusic:NO];
    } else {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [self setOnmusic:YES];
    }
}

- (void) toggleSound
{
    if (onsound) {
        [self setOnsound:NO];
    } else {
        [self setOnsound:YES];
    }
}

- (void) showHelpView
{
    HelpLayer *helpView = [HelpLayer node];
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    [scene addChild:helpView z:10 tag:110];
    MainLayer *mv = (MainLayer *)[scene getChildByTag:0];
    [mv enableMenu:NO];
}


@end
