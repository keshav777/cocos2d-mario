//
//  Game.m
//  Bandai
//
//  Created by Mark Stultz on 9/3/12.
//
//

#import "Game.h"
#import "Background.h"
#import "Player.h"
#import "CCDirector.h"
#import "CCScene.h"

@interface Game (Private)

- (void)setMovingLeft:(BOOL)moving;
- (void)setMovingRight:(BOOL)moving;
- (void)moveLeft;
- (void)moveRight;

@end

@implementation Game

- (id)init
{
	self = [super init];
	if( self != NULL )
	{
		m_player = [[Player alloc] init];
		m_background = [[Background alloc] init];
		
		[self addChild:m_player z:1];
		[self addChild:m_background z:-1];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		m_worldRect = CGRectMake( 0.0f, 0.0f, winSize.width * 10.0f, winSize.height );
		m_cameraRect = CGRectMake( 0.0f, 0.0f, winSize.width, winSize.height );
		
		m_moveSpeed = 2.0f;
		
		m_movingLeft = NO;
		m_movingRight = NO;
		
		[self scheduleUpdate];
		
		self.isKeyboardEnabled = YES;
	}
	
	return self;
}

- (void)dealloc
{
	[m_player release];
	[m_background release];
	[super dealloc];
}

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	[scene addChild:[Game node]];
	return scene;
}

- (void)update:(ccTime)deltaTime
{
	[m_background updateFromRect:m_cameraRect];
}

- (BOOL)ccKeyDown:(NSEvent *)event
{
	NSString *characters = [event charactersIgnoringModifiers];
	if( [characters length] == 1 )
	{
		unichar keyChar = [characters characterAtIndex:0];
		switch( keyChar )
		{
			case 'w':
			case 'W':
			case NSUpArrowFunctionKey:
				return YES;
			
			case 'a':
			case 'A':
			case NSLeftArrowFunctionKey:
				[self setMovingLeft:YES];
				return YES;

			case 's':
			case 'S':
			case NSDownArrowFunctionKey:
				NSLog( @"s" );
				return YES;

			case 'd':
			case 'D':
			case NSRightArrowFunctionKey:
				[self setMovingRight:YES];
				return YES;
			
			default:
				return NO;
		}
	}

	return NO;
}

- (BOOL)ccKeyUp:(NSEvent*)event
{
	NSString *characters = [event charactersIgnoringModifiers];
	if( [characters length] == 1 )
	{
		unichar keyChar = [characters characterAtIndex:0];
		switch( keyChar )
		{
			case 'w':
			case 'W':
			case NSUpArrowFunctionKey:
				return YES;
			
			case 'a':
			case 'A':
			case NSLeftArrowFunctionKey:
				[self setMovingLeft:NO];
				return YES;

			case 's':
			case 'S':
			case NSDownArrowFunctionKey:
				NSLog( @"s" );
				return YES;

			case 'd':
			case 'D':
			case NSRightArrowFunctionKey:
				[self setMovingRight:NO];
				return YES;
			
			default:
				return NO;
		}
	}

	return NO;
}


- (void)setMovingLeft:(BOOL)moving
{
	if( moving != m_movingLeft )
	{
		m_movingLeft = moving;
		if( m_movingLeft )
		{
			[self schedule:@selector(moveLeft)];
		}
		else
		{
			[self unschedule:@selector(moveLeft)];
		}
	}
}

- (void)setMovingRight:(BOOL)moving
{
	if( moving != m_movingRight )
	{
		m_movingRight = moving;
		if( m_movingRight )
		{
			[self schedule:@selector(moveRight)];
		}
		else
		{
			[self unschedule:@selector(moveRight)];
		}
	}
}

- (void)moveLeft
{
	m_cameraRect.origin.x = MAX( 0.0f, m_cameraRect.origin.x - m_moveSpeed );
}

- (void)moveRight
{
	// TODO-MAS: Clamp to world bounds
	m_cameraRect.origin.x = m_cameraRect.origin.x + m_moveSpeed;
}

@end
