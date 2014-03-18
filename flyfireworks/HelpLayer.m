//
//  HelpLayer.m
//  kuang
//
//  Created by garyliumac on 14-3-1.
//  Copyright 2014年 zlot. All rights reserved.
//

#import "HelpLayer.h"
#import "MainLayer.h"


@implementation HelpLayer

- (id) init
{
	self = [super initWithColor:ccc4(0, 0, 0, 180)];
	if (self)
	{
        self.touchEnabled = YES;
                
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *helpbg = [CCSprite spriteWithFile:@"help_bg.png"];
        helpbg.position = ccp(size.width/2, size.height/2);
        [self addChild:helpbg];
    
        NSString *text = @"Click any block of grid to switch with the right top block, can fire fireworks if come to two same color conjoint blocks. More conjoints, more score. You can remove one firework use the firecracker on the right top.";
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:14 dimensions:CGSizeMake(240,150) hAlignment:UITextAlignmentLeft];
        label.position = ccp(size.width/2, size.height/2);
        [self addChild:label];

        CCSprite *normal = [CCSprite spriteWithFile:@"close_button.png"];
        CCSprite *selected = [CCSprite spriteWithFile:@"close_button.png"];
        CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected
                                                                 target:self selector:@selector(closeHelp:)];
        item.position = ccp(128, 80);

        CCMenu* menu = [CCMenu menuWithItems:item,nil];
        
        [self addChild:menu];
        
    }
    return self;
}

- (void) closeHelp:(id)sender {
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    MainLayer *mv = (MainLayer *)[scene getChildByTag:0];
    [mv enableMenu:YES];
    [self removeFromParentAndCleanup:YES];
}

@end
