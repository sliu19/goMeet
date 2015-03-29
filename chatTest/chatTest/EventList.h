//
//  EventList.h
//  chatTest
//
//  Created by Simin Liu on 3/28/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventList : NSManagedObject

@property (nonatomic, retain) NSString * jid;
@property (nonatomic, retain) id groupMember;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSData * groupMember_data;

@end
