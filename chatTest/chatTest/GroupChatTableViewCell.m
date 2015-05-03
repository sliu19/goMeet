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
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfLabel;


@end
@implementation GroupChatTableViewCell

-(GroupChatTableViewCell*)initWithMessage:(Message*)message{
    self =[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
    self.myMessage = message;
    self.selfUser.image =[UIImage imageNamed:@"beach.jpeg"];
    self.OtherUser.image =[UIImage imageNamed:@"beach.jpeg"];
    self.selfLabel.text = message.bodyText;
    return self;
}


- (void)awakeFromNib {
    // Initialization code
    NSLog(@"awake");
    //[self setup];
    self.contentMode = UIViewContentModeRedraw;
   
}

-(void)setup{
    self.OtherUser.image = [UIImage imageNamed:@"beach.jpeg"];
    self.selfLabel.text = _myMessage.bodyText;

}

- (void)drawRect:(CGRect)rect {
    self.OtherUser.image = [UIImage imageNamed:@"beach.jpeg"];
    self.selfLabel.text = _myMessage.bodyText;
    if ([self isSelf]) {
        NSLog(@"Self message");
        self.OtherUser.hidden = true;
        self.otherLabel.hidden = true;
    }else{
        NSLog(@"Others message");
        self.selfLabel.hidden = true;
        self.selfUser.hidden = true;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(BOOL)isSelf{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Send through NSStrem
    NSString* userId = [prefs stringForKey:@"userID"];
    NSLog(@"selfID is %@, messageID is %@",userId,self.myMessage.userID);
    if ([self.myMessage.userID isEqualToString:userId]) {
        return true;
    } else {
        return false;
    }
}
@end
