//
//  PersonUIButton.m
//  chatTest
//
//  Created by Simin Liu on 4/30/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//



#import "FriendCell.h"
#import "PersonalprofileViewController.h"
#define OFF_SET 20.0


@implementation FriendCell
@synthesize myFriend;
@synthesize profilePic;
@synthesize selectedPic;
BOOL selected;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImage* Pic = [[UIImage alloc]initWithData:myFriend.userPic];
    profilePic = [[UIImageView alloc] initWithImage:Pic];
    profilePic.frame = CGRectMake(OFF_SET, OFF_SET, self.bounds.size.width-2*OFF_SET, self.bounds.size.width-2*OFF_SET);
    profilePic.bounds = CGRectMake(OFF_SET, OFF_SET, self.bounds.size.width-2*OFF_SET, self.bounds.size.width-2*OFF_SET);
    profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
    profilePic.clipsToBounds = YES;
    [self addSubview:profilePic];
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.width-OFF_SET/2, self.bounds.size.width, 20)];
    nickNameLabel.text = [NSString stringWithFormat:@"%@",myFriend.userNickName];
    [nickNameLabel setTextColor:[UIColor whiteColor]];
    //[nickNameButton.titleLabel setBackgroundColor:[UIColor clearColor]];
    [nickNameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nickNameLabel];

    UIImage* selectPic = [UIImage imageNamed:@"greenImage.jpg"];
    selectedPic = [[UIImageView alloc] initWithImage:selectPic];
    selectedPic.frame = CGRectMake(self.bounds.size.width-2*OFF_SET, self.bounds.size.width-2*OFF_SET, 20, 20);
    selectedPic.bounds = CGRectMake(self.bounds.size.width-2*OFF_SET, self.bounds.size.width-2*OFF_SET, 20, 20);
    selectedPic.layer.cornerRadius = selectedPic.frame.size.width / 2;
    selectedPic.clipsToBounds = YES;
   // NSLog(@"set selected color %@",selected);
    //selectedPic.alpha = 0.0;
    if (selected){
        NSLog(@"selected");
        //selectedPic.alpha = ;
        [self addSubview:selectedPic];
    }else{
        NSLog(@"NOT SELECTED");
        //self.backgroundColor =[UIColor whiteColor];
        [self.selectedPic removeFromSuperview];
        //selectedPic.hidden = true;
    }
    
}

-(void)prepareForReuse {
    selected = FALSE;
}


-(FriendCell*)initWith:(Friend*)friends{
    self = [super init];
    if(!self) return nil;
    //add self
    NSLog(@"Friend Name %@", friends.userNickName);
   // myFriend = [Friend alloc];
    myFriend = friends;
    [self deselect:self];
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

//选中&未选中绿勾调整
-(void) select:(FriendCell*)cell{
    selected = true;
    [self.selectedPic setHidden:NO];
}
-(void) deselect:(FriendCell*)cell{
    selected = false;
    [self.selectedPic setHidden:YES];
}
@end
