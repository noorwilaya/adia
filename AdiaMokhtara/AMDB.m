//
//  AMDB.m
//  AdiaMokhtara
//
//  Created by Lion User on 18/04/2013.
//  Copyright (c) 2013 Noor wilaya. All rights reserved.
//

#import "AMDB.h"
#import "Duaa.h"

@implementation AMDB


@synthesize idList;

static NSString * const kFeedTableName = @"duaa";
static NSString * const kItemTableName = @"item";

static NSString * const kDBFeedUrlKey = @"url";
static NSString * const kDBItemUrlKey = @"url";
static NSString * const kDBItemFeedIDKey = @"feed_id";

#pragma mark - Instance methods

- (AMDB *) initWithAMDBFilename: (NSString *) fn {
    // NSLog(@"%s %@", __FUNCTION__, fn);
    if ((self = (AMDB *) [super initWithDBFilename:fn])) {
        idList = [[NSMutableArray alloc] init];
    }
    [self setDefaults];
    return self;
}

- (NSString *) getVersion {
    return kAMDBVersion;
}

- (void) setDefaults {
    // NSLog(@"%s", __FUNCTION__);
    [self addNewIndex];
}

- (NSNumber *) getMaxItemsPerFeed {
    // NSLog(@"%s", __FUNCTION__);
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * maxItemsPerFeed = [defaults objectForKey:@"max_items_per_feed"];
    // the device doesn't initialize standardUserDefaults until the preference pane has been visited once
    if (!maxItemsPerFeed) maxItemsPerFeed = @(kDefaultMaxItemsPerFeed);
    return maxItemsPerFeed;
}

// add index for old version of the DB
- (void) addNewIndex {
    // NSLog(@"%s", __FUNCTION__);
    [self doQuery:@"CREATE UNIQUE INDEX IF NOT EXISTS feedUrl ON feed(url)"];
}

#pragma mark - Feed methods

- (NSArray *) getFeedIDs {
    // NSLog(@"%s", __FUNCTION__);
    NSDictionary * row;
    [idList removeAllObjects];  // reset the array
    for (row in [self getQuery:@"SELECT id FROM feed ORDER BY LOWER(title)"]) {
        [idList addObject:row[@"id"]];
    }
    return idList;
}

- (NSDictionary *) getFeedRow: (NSNumber *) rowid {
    // NSLog(@"%s", __FUNCTION__);
    self->tableName = kFeedTableName;
    return [self getRow:rowid];
}

- (void) deleteFeedRow: (NSNumber *) rowid {
    // NSLog(@"%s", __FUNCTION__);
    [self doQuery:@"DELETE FROM item WHERE feed_id = ?", rowid];
    [self doQuery:@"DELETE FROM feed WHERE id = ?", rowid];
}

- (NSNumber *) addFeedRow: (NSDictionary *) feed {
    // NSLog(@"%s", __FUNCTION__);
    self->tableName = kFeedTableName;
    NSNumber * rowid = [self valueFromQuery:@"SELECT id FROM feed WHERE url = ?", feed[kDBFeedUrlKey]];
    if (rowid) {
        [self updateRow:feed :rowid];
        return rowid;
    } else {
        [self insertRow:feed];
        return nil;     // indicate that it's a new row
    }
}

- (void) updateFeed: (NSDictionary *) feed forRowID: (NSNumber *) rowid {
    // NSLog(@"%s", __FUNCTION__);
    self->tableName = kFeedTableName;
    NSDictionary * rec = @{@"title": feed[@"title"],
                           @"desc": feed[@"desc"]};
    [self updateRow:rec :rowid];
}

#pragma mark - Item methods

- (NSDictionary *) getItemRow: (NSNumber *) rowid {
    // NSLog(@"%s", __FUNCTION__);
    self->tableName = kItemTableName;
    return [self getRow:rowid];
}

- (void) deleteItemRow: (NSNumber *) rowid {
    // NSLog(@"%s", __FUNCTION__);
    self->tableName = kItemTableName;
    [self deleteRow:rowid];
}

