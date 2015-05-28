//
//  PersonUIButton.m
//  chatTest
//
//  Created by Simin Liu on 4/30/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//



#import "PersonButton.h"
#import "PersonalprofileViewController.h"
#define OFF_SET 10.0


@implementation PersonButton
@synthesize myFriend;
BOOL selected;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImage* Pic = [[UIImage alloc]initWithData:myFriend.userPic];
    UIImageView* profilePic = [[UIImageView alloc] initWithImage:Pic];
    profilePic.frame = CGRectMake(OFF_SET, OFF_SET, self.bounds.size.width-2*OFF_SET, self.bounds.size.width-2*OFF_SET);
    profilePic.bounds = CGRectMake(OFF_SET, OFF_SET, self.bounds.size.width-2*OFF_SET, self.bounds.size.width-2*OFF_SET);
    profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
    profilePic.clipsToBounds = YES;
    [self addSubview:profilePic];
    UIButton *nickNameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.width-OFF_SET/2, self.bounds.size.width, 20)];
    nickNameButton.titleLabel.text = [NSString stringWithFormat:@"%@",myFriend.userNickName];
    [nickNameButton.titleLabel setTextColor:[UIColor whiteColor]];
    [nickNameButton.titleLabel setBackgroundColor:[UIColor clearColor]];
    [nickNameButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    nickNameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [nickNameButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];


    [self addSubview:nickNameButton];

}
-(void)ButtonSelected{
    NSLog(@"This person is selected?,%@",selected);
    selected = ! selected;
}

-(PersonButton*)initWith:(CGRect)frame friendItem:(Friend*)friends{
    self = [super init];
    self.frame = frame;
    if(!self) return nil;
    //add self
    NSLog(@"Friend Name %@", friends.userNickName);
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

-(void)buttonClicked:(UITapGestureRecognizer*)sender
{
    NSLog(@"double tab view detacted");
    //NSLog(@"UserName is %@",sender.myFriend.userID);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalprofileViewController *viewController = (PersonalprofileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        viewController.friends = self.myFriend;

}
    


@end
