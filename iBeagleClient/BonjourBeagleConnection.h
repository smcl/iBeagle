//
//  BonjourBeagleConnection.h
//  iBeagleClient
//
//  Created by Sean McLemon on 25/10/14.
//  Copyright (c) 2014 Sean McLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeagleConnection.h"

@interface BonjourBeagleConnection : NSObject <BeagleConnection>

@property (nonatomic, strong) NSNetService *beagleService;

@end
