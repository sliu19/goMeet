//
//  Personalprofile.m
//  chatTest
//
//  Created by Simin Liu on 3/18/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "Personalprofile.h"

@interface Personalprofile ()
@property (weak, nonatomic) IBOutlet UIImageView *ProfilePic;
@property (weak, nonatomic) IBOutlet UITextView *InformationTextField;

@end

@implementation Personalprofile

- (void)viewDidLoad {
    [super viewDidLoad];
    _InformationTextField.text = _friend.userName;
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
