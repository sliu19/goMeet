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
    _picImage.image = [UIImage imageWithData:_userPic];
    _picImage.layer.cornerRadius = _picImage.frame.size.width / 2;
    _picImage.clipsToBounds = YES;
    _actionButton.layer.cornerRadius = 5;
    _actionButton.clipsToBounds = YES;

}
- (IBAction)accpetButton:(id)sender {
    if(_userInfo==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"看了照片再决定吧？" message:@"亲爱的，重新试试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
    }
    else{
        _actionButton.backgroundColor = [UIColor grayColor];
   // acceptfriend:68958695#12341234
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString* request = [NSString stringWithFormat:@"acceptfriend:%@#%@",[prefs objectForKey:@"userID"],[_Info objectForKey:@"phone"]];
        NSData *data = [[NSData alloc] initWithData:[request dataUsingEncoding:NSUTF8StringEncoding]];
        [Communication send:data];
        [Communication addFriend:_userInfo :_userPic];
    }
    
}
-(void)changePicure{
    NSLog(@"RELOAD IMAGE");
    _picImage.image =[UIImage imageWithData:_userPic];
}
@end
