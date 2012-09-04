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

@interface Player : CCLayer
{
	CGSize m_playerSize;
	BOOL m_playerFlipped;
	CCSprite *m_playerSprite;
	CCAction *m_walkAction;
	CCAction *m_runAction;
	
	CCSprite *m_backgroundSprite;
	CCSprite *m_backgroundSprite2;
}


@end
