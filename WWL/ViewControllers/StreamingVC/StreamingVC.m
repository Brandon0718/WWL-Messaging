//
//  StreamingVC.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <WowzaGoCoderSDK/WowzaGoCoderSDK.h>
#import <IJKMediaFrameWork/IJKFFMoviePlayerController.h>

#import "StreamingVC.h"
#import "WWLDefine.h"
#import "NewsTypeCell.h"
#import "UIView+MDCBlink.h"
#import "INTULocationManager.h"
#import "UIButton+Border.h"
#import "AppDelegate.h"
#import "PopupChannelListVC.h"
#import "PopupChatVC.h"
#import "ChannelModel.h"
#import "CallVC.h"
#import "LSFloatingActionMenu.h"
#import "MP4Writer.h"
#import "NSString+Date.h"
#import "UIView+Toast.h"

#define ITEM_PER_ROW 3


@interface StreamingVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, PopupChannelSelectedDelegate, PopupChatDelegate, NewMessageDelegate, CallDelegate, UITableViewDelegate, UITableViewDataSource, WZStatusCallback, WZVideoSink, WZAudioSink, WZVideoEncoderSink, WZAudioEncoderSink, WZDataSink>
{
    UIEdgeInsets sectionInsets;
    
    INTULocationRequestID locationReq;
    
    BOOL isSubmittingLocation;
    NSTimeInterval timestamp;
    
    double last_lat;
    double last_lng;
    
    PopupChannelListVC *channelListVC;
    PopupChatVC* popupChatVC;
    int mUnreadCount;
    
    CallVC*     mVCCall;
    BOOL        mIsCallingOperator;
    
    EmergencyCallStatus emergencyCallStatus;
    
    UITableViewCell* activatedCell;
    UITableViewCell* recordOptionActivatedCell;
    LSFloatingActionMenuItem *recordOptionItem;
    
    UIDeviceOrientation currentOrientation;
    
    NSTimer* emergencyStreamTimer;
    
    StreamTypeModel* selectedNewsType;
}

#pragma mark - GoCoder SDK Components
@property (nonatomic, strong) WowzaGoCoder      *goCoder;
@property (nonatomic, strong) WowzaConfig       *goCoderConfig;
@property (nonatomic, strong) WZCameraPreview   *goCoderCameraPreview;

@property (nonatomic, strong) NSMutableArray    *receivedGoCoderEventCodes;

@property (nonatomic, strong) LSFloatingActionMenu *settingMenu;

#pragma mark - MP4Writing
@property (nonatomic, strong) MP4Writer         *mp4Writer;
@property (nonatomic, assign) BOOL              writeMP4;
@property (nonatomic, strong) dispatch_queue_t  video_capture_queue;

@end

