//
//  ViewController.m
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import "ViewController.h"
#import "Webservice.h"
#import "WebserviceCallback.h"
#import "LoadingView.h"
#import "SearchTableViewCell.h"
#import "LoadWebPageViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <WebserviceCallback, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LoadingView *loading;

@property (nonatomic, strong) NSArray *itensArray;
@property (nonatomic, strong) IBOutlet UIView *emptyView;

@end

@implementation ViewController

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.loading = [[LoadingView alloc] initWithController:self];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    self.searchBar.delegate = self;
    
    if (self.itensArray.count == 0 || self.itensArray == nil) {
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
    return self.itensArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[self.itensArray objectAtIndex:indexPath.row]];
    NSDictionary *ownerDic = [[NSDictionary alloc] initWithDictionary:dic[@"owner"]];
    
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@", [self getStringFrom:dic[@"name"]]]];
    NSURL *imageURL = [NSURL URLWithString:ownerDic[@"avatar_url"]];
    
    cell.avatarImage.layer.cornerRadius = 25;
    cell.avatarImage.layer.masksToBounds = YES;
    cell.starImage.hidden = YES;
    cell.scoreLabel.hidden = YES;
    
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[self.itensArray objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"repoToWeb" sender:dic[@"html_url"]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Search Bar Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text == nil || [searchBar.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Digite algo para buscar..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    } else {
        [self.searchBar resignFirstResponder];
        
        [self.loading show];
        NSString *stringUrl = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&sort=stars&order=desc", searchBar.text];
        
        [[[Webservice alloc] init] requestGetMethodWithUrl:stringUrl
                                                withParams:nil
                                                      type:@"search"
                                               andDelegate:self];
    }
}

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
    self.itensArray = [[NSArray alloc] initWithArray:data[@"items"]];
    [self.tableView reloadData];
}


#pragma mark - Navigation Method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"repoToWeb"]) {
        LoadWebPageViewController *vc = segue.destinationViewController;
        vc.stringURL = sender;
    }
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
