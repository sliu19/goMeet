//
//  newFriendNoticeViewController.h
//  chatTest
//
//  Created by Simin Liu on 5/3/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newFriendNoticeViewController : UITableViewController<NSStreamDelegate>


@property(strong,nonatomic)NSArray* notificationList;
@property(strong,nonatomic)NSMutableArray* notificationImageList;
@property(strong,nonatomic)NSMutableArray* userInfoList;
@end
