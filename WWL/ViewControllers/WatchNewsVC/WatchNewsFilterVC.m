//
//  WatchNewsFilterVC.m
//  WWL
//
//  Created by Kristoffer Yap on 6/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <RMDateSelectionViewController/RMDateSelectionViewController.h>
#import <RMPickerViewController/RMPickerViewController.h>
#import <MapKit/MKMapView.h>

#import "WatchNewsFilterVC.h"
#import "RMEmptyActionController.h"
#import "RMMapActionController.h"

#import "WatchNewsFilterModel.h"

#define SORT_PICKER_TAG     0
#define SOURCE_PICKER_TAG   1

@interface WatchNewsFilterVC () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    WatchNewsFilterModel* filterOption;
    NSDateFormatter* dateFormatter;
}
@end

@implementation WatchNewsFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back"]];
    
//    UIBarButtonItem* mFilterItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(onApply)];
//    self.navigationItem.rightBarButtonItems = @[mFilterItem];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    filterOption.location = self.lbl_location.text;
    filterOption.stringer = self.txt_stringer.text;
    filterOption.search = self.txt_search.text;
    
    [UserContextManager sharedInstance].vodFilterOption = filterOption;
}

- (void) hideKeyboard {
    [self.tableView endEditing:YES];
}

- (void) onApply {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) refreshData {
    filterOption = [UserContextManager sharedInstance].vodFilterOption;
    
    self.lbl_sortBy.text = [filterOption getSortByString];
    self.lbl_location.text = filterOption.location;
    self.txt_stringer.text = filterOption.stringer;
    self.txt_search.text = filterOption.search;
    
    if(filterOption.startDate) {
        self.lbl_date_start.text = [dateFormatter stringFromDate:filterOption.startDate];
    } else {
        self.lbl_date_start.text = @"None";
    }
    
    if(filterOption.endDate) {
        self.lbl_date_end.text = [dateFormatter stringFromDate:filterOption.endDate];
    } else {
        self.lbl_date_end.text = @"None";
    }
    
    self.lbl_source.text = [filterOption getSourceString];
    self.lbl_news_type.text = [filterOption getNewsTypeString];
}

#pragma mark - tableview delegate and data source

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35.0f)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 5.0f, tableView.bounds.size.width, 30.0f)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    titleLabel.textColor = [UIColor whiteColor];
    switch (section) {
        case 0:
            titleLabel.text = @"SORT BY";
            break;
        case 1:
            titleLabel.text = @"LOCATION";
            break;
        case 2:
            titleLabel.text = @"STRINGER";
            break;
        case 3:
            titleLabel.text = @"SEARCH";
            break;
        default:
            titleLabel.text = @"";
            break;
    }
    
    [headerView addSubview:titleLabel];
    
    UIView *topBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5f, tableView.bounds.size.width, 0.5f)];
    [topBorderView setBackgroundColor:[UIColor borderColor]];
    [headerView addSubview:topBorderView];
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5f)];
    [footerView setBackgroundColor:[UIColor borderColor]];
    return footerView;
}


#pragma mark - select actions
- (IBAction)onSortBy:(id)sender {
    RMAction<UIPickerView *> *selectAction = [RMAction<UIPickerView *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSInteger selectedRow = [controller.contentView selectedRowInComponent:0];
        filterOption.sortBy = (VODFilterSortBy)selectedRow;
        NSString* selectedSource = [self getTitleForSortBy:selectedRow];
        self.lbl_sortBy.text = selectedSource;
    }];
    
    RMAction<UIPickerView *> *cancelAction = [RMAction<UIPickerView *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIPickerView *> *controller) {
    }];
    
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleBlack title:@"Sort By" message:@"Please choose a sorty by option and press 'Select' or 'Cancel'." selectAction:selectAction andCancelAction:cancelAction];
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    pickerController.picker.tag = SORT_PICKER_TAG;
    
    [self presentActionController:pickerController];
}

