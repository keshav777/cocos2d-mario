//
//  Background.m
//  Bandai
//
//  Created by Mark Stultz on 9/3/12.
//
//

#import "Background.h"
#import "GameConstants.h"
#import "CCDirector.h"
#import "CCSprite.h"
#import "CCTextureCache.h"

@implementation Background

- (id)init
{
	self = [super init];
	if( self != NULL )
	{
		m_bgSprites = [[NSMutableArray alloc] init];

		CCTexture2D *bgTexture = [[CCTextureCache sharedTextureCache] addImage:@"background.png"];
		[bgTexture setAliasTexParameters];
		m_bgSize = CGSizeMake( bgTexture.pixelsWide, bgTexture.pixelsHigh );
		int numImages = ceil( gameWidth / m_bgSize.width ) + 1;
		for( int ii = 0; ii < numImages; ++ii )
		{
			CCSprite *bgSprite = [CCSprite spriteWithTexture:bgTexture];
			bgSprite.anchorPoint = CGPointZero;

			[m_bgSprites addObject:bgSprite];
			[self addChild:bgSprite z:0];
		}
	}
	
	return self;
}

- (void)dealloc
{
	[m_bgSprites release];
	[super dealloc];
}

- (void)updateFromRect:(CGRect)rect
{
	float xOffset = rect.origin.x;
	while( xOffset >= gameWidth )
	{
		xOffset -= m_bgSize.width;
	}
	
	if( xOffset > 0.0f )
	{
		xOffset = -xOffset;
	}
	
	for( CCSprite *bgSprite in m_bgSprites )
	{
		[bgSprite setPosition:CGPointMake( xOffset, 0.0f )];
		xOffset += m_bgSize.width;
	}	
}

@end
