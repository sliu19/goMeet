
#import "ModifyProfileViewController.h"
#import "Communication.h"
#import "MainTabBarViewController.h"
#import <Parse/Parse.h>

@interface ModifyProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *intro;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (nonatomic, assign) UITextField* currentResponder;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *delayedPhotoButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic) RSKImageCropViewController* imageCropController;

@end

@implementation ModifyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _nickName.delegate = self;
    _intro.delegate =self;
    _email.delegate = self;
    _location.delegate = self;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _nickName.text = [prefs objectForKey:@"nickName"];
    _intro.text = [prefs objectForKey:@"intro"];
    _email.text = [prefs objectForKey:@"email"];
    _location.text = [prefs objectForKey:@"location"];
    if([prefs dataForKey:@"userPic"]==nil){
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"blankUser.jpg"],1);
        [prefs setObject:imageData forKey:@"userPic"];
    }
    _userPic.image = [[UIImage alloc]initWithData:[prefs dataForKey:@"userPic"]];
    _userID.text = [prefs objectForKey:@"userID"];
    _gender.text = @"男";
    if ([[prefs stringForKey:@"gender"] isEqualToString:@"F"]){
        _gender.text = @"女";
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePicTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_userPic setUserInteractionEnabled:YES];
    [_userPic addGestureRecognizer:doubleTap];
    
    
    _userPic.layer.cornerRadius = _userPic.frame.size.width / 2;
    _userPic.clipsToBounds = YES;


    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePic:(id)sender {
}
- (IBAction)confirm:(id)sender {
    //profile:{"phone":6505758649,"nick":"mynickname","intro":"password","location":"mylocation","pass":"mypassword","email":"myemail"} only phoneNumberrequired
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"phone":[prefs objectForKey:@"userID"],@"intro":_intro.text,@"nick":_nickName.text,@"location":_location.text,@"email":_email.text};
    NSString *response  = [NSString stringWithFormat:@"profile:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
}



- (void)changePicTap:(id)iSender {
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:_userPic.image];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}
-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
    [self animateTextField: textField up: YES];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.currentResponder resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField *)textField up: (BOOL) up
{
    CGPoint textFieldCenter = textField.center;
    CGPoint textPosition = [_currentResponder convertPoint:textFieldCenter fromView:self.view];
    NSLog(@"POSITION IS %f",textPosition.y);
    const int movementDistance = -textPosition.y-80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    NSLog(@"start pick pics");
    self.capturedImages = [[NSMutableArray alloc] init];

    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.userPic.isAnimating)
    {
        [self.userPic stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


#pragma mark - Toolbar actions

- (IBAction)done:(id)sender
{
    // Dismiss the camera.
    if ([self.cameraTimer isValid])
    {
        [self.cameraTimer invalidate];
    }
    [self finishAndUpdate];
}


- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}


- (IBAction)delayedTakePhoto:(id)sender
{
    // These controls can't be used until the photo has been taken
    self.doneButton.enabled = NO;
    self.takePictureButton.enabled = NO;
    self.delayedPhotoButton.enabled = NO;
    self.startStopButton.enabled = NO;
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    NSTimer *cameraTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0 target:self selector:@selector(timedPhotoFire:) userInfo:nil repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:cameraTimer forMode:NSDefaultRunLoopMode];
    self.cameraTimer = cameraTimer;
}


- (IBAction)startTakingPicturesAtIntervals:(id)sender
{
    /*
     Start the timer to take a photo every 1.5 seconds.
     
     CAUTION: for the purpose of this sample, we will continue to take pictures indefinitely.
     Be aware we will run out of memory quickly.  You must decide the proper threshold number of photos allowed to take from the camera.
     One solution to avoid memory constraints is to save each taken photo to disk rather than keeping all of them in memory.
     In low memory situations sometimes our "didReceiveMemoryWarning" method will be called in which case we can recover some memory and keep the app running.
     */
    self.startStopButton.title = NSLocalizedString(@"Stop", @"Title for overlay view controller start/stop button");
    [self.startStopButton setAction:@selector(stopTakingPicturesAtIntervals:)];
    
    self.doneButton.enabled = NO;
    self.delayedPhotoButton.enabled = NO;
    self.takePictureButton.enabled = NO;
    
    self.cameraTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timedPhotoFire:) userInfo:nil repeats:YES];
    [self.cameraTimer fire]; // Start taking pictures right away.
}


