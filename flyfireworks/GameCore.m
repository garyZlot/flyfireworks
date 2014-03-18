//
//  GameCore.m
//  kuang
//
//  Created by garyliumac on 14-2-15.
//  Copyright (c) 2014年 zlot. All rights reserved.
//

#import "GameCore.h"
#import "Block.h"
#import "SimpleAudioEngine.h"


@implementation GameCore

NSArray *blockImageArr;
NSMutableArray *allBlocksArr;
NSMutableArray *sameColorBlocksArr;
NSMutableArray *fireworkEffects;

Block *switchedBlock;
BOOL canSwitch;
int minCountForClear = 2;
int score = 0;
int scorebase = 5;
int targetbase = 2500;
int targetrange = 30;
int level = 0;
int target = 0;
int initScoreForNewLevel = 0;
int canSwitchCount = 0;
int totalTime = 50; //time limit
int remainingTime = 50;
int minY = 60; //keep space in bottom
int firecrackerCount = 10;
int tryCount = 3; //player can try when failed
BOOL selectedFirecracker = NO;
int offsetY = 0;

CCLabelTTF *scoreText;
CCLabelTTF *levelTargetText;
CCLabelTTF *levelEndText;
CCSprite *endTextBg;
CCLabelTTF *canSwitchCountText;

CCSprite *firecracker;
CCMenuItem *firecrackerItem;
CCMenuItem *settingItem;

CCLabelTTF *timeLabelText;
CCSprite *timefrontSprite;
CCSprite *timeprogressSprite;
CCLabelTTF *scoreNote;
CCLabelTTF *firecrackerCountText;

NSTimer *timer;
BOOL pauseTimer = YES;
BOOL keepSwitchCount = NO;


@synthesize mainView;
@synthesize settingView;


- (GameCore *) init:(CCLayer *)layer
{
    if (self = [super init]) {
        [self setMainView:layer];
        SettingLayer *settinglayer = [[SettingLayer alloc]init];
        [self setSettingView:settinglayer];
    }
    return self;
}

- (void) initMainView
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    if (is4inch) {
        offsetY = 0;
        minY = 60;
    } else {
        offsetY = -20;
        minY = 40;
    }
    
    //add game background
    CCSprite *bg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"gamebj.png"]];
    bg.position = ccp(screenSize.width/2, screenSize.height/2);
    [mainView addChild:bg];
    
    //level and target
    levelTargetText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %d  Target: %d", level, target] fontName:@"Marker Felt" fontSize:18];
    levelTargetText.position = ccp(120, screenSize.height - 50 - offsetY);
    levelTargetText.color = ccc3(255, 255, 255);
    [mainView addChild:levelTargetText];

    //score text
    scoreText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",score] fontName:@"Marker Felt" fontSize:22];
    scoreText.position = ccp(screenSize.width/2, screenSize.height - 90 - offsetY);
    scoreText.color = ccc3(255, 255, 255);
    [mainView addChild:scoreText];
    
    //score note text
    scoreNote = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:18];
    scoreNote.position = ccp(screenSize.width/2, screenSize.height - 120 - offsetY);
    scoreNote.color = ccc3(255, 255, 255);
    [mainView addChild:scoreNote z:9];
    
    //end text for current level
    endTextBg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"textbg.png"]];
    endTextBg.position = ccp(screenSize.width/2, screenSize.height/2);
    endTextBg.scale = 0.001f;
    [mainView addChild:endTextBg z:8];
    levelEndText = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:35];
    levelEndText.position = ccp(screenSize.width/2, screenSize.height/2);
    levelEndText.color = ccc3(255, 0, 0);
    levelEndText.scale = 0.001f;
    [mainView addChild:levelEndText z:9];
    
    //can switch count text
    canSwitchCountText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",canSwitchCount] fontName:@"Marker Felt" fontSize:18];
    canSwitchCountText.position = ccp(screenSize.width - 58, screenSize.height - 100 - offsetY);
    canSwitchCountText.color = ccc3(255, 215, 0);
    [canSwitchCountText setVisible:NO];
    [mainView addChild:canSwitchCountText];
    
    //firecracker menu
    firecracker = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"firecracker.png"]];
    CCSprite *selectedFirecracker = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"firecracker.png"]];
    firecrackerItem = [CCMenuItemSprite itemWithNormalSprite:firecracker selectedSprite:selectedFirecracker target:self selector:@selector(animateFirecracker)];
    [firecrackerItem setIsEnabled:YES];
    CCMenu *firecrackerMenu = [CCMenu menuWithItems: firecrackerItem,nil];
    firecrackerMenu.touchEnabled = YES;
    firecrackerMenu.position = ccp(screenSize.width - 30, screenSize.height - 50 - offsetY);
    [mainView addChild:firecrackerMenu];
    
    //firecracker count text
    firecrackerCountText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",firecrackerCount] fontName:@"Marker Felt" fontSize:18];
    firecrackerCountText.position = ccp(screenSize.width - 50, screenSize.height - 50 - offsetY);
    firecrackerCountText.color = ccc3(255, 215, 0);
    [mainView addChild:firecrackerCountText];
    
    //setting menu
    CCSprite *setting = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"setting.png"]];
    CCSprite *selectedSetting = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"setting.png"]];
    [selectedSetting setScale:1.2];
    settingItem = [CCMenuItemSprite itemWithNormalSprite:setting selectedSprite:selectedSetting target:self selector:@selector(showSetting)];
    [settingItem setIsEnabled:YES];
    CCMenu *settingMenu = [CCMenu menuWithItems:settingItem, nil];
    settingMenu.touchEnabled = YES;
    settingMenu.position = ccp(20,20);
    [mainView addChild:settingMenu];
    
    [[self settingView] setPosition:ccp(0, 0)];
    [[self settingView] setAnchorPoint:ccp(20, 20)];
    [[self settingView] setScaleX:0.001];
    [mainView addChild:[self settingView] z:9];
    
    
    if ([[self settingView] onmusic]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg.caf"];
    } else {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    }
    
    [self updateMainView];

}


