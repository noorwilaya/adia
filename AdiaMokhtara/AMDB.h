//
//  AMDB.h
//  AdiaMokhtara
//
//  Created by Lion User on 18/04/2013.
//  Copyright (c) 2013 Noor wilaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuaaDB.h"
#import "Duaa.h"
static NSString * const kAMDBVersion = @"2.0.0a";
static NSUInteger const kDefaultMaxItemsPerFeed = 50;

@interface AMDB : DuaaDB
{
    NSMutableArray * idList;
}

@property (nonatomic, strong) NSMutableArray * idList;

- (AMDB *) initWithAMDBFilename: (NSString *) fn;
- (NSString *) getVersion;
- (NSArray *) getFeedIDs;
- (void) setDefaults;
- (NSNumber *) getMaxItemsPerFeed;
- (void) addNewIndex;

// Feed methods
- (NSDictionary *) getFeedRow: (NSNumber *) rowid;
- (void) deleteFeedRow: (NSNumber *) rowid;
- (NSNumber *) addFeedRow: (NSDictionary *) feed;
- (void) updateFeed: (NSDictionary *) feed forRowID: (NSNumber *) rowid;

// Item methods
- (NSDictionary *) getItemRow: (NSNumber *) rowid;
- (void) deleteItemRow: (NSNumber *) rowid;
- (void) deleteOldItems:(NSNumber *)feedID;
- (NSArray *) getItemIDs:(NSNumber *)feedID;
- (NSNumber *) addItemRow: (NSDictionary *) item;
- (NSNumber *) countItems:(NSNumber *)feedID;

- (NSArray *) getDuaaIDs;
-(NSMutableArray *) getDuaaList;
-(NSMutableArray *) searchDuaa:(NSString*) searchText;
-(Duaa*) getDuaaOfTheDay;


@end
