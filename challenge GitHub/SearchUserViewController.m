//
//  SearchUserViewController.m
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import "SearchUserViewController.h"
#import "Webservice.h"
#import "WebserviceCallback.h"
#import "LoadingView.h"
#import "SearchTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface SearchUserViewController () <WebserviceCallback, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LoadingView *loading;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSArray *usersArray;
@property (nonatomic) int selectedIndex;

@end

@implementation SearchUserViewController

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.loading = [[LoadingView alloc] initWithController:self];
    
    self.selectedIndex = -1;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    self.searchBar.delegate = self;
    
    if (self.usersArray.count == 0 || self.usersArray == nil) {
        self.emptyView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == indexPath.row) {
        return 110;
    } else {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[self.usersArray objectAtIndex:indexPath.row]];
    NSURL *imageURL = [NSURL URLWithString:dic[@"avatar_url"]];
    
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@", [self getStringFrom:dic[@"login"]]]];
    [cell.scoreLabel setText:[NSString stringWithFormat:@"Score: %@", [self getStringFrom:dic[@"score"]]]];
    
    cell.avatarImage.layer.cornerRadius = 25;
    cell.avatarImage.layer.masksToBounds = YES;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imageURL
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                [cell.avatarImage setImage:image];
                            }
                        }];
    
    if (self.selectedIndex == indexPath.row) {
        //Célula expandida.----
        cell.scoreLabel.hidden = NO;
        cell.starImage.hidden = NO;
    } else {
        //Célula normal.----
        cell.scoreLabel.hidden = YES;
        cell.starImage.hidden = YES;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == indexPath.row) {
        self.selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    if (self.selectedIndex != -1) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        self.selectedIndex = (int)indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    self.selectedIndex = (int)indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - Search Bar Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text == nil || [searchBar.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Digite algo para buscar..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    } else {
        [self.searchBar resignFirstResponder];
        
        [self.loading show];
        NSString *stringUrl = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", searchBar.text];
        
        [[[Webservice alloc] init] requestGetMethodWithUrl:stringUrl
                                                withParams:nil
                                                      type:@"search"
                                               andDelegate:self];
    }
}


#pragma mark - Webservice Callback
- (void)processData:(NSMutableDictionary *)data andType:(NSString *)tipo
{
    [self.loading hide];
    
    if (data == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Busca sem resultados." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.emptyView.hidden = YES;
    self.usersArray = [[NSArray alloc] initWithArray:data[@"items"]];
    [self.tableView reloadData];
}


#pragma mark - Utils
- (NSString *)getStringFrom:(id)obj {
    NSString *str;
    
    if ([obj isKindOfClass:[NSNumber class]])
        str = (NSString *)[obj stringValue];
    else
        str = (NSString *)obj;
    
    return str;
}

@end
