//
//  ClassAndGrade+CoreDataProperties.m
//  CoreDataTest
//
//  Created by MXTH on 2017/11/17.
//  Copyright © 2017年 Hannah. All rights reserved.
//
//

#import "ClassAndGrade+CoreDataProperties.h"

@implementation ClassAndGrade (CoreDataProperties)

+ (NSFetchRequest<ClassAndGrade *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ClassAndGrade"];
}

@dynamic grade;
@dynamic name;
@dynamic school;
@dynamic student;
@dynamic teacher;

@end
