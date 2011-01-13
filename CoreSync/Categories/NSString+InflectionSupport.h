//
//  NSString+InflectionSupport.h
//  vWork
//
//  Created by Marcus Wyatt on 9/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <Foundation/NSString.h>


@interface NSString (InflectionSupport)

/**
 * Return the dashed form af this camelCase string:
 *
 *   [@"camelCase" dasherize] //> @"camel-case"
 */
- (NSString *)dasherize;

/**
 * Return the underscored form af this camelCase string:
 *
 *   [@"camelCase" underscore] //> @"camel_case"
 */
- (NSString *)underscore;

/**
 * Return the camelCase form af this dashed/underscored string:
 *
 *   [@"camel-case_string" camelize] //> @"camelCaseString"
 */
- (NSString *)camelize;
- (NSString*)camelizeCached;
- (NSString *)deCamelizeWith:(NSString *)delimiter;

/**
 * Return a copy of the string suitable for displaying in a title. Each word is downcased, with the first letter upcased.
 */
- (NSString *)titleize;

- (NSString *)decapitalize;

/**
 * Return a copy of the string with the first letter capitalized.
 */
- (NSString *)toClassName;

/**
 * Returns the plural form of the word in the string.
 *
 *   [@"post" pluralize] //> @"posts"
 *
 */
- (NSString*)pluralize;

/**
 * The reverse of pluralize, returns the singular form of a word in a string.
 *
 *   [@"posts" singularize] //> @"post"
 *
 */
- (NSString*)singularize;

@end
