//
//  PersonUIButton.h
//  chatTest
//
//  Created by Simin Liu on 4/30/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface PersonButton : UIButton<UIGestureRecognizerDelegate>

@property(strong,nonatomic)Friend* myFriend;

-(PersonButton*)initWith:(CGRect)frame friendItem:(Friend*)friends;

-(void)ButtonSelected;

@end
