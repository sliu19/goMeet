//
//  GroupChatTableViewCell.h
//  chatTest
//
//  Created by Simin Liu on 4/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//  群里单条信息。尚未完成搭建

#import <UIKit/UIKit.h>
#import "Message.h"

@interface GroupChatTableViewCell : UITableViewCell

@property(nonatomic,strong)Message* myMessage;
-(void)setup;
-(CGFloat)getMessageHeight;
-(GroupChatTableViewCell*)initWithMessage:(Message*)message;
@end
