//
//  newFriendNoticeTableViewCell.m
//  chatTest
//
//  Created by Simin Liu on 5/3/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "newFriendNoticeTableViewCell.h"
#import "Communication.h"
@interface newFriendNoticeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation newFriendNoticeTableViewCell
-(void)awakeFromNib
{
    [self setup];
}

-(void)setup
{
       self.contentMode = UIViewContentModeRedraw;
    
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"name is %@",[_Info objectForKey:@"nick"]);
    _greetingLabel.text = [_Info objectForKey:@"msg"];
    _userNameLabel.text = [_Info objectForKey:@"nick"];

}
- (IBAction)accpetButton:(id)sender {
    _actionButton.backgroundColor = [UIColor grayColor];
   // acceptfriend:68958695#12341234
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* request = [NSString stringWithFormat:@"acceptfriend:%@#%@",[prefs objectForKey:@"userID"],[_Info objectForKey:@"phone"]];
    NSData *data = [[NSData alloc] initWithData:[request dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    
}

@end
