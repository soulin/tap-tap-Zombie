//
//  LoadingLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 29.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "MainMenuLoadingScene.h"
#import "MainMenuLayer.h"


@implementation MainMenuLoadingScene

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        CCSprite *back = [CCSprite spriteWithFile: @"Default.png"];
        back.rotation = 90;
        back.position = kScreenCenter;
        [self addChild: back];
        
        CCLabelBMFont *loadingLabel = [CCLabelBMFont labelWithString: @"loading..." fntFile: kFontDefault];
        loadingLabel.position = kScreenCenter;
        [self addChild: loadingLabel];
        loadingLabel.anchorPoint = ccp(1, 0);
        loadingLabel.position = ccp(kScreenWidth - 8.0f, 8.0f);
    }
    
    return self;
}

+ (MainMenuLoadingScene *) scene
{
    return [[[self alloc] init] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

- (void) onEnter
{
    [super onEnter];
    
    [self runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: 0.5f],
                                [CCCallFunc actionWithTarget: self selector: @selector(cleanMemoryAndLoadMainMenuScene)],
                                nil
                ]
    ];
}

- (void) cleanMemoryAndLoadMainMenuScene
{
    [[CCDirector sharedDirector] purgeCachedData];
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [[CCDirector sharedDirector] replaceScene:
                                        [CCTransitionFade transitionWithDuration: 0.3f 
                                                                           scene: [MainMenuLayer scene] 
                                                                       withColor: ccc3(0, 0, 0)
                                        ]
    ];
}

@end
