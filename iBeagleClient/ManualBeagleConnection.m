//
//  TestBeagleConnection.m
//  iBeagleClient
//
//  Created by Sean McLemon on 22/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import "ManualBeagleConnection.h"

@implementation ManualBeagleConnection

-(id) init {
    // default test setup = beaglebone.local:50000
    return [self initWithHostname:@"beaglebone.local" withPort:50000];
}

-(id) initWithHostname:(NSString *)name withPort:(long)port {
    self = [super init];
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.hostname = name;
    self.port = port;
    
    return self;
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    //NSLog(@"Cool, I'm connected! That was easy.");
}

-(void)sendInputToBeagle:(NSArray*)actions {

    NSError *err = nil;
    
    if ([actions count] == 0)
        return;
    
    if (self.socket.isDisconnected && ![self.socket connectToHost:self.hostname onPort:self.port error:&err]) // Asynchronous!
    {
        NSLog(@"I goofed: %@", err);
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:actions options:NSJSONWritingPrettyPrinted error:&err];
    //    NSLog(@"JSON = %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    NSData *data = [[NSData alloc] initWithData:jsonData];
    
    [self.socket writeData:data withTimeout:-1 tag:0];
    [self.socket disconnectAfterWriting];
}

@end