//
//  PersonUIButton.m
//  chatTest
//
//  Created by Simin Liu on 4/30/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//



#import "PersonUIButton.h"
#define OFF_SET 10.0


@implementation PersonUIButton
@synthesize myFriend;
BOOL selected;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImageView* profilePic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testImageApple.jpeg"]];
    profilePic.frame = CGRectMake(OFF_SET, OFF_SET, self.bounds.size.width-2*OFF_SET, self.bounds.size.width-2*OFF_SET);
    profilePic.bounds = CGRectMake(OFF_SET, OFF_SET, self.bounds.size.width-2*OFF_SET, self.bounds.size.width-2*OFF_SET);
    profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
    profilePic.clipsToBounds = YES;
    [self addSubview:profilePic];
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bounds.size.width, self.bounds.size.width-20, 20)];
    yourLabel.text = [NSString stringWithFormat:@"%@",myFriend.userID];
    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    yourLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:yourLabel];

}
-(void)ButtonSelected{
    NSLog(@"This person is selected?,%@",selected);
    selected = ! selected;
}

-(PersonUIButton*)initWith:(CGRect)frame friendItem:(Friend*)friends{
    self = [super init];
    self.frame = frame;
    if(!self) return nil;
    //add self
    NSLog(@"Friend Name %@", friends.userID);
   // myFriend = [Friend alloc];
    myFriend = friends;
    return self;
}


-(void)awakeFromNib
{
    [self setup];
}

-(void)setup
{
    self.backgroundColor = [UIColor blackColor];
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
}

@end