- (void) updateMainView
{
    NSLog(@"--call stack---%@",[NSThread callStackSymbols]);
    initScoreForNewLevel = score;
    canSwitchCount = 2000;
    if (level<0) level = 0;
    level++;
    if (level == 1) {
        target = 1000;
    } else if (level == 2){
        target = 2500;
    } else {
        target = 2500 + targetbase * (level-2) + (level - 3) * targetrange;
    }
    //target = (level ==1) ? targetbase : targetbase * level + (level + 1) * level * targetrange;
    [canSwitchCountText setString:[NSString stringWithFormat:@"%d", canSwitchCount]];
    [scoreText setString:[NSString stringWithFormat:@"%d", initScoreForNewLevel]];
    [levelTargetText setString:[NSString stringWithFormat:@"Level: %d  Target: %d", level, target]];
    [scoreNote setString:@""];
  
    if (allBlocksArr.count>0)[self removeAllBlocksFromScreen];
    [switchedBlock removeFromParent];
    
    //blockImageArr = [[NSArray alloc]initWithObjects:@"drop_blue.png", @"drop_green.png",@"drop_red.png",@"drop_violet.png",@"drop_yellow.png",@"drop_pink.png",nil];
    blockImageArr = [[NSArray alloc]initWithObjects:@"fireworks_green.png", @"fireworks_blue.png",@"fireworks_yellow.png",@"fireworks_violet.png",@"fireworks_red.png",@"fireworks_pink.png",nil];
    allBlocksArr = [[NSMutableArray alloc] init];
    sameColorBlocksArr = [[NSMutableArray alloc] init];
    
    for (int i=0; i<COL; i++) {
        NSMutableArray *blocks = [[NSMutableArray alloc]init];
        for (int j=0; j<ROW; j++) {
            float x = BLOCK_W * (i+1);
            float y = BLOCK_H * j;
            int colorIndex = (arc4random() % blockImageArr.count);
            Block *block = [Block spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[blockImageArr objectAtIndex:colorIndex]]];
            block.position = ccp(x - block.contentSize.width/2, y + block.contentSize.height/2 + minY);
            [block setColorIndex:colorIndex];
            [mainView addChild:block];
            [blocks addObject:block];
        }
        [allBlocksArr addObject:blocks];
    }
    
    switchedBlock = [self generateSwitchedBlock];
    
    //start game use timer
    remainingTime = totalTime;
    if (pauseTimer) {
        [timeLabelText setString:[NSString stringWithFormat:@"Time: %d", remainingTime]];
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
        } else {
            remainingTime++;
            [timer setFireDate:[NSDate date]];
        }
        pauseTimer = NO;
    }
    
    canSwitch = YES;
    mainView.touchEnabled = YES;
}

