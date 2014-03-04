//
//  CCImageButton.h
//  kuang
//
//  Created by garyliumac on 14-2-15.
//  Copyright 2014年 zlot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCImageButton : CCMenu {
    
}

- (void) initWithNormalImage:(NSString *) normalImage selectedImage:(NSString *)selectedImage target:(id)target selector:(SEL)selector;
@end
