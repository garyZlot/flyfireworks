//
//  StartUpLayer.m
//  kuang
//
//  Created by garyliumac on 14-2-25.
//  Copyright 2014年 zlot. All rights reserved.
//

#import "StartUpLayer.h"
#import "MainLayer.h"


@implementation StartUpLayer

@synthesize gameCenterManager;

BOOL haveClicked = NO;

CCSprite *startBtn;

+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    StartUpLayer *layer = [StartUpLayer node];
    [scene addChild:layer];
    return scene;
}


- (id) init
{
    if (self = [super init]) {
        [self setTouchEnabled:YES];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *bj = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bj.png"]];
        [bj setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:bj];
        
        startBtn = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"start.png"]];
        [startBtn setPosition:ccp(screenSize.width/2, screenSize.height/2 - 80)];
        CCSequence *seq = [CCSequence actions:[CCScaleTo actionWithDuration:.5 scale:1.2],
                           [CCScaleTo actionWithDuration:.5 scale:1.0],nil];
        [startBtn runAction:[CCRepeatForever actionWithAction:seq]];
        [self addChild:startBtn];
        
    }
    
    /*
    if([GameCenterManager isGameCenterAvailable]) {
        self.gameCenterManager= [[[GameCenterManager alloc] init] autorelease];
        [self.gameCenterManager setDelegate: self];
		[self.gameCenterManager authenticateLocalUser];
		
		//[self updateCurrentScore];
	} else {
		NSLog(@"fail to init game center");
	}
     */
    
    
    return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint gestureStartPoint = [[CCDirector sharedDirector] convertToGL:location];
    
    if (touches.count == 1) {
        if (CGRectContainsPoint([self getRectForSprite:startBtn], gestureStartPoint)) {
            //NSLog(@"touch at start");
            if (haveClicked) {
                return;
            } else {
                haveClicked = YES;
            }
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainLayer scene] ]];
        }
    }
}

- (CGRect)getRectForSprite:(CCSprite *)s
{
	float w = [s contentSize].width;
	float h = [s contentSize].height;
	CGPoint point = CGPointMake([s position].x - (w/2), [s position].y - (h/2));
	return CGRectMake(point.x,point.y,w,h);
}

@end
