//
//  CountryCodeModalVC.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/30/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "CountryCodeModalVC.h"
#import "NBPhoneNumberUtil.h"
#import "CountryModel.h"
#import "CountryItemCell.h"

@interface CountryCodeModalVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* mCountries;
    NSMutableArray* mFilteredCountries;
}
@end

@implementation CountryCodeModalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup)];
//    //    tapGesture.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapGesture];
    
    // init mCountries
    mCountries = [[NSMutableArray alloc] init];
    for (NSString* countryCode in [NSLocale ISOCountryCodes]) {
        if([countryCode isEqualToString:@"AC"]) {
            continue;
        }
        
        NSString* countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
        NSNumber* phoneCode = [[NBPhoneNumberUtil sharedInstance] getCountryCodeForRegion:countryCode];
        NSString* phoneCodeString = [NSString stringWithFormat:@"+%d", [phoneCode intValue]];
        if(![phoneCodeString isEqualToString:@"+0"]) {
            CountryModel* item = [[CountryModel alloc] initWith:countryCode name:countryName phoneCode:phoneCodeString];
            [mCountries addObject:item];
        }
    }
    
    [mCountries sortedArrayUsingComparator:^NSComparisonResult(CountryModel* obj1, CountryModel* obj2) {
        return [obj1.name compare:obj2.name];
    }];
    
    mFilteredCountries = [mCountries mutableCopy];
    
    [self.txt_search becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];

    self.view_back.layer.cornerRadius = 5;
    self.view_back.layer.shadowOpacity = 0.8;
    self.view_back.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)closePopup {
//    [self removeAnimate];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSearchTextChaned:(id)sender {
    mFilteredCountries = [self getFilteredCandidates:mCountries condition:self.txt_search.text];
    [self.tbl_country reloadData];
}

#pragma mark - TableView datasource and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mFilteredCountries.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryItemCell* item = [tableView dequeueReusableCellWithIdentifier:@"CountryItemCell"];
    [item configure:[mFilteredCountries objectAtIndex:indexPath.row]];
    return item;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.selectedDelegate countrySelected:[mFilteredCountries objectAtIndex:indexPath.row]];
    
    [self closePopup];
}

#pragma mark - Filter Functions 
-(NSMutableArray*) getFilteredCandidates:(NSArray*) candidates condition:(NSString*) condition {
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    NSMutableArray *mCandidates = [candidates mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [condition stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
    
    if(strippedString.length > 0)
    {
        NSString* plusString = [NSString stringWithFormat:@"+%@", condition];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(name BEGINSWITH[c] %@) OR (code BEGINSWITH[c] %@) OR (phoneCode BEGINSWITH[c] %@) OR (phoneCode BEGINSWITH[c] %@) OR (additionalSearchTags CONTAINS[c] %@)", condition, condition, condition, plusString, condition];
        searchResults = [[mCandidates filteredArrayUsingPredicate:predicate] mutableCopy];
    } else {
        return mCandidates;
    }
    
    return searchResults;
}


@end
