//
//  Teacher+CoreDataProperties.m
//  CoreDataTest
//
//  Created by MXTH on 2017/11/17.
//  Copyright © 2017年 Hannah. All rights reserved.
//
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Teacher"];
}

@dynamic subject;
@dynamic teachYear;
@dynamic teacherId;
@dynamic classAndGrade;
@dynamic school;
@dynamic student;

@end
