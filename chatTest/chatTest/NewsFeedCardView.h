//
//  NewsFeedCardView.h
//  chatTest
//
//  Created by Simin Liu on 4/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeed.h"

@interface NewsFeedCardView : UIView

@property (strong,nonatomic) NewsFeed* news;
@property (strong,nonatomic) id currentResponder;


-(NewsFeedCardView*)initWith:(CGRect)frame :(NewsFeed*)newsFeed;

@end
