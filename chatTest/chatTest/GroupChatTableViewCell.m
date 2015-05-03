//
//  GroupChatTableViewCell.m
//  chatTest
//
//  Created by Simin Liu on 4/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "GroupChatTableViewCell.h"
@interface GroupChatTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *OtherUser;
@property (weak, nonatomic) IBOutlet UIImageView *selfUser;
@property (weak, nonatomic) IBOutlet UILabel *BodyText;

@end
@implementation GroupChatTableViewCell


- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor blueColor];
    self.OtherUser.image = [UIImage imageNamed:@"beach.jpeg"];
    self.BodyText.text = _myMessage.bodyText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