- (void) setTime
{
    if (pauseTimer) return;
    if (remainingTime > 0) {
        remainingTime--;
    } else {
        pauseTimer = YES;
        [timer setFireDate:[NSDate distantFuture]];
        //[self checkCanGoonPlay];
    }
    [timeLabelText setString:[NSString stringWithFormat:@"Time: %d", remainingTime]];
    //NSLog(@"scale is ----- %f", (float)remainingTime/(float)totalTime);
    [timeprogressSprite setScaleX: (float)remainingTime/(float)totalTime];
}

- (void) restartGame
{
    score = 0;
    level = 0;
    target = 0;
    initScoreForNewLevel = 0;
    [self updateMainView];
}

- (void) removeAllBlocksFromScreen
{
    for (int i=0; i<allBlocksArr.count; i++) {
        NSMutableArray *bs = [allBlocksArr objectAtIndex:i];
        for (int j=0; j<bs.count; j++) {
            Block *b = [bs objectAtIndex:j];
            [b removeFromParent];
        }
    }
}

-(Block *) generateSwitchedBlock
{
    
    int randomColorIndex = (arc4random() % blockImageArr.count);
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    Block *block = [Block spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[blockImageArr objectAtIndex:randomColorIndex]]];
    block.position = ccp(size.width - 30, size.height - 100 - offsetY);
    
    [block setColorIndex:randomColorIndex];
    [mainView addChild:block];
    return block;
}

