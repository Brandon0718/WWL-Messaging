//
//  ProfileViewController.m
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "ProfileViewController.h"
#import "ProfileModel.h"
#import "UITextView+Border.h"
#import "ProfileFieldCell.h"
#import "UIImage+Resize.h"
#import "UIBarButtonItem+Image.h"
#import "UIButton+Border.h"

#define PROFILE_FIELD_TEXT          @"text"
#define PROFILE_FIELD_IMAGE         @"image"
#define PROFILE_FIELD_TEXTAREA      @"textarea"

#define TEXT_HEIGHT         32.0f
#define AVATAR_SIZE         80.0f
#define TEXT_AREA_HEIGHT    100.0f
#define DEFAULT_SPACING     16.0f

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileUpdatedDelegate>
{
    
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait";
    [self loadProfileInfo:^(BOOL isCompleted) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [self updateNavBarItems:isCompleted];
        [self.tbl_profileFields reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.btn_logout customBorder];
    [self.btn_continue customBorder];
    
    switch(self.motivationType) {
        case ProfileMotivationTypeProfile:
        case ProfileMotivationTypeChannels:
        case ProfileMotivationTypeSignin:
            [self.btn_continue removeFromSuperview];
            break;
        default:
            break;
    }
    
    // register keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) updateNavBarItems:(BOOL) isCompleted {
    UIBarButtonItem* item = [UIBarButtonItem buttonItemForImage:[UIImage imageNamed:@"icon_user_white"] target:self action:nil];
    UIBarButtonItem* warningItem = [UIBarButtonItem buttonItemForImage:[UIImage imageNamed:@"icon_warning"] target:self action:nil];
    if(isCompleted) {
        self.navigationItem.rightBarButtonItems = @[item];
    } else {
        self.navigationItem.rightBarButtonItems = @[item, warningItem];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
- (IBAction)onLogout:(id)sender {
    [[AppDelegate shared] logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)onContinue:(id)sender {
    if(![[AppDelegate shared] isProfileCompleted]) {
        [self showAlertWithTitle:@"Validation" message:@"Please complete all profile fields!"];
    } else {
        switch(self.motivationType) {
            case ProfileMotivationTypeReportNews:
                [self showChannelsVC:YES];
                break;
            case ProfileMotivationTypeSos:
                [self showSosVC:YES];
                break;
            case ProfileMotivationTypeMyVideos:
                [self showMyVideos:YES];
                break;
            case ProfileMotivationTypeSignin:
            {
                switch ([AppDelegate shared].signinMotivation) {
                    case SigninMotivationTypeSignin:
                    case SigninMotivationTypeReportNews:
                        [self showChannelsVC:YES];
                        break;
                    case SigninMotivationTypeMyVideos:
                        [self showMyVideos:YES];
                        break;
                    case SigninMotivationTypeSos:
                        [self showSosVC:YES];
                        break;
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - ProfileUploaded Delegate
-(void)profileFieldChanged:(NSInteger) row {
    BOOL isCompleted = [[AppDelegate shared] isProfileCompleted];
    [self updateNavBarItems:isCompleted];
    
    ProfileModel* item = [[AppDelegate shared].profileInfos objectAtIndex:row];
    [[MyService shared] updateUserProfileField:item completedBlock:^(BOOL success, id res) {
        if (success) {
            if([res[@"status"] isEqualToString:@"ok"]) {
                NSArray *arr = res[@"data"];
                if([arr count]) {
                    [item updateWith:[arr objectAtIndex:0]];
                }
            } else {
                [item updateWithErrorDic:res];
            }
            
            BOOL isCompleted = [[AppDelegate shared] isProfileCompleted];
            [self updateNavBarItems:isCompleted];
            
            [self.tbl_profileFields beginUpdates];
            [self.tbl_profileFields reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tbl_profileFields endUpdates];
        } else {
            NSError* err = (NSError*)res;
            [self presentSimpleAlert:err.localizedDescription title:@"Error"];
        }
    }];
}

#pragma mark - TableView Delegates and Data Sources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[AppDelegate shared].profileInfos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:ProfileFieldCellIdentifier];
    cell.updatedDelegate = self;
    
    ProfileModel* item = [[AppDelegate shared].profileInfos objectAtIndex:indexPath.row];
    item.rowIndex = indexPath.row;
    
    [cell configureCell:item];
    cell.tableView = tableView;
    cell.vcInstance = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileFieldCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:ProfileFieldCellIdentifier];
        [cell configureCell:[[AppDelegate shared].profileInfos objectAtIndex:indexPath.row]];
    }
    return [cell getHeight];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark - Keyboard Handling

// unregister keyboard notifications
//the Function that call when keyboard show.
- (void)keyboardWasShown:(NSNotification *)notif {
    CGSize _keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, _keyboardSize.height, 0);
    [self.tbl_profileFields setContentInset:contentInsets];
    [self.tbl_profileFields setScrollIndicatorInsets:contentInsets];
}
//the Function that call when keyboard hide.
- (void)keyboardWillBeHidden:(NSNotification *)notif {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [self.tbl_profileFields setContentInset:contentInsets];
    [self.tbl_profileFields setScrollIndicatorInsets:contentInsets];
}

@end
