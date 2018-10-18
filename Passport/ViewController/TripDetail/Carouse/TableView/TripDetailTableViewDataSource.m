//
//  TripDetailTableViewDataSource.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "KEPTimelineEntryCell.h"
#import "TripDetailTableViewDataSource.h"
#import "KEPBaseEntryCell+Helper.h"

@interface TripDetailTableViewDataSource ()

@property(nonatomic, strong) KEPTimelineEntryCell *headerCell;

@end

@implementation TripDetailTableViewDataSource

- (void)adjustTableViewContent {
    [self.headerCell adjustTableViewContent];
}

- (void)addRoundCorner {
    [self.headerCell addRoundCorner];
}

- (void)setTripModel:(TripDetailModel *)tripModel {
    _tripModel = tripModel;
    [self.headerCell updateData:tripModel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KEPBaseEntryCell cellHeightOfModel:self.tripModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.headerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (KEPTimelineEntryCell *)headerCell {
    if (!_headerCell) {
        _headerCell = [[KEPTimelineEntryCell alloc] init];
    }
    return _headerCell;
}

@end