- (void) handleClickEventFromMainViewAtPoint: (CGPoint) point
{
    //|| remainingTime <= 0
    if (!canSwitch || canSwitchCount == 0 ) return;
    for (int m=0; m<allBlocksArr.count; m++) {
        NSMutableArray *blocks = [allBlocksArr objectAtIndex:m];
        for (int n=0; n<blocks.count; n++) {
            if (CGRectContainsPoint([[blocks objectAtIndex:n] rect], point)) {
                if (selectedFirecracker) {
                    Block *currentBlock = [[allBlocksArr objectAtIndex:m] objectAtIndex:n];
                    [sameColorBlocksArr removeAllObjects];
                    [sameColorBlocksArr addObject:currentBlock];
                    [currentBlock setIsCanRemoved:YES];
                    firecrackerCount--;
                    if (firecrackerCount == 0) {
                        [firecrackerItem setIsEnabled:NO];
                    }
                    [firecrackerCountText setString:[NSString stringWithFormat:@"%d", firecrackerCount]];
                    [self doRemoveSameColorBlocksAction];
                
                } else {
                    [self clearBlocksStatus];
                    [sameColorBlocksArr removeAllObjects];
                    //Block *newBlock = [blocks objectAtIndex:n];
                    [self getConjointBlocksWithColor:switchedBlock.colorIndex atCol: m+1 atRow:n+1];
                    [sameColorBlocksArr removeObjectAtIndex:0];
                    
                    if ((sameColorBlocksArr.count + 1) >= minCountForClear) {
                        canSwitch = NO;
                        [sameColorBlocksArr addObject:switchedBlock];
                        [self switchBlocksAtCol:m+1 atRow:n+1];
                        if ([[self settingView] onsound]) {
                            [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
                        }
                        
                        // wait for switch animation finished
                        //NSLog(@"remainingTime is %d", remainingTime);
                        [self performSelector:@selector(checkCanRemoveBlocks) withObject:self afterDelay:0.5];
                    }
                }
                
            }
        }
    }
}

- (void) switchBlocksAtCol:(int) col atRow:(int) row
{
    if (col>0 && col<=COL && row>0 && row<=ROW) {
        Block *currentBlock = [[allBlocksArr objectAtIndex:col-1] objectAtIndex:row-1];
        if (canSwitchCount>0) canSwitchCount--;
        [canSwitchCountText setString:[NSString stringWithFormat:@"%d", canSwitchCount]];
        
        CGPoint originalPosition = switchedBlock.position;
        
        [mainView reorderChild:switchedBlock z:1];
        [mainView reorderChild:currentBlock z:1];
        [switchedBlock runAction:[CCMoveTo actionWithDuration:.3 position:currentBlock.position]];
        [currentBlock runAction:[CCMoveTo actionWithDuration:.3 position:originalPosition]];
        
        [switchedBlock setIsCheckedForColor:YES];
        [switchedBlock setIsCanRemoved:YES];
        
        [currentBlock setIsCheckedForColor:NO];
        [currentBlock setIsCanRemoved:NO];
        
        [[allBlocksArr objectAtIndex:col-1] replaceObjectAtIndex:row-1 withObject:switchedBlock];
        switchedBlock = currentBlock;
    }
}

- (void) clearBlocksStatus
{
    for (int i=0; i<allBlocksArr.count; i++) {
        NSMutableArray *bs = [allBlocksArr objectAtIndex:i];
        for (int j=0; j<bs.count; j++) {
            [[bs objectAtIndex:j] setIsCheckedForColor:NO];
            [[bs objectAtIndex:j] setIsCanRemoved:NO];
        }
    }
}

- (NSMutableArray *) getConjointBlocksWithColor:(int) colorId atCol:(int) col atRow:(int) row
{
    Block *currentBlock = [[allBlocksArr objectAtIndex:col-1] objectAtIndex:row-1];
    //int currentC = currentBlock.colorIndex;
    //NSLog(@"getConjointBlocksWithColor with %d %d %d", colorId, col,row);
    
    [currentBlock setIsCheckedForColor:YES];
    [sameColorBlocksArr addObject:currentBlock];
    [currentBlock setIsCanRemoved:YES];
    
    NSArray *adjacentBlocksLocation = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:col-1],[NSNumber numberWithInt:row],[NSNumber numberWithInt:col],[NSNumber numberWithInt:row+1],[NSNumber numberWithInt:col+1],[NSNumber numberWithInt:row],[NSNumber numberWithInt:col],[NSNumber numberWithInt:row-1], nil];
    
    int maxColCount = allBlocksArr.count;
    for (int i=0; i<4; i++) {
        int newC = [[adjacentBlocksLocation objectAtIndex:i*2] intValue];
        int newR = [[adjacentBlocksLocation objectAtIndex:i*2+1] intValue];
        
        if (newC<=maxColCount && newC>0 && newR<=ROW && newR>0) {
            NSMutableArray *bs = [allBlocksArr objectAtIndex:newC-1];
            if (newR > bs.count) continue;
            
            Block *b = [bs objectAtIndex:newR-1];
            if (!b.isCheckedForColor && (b.colorIndex == colorId)) {
                [self getConjointBlocksWithColor:colorId atCol:newC atRow:newR];
            }
            [b setIsCheckedForColor:YES];
        }
    }
    
    return sameColorBlocksArr;
}

- (void) checkCanRemoveBlocks
{
    if (sameColorBlocksArr.count > (minCountForClear-1)) {
        [self doRemoveSameColorBlocksAction];
    } else {
        if ([self checkCanGoonPlay]) canSwitch = YES;
    }
}

