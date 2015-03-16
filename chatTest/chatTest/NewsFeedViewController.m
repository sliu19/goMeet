//
//  NewsFeedViewController.m
//  chatTest
//
//  Created by Simin Liu on 2/18/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "NewsFeedViewController.h"
#define OFFSET_FROM_FRAME  10
#define OFFSET_FROM_TOP 20
#define OFFSET_BETWEEN_CARD 30

@interface NewsFeedViewController ()

@property(strong,nonatomic)NSMutableArray* NewsFeedList;

@property (strong, nonatomic) IBOutlet UIView *BackGroundView;

@property (nonatomic) CGPoint startPoint;

@property (strong,nonatomic) UIView* lastView;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *myBarButtonItem;


@end

UIScrollView* window;

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[self navigationItem] setRightBarButtonItem:_myBarButtonItem];
    // Do any additional setup after loading the view.
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
    _BackGroundView.BackgroundColor = [UIColor colorWithPatternImage:[Communication imageWithImage: [UIImage imageNamed:@"forest.jpeg"] scaledToSize:_BackGroundView.bounds.size]];
    _startPoint = _BackGroundView.bounds.origin;
    _startPoint.x += OFFSET_FROM_FRAME;
    _startPoint.y += OFFSET_FROM_TOP;
    window = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:window];
    [self drawNewsFeed:_startPoint newsfeed:testNewsFeed];
    [self drawNewsFeed:_startPoint newsfeed:testNewsFeed];
    [self drawNewsFeed:_startPoint newsfeed:testNewsFeed];
    [self drawNewsFeed:_startPoint newsfeed:testNewsFeed];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawNewsFeed:(CGPoint)start newsfeed:(NewsFeed*)myNewsFeed{
    CGPoint innerPoint;
    CGFloat textFieldEstimateHeight = (CGFloat)([myNewsFeed getContentText:myNewsFeed].length*1.5);
    CGRect frame = CGRectMake(_startPoint.x, _startPoint.y, _BackGroundView.bounds.size.width - 2*OFFSET_FROM_FRAME, (_BackGroundView.bounds.size.width - 2*OFFSET_FROM_FRAME + textFieldEstimateHeight));
    UIView* newView = [[UIView alloc]initWithFrame:frame];
    //[newView release];
    newView.opaque = YES;
    newView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
    _startPoint.y = _startPoint.y + newView.bounds.size.height+OFFSET_BETWEEN_CARD;
    UIImage *contentImage = [[UIImage alloc] initWithData:[myNewsFeed getContentImage:myNewsFeed]];
    contentImage = [Communication imageWithImage:contentImage scaledToSize:CGSizeMake(newView.bounds.size.width-2*OFFSET_FROM_FRAME,newView.bounds.size.width-2*OFFSET_FROM_FRAME)];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(OFFSET_FROM_FRAME, OFFSET_FROM_FRAME, contentImage.size.width,contentImage.size.height )];
    [iv setImage:contentImage];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    [iv setUserInteractionEnabled:YES];
    [iv addGestureRecognizer:singleTap];
    innerPoint.x = OFFSET_FROM_FRAME;
    innerPoint.y = OFFSET_FROM_FRAME +contentImage.size.height;
    UILabel* contentString = [[UILabel alloc]initWithFrame:CGRectMake(innerPoint.x, innerPoint.y, newView.bounds.size.width-2*OFFSET_FROM_FRAME,20)];
    contentString.text = [myNewsFeed getContentText:myNewsFeed];
    contentString.font=[UIFont boldSystemFontOfSize:15.0];
    contentString.textColor=[UIColor blackColor];
    contentString.backgroundColor=[UIColor clearColor];
    [newView addSubview:contentString];
    [newView addSubview:iv];
    [window addSubview:newView];
    [window setContentSize:CGSizeMake(window.bounds.size.width, _startPoint.y)];
    
    
}


-(void)drawMyContent:(UIView*)thisView newsfeed:(NewsFeed*)myNewsFeed{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *contentFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    contentFont = [contentFont fontWithSize:contentFont.pointSize *[Communication cornerScaleFactor:thisView]];
    
    //Draw context here!!!!!Use test content as sample
    
    //NSAttributedString *contentText = [[NSAttributedString alloc] initWithString:[myNewsFeed getContentText:myNewsFeed] attributes:@{ NSFontAttributeName :contentFont, NSParagraphStyleAttributeName:paragraphStyle}];
    //UIImage *contentImage = [[UIImage alloc] initWithData:[myNewsFeed getContentImage:myNewsFeed]];
    NSAttributedString* contentText = [[NSAttributedString alloc] initWithString:@"Test String"];
    UIImage* contentImage =[UIImage imageNamed:@"testImage.jpeg"];
    [Communication imageWithImage:contentImage scaledToSize:CGSizeMake(_BackGroundView.bounds.size.width - 2*OFFSET_FROM_FRAME, _BackGroundView.bounds.size.width - 2*OFFSET_FROM_FRAME)];
    CGRect textBounds;
    textBounds.origin = CGPointMake(0.0f, contentImage.size.height);
    textBounds.size = [contentText size];
    [contentImage drawInRect:thisView.bounds];
    [contentText drawInRect:textBounds];
}


- (IBAction)addNewsFeed:(id)sender {
}

- (void)resignOnTap:(id)sender {
    //[self.currentResponder resignFirstResponder];
    NSLog(@"Single Tab detacted");
   // [iSender.imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    if ([sender isKindOfClass:[UIImageView class]]) {
        [sender setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
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
