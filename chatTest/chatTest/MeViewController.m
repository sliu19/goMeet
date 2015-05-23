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
@property (weak, nonatomic) IBOutlet UITextView *PersonalnfoTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *window;
@property (weak, nonatomic) NSArray* OwnerNewsFeed;
@property (nonatomic) CGPoint startPoint;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNubmerLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation MeViewController
//@synthesize managedObjectContent;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Send through NSStrem
    NSString* userId = [prefs stringForKey:@"nickName"];
    NSData * userPic = [prefs dataForKey:@"userPic"];
    _PersonalnfoTextView.text = userId;
    _PersonalPicImageView.image=[[UIImage alloc]initWithData:userPic];
    _PersonalPicImageView.layer.cornerRadius = _PersonalPicImageView.frame.size.width / 2;
    _PersonalPicImageView.clipsToBounds = YES;
    _genderLabel.text = @"男";
    if ([[prefs stringForKey:@"gender"] isEqualToString:@"F"]){
        _genderLabel.text = @"女";
        }
    _locationLabel.text = [prefs stringForKey:@"location"] ;
    _phoneNubmerLabel.text = [prefs stringForKey:@"userID"] ;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [[_window subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _startPoint = _window.bounds.origin;
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
