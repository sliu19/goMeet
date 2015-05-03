//
//  GroupChatTableView.m
//  chatTest
//
//  Created by Simin Liu on 5/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "GroupChatTableView.h"
#import "GroupChatTableViewCell.h"
#import "Message.h"

@implementation GroupChatTableView
@synthesize messageHistory;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(GroupChatTableView*)initWithFrame:(CGRect)frames message:(NSArray*)messages{
    self = [super initWithFrame:frames style:UITableViewStylePlain];
    self.messageHistory = messages;
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [messageHistory count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MessageCell";
    GroupChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[GroupChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    Message *message = [messageHistory objectAtIndex:indexPath.row];
    cell.myMessage = message;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}

@end
