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
#import "Communication.h"
#import "newFriendNoticeViewController.h"
#import "FriendCell.h"
#define OFF_SET 10.0
@interface FriendListViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *redDot;
@property (strong,nonatomic)NSString* searchString;
@property (strong,atomic)NSArray* resultList;
@property (strong,atomic)NSArray* sortedList;
@property (weak, nonatomic) IBOutlet UICollectionView *friendCollectionView;

@end

@implementation FriendListViewController
BOOL isSearching;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    _searchBar.delegate = self;
    isSearching = false;
    _searchBar.showsCancelButton = YES;

    _redDot.layer.cornerRadius = _redDot.frame.size.width / 2;
    _redDot.clipsToBounds = YES;
    //show reddot for test purpose
    _redDot.hidden = YES;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* request = [NSString stringWithFormat:@"getfriendrequests:%@",[prefs objectForKey:@"userID"]];
    NSData *data = [[NSData alloc] initWithData:[request dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    [self.friendCollectionView setDelegate:self];
    [self.friendCollectionView setDataSource:self];
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
    [[_friendCollectionView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self setup];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder]; // using method search bar
    [_searchBar resignFirstResponder]; // using actual object name
    [self.view endEditing:YES];
    isSearching = false;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_searchBar resignFirstResponder];
}

-(void)setup
{
    // managedObjectContent = [[[UIApplication sharedApplication]delegate] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.predicate = nil;
    if(isSearching){
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"userNickName like[c] %@",_searchString];
        [request setPredicate:predicate];

    }
    
    NSError *error;
    NSArray *array = [[NSArray alloc]init];
    array = [[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"userNickName" ascending:YES];
    _sortedList = [[NSArray alloc]init];
    _sortedList=[array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        NSLog(@"%lu Friends available",(unsigned long)count);
        //NSMutableArray* newsFeedArray = [[NSMutableArray alloc]init];
       // for( Friend* friends in sortedList){
            //CGRect frame = CGRectMake(startPt.x+OFF_SET, startPt.y, buttonWeigth, buttonHeight);
            //FriendCell* nameCard = [[FriendCell alloc]initWith:frame friendItem:_sortedList[i]];;
    }
    else {
        // Deal with error.
        NSLog(@"No Friends Available");
    }
    [self.friendCollectionView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"friendNotification"])
    {
        newFriendNoticeViewController *vc = [segue destinationViewController];
        vc.notificationList = _resultList;
    }
    if ([[segue identifier] isEqualToString:@"FriendProfile"]) {
        PersonalprofileViewController* vc = [segue destinationViewController];
        FriendCell* friend = (FriendCell*)sender;
        vc.friends = friend.myFriend;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 120);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Numver of cells %lu",[self.sortedList count]);
    return [self.sortedList count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Array is %@",self.sortedList);
    FriendCell *cell= [self.friendCollectionView dequeueReusableCellWithReuseIdentifier:@"FriendCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSLog(@"index number is %lu",indexPath.row);
    cell.myFriend = _sortedList[indexPath.row];
    cell.selectedPic.hidden = true;
    return cell;
}

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
                NSInteger len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSData *output = [[NSData alloc] initWithBytes:buffer length:len];
                        
                        if (nil != output) {
                            NSLog(@"have friend request available");
                            _redDot.hidden = false;
                            NSDictionary*result = [Communication parseFromJson:output];
                            NSArray* resultList = [result objectForKey:@"requests"];
                            NSLog(@"RESULT IS %@",[result objectForKey:@"requests"]);
                            _resultList = resultList;
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"Can not connect to the host!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"链接不上服务器" message:@"稍微晚些时候试试吧？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert addButtonWithTitle:@"Yes"];
            [alert show];
            break;
        }
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}




@end
