//
//  PublicEvent.m
//  chatTest
//
//  Created by Simin Liu on 5/12/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "PublicEvent.h"

@implementation PublicEvent
@synthesize title;
@synthesize time;
@synthesize location;
-(PublicEvent*)init:(NSDictionary*)dict{
    self  = [super init];
    title = [dict objectForKey:@"title"];
    time = [dict objectForKey:@"time"];
    location = [dict objectForKey:@"location"];
    
    return  self;
}


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:time forKey:@"time"];
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:location forKey:@"location"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSDictionary*dict = @{@"time":[decoder decodeObjectForKey:@"time"],@"title":[decoder decodeObjectForKey:@"title"],@"location":[decoder decodeObjectForKey:@"location"]};
    return [self init:dict];
}


@end
