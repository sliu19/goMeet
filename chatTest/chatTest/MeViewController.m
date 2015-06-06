//
//  MeViewController.m
//  chatTest
//
//  Created by Simin Liu on 3/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "MeViewController.h"

#import "AppDelegate.h"
#define OFFSET_FROM_FRAME  2


@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *PersonalPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) NSArray* OwnerNewsFeed;
@property (nonatomic) CGPoint startPoint;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNubmerLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *ModifyInfoButton;

@end

@implementation MeViewController
//@synthesize managedObjectContent;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //Send through NSStrem
    NSData * userPic = [prefs dataForKey:@"userPic"];
    _PersonalPicImageView.image=[[UIImage alloc]initWithData:userPic];
    _ModifyInfoButton.layer.cornerRadius = 5;
    _ModifyInfoButton.clipsToBounds = YES;

    
 // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        //Send through NSStrem
    NSString* userNickName = [prefs stringForKey:@"nickName"];
    NSData * userPic = [prefs dataForKey:@"userPic"];
    _userNickNameLabel.text = userNickName;
    _PersonalPicImageView.image=[[UIImage alloc]initWithData:userPic];
    _PersonalPicImageView.layer.cornerRadius = _PersonalPicImageView.frame.size.width / 2;
    _PersonalPicImageView.clipsToBounds = YES;
    _genderLabel.text = @"男";
    if ([[prefs stringForKey:@"gender"] isEqualToString:@"F"]){
        _genderLabel.text = @"女";
    }
    _locationLabel.text = [prefs stringForKey:@"location"] ;
    _phoneNubmerLabel.text = [prefs stringForKey:@"userID"] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)resignOnTap:(UITapGestureRecognizer *)sender{
    //[self.currentResponder resignFirstResponder];
    NSLog(@"Double Tab detacted");
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
