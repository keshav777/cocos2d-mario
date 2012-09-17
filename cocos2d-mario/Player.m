//
//  Playe.m
//  Bandai
//
//  Created by Mark Stultz on 8/31/12.
//
//

#import "CCActionInterval.h"
#import "CCActionInstant.h"
#import "CCAnimation.h"
#import "CCDirector.h"
#import "CCParallaxNode.h"
#import "CCSprite.h"
#import "CCSpriteFrameCache.h"
#import "Player.h"
#import "Background.h"
#import "GameConstants.h"
#import "World.h"

@interface Player (Private)

- (void)buildPlayerSprite;
- (void)updateVelocity:(float)deltaTime;
- (void)updateSprite:(float)deltaTime;

@end

@implementation Player

@synthesize position = m_position;

- (id)initWithWorld:(World *)world;
{
	self = [super init];
	if( self != NULL )
	{
		m_position = CGPointZero;
		m_size = CGSizeZero;
		m_flipped = NO;
		m_velocity = 0.0f;
		m_targetVelocity = 0.0f;
		m_oscillationTime = 0.0f;
		m_oscillationIndex = 0;
		m_maxWalkAnimTime = 0.0f;
		m_maxWalkAnimIndex = 0;
		m_dir = Right;
		m_state = Idle;
		m_playerSprite = NULL;
		m_frames = [[NSMutableArray alloc] init];
		m_world = world;
		
		[self buildPlayerSprite];
		
		[self addChild:m_playerSprite z:1];
	}
	
	return self;
}

- (void)update:(ccTime)deltaTime
{
	CGPoint position = m_position;
	position.x += m_velocity * playerVelScale * deltaTime;
	[self setPosition:position];

	[self updateVelocity:deltaTime];
	[self updateSprite:deltaTime];
}

- (void)dealloc
{
	[m_playerSprite release];
	[m_frames release];
	[super dealloc];
}

- (void)moveLeft
{
	if( m_targetVelocity == -playerMaxWalkVel )
	{
		return;
	}

	m_targetVelocity = -playerMaxWalkVel;
	m_state = Walking;

	if( m_dir != Left )
	{
		m_dir = Left;
		m_playerSprite.flipX = YES;
	}
}

- (void)moveRight
{
	if( m_targetVelocity == playerMaxWalkVel )
	{
		return;
	}

	m_targetVelocity = playerMaxWalkVel;
	m_state = Walking;
	
	if( m_dir != Right )
	{
		m_dir = Right;
		m_playerSprite.flipX = NO;
	}
}

- (void)setPosition:(CGPoint)position
{
	if( !CGPointEqualToPoint( position, m_position ) )
	{
		m_position = position;
		CGPoint pixelPos = m_position;
		pixelPos.x = floor( pixelPos.x );
		[m_playerSprite setPosition:pixelPos];
		
		
	}
}

- (void)setIdle
{
	m_targetVelocity = 0.0f;
	m_state = Idle;
}

- (void)buildPlayerSprite
{
	CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[spriteFrameCache addSpriteFramesWithFile:@"player.plist"];
	
	CCSpriteFrame *frame1 = [spriteFrameCache spriteFrameByName:@"mario_01.png"];
	CCSpriteFrame *frame2 = [spriteFrameCache spriteFrameByName:@"mario_02.png"];
	CCSpriteFrame *frame3 = [spriteFrameCache spriteFrameByName:@"mario_03.png"];
	
	[m_frames insertObject:frame1 atIndex:0];
	[m_frames insertObject:frame2 atIndex:1];
	[m_frames insertObject:frame3 atIndex:2];
	
	m_size = frame1.rectInPixels.size;
	m_playerSprite = [[CCSprite spriteWithSpriteFrame:frame1] retain];
	[m_playerSprite.texture setAliasTexParameters];
	m_playerSprite.anchorPoint = CGPointZero;
}

