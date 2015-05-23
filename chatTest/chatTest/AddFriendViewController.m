//
//  AddFriend.m
//  chatTest
//
//  Created by Simin Liu on 3/16/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "AddFriendViewController.h"
#import "MainTabBarViewController.h"
#import "Communication.h"

@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addFriendTextField;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (nonatomic, assign) id currentResponder;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchFriend;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *MessageTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmSearch;
@property (strong,nonatomic) NSString* newfriend;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
     NSLog(@"AddFriendPage");
    _addFriendTextField.delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    _searchFriend.delegate = self;
    _newfriend = @"111111111";
    //[self setUserInteractionEnabled:YES];
    //[iv addGestureRecognizer:singleTap];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchPeople:(id)sender {
    NSLog(@"searchNumber %@",_searchFriend.text);
    _newfriend = _searchFriend.text;
    //seekuser:6505758649
    NSString* response = [NSString stringWithFormat:@"seekuser:%@",_newfriend];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
}



- (IBAction)sendRequest:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Send through NSStrem
    //addfriend:6505758649#1234567899
    NSString* userId = [prefs stringForKey:@"userID"];
    //addfriend:{"src_user":12341234,"msg":"omg my message","dst_user":68958695}
    NSDictionary* dict = @{@"src_user":userId,@"msg":@"test test test friend request",@"dst_user":_newfriend};
    NSString* response = [NSString stringWithFormat:@"addfriend:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];    
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
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
                                [viewController setSelectedIndex:0];
                                [self presentViewController:viewController animated:YES completion:nil];

                            NSLog(@"server said: %@", output);
                        }
                        
                            
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"Can not connect to the host!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"链接不上服务器" message:@"稍微晚些时候试试吧？" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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


-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder]; // using method search bar
    [_searchFriend resignFirstResponder]; // using actual object name
    [self.view endEditing:YES];
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
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
