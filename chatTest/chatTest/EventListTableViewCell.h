//
//  EventListTableViewCell.h
//  chatTest
//
//  Created by Simin Liu on 4/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//  活动元素


#import <UIKit/UIKit.h>
#import "EventList.h"

@interface EventListTableViewCell : UITableViewCell

@property (strong,nonatomic) EventList* myEvent;
@end
