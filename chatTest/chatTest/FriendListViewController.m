//
//  FriendListViewController.m
//  chatTest
//
//  Created by Simin Liu on 4/30/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "FriendListViewController.h"
#import "PersonalprofileViewController.h"
#import "AppDelegate.h"
#define OFF_SET 10.0
@interface FriendListViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *redDot;
@property (strong,nonatomic)NSString* searchString;


@end

@implementation FriendListViewController
BOOL isSearching;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    _searchBar.delegate = self;
    isSearching = false;
    _searchBar.showsCancelButton = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)searchBarDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [_searchBar resignFirstResponder];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    isSearching = true;
    _searchString = [[@"*" stringByAppendingString:searchText ] stringByAppendingString:@"*"];
    [[_mainView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self setup];
    [_mainView setNeedsDisplay];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder]; // using method search bar
    [_searchBar resignFirstResponder]; // using actual object name
    [self.view endEditing:YES];
    isSearching = false;
}


-(void)setup
{
    CGPoint startPt = _mainView.bounds.origin;
    CGFloat buttonWeigth = _mainView.bounds.size.width/3-2*OFF_SET;
    CGFloat buttonHeight = buttonWeigth*1.3;
    
    
    
    // managedObjectContent = [[[UIApplication sharedApplication]delegate] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.predicate = nil;
    if(isSearching){
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"userName like[c] %@",_searchString];
        [request setPredicate:predicate];

    }
    
    NSError *error;
    NSArray *array = [[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"userName" ascending:YES];
    NSArray *sortedList = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    //sortedList = [[sortedList reverseObjectEnumerator] allObjects];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        NSLog(@"%lu Friends available",(unsigned long)count);
        //NSMutableArray* newsFeedArray = [[NSMutableArray alloc]init];
       // for( Friend* friends in sortedList){
        for (int i =0; i<count; i++) {
            NSLog(@"Draw one persionButton");
            CGRect frame = CGRectMake(startPt.x+OFF_SET, startPt.y, buttonWeigth, buttonHeight);
            PersonUIButton* nameCard = [[PersonUIButton alloc]initWith:frame friendItem:sortedList[i]];
            [nameCard addTarget:self
                       action:@selector(buttonClicked:)
             forControlEvents:UIControlEventTouchDown];
            [_mainView addSubview:nameCard];
            nameCard.hidden = false;
            nameCard.backgroundColor = [UIColor clearColor];
            startPt.x = startPt.x + buttonWeigth+ 2*OFF_SET;
            if(startPt.x>=_mainView.bounds.size.width){
                startPt.y +=buttonHeight;
                startPt.x = _mainView.bounds.origin.x;
            //[_mainView setNeedsDisplay];
            }

        }
        //[_mainView setNeedsDisplay];
    }
    else {
        // Deal with error.
        NSLog(@"No Friends Available");
    }
    _redDot.image = [UIImage imageNamed:@"Date"];
    
}

-(void)buttonClicked:(PersonUIButton*)sender
{
    NSLog(@"buttonClick detacted");
    if ([sender isKindOfClass:[PersonUIButton class]]) {
        NSLog(@"This is a PersonalUIBUtton");
        //[sender.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        NSLog(@"UserName is %@",sender.myFriend.userName);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       PersonalprofileViewController *viewController = (PersonalprofileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        viewController.friends = sender.myFriend;
        //[self presentViewController:viewController animated:YES completion:nil];
        [[self navigationController] pushViewController:viewController animated:YES];
    }

}

@end
