//
//  Playe.m
//  Bandai
//
//  Created by Mark Stultz on 8/31/12.
//
//

#import "Player.h"
#import "Background.h"
#import "GameConstants.h"
#import "CCActionInterval.h"
#import "CCActionInstant.h"
#import "CCAnimation.h"
#import "CCDirector.h"
#import "CCParallaxNode.h"
#import "CCSprite.h"
#import "CCSpriteFrameCache.h"

static const int sc_oscillationFrameCount = 5;
static const float sc_oscillationTimeDuration = framesPerSecond * (float)sc_oscillationFrameCount;
static const float sc_topSpeedOscillation[ sc_oscillationFrameCount ] = { 1.0f, 3.0f, 2.0f, 1.0f, 2.0f };

@interface Player (Private)

- (void)buildPlayerSprite;
- (void)buildRunAction;

- (void)onRunAnimReachedLastFrame;

@end

@implementation Player

@synthesize position = m_position;

- (id)init
{
	self = [super init];
	if( self != NULL )
	{
		m_position = CGPointZero;
		m_size = CGSizeZero;
		m_flipped = NO;
		m_velocity = 0.0f;
		m_targetVelocity = 0.0f;
		m_dir = Right;
		m_state = Idle;
		m_playerSprite = NULL;
		m_frames = [[NSMutableArray alloc] init];
		
		[self buildPlayerSprite];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[self setPosition:CGPointMake( winSize.width * 0.5f, winSize.height * 0.5f )];

		[self addChild:m_playerSprite z:1];
	}
	
	return self;
}

- (void)update:(ccTime)deltaTime
{
	CGPoint position = m_position;
	position.x += m_velocity * playerVelScale * deltaTime;
	[self setPosition:position];

	if( m_velocity != m_targetVelocity )
	{
		bool movingLeft = signbit( m_targetVelocity - m_velocity );
		if( m_state == Moving )
		{
			if( movingLeft )
			{
				m_velocity = MAX( -playerMaxWalkVel, m_velocity - ( playerAcc * deltaTime ) );
			}
			else
			{
				m_velocity = MIN( playerMaxWalkVel, m_velocity + ( playerAcc * deltaTime ) );
			}
		}
		else if( m_state == Idle )
		{
			if( movingLeft )
			{
				m_velocity = MAX( 0.0f, m_velocity - ( playerAcc * deltaTime ) );
			}
			else
			{
				m_velocity = MIN( 0.0f, m_velocity + ( playerAcc * deltaTime ) );
			}
		}
		
		//NSLog( @"m_velocity: %f | m_position.x: %f\n", m_velocity, m_position.x );
	}
}

- (void)dealloc
{
	[m_playerSprite release];
	[m_frames release];
	[super dealloc];
}

- (void)moveLeft
{
	m_targetVelocity = -playerMaxWalkVel;
	m_state = Moving;
}

- (void)moveRight
{
	m_targetVelocity = playerMaxWalkVel;
	m_state = Moving;
}

- (void)setPosition:(CGPoint)position
{
	if( !CGPointEqualToPoint( position, m_position ) )
	{
		m_position = position;
		[m_playerSprite setPosition:m_position];
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
	m_playerSprite = [CCSprite spriteWithSpriteFrame:frame1];
	[m_playerSprite setScale:2.0f];
	[m_playerSprite.texture setAliasTexParameters];
}

@end
