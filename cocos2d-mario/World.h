//
//  World.h
//  cocos2d-mario
//
//  Created by Mark Stultz on 9/16/12.
//
//

#import "CCLayer.h"

@class CCTMXTiledMap;

@interface World : CCLayer
{
@private
	CCTMXTiledMap *m_tiledMap;
}

@end
