//
//  HelloWorldLayer.m
//  Boxes
//
//  Created by Bob Bonifield on 9/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [self setIsAccelerometerEnabled:YES];
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
        [self scheduleUpdate];
        
        _hero = [CCSprite spriteWithFile:@"hero.png"];
        CGSize frame = [[CCDirector sharedDirector] winSize];
        [_hero setPosition:ccp(frame.width/2, 30)];
        
        [self addChild:_hero];
        
        __block CCSprite *box = [CCSprite spriteWithFile:@"box-100x100.png"];
        [box setPosition:ccp(frame.width/4*3, frame.height-30)];
        
        [self addChild:box];
        
        
        CCMoveTo *move = [CCMoveTo actionWithDuration:2.0 position:ccp(frame.width/4*3, -box.contentSize.height/2)];
        CCCallFunc *func = [CCCallBlock actionWithBlock:^{
            [self removeChild:box cleanup:YES];
        }];
        
        [box runAction:[CCSequence actions:move, func, nil]];
	}
	return self;
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    Float32 accelarationFraction = acceleration.x * 6;
    if (accelarationFraction < -1) {
        accelarationFraction = -1;
    } else if (accelarationFraction > 1) {
        accelarationFraction = 1;
    }
    _rate = accelarationFraction;
}

- (void) update:(ccTime)deltaTime {
    CGPoint curPosition = _hero.position;
    if (curPosition.x <= 0 && _rate < 0) {
        return;
    } else if (curPosition.x >= [[CCDirector sharedDirector] winSize].width && _rate > 0) {
        return;
    }
    
    float moveBy = 8 * pow(_rate, 3);
    if (abs(moveBy) < 0.05) {
        moveBy = 0;
    }
    curPosition.x += moveBy;
    [_hero setPosition:curPosition];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
