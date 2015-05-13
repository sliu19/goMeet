//
//  PublicEventTableViewCell.h
//  chatTest
//
//  Created by Simin Liu on 5/6/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventList.h"
@interface PublicEventTableViewCell : UITableViewCell

@property(nonatomic,strong)EventList* eventItem;
@end
