//
//  TestBeagleConnection.h
//  iBeagleClient
//
//  Created by Sean McLemon on 22/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import "BeagleConnection.h"
#import "GCDAsyncSocket.h"

@interface ManualBeagleConnection : NSObject <BeagleConnection>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSString *hostname;
@property (nonatomic) NSInteger port;

-(id) init;
-(id) initWithHostname:(NSString *)name withPort:(long)port;

@end
