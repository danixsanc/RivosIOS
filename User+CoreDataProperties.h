//
//  User+CoreDataProperties.h
//  
//
//  Created by Ramón Quiñonez on 19/10/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;

@end

NS_ASSUME_NONNULL_END
