//
//  NoticeDetailViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/14/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDescriptLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attandaceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImae;
@end

@implementation NoticeDetailViewController
@synthesize myEvent;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSLog(@"Event in detail view is %@",myEvent);
    _eventOwnerLabel.text = @"邀请您参加了一个活动";
    _eventDescriptLabel.text = [myEvent objectForKey:@"title"];
    _locationLabel.text = [myEvent objectForKey:@"location"];
    _userImae.image = [UIImage imageNamed:@"testImage.jpeg"];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)joinEvent:(id)sender {
}
- (IBAction)nextTime:(id)sender {
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
