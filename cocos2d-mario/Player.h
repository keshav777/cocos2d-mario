//
//  Player.h
//  Bandai
//
//  Created by Mark Stultz on 8/31/12.
//
//

#import "CCLayer.h"

@class CCAction;
@class CCScene;
@class CCSprite;

typedef enum
{
	Left,
	Right,
} Direction;

typedef enum
{
	Idle,
	Walking,
	WalkingMax,
} State;

@interface Player : CCLayer
{
	CGPoint m_position;
	CGSize m_size;
	BOOL m_flipped;
	float m_velocity;
	float m_targetVelocity;
	float m_oscillationTime;
	int m_oscillationIndex;
	float m_maxWalkAnimTime;
	int m_maxWalkAnimIndex;
	Direction m_dir;
	State m_state;
	CCSprite *m_playerSprite;
	NSMutableArray *m_frames;
}

@property (nonatomic, assign) CGPoint position;

- (void)update:(ccTime)deltaTime;

- (void)setIdle;
- (void)moveLeft;
- (void)moveRight;

@end
