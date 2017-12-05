//
//  RMMapActionController.m
//  RMActionController-Demo
//
//  Created by Roland Moers on 01.05.15.
//  Copyright (c) 2015 Roland Moers. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RMMapActionController.h"
#import <GooglePlaces/GMSAutocompleteFilter.h>
#import <GooglePlaces/GMSPlacesClient.h>

@interface RMMapActionController() <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL movedUp;
    GMSPlacesClient *placeClient;
    NSLayoutConstraint* tableBottomConstraint;
}

@end

@implementation RMMapActionController

#pragma mark - Init and Dealloc
- (instancetype)initWithStyle:(RMActionControllerStyle)aStyle title:(NSString *)aTitle message:(NSString *)aMessage selectAction:(RMAction *)selectAction andCancelAction:(RMAction *)cancelAction {
    self = [super initWithStyle:aStyle title:aTitle message:aMessage selectAction:selectAction andCancelAction:cancelAction];
    if(self) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        placeClient = [GMSPlacesClient sharedClient];
        
        // Add Search Controller
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        
        NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
        
        self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.searchBar addConstraint:heightConstraint];
        self.searchBar.placeholder = @"Search Here";
        self.searchBar.delegate = self;
        [self.contentView addSubview:self.searchBar];
        [self.contentView addConstraints:@[topConstraint, leftConstraint, rightConstraint]];
        
        // Add MKMapView
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.mapView];
        
        NSLayoutConstraint* mapTopConstraint = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:44];
        NSLayoutConstraint* mapLeftConstraint = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint* mapRightConstraint = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint* mapBottomConstraint = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.contentView addConstraints:@[mapTopConstraint, mapLeftConstraint, mapRightConstraint, mapBottomConstraint]];
        
        // Add TableView
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        [self.contentView addSubview:self.tableView];
        
        NSLayoutConstraint* tableTopConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:44];
        NSLayoutConstraint* tableLeftConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint* tableRightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        tableBottomConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint* tableHeightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:176];
        [self.tableView addConstraint:tableHeightConstraint];
        
        [self.contentView addConstraints:@[tableTopConstraint, tableLeftConstraint, tableRightConstraint, tableBottomConstraint]];
        self.tableView.hidden = YES;
        
        NSDictionary *bindings = @{@"contentView": self.contentView};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[contentView(>=300)]" options:0 metrics:nil views:bindings]];
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(200)]" options:0 metrics:nil views:bindings]];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


//the Function that call when keyboard show.
- (void)keyboardWasShown:(NSNotification *)notif {
    CGSize _keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if(!movedUp) {
        [self.contentView layoutIfNeeded];
        tableBottomConstraint.constant = -_keyboardSize.height / 2;
        [UIView animateWithDuration:5
                         animations:^{
                             [self.contentView layoutIfNeeded];
                             movedUp = true;
                         }];
    }
}
//the Function that call when keyboard hide.
- (void)keyboardWillBeHidden:(NSNotification *)notif {
    if(movedUp) {
        [self.contentView layoutIfNeeded];
        
        tableBottomConstraint.constant = 0;
        [UIView animateWithDuration:5
                         animations:^{
                             [self.contentView layoutIfNeeded];
                             movedUp = false;
                         }];
    }
}

#pragma mark - Properties
- (BOOL)disableBlurEffectsForContentView {
    return YES;
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"autocompleteCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"autocompleteCell"];
    }
    
    GMSAutocompletePrediction *thisPlace = self.searchResults[indexPath.row];
    cell.textLabel.attributedText = thisPlace.attributedPrimaryText;
    cell.detailTextLabel.attributedText = thisPlace.attributedSecondaryText;
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    GMSAutocompletePrediction *selectedPlace = self.searchResults[indexPath.row];
    
    [placeClient lookUpPlaceID:selectedPlace.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"lookUpPlaceID error %@", [error localizedDescription]);
            [self handleSearchError:error];
        } else if (result != nil) {
            [self.tableView setHidden:YES];
            self.searchBar.text = selectedPlace.attributedPrimaryText.string;
            [self addPlacemarkAnnotationToMap:result addressString:result.formattedAddress];
            [self recenterMapToPlacemark:result];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }];
}

#pragma mark - UISearchBar Delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        [self.tableView setHidden:NO];
        
        
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
        
        [placeClient autocompleteQuery:searchText
                                  bounds:nil
                                  filter:filter
                                callback:^(NSArray *results, NSError *error) {
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                        [self handleSearchError:error];
                                    } else {
                                        self.searchResults = results;
                                        [self.tableView reloadData];
                                    }
                                }];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
}

#pragma mark - Helpers

- (void)addPlacemarkAnnotationToMap:(GMSPlace *)place addressString:(NSString *)address
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = place.coordinate;
    annotation.title = address;
    
    [self.mapView addAnnotation:annotation];
}

- (void)recenterMapToPlacemark:(GMSPlace *)place
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    region.span = span;
    region.center = place.coordinate;
    
    [self.mapView setRegion:region animated:YES];
}

- (void)handleSearchError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