- (void) deleteOldItems:(NSNumber *)feedID {
    // NSLog(@"%s", __FUNCTION__);
    [self doQuery:@"DELETE FROM item WHERE feed_id = ? AND id NOT IN "
	 @"(SELECT id FROM item WHERE feed_id = ? ORDER BY pubdate DESC LIMIT ?)",
	 feedID, feedID, [self getMaxItemsPerFeed]];
}

- (NSArray *) getItemIDs:(NSNumber *)feedID {
    // NSLog(@"%s", __FUNCTION__);
    NSDictionary * row;
    [idList removeAllObjects];  // reset the array
    for (row in [self getQuery:@"SELECT id FROM item WHERE feed_id = ? ORDER BY pubdate DESC", feedID]) {
        [idList addObject:row[@"id"]];
    }
    return idList;
}

- (NSNumber *) addItemRow: (NSDictionary *) item {
    // NSLog(@"%s", __FUNCTION__);
    self->tableName = kItemTableName;
    NSNumber * rowid = [self valueFromQuery:@"SELECT id FROM item WHERE url = ? AND feed_id = ?",
                        item[kDBItemUrlKey], item[kDBItemFeedIDKey]];
    if (rowid) {
        [self updateRow:item :rowid];
        return rowid;
    } else {
        [self insertRow:item];
        return nil;     // indicate that it's a new row
    }
}

- (NSNumber *) countItems:(NSNumber *)feedID {
    // NSLog(@"%s", __FUNCTION__);
    return [self valueFromQuery:@"SELECT COUNT(*) FROM item WHERE feed_id = ?", feedID];
}

- (NSArray *) getDuaaIDs
{
    // NSLog(@"%s", __FUNCTION__);
    NSDictionary * row;
    [idList removeAllObjects];  // reset the array
    for (row in [self getQuery:@"SELECT id FROM duaa"]) {
        [idList addObject:row[@"id"]];
    }
    return idList;
}

-(NSMutableArray *) getDuaaList
{
    NSMutableArray *duaalist=[[NSMutableArray alloc] init];
    Duaa *duaa;
    NSDictionary * row;
    NSNumber *duaaId;
    for (row in [self getQuery:@"SELECT * FROM duaa"])
    {
        duaa=[[Duaa alloc] init];
        duaaId=row[@"id"];
        duaa.duaaId=[duaaId intValue];
        duaa.duaaName=row[@"duaaname"];
        duaa.duaaReciter=row[@"reciter"];
        duaa.duaaText=row[@"text"];
        duaa.duaaSearchText=row[@"searchtext"];
        duaa.duaaFile=row[@"file"];
        NSLog(@"duaa name %@",duaa.duaaName);
        [duaalist addObject:duaa];
    }

    NSLog(@"finished getting duaa list");
    NSLog(@"duaa list size is :%i",duaalist.count);
    
    
    
    return duaalist;
    
}

-(NSMutableArray *) searchDuaa:(NSString*) searchText
{
    NSLog(@"The user is searching in the duaa list");
    NSMutableArray *duaalist=[[NSMutableArray alloc] init];
    Duaa *duaa;
    NSDictionary * row;
    NSNumber *duaaId;
    NSString* query=[[NSString alloc]initWithFormat:@"SELECT * FROM duaa where searchtext like '%%%@%%'",searchText];
    NSLog(@"the query is %@",query);
    for (row in [self getQuery:query])
    {
        duaa=[[Duaa alloc] init];
        duaaId=row[@"id"];
        duaa.duaaId=[duaaId intValue];
        duaa.duaaName=row[@"duaaname"];
        duaa.duaaReciter=row[@"reciter"];
        duaa.duaaText=row[@"text"];
        duaa.duaaSearchText=row[@"searchtext"];
        duaa.duaaFile=row[@"file"];
        NSLog(@"duaa name %@",duaa.duaaName);
        [duaalist addObject:duaa];
    }
    
    NSLog(@"finished getting duaa list");
    NSLog(@"duaa list size is :%i",duaalist.count);
    
    
    
    return duaalist;
}

@end
