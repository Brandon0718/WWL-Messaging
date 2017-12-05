//
//  RMMapActionController.h
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

#import <RMActionController/RMActionController.h>
#import <MapKit/MapKit.h>

/*
 *  RMMapActionController is a simple example showing how to subclass RMActionController and show custom content in the action controller.
 *
 *  For another example see RMCustomViewActionController in this project. Additionally, I published two more RMActionController subclasses called RMDateSelectionViewController and RMPickerViewController. You can find them on GitHub.
 */
@interface RMMapActionController : RMActionController<UIView *>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) UISearchBar* searchBar;
//@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;

@property (strong, nonatomic) NSArray *searchResults;

@end
