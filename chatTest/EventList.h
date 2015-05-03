//
//  EventList.h
//  chatTest
//
//  Created by Simin Liu on 5/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventList : NSManagedObject

@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) id groupMember;
@property (nonatomic, retain) NSData * groupMember_data;
@property (nonatomic, retain) NSString * jid;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) id message;
@property (nonatomic, retain) NSData * message_data;

@end
