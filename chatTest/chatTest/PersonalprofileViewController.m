//
//  Personalprofile.m
//  chatTest
//
//  Created by Simin Liu on 3/18/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "PersonalprofileViewController.h"

@interface PersonalprofileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;


@end

@implementation PersonalprofileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userName.text = _friends.userName;
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
