//
//  NewsFeedViewController.m
//  chatTest
//
//  Created by Simin Liu on 2/18/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedCardView.h"
#import "addNewsFeedViewController.h"
#define OFFSET_FROM_FRAME  10
#define OFFSET_FROM_TOP 20
#define OFFSET_BETWEEN_CARD 30

@interface NewsFeedViewController ()

@property(strong,nonatomic)NSMutableArray* NewsFeedList;

@property (strong, nonatomic) IBOutlet UIView *BackGroundView;


@property (nonatomic) CGPoint startPoint;

@property (strong,nonatomic)UIScrollView *window;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddNew;


@end

//UIScrollView* window;

@implementation NewsFeedViewController
@synthesize newsList;

- (void)viewDidLoad {
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    NSLog(@"InitPage");
    _NewsFeedList = [[NSMutableArray alloc] init];
    NewsFeed* testNewsFeed =[[NewsFeed alloc]init];
    UIImage *testImage = [UIImage imageNamed:@"testImageApple.jpeg"];
    NSData * testImageData = UIImageJPEGRepresentation(testImage,testImage.scale);
    [testNewsFeed SampleInit:testImageData];
    //Make 10 sample newsFeed
    [_NewsFeedList addObject:testNewsFeed];
    [_NewsFeedList addObject:testNewsFeed];
    [_NewsFeedList addObject:testNewsFeed];
    [_NewsFeedList addObject:testNewsFeed];
    _BackGroundView.BackgroundColor = [UIColor colorWithPatternImage:[Communication imageWithImage: [UIImage imageNamed:@"forest.jpeg"] scaledToSize:_BackGroundView.bounds.size]];
    _startPoint = _BackGroundView.bounds.origin;
    _startPoint.x += OFFSET_FROM_FRAME;
    _startPoint.y += OFFSET_FROM_TOP;
    
    newsList  = _NewsFeedList;
    _window = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_window];
    [self getNewsList];
    for(NewsFeed *news in newsList){
        [self drawNewsFeed:_startPoint newsfeed:news];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawNewsFeed:(CGPoint)start newsfeed:(NewsFeed*)myNewsFeed{
    CGFloat textFieldEstimateHeight = (CGFloat)([myNewsFeed getContentText:myNewsFeed].length*1.5);
    CGRect frame = CGRectMake(_startPoint.x, _startPoint.y, _BackGroundView.bounds.size.width - 2*OFFSET_FROM_FRAME, (_BackGroundView.bounds.size.width - 2*OFFSET_FROM_FRAME + textFieldEstimateHeight));
    NewsFeedCardView* newView = [[NewsFeedCardView alloc] initWith:frame :myNewsFeed];
    newView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [newView setUserInteractionEnabled:YES];
    [newView addGestureRecognizer:doubleTap];

    _startPoint.y = _startPoint.y + newView.bounds.size.height+OFFSET_BETWEEN_CARD;
    [_window addSubview:newView];
    [_window setContentSize:CGSizeMake(_window.bounds.size.width, _startPoint.y)];
}



- (IBAction)addNewsFeed:(id)sender {
}

- (void)resignOnTap:(UITapGestureRecognizer *)sender{
    //[self.currentResponder resignFirstResponder];
    NSLog(@"Double Tab detacted");
    if ([(NewsFeedCardView *)sender.view isKindOfClass:[NewsFeedCardView class]]) {
         NSLog(@"This is a newsFeedCardView,TO DO:Push a new navi view");
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
- (IBAction)PullNews:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userID"];
    NSString* response = [NSString stringWithFormat:@"Continuepollnews:%@",userId];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    
}

-(void)getNewsList{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userID"];
    NSString* response = [NSString stringWithFormat:@"pollnews:%@",userId];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
}
- (IBAction)AddNews:(UIBarButtonItem *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *viewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"AddNewsFeedNavi"];
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
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    typedef enum {
        NSStreamEventNone = 0,
        NSStreamEventOpenCompleted = 1 << 0,
        NSStreamEventHasBytesAvailable = 1 << 1,
        NSStreamEventHasSpaceAvailable = 1 << 2,
        NSStreamEventErrorOccurred = 1 << 3,
        NSStreamEventEndEncountered = 1 << 4
    }NSStringEvent;
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                    NSLog(@"trigger segue");
                                    [self performSegueWithIdentifier:@"login" sender:nil];
                                    
                                    break;
                                    
                                default:
                                    NSLog(@"output int val %@", output.intValue);
                                    break;
                            }
                            NSLog(@"server said: %@", output);
                            
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}


@end
