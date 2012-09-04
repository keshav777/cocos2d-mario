//
//  Game.h
//  Bandai
//
//  Created by Mark Stultz on 9/3/12.
//
//

#import "CCLayer.h"

@class Background;
@class Player;
@class CCScene;

@interface Game : CCLayer
{
@private
	Player *m_player;
	Background *m_background;
	CGRect m_worldRect;
	CGRect m_cameraRect;
	float m_moveSpeed;
	
	BOOL m_movingLeft;
	BOOL m_movingRight;
}

+ (CCScene *)scene;

@end
