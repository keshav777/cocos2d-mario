//
//  Game.m
//  Bandai
//
//  Created by Mark Stultz on 9/3/12.
//
//

#import "Game.h"
#import "Background.h"
#import "GameConstants.h"
#import "Player.h"
#import "CCDirector.h"
#import "CCScene.h"

@interface Game (Private)

- (void)updateMovement;
- (void)updateCamera;

@end

@implementation Game

- (id)init
{
	self = [super init];
	if( self != NULL )
	{
		self.anchorPoint = CGPointZero;
		self.scale = gameSizeScale;
		[self setContentSize:CGSizeMake( gameWidth * gameSizeScale, gameHeight * gameSizeScale )];

		m_player = [[Player alloc] init];
		m_background = [[Background alloc] init];
		
		[self addChild:m_player z:1];
		[self addChild:m_background z:-1];
		
		m_worldRect = CGRectMake( 0.0f, 0.0f, gameWidth * 10.0f, gameHeight );
		m_cameraRect = CGRectMake( 0.0f, 0.0f, gameWidth, gameHeight );
		
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
	[self updateMovement];
	[self updateCamera];
	[m_player update:deltaTime];

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
				m_movingLeft = YES;
				return YES;

			case 's':
			case 'S':
			case NSDownArrowFunctionKey:
				NSLog( @"s" );
				return YES;

			case 'd':
			case 'D':
			case NSRightArrowFunctionKey:
				m_movingRight = YES;
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
				m_movingLeft = NO;
				return YES;

			case 's':
			case 'S':
			case NSDownArrowFunctionKey:
				NSLog( @"s" );
				return YES;

			case 'd':
			case 'D':
			case NSRightArrowFunctionKey:
				m_movingRight = NO;
				return YES;
			
			default:
				return NO;
		}
	}

	return NO;
}

- (void)updateMovement
{
	if( m_movingLeft && m_movingRight )
	{
	//	[m_player setIdle];
	}
	else if( m_movingLeft )
	{
		[m_player moveLeft];
	
		//CGPoint position = m_player.position;
		//position.x = MAX( 0.0f, position.x - m_moveSpeed );
		//m_player.position = position;
		//[m_player setRunning];
	}
	else if( m_movingRight )
	{
		[m_player moveRight];
	
		// TODO-MAS: Clamp to world bounds
		//CGPoint position = m_player.position;
		//position.x = position.x + m_moveSpeed;
		//m_player.position = position;
		//[m_player setRunning];
	}
	else
	{
		[m_player setIdle];
	}
}

- (void)updateCamera
{
	
}

@end
