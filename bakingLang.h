/*-------------------------------------------------------------------------*
 *---									---*
 *---		bakingLang.h						---*
 *---									---*
 *---	    This file includes files, defines types and declares	---*
 *---	variables and functions used in common for both the lex/flex	---*
 *---	and YACC/Bison source files of the baking language.		---*
 *---									---*
 *---	----	----	----	----	----	----	----	----	---*
 *---									---*
 *---	Version 1a		2018 February 18	Joseph Phillips	---*
 *---									---*
 *-------------------------------------------------------------------------*/


#include	<cstdlib>
#include	<cstdio>
#include	<cstring>


//  PURPOSE:  To tell the default length of C char arrays.
const int	LINE_LEN	= 256;

//  PURPOSE:  To distinguish among the ingredients.
typedef enum	{
		  FLOUR_INGRED,
		  EGGS_INGRED,
		  SUGAR_INGRED,
		  HONEY_INGRED,
		  COCOA_INGRED,
		  VANILLA_INGRED,
		  CINNAMON_INGRED,
		  BUTTER_INGRED,
		  VEGETABLE_OIL_INGRED,
		  MILK_INGRED,
		  WATER_INGRED,
		  BAKING_SODA_INGRED,
		  BAKING_POWDER_INGRED
		}
		ingredient_ty;


//  PURPOSE:  To distinguish among the baking measures.
typedef	enum	{
		  TEASPOON_MEASURE,
		  TABLESPOON_MEASURE,
		  CUPS_MEASURE,
		  ITEM_MEASURE
		}
		measure_ty;


//  PURPOSE:  To distinguish among the baking time units.
typedef enum	{
		  MINUTES_TIME_UNITS,
		  HOURS_TIME_UNITS
		}
		time_ty;


//  PURPOSE:  To distinguish among the baking temperature units.
typedef enum	{
		  CELSIUS_TEMP_UNITS,
		  FAHRENHEIT_TEMP_UNITS
		}
		temp_ty;


//  PURPOSE:  To hold the names of the ingredients.
extern
const char*	ingredientNames[];


//  PURPOSE:  To  hold the names of the measures.
extern
const char*	measureNames[];


//  PURPOSE:  To hold the names of the baking time units.
extern
const char*	timeNames[];


//  PURPOSE:  To hold the names of the baking temperature units.
extern
const char*	tempNames[];


#include	"BakingNode.h"


//  PURPOSE:  To point to the current position at which tokenizing should be
//	done.
extern
char*		textPtr;


//  PURPOSE:  To point to the end of the tokenizing input.
extern
char*		textEndPtr;


//  PURPOSE:  To hold the root of the recipe.
extern
Node*		recipeRootPtr;

// PURPOSE:  To print parse-time error 'cPtr'.
extern
int		yyerror		(const char*	cPtr
				);


// PURPOSE:  To return the next token.
extern
int		yylex		();