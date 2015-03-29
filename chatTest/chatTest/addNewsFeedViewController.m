//
//  addNewsFeedViewController.m
//  chatTest
//
//  Created by Simin Liu on 3/19/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "addNewsFeedViewController.h"
#import "RSKImageCropViewController.h"
#import "Communication.h"
#import "OwnerNewsFeed.h"
#import "NewsFeedList.h"
#import "AppDelegate.h"

@interface addNewsFeedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addImage;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *uiView;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *SendNewsFeed;
@property (weak, nonatomic) IBOutlet UITextField *BodyTextField;

@property (strong, nonatomic) NSString* uuidString;

@property (nonatomic, assign) id currentResponder;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *delayedPhotoButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;

@end

@implementation addNewsFeedViewController

@synthesize outImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    self.capturedImages = [[NSMutableArray alloc] init];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        [toolbarItems removeObjectAtIndex:2];
        [self.toolBar setItems:toolbarItems animated:NO];
    }
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_imageView setUserInteractionEnabled:YES];
    [_imageView addGestureRecognizer:doubleTap];

}

-(void)awakeFromNib{
    [_uiView setNeedsDisplay];
}

- (void)resignOnTap:(id)sender {
    NSLog(@"Single Tab detacted");
    [self.currentResponder resignFirstResponder];
    UIImage* image = _imageView.image;
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];

    
}
- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
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
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
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
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.capturedImages addObject:image];
    
    if ([self.cameraTimer isValid])
    {
        return;
    }
    
    [self finishAndUpdate];
    //UIImage *image = _imageView.image;
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:NO];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [_uiView setNeedsDisplay];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    [_uiView setNeedsDisplay];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.imageView.image = croppedImage;
    _imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    self.imageView.image = croppedImage;
    _imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
    // Use when `applyMaskToCroppedImage` set to YES.
    //[SVProgressHUD show];
}

- (IBAction)SendNewsFeedToServer:(id)sender {
    NSLog(@"Inside send FR");
    //If user upload Image
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    _uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Send through NSStrem
    NSString* testId = [prefs stringForKey:@"userID"];
    NSString* Body = _BodyTextField.text;
    NSString *newsFeedBody  = [NSString stringWithFormat:@"newstatus:{\"uuid\":%@,\"userID\":\"%@\",\"body\":\"%@\"}",_uuidString,testId,Body];
    NSMutableData *data = [[NSMutableData alloc] initWithData:[newsFeedBody dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    
    if (_imageView.image!=nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        NSData* result = nil;
        NSHTTPURLResponse* response = nil;
        NSError* error = nil;
        int statusCode = 0;
        NSURL* requestURL = [NSURL URLWithString:@"http://54.69.204.42:8000/form"];
        NSData* bodyimage =UIImageJPEGRepresentation(_imageView.image,1.0);
        NSString* testImage = [bodyimage base64EncodedStringWithOptions:0];
        NSMutableData* body  =[[NSString stringWithFormat:@"{\"%@\":\"%@\"}", _uuidString,testImage] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=this is test boundary"];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPBody:body];
        
        // set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        // set URL
        [request setURL:requestURL];
        NSLog(@"%@", [request allHTTPHeaderFields]);
        
        result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSLog( @"NSURLConnection result %ld %@ %@", (long)[response statusCode], [request description], [error description] );
        statusCode = [response statusCode];
        if ( (statusCode == 0) || (!result && statusCode == 200) ) {
            statusCode = 500;}
    }
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
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        NSLog(@"This return string from server %@",output);
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                {
                                    //If secceed set ownerNewsFeed item
                                    OwnerNewsFeed* news = nil;
                                    news = [NSEntityDescription insertNewObjectForEntityForName:@"OwnerNewsFeed" inManagedObjectContext:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
                                    
                                    [news setValue: _BodyTextField.text forKey :@"bodyTextField"];
                                    NSData *imageData = UIImageJPEGRepresentation([Communication compressToSmallSquare:_imageView.image],0.0);
                                    [news setValue: imageData forKey :@"image"];
                                    [news setValue:_uuidString forKey:@"uuid"];
                                    NSDate *now = [NSDate date];
                                    [news setValue:now forKey:@"date"];
                                    
                                    NewsFeedList* newList = nil;
                                    newList = [NSEntityDescription insertNewObjectForEntityForName:@"NewsFeedList" inManagedObjectContext:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
                                    [newList setValue: _BodyTextField.text forKey :@"bodyTextField"];
                                    [newList setValue: imageData forKey :@"image"];
                                    [newList setValue:_uuidString forKey:@"uuid"];
                                    [newList setValue:now forKey:@"date"];
                                    
                                    
                                    
                                    //If failed
                                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                                                   message:@"This is an alert."
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                          handler:^(UIAlertAction * action) {}];
                                    
                                    UIAlertAction* reSendAction = [UIAlertAction actionWithTitle:@"Resend" style:UIAlertActionStyleDefault
                                                                                         handler:^(UIAlertAction * action) {[self SendNewsFeedToServer:nil];}];
                                    
                                    [alert addAction:defaultAction];
                                    [alert addAction:reSendAction];
                                    [self presentViewController:alert animated:YES completion:nil];
                                    // NSLog(@"trigger segue");
                                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"LogInNotification" object:self];
                                    //[self performSegueWithIdentifier:@"login" sender:nil];
                                    
                                    break;}
                                    
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
            NSLog(@"Can not connect to the host!");
            break;
            
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

@end