- (void) doRemoveSameColorBlocksAction
{
    if (selectedFirecracker) {
        CCSprite *s = [sameColorBlocksArr objectAtIndex:0];
        CCSequence *seq = [CCSequence actions:[CCScaleTo actionWithDuration:.3 scale:0.001f],
                           [CCCallFunc actionWithTarget:self selector:@selector(refreshAllBlocks)],
                           nil];
        [s runAction:seq];
        [firecracker stopAllActions];
        selectedFirecracker = NO;
        return;
    }
    for (int i=0; i<sameColorBlocksArr.count; i++) {
        Block *b = [sameColorBlocksArr objectAtIndex:i];
        [mainView reorderChild:b z:1];
        b.scale = 1.5;
        CCSequence *seq = [CCSequence actions:[CCScaleTo actionWithDuration:.6 scale:0.001f],
                           i==0 ? [CCCallFunc actionWithTarget:self selector:@selector(updateScore)] : nil,
                           i==0 ? [CCCallFunc actionWithTarget:self selector:@selector(refreshAllBlocks)] : nil,
                           nil];
        int playX = (arc4random() % 220) + 50;
        //NSLog(@"playX is -----%d", playX);
        CCSequence *seq2 = [CCSequence actions:[CCMoveTo actionWithDuration:.6 position:ccp(playX, scoreText.position.y)],
                            [CCCallFuncND actionWithTarget:self selector:@selector(playFireWorkEffect:atLocationX:) data:playX],                            nil];
        //[b runAction:[CCMoveTo actionWithDuration:.6 position:scoreText.position]];
        [b runAction:seq];
        [b runAction:seq2];
    }
    
    if ([[self settingView] onsound]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"bomb.caf"];
    }
}

- (void) playFireWorkEffect: (int) sender atLocationX:(int) x
{
    //int playX = (arc4random() % 300) + 60;
    CCParticleSystem *s = [CCParticleSystemQuad particleWithFile:@"firework.plist"];
    s.position = ccp(x, scoreText.position.y - 20);
    [s setAutoRemoveOnFinish:YES];
    [mainView addChild:s z:5];
}


-(void) updateScore
{
    int getScore = scorebase*sameColorBlocksArr.count*(sameColorBlocksArr.count-1);
    //NSLog(@"score is %d and %d", score, getScore);
    score = score + getScore;
    [scoreNote setString:[NSString stringWithFormat:@"%d fireworks: %d", sameColorBlocksArr.count, getScore]];
    [scoreText setString:[NSString stringWithFormat:@"%d",score]];
}

-(void) refreshAllBlocks
{
    int m=0;
    while (m<allBlocksArr.count) {
        NSMutableArray *bs = [allBlocksArr objectAtIndex:m];
        int n = 0;
        while (n<bs.count) {
            if ([[bs objectAtIndex:n] isCanRemoved]) {
                [bs removeObjectAtIndex:n];
            } else {
                n++;
            }
        }
        
        if ([bs count] == 0) {
            [allBlocksArr removeObject:bs];
        } else {
            m++;
        }
    }
    
    for (int i=0; i<allBlocksArr.count; i++) {
        NSMutableArray *bs = [allBlocksArr objectAtIndex:i];
        //NSLog(@"%d col has %d blocks",i+1, bs.count);
        for (int j=0; j<bs.count; j++) {
            float x = BLOCK_W * (i+1);
            float y = BLOCK_H * j;
            Block *block = [bs objectAtIndex:j];
            block.position = ccp(x - block.contentSize.width/2, y + block.contentSize.height/2 + minY);
            [mainView reorderChild:block z:0];
        }
    }
    
    if ([self canContinueRemove]) {
        canSwitch = YES;
    } else {
        [self checkCanGoonPlay];
    }
    
}

