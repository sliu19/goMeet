//
//  PersonalProfile.m
//  chatTest
//
//  Created by Simin Liu on 4/30/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "PersonalProfile.h"

@implementation PersonalProfile
@synthesize myFriend;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 20)];
    yourLabel.text = [NSString stringWithFormat:@"Test String for personalprofile name: %@",myFriend.userName];
    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor whiteColor]];
    [yourLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    //[yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [self addSubview:yourLabel];
}



-(PersonalProfile*)initWith:(CGRect)frame friendItem:(Friend*)friend{
    self = [super initWithFrame:frame];
    if(!self) return nil;
    //add self
    self.myFriend = friend;
    return self;
}


-(void)awakeFromNib
{
    [self setup];
}

-(void)setup
{
    self.backgroundColor = [UIColor grayColor];
    self.opaque = YES;
    self.contentMode = UIViewContentModeRedraw;

}

@end
