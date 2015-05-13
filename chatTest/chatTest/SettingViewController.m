//
//  SettingViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/12/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOut:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:nil forKey:@"userID"];
    [defaults setObject:nil forKey:@"passCode"];
    //[defaults setInteger:age forKey:@"age"];
    [defaults setObject:nil forKey:@"userPic"];
    [defaults synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *viewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"InitPage"];
    [self presentViewController:viewController animated:YES completion:nil];
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
