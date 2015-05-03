//
//  Message.m
//  chatTest
//
//  Created by Simin Liu on 5/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Message.h"
@interface Message()


@end

@implementation Message

-(Message*)init:(NSString*)body name:(NSString*)userName
{
    self = [super init];
    self.userID = userName;
    self.bodyText = body;
    
    return self;
}

-(BOOL)isSelf
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userID"];

    if (self.userID == userId) {
        return true;
    }
    return false;
}

@end