- (IBAction)stopTakingPicturesAtIntervals:(id)sender
{
    // Stop and reset the timer.
    [self.cameraTimer invalidate];
    self.cameraTimer = nil;
    
    [self finishAndUpdate];
}


- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"Number of pic picked %lu",(unsigned long)[self.capturedImages count]);
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            NSLog(@"ONE single picture");
            
            [self.userPic setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.userPic.animationImages = self.capturedImages;
            self.userPic.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.userPic.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.userPic startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
}


#pragma mark - Timer

// Called by the timer to take a picture.
- (void)timedPhotoFire:(NSTimer *)timer
{
    [self.imagePickerController takePicture];
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPicking pic");
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //_imageView.image = image;
    [self.capturedImages addObject:image];
    
    if ([self.cameraTimer isValid])
    {
        NSLog(@"return here");
        return;
    }
    
    [self finishAndUpdate];
    //UIImage *image = _imageView.image;
    //RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    // imageCropVC.delegate = self;
    // [self.navigationController pushViewController:imageCropVC animated:NO];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.userPic.image = croppedImage;
    _userPic.image = croppedImage;
    [self.navigationController presentViewController:self.imageCropController animated:NO completion: nil];
   // [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    self.userPic.image = croppedImage;
    _userPic.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
    // Use when `applyMaskToCroppedImage` set to YES.
    //[SVProgressHUD show];
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
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = (int)[inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                {
                                    NSLog(@"successful modifile");
                                    //6505758649,"nick":"mynickname","intro":"password","location":"mylocation","pass":"mypassword","email":"myemail"} only phoneNumberrequired
                                    
                                    // Create instances of NSData
                                    CGFloat compressionRatio = 1 ;
                                    UIImage *contactImage = _userPic.image;
                                    NSData *imageData = UIImageJPEGRepresentation(contactImage,compressionRatio);
                                    while ([imageData length]>20000) {
                                        compressionRatio=compressionRatio*0.5;
                                        imageData=UIImageJPEGRepresentation(contactImage,compressionRatio);
                                    }
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    
                                    PFQuery *query = [PFQuery queryWithClassName:@"People"];
                                    [query getObjectInBackgroundWithId:[defaults objectForKey:@"parseID"] block:^(PFObject *user, NSError *error) {
                                            PFFile *file = [PFFile fileWithName:@"smallPic" data:imageData];
                                        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {if(succeeded){
                                            user[@"smallPicFile"] = file;
                                            [user saveInBackground];
                                        }
                                            
                                        } progressBlock:^(int percentDone) {
                                            NSLog(@"Finish percentage is %d",percentDone);
                                        }];
                                    }];
                                    
                                    // Store the data
                                    
                                    
                                    [defaults setObject:[_nickName text] forKey:@"nickName"];
                                    [defaults setObject:[_intro text] forKey:@"intro"];
                                    [defaults setObject:[_location text] forKey:@"location"];
                                    [defaults setObject:[_email text]forKey:@"email"];
                                    [defaults setObject:imageData forKey:@"userPic"];
                                    [defaults synchronize];
                                    
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
                                    [viewController setSelectedIndex:1];
                                    [self presentViewController:viewController animated:YES completion:nil];                                    break;
                                }
                                    
                                default:
                                    NSLog(@"output int val %d", output.intValue);
                                    break;
                            }
                            NSLog(@"server said: %@", output);
                            
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
            //[alert addButtonWithTitle:@"Yes"];
            [alert show];
            [Communication initNetworkCommunication];
            break;
        }
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}





@end
