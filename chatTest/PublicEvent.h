//
//  PublicEvent.h
//  chatTest
//
//  Created by Simin Liu on 5/12/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//  实时活动模型

#import <Foundation/Foundation.h>

@interface PublicEvent : NSObject<NSCoding>


@property(strong,nonatomic)NSString*time;
@property(strong,nonatomic)NSString*title;
@property(strong,nonatomic)NSString*location;
-(PublicEvent*)init:(NSDictionary*)dict;

@end
