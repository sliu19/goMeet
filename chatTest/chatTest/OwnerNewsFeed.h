//
//  OwnerNewsFeed.h
//  chatTest
//
//  Created by Simin Liu on 3/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OwnerNewsFeed : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * bodyTextField;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * userID;

@end
