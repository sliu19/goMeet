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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
