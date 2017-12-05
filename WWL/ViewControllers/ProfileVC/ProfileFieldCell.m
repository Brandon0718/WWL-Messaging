//
//  ProfileFieldCell.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/26/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "ProfileFieldCell.h"
#import "UITextView+Border.h"
#import "UIImage+Resize.h"
#import "UIImage+Encode.h"
#import "MyService.h"
#import "NSString+Regex.h"

@interface ProfileFieldCell() <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ProfileFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCell:(ProfileModel*) dataModel {
    self.dataModel = dataModel;
    
    // Update status first
    [self updateStatus:self.dataModel.currentStatus];
    
    // Update label, value, and etc
    switch (self.dataModel.type) {
        case ProfileFieldTypeText:
            [self.txt_content setHidden:NO];
            [self.img_content setHidden:YES];
            [self.tv_content setHidden:YES];
            [self.img_content setUserInteractionEnabled:NO];
            
            self.txt_content.text = (NSString*)self.dataModel.value;
            break;
        case ProfileFieldTypeImage:
        {
            [self.txt_content setHidden:YES];
            [self.img_content setHidden:NO];
            [self.tv_content setHidden:YES];
            
            self.img_content.layer.borderWidth = 1.0f;
            self.img_content.layer.cornerRadius = 5.0f;
            self.img_content.layer.borderColor = [[UIColor whiteColor] CGColor];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageSource)];
            //    tapGesture.cancelsTouchesInView = NO;
            [self.img_content addGestureRecognizer:tapGesture];
            [self.img_content setUserInteractionEnabled:YES];
            
            if(self.dataModel.value) {
                [self.img_content sd_setImageWithURL:self.dataModel.value
                                    placeholderImage:[UIImage imageNamed:@"img_default_avatar"]];
            } else {
                self.img_content.image = [UIImage imageNamed:@"img_default_avatar"];
            }
            break;
        }
        case ProfileFieldTypeTextArea:
            [self.txt_content setHidden:YES];
            [self.img_content setHidden:YES];
            [self.tv_content setHidden:NO];
            [self.img_content setUserInteractionEnabled:NO];
            
            [self.tv_content setDefaultBorder];
            
            self.tv_content.text = (NSString*)self.dataModel.value;
            break;
        default:
            break;
    }
    
    self.lbl_caption.text = self.dataModel.label;
    self.lbl_error.text = [self.dataModel getErrorMsg];
}

-(CGFloat) getHeight {
    switch (self.dataModel.type) {
        case ProfileFieldTypeText:
            return self.txt_content.frame.origin.y + self.txt_content.frame.size.height + 16.0f;
        case ProfileFieldTypeImage:
            return self.img_content.frame.origin.y + self.img_content.frame.size.height + 16.0f;
        case ProfileFieldTypeTextArea:
            return self.tv_content.frame.origin.y + self.tv_content.frame.size.height + 16.0f;
        default:
            return 0;
    }
}

# pragma mark - Keyboard Handling

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    CGPoint pointInTable = [textView.superview convertPoint:self.lbl_caption.frame.origin toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height - 16.0f);
    
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    
    [self.tableView setContentOffset:contentOffset animated:YES];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    
    if ([textView.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = (UITableViewCell*)textView.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    self.dataModel.value = textView.text;
    [self updateStatus:ProfileFieldStatusInputting];
}

- (IBAction)textFieldDidChange:(id)sender {
    UITextField* textField = (UITextField*) sender;
    self.dataModel.value = textField.text;
    [self updateStatus:ProfileFieldStatusInputting];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    self.dataModel.value = textView.text;
    [self updateStatus:ProfileFieldStatusPosting];
    
    [self.updatedDelegate profileFieldChanged:self.dataModel.rowIndex];
}

- (IBAction)textFieldEditDidEnd:(id)sender {
    UITextField* textField = (UITextField*) sender;
    self.dataModel.value = textField.text;
    [self updateStatus:ProfileFieldStatusPosting];
    
    [self.updatedDelegate profileFieldChanged:self.dataModel.rowIndex];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) updateStatus:(ProfileFieldStatus) status {
    switch (status) {
        case ProfileFieldStatusValid:
            self.iv_status.image = [UIImage imageNamed:@"icon_green_tick"];
            break;
        case ProfileFieldStatusInvalid:
            self.iv_status.image = [UIImage imageNamed:@"icon_red_close"];
            break;
        case ProfileFieldStatusInputting:
            self.iv_status.image = [UIImage imageNamed:@"icon_write_white"];
            break;
        case ProfileFieldStatusPosting:
            self.iv_status.image = [UIImage imageNamed:@"icon_upload"];
            break;
    }
}


#pragma mark - Image Picker Methods
- (void) showImageSource {
    [self updateStatus:ProfileFieldStatusInputting];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Get Image From" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getImageFromSource:UIImagePickerControllerSourceTypeCamera];
                    });
                }else{
                    // Camera Access Denied
                }
            }];
        } else{
            [self getImageFromSource:UIImagePickerControllerSourceTypeCamera];
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getImageFromSource:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }]];
    
    
    // for iPad
    [actionSheet setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [actionSheet
                                                     popoverPresentationController];
    popPresenter.sourceView = self;
    popPresenter.sourceRect = self.img_content.bounds;
    
    [self.vcInstance presentViewController:actionSheet animated:YES completion:nil];
}

- (void)getImageFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController
                           availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType] && [mediaTypes count] > 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.vcInstance presentViewController:picker animated:YES completion:NULL];
    }
    else {
        // Device doesn’t support that media source.
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *shrunkenImage =[chosenImage shrinkForAvatar];
    
    if(shrunkenImage) {
        self.img_content.image = shrunkenImage;
        self.dataModel.value = [shrunkenImage encodeImageToBinary];
        
        [self updateStatus:ProfileFieldStatusPosting];
        [self.updatedDelegate profileFieldChanged:self.dataModel.rowIndex];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
