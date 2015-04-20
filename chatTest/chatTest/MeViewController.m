//
//  MeViewController.m
//  chatTest
//
//  Created by Simin Liu on 3/22/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "MeViewController.h"
#import "NewsFeedCardView.h"
#import "AppDelegate.h"
#define OFFSET_FROM_FRAME  2


@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *PersonalPicImageView;
@property (weak, nonatomic) IBOutlet UITextView *PersonalnfoTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *window;
@property (weak, nonatomic) NSArray* OwnerNewsFeed;
@property (nonatomic) CGPoint startPoint;

@end

@implementation MeViewController
//@synthesize managedObjectContent;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Send through NSStrem
    NSString* userId = [prefs stringForKey:@"userID"];
    NSData * userPic = [prefs dataForKey:@"userPic"];
    _PersonalnfoTextView.text = userId;
    _PersonalPicImageView.image=[[UIImage alloc]initWithData:userPic];
    _startPoint = _window.bounds.origin;
    [self drawNews];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [[_window subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _startPoint = _window.bounds.origin;
    [self drawNews];
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *viewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"InitPage"];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)drawNews{
   // managedObjectContent = [[[UIApplication sharedApplication]delegate] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OwnerNewsFeed"];
    request.predicate = nil;
    //NSPredicate *predicate =
    //[NSPredicate predicateWithFormat:@"self == %@", OwnerNewsFeed];
    //[request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortedList = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    sortedList = [[sortedList reverseObjectEnumerator] allObjects];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        NSLog(@"%lu NewsFeed available",(unsigned long)count);
        //NSMutableArray* newsFeedArray = [[NSMutableArray alloc]init];
        for( OwnerNewsFeed* news in sortedList){
            NSLog(@"Draw one pic");
            NewsFeed* temp =  [[NewsFeed alloc] initWithOwnerNewsFeed:news];
            [self drawNewsFeed:temp];
        }
    }
    else {
        // Deal with error.
        NSLog(@"No owersNewsFeed available");
    }
}

-(void)drawNewsFeed:(NewsFeed*)myNewsFeed{
    CGRect frame = CGRectMake(_startPoint.x, _startPoint.y, _window.bounds.size.width/3,_window.bounds.size.width/3);
    NewsFeedCardView* newView = [[NewsFeedCardView alloc] initWith:frame :myNewsFeed];
    newView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [newView setUserInteractionEnabled:YES];
    [newView addGestureRecognizer:doubleTap];
    if(_startPoint.x<_window.bounds.size.width){
        _startPoint.x +=_window.bounds.size.width/3;
    }
    else{
        _startPoint.y = _startPoint.y + _window.bounds.size.width/3;
        _startPoint.x = _window.bounds.origin.x;
    }
    [_window addSubview:newView];
    [_window setContentSize:CGSizeMake(_window.bounds.size.width, _startPoint.y+_window.bounds.size.width/3)];
}

- (void)resignOnTap:(UITapGestureRecognizer *)sender{
    //[self.currentResponder resignFirstResponder];
    NSLog(@"Double Tab detacted");
    if ([(NewsFeedCardView *)sender.view isKindOfClass:[NewsFeedCardView class]]) {
        NSLog(@"This is a NewsFeedCardView,TO DO:Push a new navi view");
        //[sender.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    }
    else {
        NSLog(@"This is not a imageView");
        NSLog(@"Sender is a %@",NSStringFromClass([sender class]));
        //NSLog(@"Sender is a %@",NSStringFromClass([sender class]));
        //[UIView animateWithDuration:0.25 animations:^{
        //      self.imageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        //    self.imageView.transform = CGAffineTransformIdentity;
        // }];
        
    }
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
