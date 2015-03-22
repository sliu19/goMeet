//
//  MeViewController.m
//  chatTest
//
//  Created by Simin Liu on 3/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *PersonalPicImageView;
@property (weak, nonatomic) IBOutlet UITextView *PersonalnfoTextView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Send through NSStrem
    NSString* userId = [prefs stringForKey:@"userID"];
    NSDate * userPic = [prefs stringForKey:@"userPic"];
    _PersonalnfoTextView.text = userId;
    _PersonalPicImageView.image=[[UIImage alloc]initWithData:userPic];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LogOut:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:nil forKey:@"userID"];
    [defaults setObject:nil forKey:@"passCode"];
    //[defaults setInteger:age forKey:@"age"];
    [defaults setObject:nil forKey:@"userPic"];
    [defaults synchronize];
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
