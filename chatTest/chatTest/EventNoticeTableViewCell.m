//
//  EventNoticeTableViewCell.m
//  chatTest
//
//  Created by Simin Liu on 5/14/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "EventNoticeTableViewCell.h"
@interface EventNoticeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *eventdescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventOwnerLabel;

@end
@implementation EventNoticeTableViewCell
@synthesize myEvent;



- (void)awakeFromNib {
    // Initialization code

    self.contentMode = UIViewContentModeRedraw;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"EVENT inside cell is %@",myEvent);
    self.eventdescriptionLabel.text = [myEvent objectForKey:@"title"];
    self.eventOwnerLabel.text = @"邀请你参加了一个活动";
    _userImage.image = [UIImage imageNamed:@"nightLife.jpeg"];
    _userImage.layer.cornerRadius = _userImage.frame.size.width / 2;
    _userImage.clipsToBounds = YES;
}

@end
