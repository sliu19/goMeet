//
//  PersonalProfile.h
//  chatTest
//
//  Created by Simin Liu on 4/30/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
@interface PersonalProfile : UIView

@property(strong,nonatomic)Friend* myFriend;

-(PersonalProfile*)initWith:(CGRect)frame friendItem:(Friend*)friend;


@end
