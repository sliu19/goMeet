//
//  PublicEventTableViewCell.m
//  chatTest
//
//  Created by Simin Liu on 5/6/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "PublicEventTableViewCell.h"
#import "Communication.h"
@interface PublicEventTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIView *AttendanceView;
@property (weak, nonatomic) IBOutlet UIButton *JoinButton;


@end

@implementation PublicEventTableViewCell
@synthesize eventItem;


-(void)awakeFromNib
{
    [self setup];
}

-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
        self.contentMode = UIViewContentModeRedraw;
}
    
    
- (void)drawRect:(CGRect)rect {
    _JoinButton.layer.cornerRadius = 5;
    _JoinButton.clipsToBounds = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:eventItem.time];
    _TitleLabel.text = eventItem.title;
    _LocationLabel.text = eventItem.location;
    _TimeLabel.text = stringFromDate;
    _JoinButton.layer.cornerRadius = 5;
    _JoinButton.clipsToBounds = YES;

   
}
- (IBAction)joinEvent:(id)sender {
    //eventaccept:{"event_id":"37aa7291-f8e9-11e4-9fd2-b8e85632007e","user_id":6505758649}
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"user_id":[prefs objectForKey:@"userID"],@"event_id":eventItem.jid};
    NSString *response  = [NSString stringWithFormat:@"eventaccept:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];

    
}
@end
