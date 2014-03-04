//
//  CCImageButton.m
//  kuang
//
//  Created by garyliumac on 14-2-15.
//  Copyright 2014年 zlot. All rights reserved.
//

#import "CCImageButton.h"


@implementation CCImageButton

- (void) initWithNormalImage:(NSString *) normalImage selectedImage:(NSString *)selectedImage target:(id)target selector:(SEL)selector
{
    CCSprite *normal = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:normalImage]];
    CCSprite *selected = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:selectedImage]];
    if (normalImage == selectedImage) selected.scale = 1.2;
    CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected target:target selector:selector];
    self = [CCMenu menuWithItems:item, nil];
    self.touchEnabled = YES;
}

@end
