//
//  School+CoreDataProperties.m
//  CoreDataTest
//
//  Created by MXTH on 2017/11/17.
//  Copyright © 2017年 Hannah. All rights reserved.
//
//

#import "School+CoreDataProperties.h"

@implementation School (CoreDataProperties)

+ (NSFetchRequest<School *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"School"];
}

@dynamic historyYear;
@dynamic name;
@dynamic classAndGrade;
@dynamic student;
@dynamic teacher;

@end
