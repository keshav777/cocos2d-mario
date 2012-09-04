//
//  Playe.m
//  Bandai
//
//  Created by Mark Stultz on 8/31/12.
//
//

#import "Player.h"
#import "Background.h"
#import "CCActionInterval.h"
#import "CCAnimation.h"
#import "CCDirector.h"
#import "CCParallaxNode.h"
#import "CCSprite.h"
#import "CCSpriteFrameCache.h"

@implementation Player

- (id)init
{
	self = [super init];
	if( self != NULL )
	{
		CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[spriteFrameCache addSpriteFramesWithFile:@"player.plist"];
		
		CCSpriteFrame *playerSpriteFrame = [spriteFrameCache spriteFrameByName:@"mario_01.png"];
		m_playerSize = playerSpriteFrame.rectInPixels.size;		
		m_playerFlipped = NO;
		m_playerSprite = [CCSprite spriteWithSpriteFrame:playerSpriteFrame];
		
		CCAnimation *animation = [CCAnimation animation];
		[animation addSpriteFrame:[spriteFrameCache spriteFrameByName:@"mario_01.png"]];
		[animation addSpriteFrame:[spriteFrameCache spriteFrameByName:@"mario_02.png"]];
		[animation addSpriteFrame:[spriteFrameCache spriteFrameByName:@"mario_03.png"]];
		[animation addSpriteFrame:[spriteFrameCache spriteFrameByName:@"mario_02.png"]];

		animation.delayPerUnit = ( 1.0f / 60.0f ) * animation.frames.count;
		animation.restoreOriginalFrame = YES;
		
		id walkAnim = [CCAnimate actionWithAnimation:animation];
		id walkSeq = [CCSequence actions: walkAnim, nil];
		m_walkAction = [CCRepeatForever actionWithAction:walkSeq];
		
		[m_playerSprite runAction:m_walkAction];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[m_playerSprite setPosition:CGPointMake( winSize.width * 0.5f, winSize.height * 0.5f )];

		[m_playerSprite setScale:2.0f];
		[m_playerSprite.texture setAliasTexParameters];

		[self addChild:m_playerSprite z:1];
	}
	
	return self;
}

- (void)dealloc
{
	[m_playerSprite release];
	[super dealloc];
}

@end
