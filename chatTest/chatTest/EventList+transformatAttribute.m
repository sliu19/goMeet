//
//  EventList+transformatAttribute.m
//  chatTest
//
//  Created by Simin Liu on 3/28/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "EventList+transformatAttribute.h"

@implementation EventList (transformatAttribute)

-(NSArray *)groupMember{
    if (!self.groupMember_data) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.groupMember_data];
}

-(void)setGroupMember:(id)groupMember{
    NSData *groupMember_data = [NSKeyedArchiver archivedDataWithRootObject:groupMember];
    [self setValue:groupMember_data forKey:@"groupMember_data"];
}

-(NSArray*)message{
    if (!self.message_data) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.message_data];
}

-(void)setMessage:(id)message{
    NSData* message_data =[NSKeyedArchiver archivedDataWithRootObject:message];
    [self setValue:message_data forKey:@"message_data"];

}


@end
