//
//  NewsFeedList.h
//  chatTest
//
//  Created by Simin Liu on 3/21/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewsFeedList : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * bodyTextField;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * uuid;

@end
