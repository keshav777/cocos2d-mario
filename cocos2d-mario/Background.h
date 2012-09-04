//
//  Background.h
//  Bandai
//
//  Created by Mark Stultz on 9/3/12.
//
//

#import "CCLayer.h"

@class CCScene;

@interface Background : CCLayer
{
@private
	CGSize m_bgSize;
	NSMutableArray *m_bgSprites;
}

- (void)updateFromRect:(CGRect)rect;

@end