@implementation StreamingVC

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    emergencyCallStatus = EmergencyCallStatusNone;
    
    sectionInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    self.navigationController.navigationBarHidden = YES;
  
    [self updateRecButton:NO];
    [self.btn_record setHidden:YES];
    [self.view_recording setHidden:YES];
    [self.view_chat setHidden:YES];
    [self.view_setting setHidden:YES];
    [self.view_streamRecordOption setHidden:YES];
    
    self.view_types.layer.cornerRadius = 8.0f;
    self.view_setting.layer.cornerRadius = 8.0f;
    self.view_streamRecordOption.layer.cornerRadius = 8.0f;
    
    self.view_recording.layer.borderWidth = 1.0f;
    self.view_recording.layer.borderColor = [[UIColor redColor] CGColor];
    self.view_recording.layer.cornerRadius = 3.0f;
    
    // Join Badge Tap Gesture to button event
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChat)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view_chat addGestureRecognizer:tapGesture];
    
    [MessagingManager sharedManager].messageDelegate = self;
    
    mUnreadCount = 0;
    [[ChannelManager sharedManager] getUnreadCount:^(NSUInteger unreadCount) {
        mUnreadCount += unreadCount;
        
        if(mUnreadCount) {
            self.lbl_chat_unread.text = [NSString stringWithFormat:@"%lu", (unsigned long)mUnreadCount];
        } else {
            self.lbl_chat_unread.text = @"";
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDeactive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    if(self.mode == StreamModeEmergency) {
        self.view_rotateWarning.hidden = YES;
        self.btn_back.hidden = NO;
        [self loadEmergencyInfo];
    } else if(self.mode == StreamModeNormal) {
        [self rotateWarningText:[[UIDevice currentDevice] orientation]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    currentOrientation = [UIDevice currentDevice].orientation;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // setup wowza sdk
    [self setupWowzaGoCoder];
    
    [self onSetting:nil];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.goCoder.cameraPreview.previewLayer.frame = self.view.bounds;
    
    self.view_rotateDesc.frame = self.view.frame;
    self.btn_backOrient.frame = CGRectMake(16, 36, 35, 34);
    self.img_rotateWarning.frame = CGRectMake((self.view_rotateDesc.bounds.size.width - 300) / 2, (self.view_rotateDesc.bounds.size.height - 300) / 2, 300, 300);
}

-(BOOL)shouldAutorotate {
    if(self.mode == StreamModeNormal) {
        return NO;
    } else {
        return YES;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if(self.mode == StreamModeNormal || [AppDelegate shared].mIsStreamingEmergency) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if(self.mode == StreamModeNormal) {
        return UIInterfaceOrientationLandscapeRight;
    } else {
        return UIInterfaceOrientationPortrait;
    }
}

-(void)loadEmergencyInfo {
    // We should get channels and news types here
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait";
    [[MyService shared] getChannels:^(BOOL success, id res) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(success) {
            if ([res[@"status"] isEqualToString:@"ok"]) {
                NSMutableArray* tmp_channels = [[NSMutableArray alloc] init];
                NSArray* channels = res[@"data"];
                for (NSDictionary* item in channels) {
                    ChannelModel* modelItem = [[ChannelModel alloc] initWith:item];
                    [tmp_channels addObject:modelItem];
                }
                
                self.selectedChannels = tmp_channels;
                
                MBProgressHUD* newsTypeHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                newsTypeHud.labelText = @"Please wait";
                
                // Get Stream types
                [[MyService shared] getStreamTypes:^(BOOL success, id res) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if (success) {
                        if([res[@"status"] isEqualToString:@"ok"]) {
                            NSMutableArray* types = [[NSMutableArray alloc] init];
                            NSArray* data = res[@"data"];
                            
                            for(NSDictionary* item in data) {
                                StreamTypeModel* model = [[StreamTypeModel alloc] initWith:item];
                                if([model.name isEqualToString:@"Fire"] ||
                                   [model.name isEqualToString:@"Accident"] ||
                                   [model.name isEqualToString:@"Crime"] ||
                                   [model.name isEqualToString:@"War"] ||
                                   [model.name isEqualToString:@"Weather"] ||
                                   [model.name isEqualToString:@"Other"]) {
                                    [types addObject:model];
                                }
                            }
                            
                            self.types = types;
                            [self.cv_types reloadData];
                        }
                    } else {
                        NSError* err = (NSError*)res;
                        [self showAlertWithTitle:@"Error" message:err.localizedDescription];
                    }
                }];
            } else {
                [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
            }
        } else {
            NSError* err = (NSError*)res;
            [self showAlertWithTitle:@"Error" message:err.localizedDescription];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateRecButton:(BOOL) recording {
    if(recording) {
        self.btn_record.hidden = NO;
        [self.btn_record setImage:[UIImage imageNamed:@"icon_btn_recstop_normal"] forState:UIControlStateNormal];
        [self.btn_record setImage:[UIImage imageNamed:@"icon_btn_recstop_selected"] forState:UIControlStateHighlighted];
    } else {
        self.btn_record.hidden = YES;
        [self.btn_record setImage:[UIImage imageNamed:@"icon_btn_rec_normal"] forState:UIControlStateNormal];
        [self.btn_record setImage:[UIImage imageNamed:@"icon_btn_rec_selected"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - System Notification Handlers
-(void) onApplicationActive:(NSNotification*) notification {
    NSLog(@"application_log:Application activated!");
    
    // Wait for 1 sec for deactive soon
    if(emergencyCallStatus == EmergencyCallStatusAccept) {
        emergencyStreamTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onEmergencyCallEnded) userInfo:nil repeats:NO];
    } else {
        emergencyCallStatus = EmergencyCallStatusNone;
    }
}

-(void) onApplicationDeactive:(NSNotification*) notification {
    NSLog(@"application_log:Application Deactivated!");
    if(emergencyStreamTimer) {
        [emergencyStreamTimer invalidate];
        emergencyStreamTimer = nil;
    }
    
    [self.view_rotateDesc setTransform:CGAffineTransformMakeRotation(0)];
    self.view_rotateWarning.hidden = YES;
}

- (void) onEmergencyCallEnded {
    [self startEmergencyStream:NO];
}

- (void) startEmergencyStream:(BOOL) isResume {
    emergencyCallStatus = EmergencyCallStatusNone;
    
    // Ensure the minimum set of configuration settings have been specified necessary to
    // initiate a broadcast streaming session
    NSError *configError = [self.goCoder.config validateForBroadcast];
    if (configError != nil) {
        [self showAlertWithTitle:@"Incomplete Streaming Settings" message:configError.localizedDescription];
        return;
    }
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(isResume) {
        hud.labelText = @"Resume Streaming";
    } else {
        hud.labelText = @"Start Streaming";
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.receivedGoCoderEventCodes removeAllObjects];
        [self.goCoder startStreaming:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    });
}

-(void) onOrientationDidChange:(NSNotification*) notification {
    UIDevice * device = notification.object;
    
    if(self.mode == StreamModeNormal || (self.goCoder.status.state == WZStateRunning && self.mode == StreamModeEmergency)) {
        [self rotateWarningText:device.orientation];
    }
    
    if(self.mode == StreamModeEmergency && ![AppDelegate shared].mIsStreamingEmergency) {
        [self.cv_types reloadData];
        
        // Get Preview Layer connection
        AVCaptureConnection *previewLayerConnection=self.goCoderCameraPreview.previewLayer.connection;
        
        if ([previewLayerConnection isVideoOrientationSupported]) {
            switch(device.orientation) {
                case UIDeviceOrientationLandscapeLeft:
                    [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                    break;
                case UIDeviceOrientationLandscapeRight:
                    [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
                    break;
                case UIDeviceOrientationPortrait:
                    [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
                    break;
                default:
                    [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                    break;
            }
        }
    } else {
        // Get Preview Layer connection
        if(self.goCoderCameraPreview.previewLayer.connection.videoOrientation != AVCaptureVideoOrientationLandscapeRight) {
            AVCaptureConnection *previewLayerConnection=self.goCoderCameraPreview.previewLayer.connection;
            if ([previewLayerConnection isVideoOrientationSupported]) {
                [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            }
        }
    }
    
    if(self.settingMenu && currentOrientation != device.orientation) {
        currentOrientation = device.orientation;
        [self.settingMenu removeFromSuperview];
        self.settingMenu = nil;
        self.btn_setting.hidden = NO;
        
        [self onSetting:nil];
    }
}

- (void) rotateWarningText:(UIDeviceOrientation) orientation {
    switch(orientation) {
        case UIDeviceOrientationLandscapeLeft:
            [self.view_rotateDesc setTransform:CGAffineTransformMakeRotation(0)];
            self.view_rotateWarning.hidden = YES;
            if(self.goCoder.status.state == WZStateIdle) {
                self.btn_back.hidden = NO;
            }
            self.view_rotateDesc.bounds = self.view.bounds;
            break;
        case UIDeviceOrientationLandscapeRight:
            self.view_rotateWarning.hidden = NO;
            self.btn_back.hidden = YES;
            [self.view_rotateDesc setTransform:CGAffineTransformMakeRotation(-M_PI)];
            self.view_rotateDesc.bounds = self.view.bounds;
            break;
        case UIDeviceOrientationPortrait:
            self.view_rotateWarning.hidden = NO;
            self.btn_back.hidden = YES;
            [self.view_rotateDesc setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            self.view_rotateDesc.bounds = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
            self.view_rotateDesc.center = self.view.center;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            self.view_rotateWarning.hidden = NO;
            self.btn_back.hidden = YES;
            [self.view_rotateDesc setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            self.view_rotateDesc.bounds = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
            self.view_rotateDesc.center = self.view.center;
            break;
        case UIDeviceOrientationFaceUp:
            self.view_rotateWarning.hidden = NO;
            self.btn_back.hidden = YES;
            break;
        default:
            self.view_rotateWarning.hidden = YES;
            if(self.goCoder.status.state == WZStateIdle) {
                self.btn_back.hidden = NO;
            }
            [self.view_rotateDesc setTransform:CGAffineTransformMakeRotation(0)];
            break;
    }
    
    self.btn_backOrient.frame = CGRectMake(16, 36, 35, 34);
    self.img_rotateWarning.frame = CGRectMake((self.view_rotateDesc.bounds.size.width - 300) / 2, (self.view_rotateDesc.bounds.size.height - 300) / 2, 300, 300);
}

- (IBAction)onBack:(id)sender {
    [self.goCoderCameraPreview stopPreview];
    self.goCoder.cameraView = nil;
    [self.goCoder unregisterVideoSink:self];
    [self.goCoder unregisterAudioSink:self];
    [self.goCoder unregisterVideoEncoderSink:self];
    [self.goCoder unregisterAudioEncoderSink:self];
    [self.goCoder unregisterDataSink:self eventName:@"onTextData"];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBackOrient:(id)sender {
    [self onBack:sender];
}

#pragma mark - User Actions

- (IBAction)onBtnRecord:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.goCoder endStreaming:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.streamDelegate) {
                [self.streamDelegate channelStreamEnded:self.selectedChannels];
            }
            [self onBack:nil];
        });
    });
}

-(void) onChat {
    channelListVC = (PopupChannelListVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"PopupChannelListVC" storyboardName:kStoryboardTwilio];
    channelListVC.channelSelectedDelegate = self;
    
    channelListVC.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController*presentController = [channelListVC popoverPresentationController];
    presentController.delegate = self;
    presentController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    presentController.sourceView = self.view_chat;
    presentController.sourceRect = self.view_chat.bounds;
    
    [self presentViewController:channelListVC animated:YES completion:^{
        self.btn_record.hidden = YES;
        self.btn_setting.hidden = YES;
    }];
}

-(void)channelSelected:(TCHChannel *)channel {
    popupChatVC = (PopupChatVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"PopupChatVC" storyboardName:kStoryboardTwilio];
    [popupChatVC setChannel:channel];
    popupChatVC.providesPresentationContextTransitionStyle = YES;
    popupChatVC.definesPresentationContext = YES;
    popupChatVC.popupChatDelegate = self;
    [popupChatVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:popupChatVC animated:YES completion:^{
        // Hide some controls Here
        [self.view_chat setHidden:YES];
    }];
}

-(void)PopupChatClosed {
    popupChatVC = nil;
    
    self.btn_record.hidden = NO;
    self.btn_setting.hidden = NO;
    
    mUnreadCount = 0;
    [[ChannelManager sharedManager] getUnreadCount:^(NSUInteger unreadCount) {
        mUnreadCount += unreadCount;
        
        if(mUnreadCount) {
            self.lbl_chat_unread.text = [NSString stringWithFormat:@"%lu", (unsigned long)mUnreadCount];
        } else {
            self.lbl_chat_unread.text = @"";
        }
    }];
    
    // Show some controls again
    [self.view_chat setHidden:NO];
}

- (IBAction)onSetting:(id)sender {
    self.btn_setting.hidden = YES;
    
    NSString* micOnIcon = self.goCoder.isAudioMuted ? @"icon_stream_setting_mic_off" : @"icon_stream_setting_mic_on";
    NSString* flasOnIcon = self.goCoderCameraPreview.camera.torchOn ? @"icon_stream_setting_flash_on" : @"icon_stream_setting_flash_off";
    NSString* localRecordIcon = @"icon_stream_setting_local_off";
    switch([UserContextManager sharedInstance].streamRecordOption) {
        case StreamRecordOptionWeb:
            localRecordIcon = @"icon_stream_setting_local_off";
            break;
        case StreamRecordOptionPhone:
            localRecordIcon = @"icon_stream_setting_local_on";
            break;
        default:
            break;
    }
    
    NSArray *menuIcons;
    if(self.goCoder.status.state != WZStateRunning) {
        menuIcons = @[@"icon_stream_setting", @"icon_stream_setting_camera", @"icon_stream_setting_resolution", micOnIcon, flasOnIcon, localRecordIcon];
    } else {
        menuIcons = @[@"icon_stream_setting", @"icon_stream_setting_camera", micOnIcon, flasOnIcon];
    }
    
    NSMutableArray *menus = [NSMutableArray array];
    
    CGSize itemSize = self.btn_setting.frame.size;
    for (NSString *icon in menuIcons) {
        LSFloatingActionMenuItem *item = [[LSFloatingActionMenuItem alloc] initWithImage:[UIImage imageNamed:icon] highlightedImage:[UIImage imageNamed:icon]];
        item.itemSize = itemSize;
        
        [menus addObject:item];
    }
    
    self.settingMenu = [[LSFloatingActionMenu alloc] initWithFrame:self.view_settingBack.bounds
                                                         direction:LSFloatingActionMenuDirectionRight
                                                         menuItems:menus
                                                       menuHandler:^(LSFloatingActionMenuItem *item, NSUInteger index) {
        NSLog(@"Clicked at index %d", (int)index);
                                                           if(self.goCoder.status.state == WZStateRunning) {
                                                               switch(index) {
                                                                   case 1: // switch camera;
                                                                       [self.goCoderCameraPreview switchCamera];
                                                                       break;
                                                                   case 2: // stream mic off
                                                                   {
                                                                       BOOL newMutedState = !self.goCoder.isAudioMuted;
                                                                       self.goCoder.audioMuted = newMutedState;
                                                                       
                                                                       if(newMutedState) {
                                                                           item.image = [UIImage imageNamed:@"icon_stream_setting_mic_off"];
                                                                           item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_mic_off"];
                                                                           [self.view makeToast:@"Muted"];
                                                                       } else {
                                                                           item.image = [UIImage imageNamed:@"icon_stream_setting_mic_on"];
                                                                           item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_mic_on"];
                                                                           [self.view makeToast:@"Mic On"];
                                                                       }
                                                                       break;
                                                                   }
                                                           case 3: // camera flash on/off
                                                               {
                                                                   BOOL newTorchOnState = !self.goCoderCameraPreview.camera.torchOn;
                                                                   
                                                                   self.goCoderCameraPreview.camera.torchOn = newTorchOnState;
                                                                   
                                                                   if(newTorchOnState) {
                                                                       item.image = [UIImage imageNamed:@"icon_stream_setting_flash_on"];
                                                                       item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_flash_on"];
                                                                   } else {
                                                                       item.image = [UIImage imageNamed:@"icon_stream_setting_flash_off"];
                                                                       item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_flash_off"];
                                                                   }
                                                                   break;
                                                               }
                                                           default:
                                                               break;
                                                           }
                                                       } else {
                                                           switch(index) {
                                                               case 1: // switch camera;
                                                                   [self.goCoderCameraPreview switchCamera];
                                                                   break;
                                                               case 2: // stream resolution
                                                                   if(self.goCoder.status.state != WZStateRunning) {
                                                                       self.view_setting.alpha = 100;
                                                                       [self.view_setting setHidden:![self.view_setting isHidden]];
                                                                   } else {
                                                                       [self presentSimpleAlert:@"Stream Resolution update is not allowed while streaming." title:@"Streaming"];
                                                                   }
                                                                   break;
                                                               case 3: // mic on/off
                                                               {
                                                                   BOOL newMutedState = !self.goCoder.isAudioMuted;
                                                                   self.goCoder.audioMuted = newMutedState;
                                                                   
                                                                   if(newMutedState) {
                                                                       item.image = [UIImage imageNamed:@"icon_stream_setting_mic_off"];
                                                                       item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_mic_off"];
                                                                       [self.view makeToast:@"Muted"];
                                                                   } else {
                                                                       item.image = [UIImage imageNamed:@"icon_stream_setting_mic_on"];
                                                                       item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_mic_on"];
                                                                       [self.view makeToast:@"Mic On"];
                                                                   }
                                                                   break;
                                                               }
                                                               case 4: // camera flash on/off
                                                               {
                                                                   BOOL newTorchOnState = !self.goCoderCameraPreview.camera.torchOn;
                                                                   
                                                                   self.goCoderCameraPreview.camera.torchOn = newTorchOnState;
                                                                   
                                                                   if(newTorchOnState) {
                                                                       item.image = [UIImage imageNamed:@"icon_stream_setting_flash_on"];
                                                                       item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_flash_on"];
                                                                   } else {
                                                                       item.image = [UIImage imageNamed:@"icon_stream_setting_flash_off"];
                                                                       item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_flash_off"];
                                                                   }
                                                                   break;
                                                               }
                                                               case 5: // record to phone stream or just stream
                                                                   if(self.goCoder.status.state != WZStateRunning) {
                                                                       CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                                                                       
                                                                       // this is just one of many style options
                                                                       style.messageFont = [UIFont boldSystemFontOfSize:24.0f];
                                                                       
                                                                       if ([UserContextManager sharedInstance].streamRecordOption == StreamRecordOptionWeb) {
                                                                           [UserContextManager sharedInstance].streamRecordOption = StreamRecordOptionPhone;
                                                                           item.image = [UIImage imageNamed:@"icon_stream_setting_local_on"];
                                                                           item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_local_on"];
                                                                           
                                                                           [self.view makeToast:@"RECORD TO PHONE"
                                                                                       duration:1.0
                                                                                       position:CSToastPositionCenter
                                                                                          style:style];
                                                                       } else if ([UserContextManager sharedInstance].streamRecordOption == StreamRecordOptionPhone) {
                                                                           [UserContextManager sharedInstance].streamRecordOption = StreamRecordOptionWeb;
                                                                           item.image = [UIImage imageNamed:@"icon_stream_setting_local_off"];
                                                                           item.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_local_off"];
                                                                           
                                                                           [self.view makeToast:@"DO NOT RECORD TO PHONE"
                                                                                       duration:1.0
                                                                                       position:CSToastPositionCenter
                                                                                          style:style];
                                                                       }
                                                                   } else {
                                                                       [self presentSimpleAlert:@"Record Option update is not allowed while streaming." title:@"Streaming"];
                                                                   }
                                                                   break;
                                                               default:
                                                                   break;
                                                           }
                                                       }

                
    } closeHandler:^{
        [self.settingMenu removeFromSuperview];
        self.settingMenu = nil;
        self.btn_setting.hidden = NO;
    }];
    
    self.settingMenu.itemSpacing = 12;
    self.settingMenu.startPoint = self.btn_setting.center;
    self.settingMenu.rotateStartMenu = YES;
    
    [self.view_settingBack addSubview:self.settingMenu];
    [self.settingMenu open];
}



-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}

#pragma mark - Collection View Datasources and Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.types.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsTypeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsTypeCell" forIndexPath:indexPath];
    [cell configureCell:[self.types objectAtIndex:indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StreamTypeModel *newModel = [self.types objectAtIndex:indexPath.row];
    [self selectNewsTypeAndStartStreaming:newModel isResuming:NO];
}

-(void) selectNewsTypeAndStartStreaming:(StreamTypeModel*) newsType isResuming:(BOOL) isResuming {
    BOOL isEmergency = NO;
    if(self.mode == StreamModeEmergency) {
        isEmergency = YES;
    }
    
    MBProgressHUD* progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.labelText = @"Please wait...";
    
    [[MyService shared] generateStreamToken:(int)newsType.identifier
                                   channels:self.selectedChannels
                                isEmergency:isEmergency
                                deviceModel:[UIDevice currentDevice].model
                           streamResolution:(StreamResolution)[UserContextManager sharedInstance].streamResolution
                                      block:^(BOOL success, id res) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          if (success) {
                                              if([res[@"status"] isEqualToString:@"ok"]) {
                                                  NSLog(@"application_log stream token dic:%@", res);
                                                  
                                                  selectedNewsType = newsType;
                                                  
                                                  self.data = [[StreamInfoModel alloc] initWith:res];
                                                  
                                                  // set host address and stream name
                                                  self.goCoderConfig.hostAddress = self.data.ipAddress;
                                                  self.goCoderConfig.streamName = self.data.streamName;
                                                  self.goCoderConfig.applicationName = [NSString stringWithFormat:@"live?token=%@",self.data.token];
                                                  
                                                  self.goCoder.config = self.goCoderConfig;
                                                  
                                                  if(self.mode == StreamModeNormal) {
                                                      [self.btn_back setHidden:YES];
                                                      [self.view_types setHidden:YES];
                                                      
                                                      // Ensure the minimum set of configuration settings have been specified necessary to
                                                      // initiate a broadcast streaming session
                                                      NSError *configError = [self.goCoder.config validateForBroadcast];
                                                      if (configError != nil) {
                                                          [self showAlertWithTitle:@"Incomplete Streaming Settings" message:configError.localizedDescription];
                                                          return;
                                                      }
                                                      
                                                      // Start recording immediately
                                                      MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                      if(isResuming) {
                                                          hud.labelText = @"Resume Streaming";
                                                      } else {
                                                          hud.labelText = @"Start Streaming";
                                                      }
                                                      
                                                      
                                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                          [self.receivedGoCoderEventCodes removeAllObjects];
                                                          [self.goCoder startStreaming:self];
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                          });
                                                      });
                                                  } else {
                                                      if(isResuming) {
                                                          [self startEmergencyStream:YES];
                                                      } else {
                                                          [self loadEmergencyNumberAndCall];
                                                      }
                                                  }
                                              } else {
                                                  [self showAlertWithTitle:@"Error" message:@"Your access to stream blocked. Please check your profile again."];
                                              }
                                          } else {
                                              NSError* err = (NSError*)res;
                                              [self showAlertWithTitle:@"Error" message:err.localizedDescription];
                                              return;
                                          }
                                      }];
}

- (void) loadEmergencyNumberAndCall {
    // Load Emergency Number
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                       timeout:0.5
                          delayUntilAuthorized:YES
                                         block:
     ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
         MBProgressHUD* progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         progressHUD.labelText = @"Please wait...";
         [[MyService shared] submitLocation:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude isEmergency:YES streamName:nil
                                   withCompletion:^(BOOL success, id res) {
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       NSString* emergencyNumber = @"+13477226703";
                                       if(success) {
                                           if ([res[@"status"] isEqualToString:@"ok"]) {
                                               NSDictionary* data = res[@"data"];
                                               if([data objectForKey:@"country"] && [data objectForKey:@"country"] != [NSNull null]) {
                                                   NSDictionary* country = [data objectForKey:@"country"];
                                                   if([country objectForKey:@"emergency_number"] && [country objectForKey:@"emergency_number"] != [NSNull null]) {
                                                       emergencyNumber = [country objectForKey:@"emergency_number"];
                                                   }
                                               }
                                           }
                                       }
                                       
                                       NSLog(@"orientation_log: starting emergency");
                                       NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", emergencyNumber]];
                                       
                                       emergencyCallStatus = EmergencyCallStatusCalling;
                                       
                                       if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                                           [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:^(BOOL success) {
                                               NSLog(@"orientation_log: call emergency started:%d", success);
                                               
                                               if(success) {
                                                   emergencyCallStatus = EmergencyCallStatusAccept;
                                               } else {
                                                   emergencyCallStatus = EmergencyCallStatusNone;
                                               }
                                               
                                               if(success) {
                                                   [self.btn_back setHidden:YES];
                                                   [self.view_types setHidden:YES];
                                               }
                                           }];
                                       } else {
                                           [self presentSimpleAlert:@"Call facility is not available on your device" title:@"Error"];
                                       }
                                   }];
     }];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat paddingSize = sectionInsets.left * (ITEM_PER_ROW + 1);
    CGFloat availableWidth = self.cv_types.frame.size.width - paddingSize;
    CGFloat widthPerItem = availableWidth / ITEM_PER_ROW - 2.0f;
    
    CGFloat availableHeight = self.cv_types.frame.size.height - paddingSize;
    
    CGFloat heightPerItem;
    if(self.mode == StreamModeNormal) {
        heightPerItem = availableHeight / ITEM_PER_ROW;
    } else {
        heightPerItem = availableHeight / 2;
    }
    
    
    return CGSizeMake(widthPerItem, heightPerItem);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return sectionInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return sectionInsets.left;
}


#pragma mark - Wowza Gocoder Part
/**
 * This method is called in viewDidLoad
 */
- (void) setupWowzaGoCoder {
    [WowzaGoCoder setLogLevel:WowzaGoCoderLogLevelDefault];
    
    self.goCoder = nil;
    self.goCoderConfig = [WowzaConfig new];
    
    // set video frame size and bit rate
    switch ([UserContextManager sharedInstance].streamResolution) {
        case StreamResolution288p:
            [self.goCoderConfig loadPreset:WZFrameSizePreset352x288];
            break;
        case StreamResolution480p:
            [self.goCoderConfig loadPreset:WZFrameSizePreset640x480];
            break;
        case StreamResolution720p:
            [self.goCoderConfig loadPreset:WZFrameSizePreset1280x720];
            break;
        case StreamResolution1080p:
            [self.goCoderConfig loadPreset:WZFrameSizePreset1920x1080];
            break;
    }
    
    
    // set host address and stream name
    self.goCoderConfig.hostAddress = self.data.ipAddress;
    self.goCoderConfig.streamName = self.data.streamName;
    self.goCoderConfig.applicationName = [NSString stringWithFormat:@"live?token=%@",self.data.token];
    

    NSError *goCoderLicensingError = [WowzaGoCoder registerLicenseKey:[AppDelegate shared].wowzaKey];

    if (goCoderLicensingError != nil) {
        // Handle license key registration failure
        [self showAlertWithTitle:@"GoCoder SDK Licensing Error" message:goCoderLicensingError.localizedDescription];
    }
    else {
        NSLog(@"Success License!");
        // Initialize the GoCoder SDK
        self.goCoder = [WowzaGoCoder sharedInstance];
        
        // Specify the view in which to display the camera preview
        if (self.goCoder != nil) {
            // Request camera and microphone permissions
            [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeCamera response:^(WowzaGoCoderCapturePermission permission) {
                NSLog(@"Camera permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
            }];
            
            [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeMicrophone response:^(WowzaGoCoderCapturePermission permission) {
                NSLog(@"Microphone permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
            }];
            
            [self.goCoder registerVideoSink:self];
            [self.goCoder registerAudioSink:self];
            [self.goCoder registerVideoEncoderSink:self];
            [self.goCoder registerAudioEncoderSink:self];
            
            [self.goCoder registerDataSink:self eventName:@"onTextData"];
            
            self.goCoder.config = self.goCoderConfig;
            self.goCoder.cameraView = self.view;
            
            NSLog(@"width:%f, height:%f", self.view.frame.size.width, self.view.frame.size.height);
            
            // Start the camera preview
            self.goCoderCameraPreview = self.goCoder.cameraPreview;
            [self.goCoderCameraPreview startPreview];
        }
    }
}

#pragma mark - WZStatusCallback Protocol Instance Methods
- (void) onWZStatus:(WZStatus *) goCoderStatus {
    // A successful status transition has been reported by the GoCoder SDK
    NSLog(@"WZStatus: %lu", (unsigned long)goCoderStatus.state);
    
    switch (goCoderStatus.state) {
        case WZStateRunning:
        {
            // Make
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            
            // Update Some Values
            if(self.mode == StreamModeNormal) {
                [AppDelegate shared].mIsStreamingEmergency = NO;
            } else if(self.mode == StreamModeEmergency) {
                [AppDelegate shared].mIsStreamingEmergency = YES;
            }
            
            [AppDelegate shared].mIsStreaming = YES;
            [AppDelegate shared].mStreamName = self.data.streamName;
            
            // Update UI
            [self updateRecButton:YES];
            [self.btn_record setHidden:NO];
            [self.view_chat setHidden:NO];
            [self.btn_setting setHidden:YES];
            
            self.lbl_streamNotice.text = @"STREAMING";
            [self.view_recording blink];
            
            // Refresh Setting Menu for streaming icons
            [self.settingMenu removeFromSuperview];
            self.settingMenu = nil;
            self.btn_setting.hidden = NO;
            [self onSetting:nil];
            self.btn_backOrient.hidden = YES;
            
            if([UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeLeft) {
                self.view_rotateWarning.hidden = NO;
                self.btn_back.hidden = YES;
            } else {
                self.view_rotateWarning.hidden = YES;
            }
            break;
        }
        case WZStateIdle:
        {
            if([AppDelegate shared].mIsStreaming) {
                [self updateRecButton:NO];
                [self.view_recording stopBlinking];
                self.lbl_streamNotice.text = @"STREAMING STOPPED";
            } else {
                self.btn_backOrient.hidden = YES;
            }
            
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            [AppDelegate shared].mIsStreaming = NO;
            [AppDelegate shared].mIsStreamingEmergency = NO;
            [AppDelegate shared].mStreamName = nil;
            
            break;
        }
        case WZStateStarting:
            if ([UserContextManager sharedInstance].streamRecordOption == StreamRecordOptionPhone) {
                self.mp4Writer = [MP4Writer new];
                self.writeMP4 = [self.mp4Writer prepareWithConfig:self.goCoderConfig videoFileName:[NSString getLocalVideoNameString]];
                if (self.writeMP4) {
                    [self.mp4Writer startWriting];
                }
            }
            break;
        case WZStateStopping:
            if (self.writeMP4 && self.mp4Writer.writing) {
                [self.mp4Writer stopWriting];
            }
            self.writeMP4 = NO;
            break;
        default:
            break;
    }
}

- (void) onWZEvent:(WZStatus *) goCoderStatus {
    // If an event is reported by the GoCoder SDK, display an alert dialog describing the event,
    // but only if we haven't already shown an alert for this event
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        __block BOOL haveSeenAlertForEvent = NO;
//        [self.receivedGoCoderEventCodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([((NSNumber *)obj) isEqualToNumber:[NSNumber numberWithInteger:goCoderStatus.error.code]]) {
//                haveSeenAlertForEvent = YES;
//                *stop = YES;
//            }
//        }];
//        
//        if (!haveSeenAlertForEvent) {
////            [self showAlertWithTitle:@"Live Streaming Event" message:[NSString stringWithFormat:@"GoCoder Status:%ld", goCoderStatus.state]];
//            [self.receivedGoCoderEventCodes addObject:[NSNumber numberWithInteger:goCoderStatus.error.code]];
//        }
//    });
}

- (void) onWZError:(WZStatus *) goCoderStatus {
    // If an error is reported by the GoCoder SDK, display an alert dialog containing the error details
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
////        [self showAlertWithTitle:@"Live Streaming Error" message:[NSString stringWithFormat:@"GoCode State:%lu", (unsigned long)goCoderStatus.state]];
//    });
}

#pragma mark - WZVideoSink

- (void) videoFrameWasCaptured:(nonnull CVImageBufferRef)imageBuffer framePresentationTime:(CMTime)framePresentationTime frameDuration:(CMTime)frameDuration {
}

- (void) videoCaptureInterruptionStarted {
    if (!self.goCoderConfig.backgroundBroadcastEnabled) {
        if(self.goCoder.status.state == WZStateRunning) {
            NSLog(@"application_log:End Streaming!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.goCoder endStreaming:self];
            });
        }
    }
}

- (void) videoCaptureInterruptionEnded {
    if (!self.goCoderConfig.backgroundBroadcastEnabled) {
        if(self.goCoder.status.state == WZStateIdle &&
           emergencyCallStatus == EmergencyCallStatusNone &&
           selectedNewsType) {
            NSLog(@"application_log:Resume Streaming!");
            [self selectNewsTypeAndStartStreaming:selectedNewsType isResuming:YES];
        }
    }
}

- (void) videoCaptureUsingQueue:(nullable dispatch_queue_t)queue {
    self.video_capture_queue = queue;
}

#pragma mark - WZAudioSink

- (void) audioLevelDidChange:(float)level {
    //    NSLog(@"%@ %0.2f", @"Audio level did change", level);
}

- (void) audioPCMFrameWasCaptured:(nonnull const AudioStreamBasicDescription *)pcmASBD bufferList:(nonnull const AudioBufferList *)bufferList time:(CMTime)time sampleRate:(Float64)sampleRate {
    // The commented-out code below simply dampens the amplitude of the audio data.
    // It is intended as an example of how one would access and modify the audio sample data.
    
    //    int16_t *fdata = bufferList->mBuffers[0].mData;
    //
    //    for (int i = 0; i < bufferList->mBuffers[0].mDataByteSize/sizeof(*fdata); i++) {
    //        *fdata = (int16_t)(*fdata * 0.1);
    //        fdata++;
    //    }
}


#pragma mark - WZAudioEncoderSink

- (void) audioSampleWasEncoded:(nullable CMSampleBufferRef)data {
    if (self.writeMP4) {
        [self.mp4Writer appendAudioSample:data];
    }
}


#pragma mark - WZVideoEncoderSink

- (void) videoFrameWasEncoded:(nonnull CMSampleBufferRef)data {
    if (self.writeMP4) {
        [self.mp4Writer appendVideoSample:data];
    }
}

#pragma mark - WZDataSink

- (void) onData:(WZDataEvent *)dataEvent {
//    NSLog(@"Got data - %@", dataEvent.description);
}


#pragma mark - Setting Table View Delegates

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"video_cell"];
    
    if(tableView.tag == 0) {
        StreamResolution resolution = [UserContextManager sharedInstance].streamResolution;
        
        switch(indexPath.row) {
            case 0:
                cell.textLabel.text = @"352 x 288";
                if(resolution == StreamResolution288p) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    activatedCell = cell;
                }
                break;
            case 1:
                cell.textLabel.text = @"640 x 480";
                if(resolution == StreamResolution480p) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    activatedCell = cell;
                }
                break;
            case 2:
                cell.textLabel.text = @"1280 x 720";
                if(resolution == StreamResolution720p) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    activatedCell = cell;
                }
                break;
            case 3:
                cell.textLabel.text = @"1920 x 1080";
                if(resolution == StreamResolution1080p) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    activatedCell = cell;
                }
                break;
        }
    } else if(tableView.tag == 1) {
        StreamRecordOption recordOption = [UserContextManager sharedInstance].streamRecordOption;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        switch(indexPath.row) {
            case 0:
                cell.textLabel.text = @"Just stream to web";
                if(recordOption == StreamRecordOptionWeb) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    recordOptionActivatedCell = cell;
                }
                break;
            case 1:
                cell.textLabel.text = @"Stream to web and record to phone";
                if(recordOption == StreamRecordOptionPhone) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    recordOptionActivatedCell = cell;
                }
                break;
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 0) {
        return 4;
    } else if(tableView.tag == 1) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if(tableView.tag == 0) {
        if(activatedCell) {
            activatedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        activatedCell = cell;
        [UserContextManager sharedInstance].streamResolution = (NSInteger)indexPath.row;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.view_setting.alpha = 0;
        } completion:^(BOOL finished) {
            self.view_setting.hidden = finished;
        }];
    } else if(tableView.tag == 1) {
        if(recordOptionActivatedCell) {
            recordOptionActivatedCell.accessoryType = UITableViewCellAccessoryNone;
        }

        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        recordOptionActivatedCell = cell;
        [UserContextManager sharedInstance].streamRecordOption = (NSInteger)indexPath.row;
        
        if(recordOptionItem) {
            switch([UserContextManager sharedInstance].streamRecordOption) {
                case StreamRecordOptionPhone:
                    recordOptionItem.image = [UIImage imageNamed:@"icon_stream_setting_local_on"];
                    recordOptionItem.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_local_on"];
                    break;
                case StreamRecordOptionWeb:
                    recordOptionItem.image = [UIImage imageNamed:@"icon_stream_setting_local_off"];
                    recordOptionItem.highlightedImage = [UIImage imageNamed:@"icon_stream_setting_local_off"];
                    break;
                default:
                    break;
            }
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            self.view_streamRecordOption.alpha = 0;
        } completion:^(BOOL finished) {
            self.view_streamRecordOption.hidden = finished;
        }];
    }
}

