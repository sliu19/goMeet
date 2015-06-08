//
//  PersonUIButton.h
//  chatTest
//
//  Created by Simin Liu on 4/30/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//  好友界面每个好友元素

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface FriendCell : UICollectionViewCell<UIGestureRecognizerDelegate>

@property(strong,nonatomic)Friend* myFriend;
@property(strong,nonatomic)UIImageView* profilePic;
@property(strong,nonatomic)UIImageView* selectedPic;

-(FriendCell*)initWith:(Friend*)friends;
-(void) select:(FriendCell*)cell;
-(void) deselect:(FriendCell*)cell;
@end
