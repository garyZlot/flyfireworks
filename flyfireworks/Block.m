//
//  Block.m
//  kuang
//
//  Created by garyliumac on 14-1-18.
//  Copyright 2014年 zlot. All rights reserved.
//

#import "Block.h"


@implementation Block

@synthesize colorIndex;
@synthesize blockCenter;
@synthesize isCheckedForColor;
@synthesize isCanRemoved;

-(id) init
{
    if (self = [super init]) {
        isCheckedForColor = NO;
        isCanRemoved = YES;
    }
    
    return self;
}

-(CGRect) rect {
	float w = [self contentSize].width;
	float h = [self contentSize].height;
	CGPoint point = CGPointMake([self position].x - (w/2), [self position].y - (h/2));
	return CGRectMake(point.x,point.y,w,h);
}

@end
