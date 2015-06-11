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
@synthesize describe;
@synthesize jid;
-(PublicEvent*)init:(NSDictionary*)dict{
    self  = [super init];
    title = [dict objectForKey:@"title"];
    NSTimeInterval timestamp = (NSTimeInterval)[[dict objectForKey:@"begin_time"] doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];

//Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];

    NSString *stringFromDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    time = stringFromDate;
    location = [dict objectForKey:@"location"];
    describe = [dict objectForKey:@"description"];
    jid = [dict objectForKey:@"event_id"];
    return  self;
}


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:time forKey:@"time"];
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeObject:describe forKey:@"describe"];
    [encoder encodeObject:jid forKey:@"jid"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSDictionary*dict = @{@"time":[decoder decodeObjectForKey:@"time"],@"title":[decoder decodeObjectForKey:@"title"],@"location":[decoder decodeObjectForKey:@"location"],@"describe":[decoder decodeObjectForKey:@"describe"],@"jid":[decoder decodeObjectForKey:@"jid"]};
    return [self init:dict];
}


@end
