//
//  NoticeDetailViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/14/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "Communication.h"

@interface NoticeDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *attandanceView;
@property (weak, nonatomic) IBOutlet UILabel *eventDescrbeLabel;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *notgoButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImae;
@end

@implementation NoticeDetailViewController
@synthesize myEvent;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Event in detail view is %@",myEvent);
    _eventOwnerLabel.text = [NSString stringWithFormat:@"%@ 邀请您参加了一个活动",[myEvent objectForKey:@"nickName"]];
    _eventTitleLabel.text = [myEvent objectForKey:@"title"];
    _eventDescrbeLabel.text = [myEvent objectForKey:@"description"];
    _locationLabel.text = [myEvent objectForKey:@"location"];
    _userImae.image = [UIImage imageWithData:[myEvent objectForKey:@"userPic"]];
    _userImae.layer.cornerRadius = _userImae.frame.size.width / 2;
    _userImae.clipsToBounds = YES;
    double timestampval =  [[myEvent objectForKey:@"begin_time"] doubleValue]/1000;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
   _timeLabel.text = [formatter stringFromDate:updatetimestamp];
    _goButton.layer.cornerRadius = 5;
    _goButton.clipsToBounds = YES;
    _notgoButton.layer.cornerRadius = 5;
    _notgoButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)joinEvent:(id)sender {
   // eventaccept:{"event_id":"37aa7291-f8e9-11e4-9fd2-b8e85632007e","user_id":6505758649}
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"user_id":[prefs objectForKey:@"userID"],@"event_id":[myEvent objectForKey:@"event_id"]};
    NSString *response  = [NSString stringWithFormat:@"eventaccept:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    
    
    //add to local database

}
- (IBAction)nextTime:(id)sender {
    _goButton.hidden =true;
    _notgoButton.hidden =true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