- (BOOL) checkCanGoonPlay
{
    //|| remainingTime<=0
    if (![self canContinueRemove] ) {
        //NSLog(@"--call stack---%@",[NSThread callStackSymbols]);
        canSwitch = NO;
        if (score < target) {
            if (tryCount>0) {
                [levelEndText setString:[NSString stringWithFormat:@"You lost, can try %d %@", tryCount, tryCount==1 ? @"time" : @"times"]];
                [levelEndText setFontSize:20];
                level--;
                score = initScoreForNewLevel;
                tryCount--;
            } else {
                [levelEndText setString:@"You lost!"];
                [levelEndText setFontSize:35];
                level = 0;
                score = 0;
            }
        } else {
            tryCount = 3;
            [levelEndText setFontSize:35];
            [levelEndText setString:@"You win!"];
        }
        CCSequence *seq = [CCSequence actions:[CCScaleTo actionWithDuration:1 scale:1.0],
                           [CCScaleTo actionWithDuration:2 scale:1.0],
                           [CCScaleTo actionWithDuration:.5 scale:0.001f],
                           [CCCallFunc actionWithTarget:self selector:@selector(updateMainView)],nil];
        CCSequence *seq2 = [CCSequence actions:[CCScaleTo actionWithDuration:1 scale:1.8],
                           [CCScaleTo actionWithDuration:2 scale:1.8],
                           [CCScaleTo actionWithDuration:.5 scale:0.001f],nil];
        [endTextBg runAction:seq2];
        [levelEndText runAction:seq];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL) canContinueRemove
{
    int caCount=0,cbCount=0,ccCount=0,cdCount=0,ceCount=0,cfCount=0;
    for (int i=0; i<allBlocksArr.count; i++) {
        NSMutableArray * bs = [allBlocksArr objectAtIndex:i];
        for (int j=0; j<bs.count; j++) {
            int color = [[bs objectAtIndex:j] colorIndex];
            switch (color) {
                case 0:
                    caCount++;
                    break;
                case 1:
                    cbCount++;
                    break;
                case 2:
                    ccCount++;
                    break;
                case 3:
                    cdCount++;
                    break;
                case 4:
                    ceCount++;
                    break;
                case 5:
                    cfCount++;
                default:
                    break;
            }

            /*
            if ( canSwitchCount > 0 && (caCount>=minCountForClear || cbCount>=minCountForClear || ccCount>=minCountForClear
                                        || ceCount>=minCountForClear || cdCount>=minCountForClear || cfCount>=minCountForClear)) {
                return YES;
            }
            */
        }
        
    }
    
    int switchBlockColor = switchedBlock.colorIndex;
    int willSwitchColorCount = 0;
    switch (switchBlockColor) {
        case 0:
            caCount++;
            willSwitchColorCount = caCount;
            break;
        case 1:
            cbCount++;
            willSwitchColorCount = cbCount;
            break;
        case 2:
            ccCount++;
            willSwitchColorCount = ccCount;
            break;
        case 3:
            cdCount++;
            willSwitchColorCount = cdCount;
            break;
        case 4:
            ceCount++;
            willSwitchColorCount = ceCount;
            break;
        case 5:
            cfCount++;
            willSwitchColorCount = cfCount;
        default:
            break;
    }
    
    /*
    if ( canSwitchCount > 0 && (caCount>=minCountForClear || cbCount>=minCountForClear || ccCount>=minCountForClear
                                || ceCount>=minCountForClear || cdCount>=minCountForClear || cfCount>=minCountForClear)) {
        return YES;
    }
     */
    
    if (canSwitchCount > 0 && willSwitchColorCount>=minCountForClear && [self getAllBlockCount]>1) {
        return YES;
    }
    
    return NO;
}

- (int) getAllBlockCount
{
    int count = 0;
    for (int i=0; i<allBlocksArr.count; i++) {
        NSMutableArray * bs = [allBlocksArr objectAtIndex:i];
        for (int j=0; j<bs.count; j++) {
            count ++;
        }
    }
    return count;
}

- (void) animateFirecracker
{
    CCSequence *seq = [CCSequence actions:[CCScaleTo actionWithDuration:.5 scale:1.2],
                   [CCScaleTo actionWithDuration:.5 scale:1.0],nil];
    [firecracker runAction:[CCRepeatForever actionWithAction:seq]];
    selectedFirecracker = YES;
}

- (void) showSetting
{
    
    if ([[self settingView] scaleX] < 1) {
        [[self settingView] setScaleX:1.0];
        //[[self settingView] runAction:[CCScaleBy actionWithDuration:3 scaleX:1.0 scaleY:1.0]];
    } else {
        [[self settingView] setScaleX:0.001];
        //[[self settingView] runAction:[CCScaleTo actionWithDuration:0.2 scale:0.001]];
    }
}

-(void) enableMenu:(BOOL) isEnabled
{
    [firecrackerItem setIsEnabled:isEnabled && firecrackerCount>0];
    [settingItem setIsEnabled:isEnabled];
}

@end