- (IBAction)onResetFilters:(id)sender {
    [self presentAskAlert:@"All filters will be reset to default. Are you sure to reset?" title:@"Reset Filters" okText:@"YES" cancelText:@"CANCEL" handler:^(BOOL isPositive) {
        if(isPositive) {
            [UserContextManager sharedInstance].vodFilterOption = [[WatchNewsFilterModel alloc] initWithDefault];
            [self refreshData];
        }
    }];
}

- (IBAction)onLocationSelect:(id)sender {
    RMAction *selectAction = [RMAction<UIView *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIView *> *controller) {
        RMMapActionController* mapController = (RMMapActionController*)controller;
        self.lbl_location.text = mapController.searchBar.text;
    }];
    
    RMAction *cancelAction = [RMAction<UIView *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIView *> *controller) {
    }];
    
    RMMapActionController *actionController = [RMMapActionController actionControllerWithStyle:RMActionControllerStyleBlack];
    actionController.title = @"Location";
    actionController.message = @"Please select a location and tap 'Select' or 'Cancel'.";
    
    [actionController addAction:selectAction];
    [actionController addAction:cancelAction];
    
    [self presentActionController:actionController];
}

- (IBAction)onDateStartSelect:(id)sender {
    RMAction<UIDatePicker *> *selectAction = [RMAction<UIDatePicker *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        if(filterOption.endDate && [controller.contentView.date compare:filterOption.endDate] == NSOrderedDescending) {
            [self presentSimpleAlert:@"Start Date must be before End Date!" title:@"Start Date Error"];
        } else {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, yyyy"];
            
            self.lbl_date_start.text = [formatter stringFromDate:controller.contentView.date];
            filterOption.startDate = controller.contentView.date;
        }
    }];
    
    RMAction<UIDatePicker *> *cancelAction = [RMAction<UIDatePicker *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleBlack title:@"Start Date" message:@"Please choose a start date to filter and press 'Select' or 'Cancel'" selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self presentActionController:dateSelectionController];
}
- (IBAction)onDateEndSelect:(id)sender {
    RMAction<UIDatePicker *> *selectAction = [RMAction<UIDatePicker *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        if(filterOption.startDate && [controller.contentView.date compare:filterOption.startDate] == NSOrderedAscending) {
            [self presentSimpleAlert:@"End Date cannot be before Start Date!" title:@"End Date Error"];
        } else {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, yyyy"];
            
            self.lbl_date_end.text = [formatter stringFromDate:controller.contentView.date];
            filterOption.endDate = controller.contentView.date;
        }
    }];
    
    RMAction<UIDatePicker *> *cancelAction = [RMAction<UIDatePicker *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleBlack title:@"End Date" message:@"Please choose a end date to filter and press 'Select' or 'Cancel'" selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self presentActionController:dateSelectionController];
}

- (IBAction)onSourceSelect:(id)sender {
    RMAction<UIPickerView *> *selectAction = [RMAction<UIPickerView *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSInteger selectedRow = [controller.contentView selectedRowInComponent:0];
        filterOption.source = (VODFilterSource)selectedRow;
        
        NSString* selectedSource = [self getTitleForSource:selectedRow];
        self.lbl_source.text = selectedSource;
    }];
    
    RMAction<UIPickerView *> *cancelAction = [RMAction<UIPickerView *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIPickerView *> *controller) {
    }];
    
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleBlack title:@"Source" message:@"Please choose a source to filter and press 'Select' or 'Cancel'." selectAction:selectAction andCancelAction:cancelAction];
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    pickerController.picker.tag = SOURCE_PICKER_TAG;
    
    [self presentActionController:pickerController];
}

