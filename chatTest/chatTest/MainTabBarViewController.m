//
//  MainTabBarViewController.m
//  chatTest
//
//  Created by Simin Liu on 4/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "Communication.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    CGRect myFrame = self.tabBar.frame;
    UIImage *redBackground = [UIImage imageNamed:@"active-state.png"];
    UIImage *activeBackground = [Communication imageWithImage:redBackground
                                                scaledToSize:CGSizeMake(myFrame.size.width/4,myFrame.size.height)];

    [[UITabBar appearance] setSelectionIndicatorImage:activeBackground];
    [[UITabBar appearance]setTintColor:[UIColor whiteColor]];
    
 //UIImage *whiteBackground = [UIImage imageNamed:@"highLight.png"];
    //[[UITabBar appearance] setSelectionIndicatorImage:whiteBackground];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
    // Dispose of any resources that can be recreated.
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
