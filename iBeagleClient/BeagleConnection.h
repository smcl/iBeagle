//
//  BeagleConnection.h
//  iBeagleClient
//
//  Created by Sean McLemon on 22/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BeagleConnection

-(void)sendInputToBeagle:(NSArray*)input;

@end