#pragma mark - NewMessageDelegate Methods

-(void)messageAdded:(NSString *)message userInfo:(TwilioUserModel *)userInfo {
    mUnreadCount++;
    
    if(mUnreadCount) {
        self.lbl_chat_unread.text = [NSString stringWithFormat:@"%d", mUnreadCount];
    } else {
        self.lbl_chat_unread.text = @"";
    }
    
    if([message isEqualToString:CHAT_VOICE_CALLING] && [AppDelegate shared].mIsStreaming) {
        if(popupChatVC) {
            [popupChatVC onDone];
        }
        
        if(channelListVC) {
            [channelListVC dismissViewControllerAnimated:YES completion:nil];
        }
        
        mVCCall = (CallVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"CallVC" storyboardName:kStoryboardMain];
        mVCCall.userName = userInfo.name;
        mVCCall.avatarLink = userInfo.avatarLink;
        mVCCall.providesPresentationContextTransitionStyle = YES;
        mVCCall.definesPresentationContext = YES;
        mVCCall.callDelegate = self;
        [mVCCall setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self presentViewController:mVCCall animated:YES completion:nil];
    }
    
    if(mVCCall && [message isEqualToString:CHAT_VOICE_END]) {
        [mVCCall dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)messageManagerStatusUpdated:(TCHClientSynchronizationStatus)status {
}

#pragma mark - Call Delegate methods
-(void)callProecessed:(BOOL)isAccept {
    if(mVCCall) {
        [mVCCall dismissViewControllerAnimated:YES completion:nil];
        mVCCall = nil;
    }
    
    mIsCallingOperator = isAccept;
}

@end
