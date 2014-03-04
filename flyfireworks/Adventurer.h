//
//  Adventurer.h
//  SpriteTutorialPart3
//
//  Created by MajorTom on 9/13/10.
//  Copyright 2010 iPhoneGameTutorials.com All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface Adventurer : CCNode {
    CCAction *_walkAction;
	CCAction *_moveAction;
    CCAnimate *_animate;
    BOOL _moving;
}

@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) CCAnimate *animate;

@end
