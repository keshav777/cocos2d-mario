//
//  World.m
//  cocos2d-mario
//
//  Created by Mark Stultz on 9/16/12.
//
//

#import "World.h"
#import "CCTMXTiledMap.h"

@implementation World

- (id)init
{
	self = [super init];
	if( self != NULL )
	{
		m_tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"world.tmx"];
		[self addChild:m_tiledMap];
		
		for( CCTMXLayer* child in [m_tiledMap children] )
		{
			[[child texture] setAliasTexParameters];
		}
	}
	
	return self;
}

@end