- (IBAction)onNewsTypeSelect:(id)sender {
    RMActionControllerStyle style = RMActionControllerStyleBlack;
    
    RMAction *action1 = [RMImageAction<UIView *> actionWithTitle:@"Fire" image:[UIImage imageNamed:@"icon_type_fire"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"Fire";
        filterOption.newsType = VODFilterNewsTypeFire;
    }];
    RMAction *action2 = [RMImageAction<UIView *> actionWithTitle:@"Crime" image:[UIImage imageNamed:@"icon_type_crime"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"Crime";
        filterOption.newsType = VODFilterNewsTypeCrime;
    }];
    RMAction *action3 = [RMImageAction<UIView *> actionWithTitle:@"War" image:[UIImage imageNamed:@"icon_type_war"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"War";
        filterOption.newsType = VODFilterNewsTypeWar;
    }];
    RMAction *action4 = [RMImageAction<UIView *> actionWithTitle:@"Accident" image:[UIImage imageNamed:@"icon_type_accident"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"Accident";
        filterOption.newsType = VODFilterNewsTypeAccident;
    }];
    RMAction *action5 = [RMImageAction<UIView *> actionWithTitle:@"Politics" image:[UIImage imageNamed:@"icon_type_politics"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"Politics";
        filterOption.newsType = VODFilterNewsTypePolitics;
    }];
    RMAction *action6 = [RMImageAction<UIView *> actionWithTitle:@"Weathers" image:[UIImage imageNamed:@"icon_type_weather"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"Weathers";
        filterOption.newsType = VODFilterNewsTypeWeathers;
    }];
    RMAction *action7 = [RMImageAction<UIView *> actionWithTitle:@"Celebrities" image:[UIImage imageNamed:@"icon_type_celebrities"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"Celebrities";
        filterOption.newsType = VODFilterNewsTypeCelebrities;
    }];
    RMAction *action8 = [RMImageAction<UIView *> actionWithTitle:@"Sport" image:[UIImage imageNamed:@"icon_type_sports"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"Sport";
        filterOption.newsType = VODFilterNewsTypeSport;
    }];
    RMAction *action9 = [RMImageAction<UIView *> actionWithTitle:@"Other" image:[UIImage imageNamed:@"icon_type_other"] style:RMActionStyleDone andHandler:^(RMActionController<UIView *> * _Nonnull controller) {
        self.lbl_news_type.text = @"Other";
        filterOption.newsType = VODFilterNewsTypeOther;
    }];
    
    RMAction *selectAction = [RMScrollableGroupedAction<UIView *> actionWithStyle:RMActionStyleDone actionWidth:100 andActions:@[action1, action2, action3, action4, action5, action6, action7, action8, action9]];
    
    RMAction *cancelAction = [RMAction<UIView *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIView *> *controller) {
    }];
    
    RMEmptyActionController *actionController = [RMEmptyActionController actionControllerWithStyle:style];
    actionController.title = @"News Type";
    actionController.message = @"Please choose an news type to filer or tap 'Cancel'";
    
    [actionController addAction:selectAction];
    [actionController addAction:cancelAction];
    
    [self presentActionController:actionController];
}

#pragma mark - RMPickerViewController Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch(pickerView.tag) {
        case SORT_PICKER_TAG:
            return 3;
        case SOURCE_PICKER_TAG:
            return 4;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch(pickerView.tag) {
        case SORT_PICKER_TAG:
            return [self getTitleForSortBy:row];
        case SOURCE_PICKER_TAG:
            return [self getTitleForSource:row];
        default:
            return nil;
    }
}

-(NSString*) getTitleForSource:(NSInteger) row {
    switch (row) {
        case 0:
            return @"All Channels";
        case 1:
            return @"My News Connections";
        case 2:
            return @"Favorites";
        case 3:
            return @"Near By";
        default:
            return @"All Channels";
    }
}

-(NSString*) getTitleForSortBy:(NSInteger) row {
    switch (row) {
        case 0:
            return @"None";
        case 1:
            return @"Date";
        case 2:
            return @"Stringer";
        default:
            return @"None";
    }
}

#pragma mark - Picker Selection Method
- (void)presentActionController:(RMActionController *)actionController {
    //You can enable or disable blur, bouncing and motion effects
    actionController.disableBouncingEffects = NO;
    actionController.disableMotionEffects = NO;
    actionController.disableBlurEffects = YES;
    
    //On the iPad we want to show the map action controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
    if([actionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        actionController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        actionController.popoverPresentationController.sourceView = self.tableView;
        actionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:actionController animated:YES completion:nil];
}

#pragma mark - UTIL METHODS


@end
