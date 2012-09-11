//
//  AppDelegate.m
//  Bandai
//
//  Created by Mark Stultz on 8/30/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "AppDelegate.h"
#import "Game.h"
#import "GameConstants.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize glView = _glView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSRect rect = NSMakeRect( 0.0f, 0.0f, gameWidth * gameSizeScale, gameHeight * gameSizeScale );
	self.window = [[NSWindow alloc] initWithContentRect:rect styleMask:
		(NSWindowCloseButton | NSWindowMiniaturizeButton) backing:NSBackingStoreBuffered defer:YES];
	
	self.glView = [[CCGLView alloc] initWithFrame:rect shareContext:nil];
	[self.window setContentView:self.glView];

	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	[director setProjection:kCCDirectorProjection2D];
	[director setDisplayStats:YES];
	[director setView:_glView];

	// EXPERIMENTAL stuff.
	// 'Effects' don't work correctly when autoscale is turned on.
	// Use kCCDirectorResize_NoScale if you don't want auto-scaling.
	//[director setResizeMode:kCCDirectorResize_AutoScale];
	
	// Enable "moving" mouse event. Default no.
	[_window setAcceptsMouseMovedEvents:NO];
	
	// Center main window
	[_window setTitle:@"Mario"];
	[_window center];
	[_window makeKeyAndOrderFront:self];
	
	CCScene *scene = [Game scene];
	[director runWithScene:scene];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
	return YES;
}

- (void)dealloc
{
	[[CCDirector sharedDirector] end];
	[_window release];
	[super dealloc];
}

#pragma mark AppDelegate - IBActions

- (IBAction)toggleFullScreen: (id)sender
{
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	[director setFullScreen: ! [director isFullScreen] ];
}

@end
