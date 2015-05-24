//
//  Friend.h
//  chatTest
//
//  Created by Simin Liu on 5/24/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userImageUUID;
@property (nonatomic, retain) NSData * userPic;
@property (nonatomic, retain) NSString * userNickName;

@end
