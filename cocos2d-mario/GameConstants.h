//
//  GameConstants.h
//  cocos2d-mario
//
//  Created by Mark Stultz on 9/8/12.
//
//

static const float gameWidth = 256.0f;
static const float gameHeight = 224.0f;
static const float gameSizeScale = 4.0f;
static const float framesPerSecond = 40.0f;
static const float playerAcc = 60.0f;
static const float playerVelScale = 2.5f;
static const float playerMaxWalkVel = 19.5f;
static const float playerMaxOscWalkVel = 21.0f;
static const int oscillationFrameCount = 5;
static const float oscillationFrameDuration = 1.0f / framesPerSecond;
static const float oscillationAccTable[ oscillationFrameCount ] = { 60.0f, -40.0f, -40.0f, 60.0f, -40.0f };
static const float maxWalkFrameDuration = 6.0f * ( 1.0f / framesPerSecond );
static const int maxWalkFrameCount = 3;