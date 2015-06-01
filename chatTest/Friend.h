//
//  Friend.h
//  赢家
//
//  Created by Simin Liu on 6/1/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userNickName;
@property (nonatomic, retain) NSData * userPic;
@property (nonatomic, retain) NSString * parseID;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * location;

@end
