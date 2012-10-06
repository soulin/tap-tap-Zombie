//
//  GameScene.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "GameScene.h"

#import "GameLayer.h"
#import "HUDLayer.h"

#import "MainMenuLayer.h"

#import "GamePausePopup.h"
#import "GameOverPopup.h"

#import "MapCache.h"


@implementation GameScene

@synthesize gameOverStatus;

#pragma mark init and dealloc
- (id) initWithMap: (Map *) map_
{
    if(self = [super init])
    {
        gameLayer = [GameLayer gameLayerWithDelegate: self andMap: map_];
        [self addChild: gameLayer];
        
        hudLayer = [HUDLayer hudLayerWithDelegate: self];
        [self addChild: hudLayer];
        
        map = [map_ retain];
    }
    
    return self;
}

+ (id) gameSceneWithMap: (Map *) map
{
    return [[[self alloc] initWithMap: map] autorelease];
}

- (void) dealloc
{
    [map release];
    
    [super dealloc];
}

- (void) reset
{
    isGameOver = NO;
    success = 0;
    gameOverStatus.isFailed = NO;
}

#pragma mark -

- (void) gameOver
{
    isGameOver = YES;
    gameOverStatus.isFailed = success == kMinSuccess;
    [[MapCache sharedMapCache] mapInfoAtIndex: map.index].isPassed = !gameOverStatus.isFailed;
    [[MapCache sharedMapCache] saveMapsInfo];
    [GameOverPopup showOnRunningSceneWithDelegate: self];
}

#pragma mark -

#pragma mark CCPopupLayerDelegate methods implementation
- (void) popupWillOpen: (CCPopupLayer *) popup
{
    [gameLayer pauseSchedulerAndActionsWithChildren];
    [gameLayer disableWithChildren];
    
    [hudLayer pauseSchedulerAndActionsWithChildren];
    [hudLayer disableWithChildren];
}

- (void) popupDidFinishClosing:(CCPopupLayer *)popup
{
    [gameLayer resumeSchedulerAndActionsWithChildren];
    [gameLayer enableWithChildren];
    
    [hudLayer resumeSchedulerAndActionsWithChildren];
    [hudLayer enableWithChildren];
}

#pragma mark HUDLayerDelegate methods implementation
- (void) pause
{
    [GamePausePopup showOnRunningSceneWithDelegate: self];
}

#pragma mark GamePausePopupDelegate and GameOverPopupDelegate methods implementation
- (void) exit
{
    // go to main menu
    CCTransitionFade *sceneTransition = [CCTransitionFade transitionWithDuration: 0.3f
                                                                           scene: [MainMenuLayer scene]
                                                                       withColor: ccc3(0, 0, 0)];
    
    [[CCDirector sharedDirector] replaceScene: sceneTransition];
}

- (void) restart
{
    [self reset];
    [gameLayer reset];
    [hudLayer setProgressScaleValue: success];
}

#pragma mark GameLayerDelegate methods implementation
- (void) giveAward: (float) award
{
    if(isGameOver) return;
    
    success += award;
    
    success = success < kMinSuccess ? kMinSuccess : success > kMaxSuccess ? kMaxSuccess : success;
    
    [hudLayer setProgressScaleValue: success];
    
    if((success == kMinSuccess) || (success == kMaxSuccess))
    {
        [self gameOver];
    }
}

#pragma mark -

@end
