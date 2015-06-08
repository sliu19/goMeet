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

//查看信息是否本机发出
-(BOOL)isSelf
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userID"];

    if (self.userID == userId) {
        return true;
    }
    return false;
}

//encoding
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_userID forKey:@"userID"];
    [encoder encodeObject:_bodyText forKey:@"bodyText"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *userID = [decoder decodeObjectForKey:@"userID"];
    NSString*bodyText = [decoder decodeObjectForKey:@"bodyText"];
    return [self init:bodyText name:userID];
}
@end
