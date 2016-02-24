//
//  News+CoreDataProperties.h
//  CuiJian
//
//  Created by Moonths on 16/2/17.
//  Copyright © 2016年 Rick. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "News.h"

NS_ASSUME_NONNULL_BEGIN

@interface News (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *post_title;
@property (nullable, nonatomic, retain) NSString *post_id;
@property (nullable, nonatomic, retain) NSString *post_date;
@property (nullable, nonatomic, retain) NSString *post_modified;
@property (nullable, nonatomic, retain) NSString *post_excerpt;
@property (nullable, nonatomic, retain) NSString *post_content;
@property (nullable, nonatomic, retain) id feature_image;
@property (nullable, nonatomic, retain) NSNumber *term_id;

@end

NS_ASSUME_NONNULL_END
