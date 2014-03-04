//
//  Block.h
//  kuang
//
//  Created by garyliumac on 14-1-18.
//  Copyright 2014年 zlot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Block : CCSprite {
    int colorIndex;
    BOOL isCheckedForColor;
    BOOL isCanRemoved;
    CGPoint blockCenter;
}

@property int colorIndex;
@property BOOL isCheckedForColor;
@property BOOL isCanRemoved;
@property CGPoint blockCenter;

-(CGRect) rect;
@end
