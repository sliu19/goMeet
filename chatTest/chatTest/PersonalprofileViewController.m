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
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation PersonalprofileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userName.text = _friends.userNickName;
    _userPic.layer.cornerRadius = _userPic.frame.size.width / 2;
    _userPic.clipsToBounds = YES;
    _phoneNumLabel.text = _friends.userID;
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