- (void)updateVelocity:(float)deltaTime
{
	float toTargetVel = m_targetVelocity - m_velocity;

	switch( m_state )
	{
		case Idle:
			{
				Direction dir = signbit( toTargetVel ) ? Left : Right;
				if( dir == Left )
				{
					m_velocity = MAX( 0.0f, m_velocity - ( playerAcc * deltaTime ) );
				}
				else
				{
					m_velocity = MIN( 0.0f, m_velocity + ( playerAcc * deltaTime ) );
				}
			}
			break;
		case Walking:
			{
				Direction dir = signbit( toTargetVel ) ? Left : Right;
				if( dir == Left )
				{
					m_velocity = MAX( -playerMaxWalkVel, m_velocity - ( playerAcc * deltaTime ) );
				}
				else
				{
					m_velocity = MIN( playerMaxWalkVel, m_velocity + ( playerAcc * deltaTime ) );
				}
				
				if( ABS( m_velocity ) == playerMaxWalkVel )
				{
					m_state = WalkingMax;
					m_oscillationTime = 0.0f;
				}
			}
			break;
		case WalkingMax:
			{
				float oscillationTimeToProcess = deltaTime;
				while( oscillationTimeToProcess > 0.0f )
				{
					float oscillationFrameEnd = ( m_oscillationIndex + 1 ) * oscillationFrameDuration;
					float timeToEndOfOscillationFrame = MIN( oscillationTimeToProcess, oscillationFrameEnd - m_oscillationTime );
					float oscillationAcc = oscillationAccTable[ m_oscillationIndex ];

					if( m_dir == Left )
					{
						m_velocity = MAX( -playerMaxOscWalkVel, m_velocity - ( oscillationAcc * timeToEndOfOscillationFrame ) );
					}
					else
					{
						m_velocity = MIN( playerMaxOscWalkVel, m_velocity + ( oscillationAcc * timeToEndOfOscillationFrame ) );
					}
					
					m_oscillationTime += timeToEndOfOscillationFrame;
					if( m_oscillationTime >= oscillationFrameEnd )
					{
						++m_oscillationIndex;
						if( m_oscillationIndex >= oscillationFrameCount )
						{
							m_oscillationTime -= ( (float)oscillationFrameCount ) * oscillationFrameDuration;
							m_oscillationIndex = 0;
						}
					}

					oscillationTimeToProcess -= timeToEndOfOscillationFrame;
				}				
			}
			break;
	}
}

- (void)updateSprite:(float)deltaTime
{
/*
	if( m_velocity != 0.0f )
	{
		if( ABS( m_velocity ) < 3.0f )
		{
			[m_playerSprite setDisplayFrame:[m_frames objectAtIndex:0]];
		}
		else if( m_velocity < playerMaxWalkVel )
		{
			[m_playerSprite setDisplayFrame:[m_frames objectAtIndex:1]];
		}
	}*/
	
	switch( m_state )
	{
		case Idle:
			[m_playerSprite setDisplayFrame:[m_frames objectAtIndex:0]];
			break;
		case Walking:
			{
				if( ABS( m_velocity ) < 3.0f )
				{
					[m_playerSprite setDisplayFrame:[m_frames objectAtIndex:0]];
				}
				else
				{
					[m_playerSprite setDisplayFrame:[m_frames objectAtIndex:2]];
				}
				
				m_maxWalkAnimTime = 0.0f;
				m_maxWalkAnimIndex = 1;
			}
			break;
		case WalkingMax:
			{
				m_maxWalkAnimTime += deltaTime;
				while( m_maxWalkAnimTime >= maxWalkFrameDuration )
				{
					m_maxWalkAnimTime = MAX( 0.0f, m_maxWalkAnimTime - maxWalkFrameDuration );
					--m_maxWalkAnimIndex;
					if( m_maxWalkAnimIndex < 0 )
					{
						m_maxWalkAnimIndex = 2;
					}
				}
				
				[m_playerSprite setDisplayFrame:[m_frames objectAtIndex:m_maxWalkAnimIndex]];
			}
			break;
	}
}

@end
