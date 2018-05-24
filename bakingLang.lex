%{
/*-------------------------------------------------------------------------*
 *---									---*
 *---		bakingLang.lex						---*
 *---									---*
 *---	    This file defines a tokenizer for the baking language.	---*
 *---									---*
 *---	----	----	----	----	----	----	----	----	---*
 *---									---*
 *---	Version 1a		2018 February 18	Joseph Phillips	---*
 *---									---*
 *-------------------------------------------------------------------------*/
#include		"bakingLang.h"
#include		"bakingLang.tab.h"

#undef			YY_INPUT
#define			YY_INPUT(buffer,result,maxSize)		\
			{ result = ourInput(buffer,maxSize); }

extern
int			ourInput(char* buffer, int maxSize);

#define			MIN(x,y)       (((x)<(y)) ? (x) : (y))

%}

%%
[0-9]+|([0-9]*\.[0-9]+)	{
							printf("NUMBER\n");
			 				yylval.numNode = strtod(yytext,NULL);
			 				return(number);
						}
mix|Mix	{printf("MIX\n"); return(mix);}
combine|Combine {printf("COMBINE\n"); return(combine);}
bake|Bake	{printf("BAKE\n"); return(bake);}
"for"	{printf("FOR\n"); return(FOR);}
"at"	{printf("AT\n"); return(at);}
"to"	{printf("TO\n"); return(to);}
"make"	{printf("MAKE\n"); return(make);}
"into"	{printf("INTO\n"); return(into);}
"flour"	{
			printf("FLOUR\n");
			yylval.ingredient = FLOUR_INGRED; 
			return(INGREDIENT);
		}
egg|eggs	{ printf("EGG\n"); yylval.ingredient = EGGS_INGRED; return(INGREDIENT);}
"sugar"	{
			printf("SUGAR\n");
			yylval.ingredient = SUGAR_INGRED; 
			return(INGREDIENT);
		}
"honey"	{
			printf("HONEY\n");
			yylval.ingredient = HONEY_INGRED; 
			return(INGREDIENT);
						}
"cocoa"	{
			printf("COCOA\n");
			yylval.ingredient = COCOA_INGRED; 
			return(INGREDIENT);
		}
"vanilla"	{
				printf("VANILLA\n");
				yylval.ingredient = VANILLA_INGRED; 
				return(INGREDIENT);
			}
"cinnamon"	{
				printf("CINNAMON\n");
				yylval.ingredient = CINNAMON_INGRED; 
				return(INGREDIENT);
			}
"butter"	{
				printf("BUTTER\n");
				yylval.ingredient = BUTTER_INGRED; 
				return(INGREDIENT);
			}
"vegetable oil"	{
					printf("VEGETABLE_OIL\n");
					yylval.ingredient = VEGETABLE_OIL_INGRED; 
					return(INGREDIENT);
				}
"vegetableoil"	{
					printf("VEGETABLE_OIL\n");
					yylval.ingredient = VEGETABLE_OIL_INGRED; 
					return(INGREDIENT);}
"milk"	{
			printf("MILK\n");
			yylval.ingredient = MILK_INGRED; 
			return(INGREDIENT);
		}
"water"	{
			printf("WATER\n");
			yylval.ingredient = WATER_INGRED; 
			return(INGREDIENT);
		}
"bakingsoda"	{
					printf("BAKING_SODA\n");
					yylval.ingredient = BAKING_SODA_INGRED; 
					return(INGREDIENT);
				}
"baking soda"	{
					printf("BAKING_SODA\n");
					yylval.ingredient = BAKING_SODA_INGRED; 
					return(INGREDIENT);
				}
"bakingpowder"	{
					printf("BAKINGPOWDER\n");
					yylval.ingredient = BAKING_POWDER_INGRED;
					return(INGREDIENT);
				}
"baking powder"	{
					printf("BAKINGPOWDER\n");
					yylval.ingredient = BAKING_POWDER_INGRED;
					return(INGREDIENT);
				}
"teaspoons"	{
				printf("TEA_SPOONS\n");
				yylval.measure = TEASPOON_MEASURE; 
				return(MEASURE);
			}
"tbl"	{
			printf("TABLESPOONS\n");
			yylval.measure = TABLESPOON_MEASURE; 
			return(MEASURE);
		}
tablespoon|tablespoons	{printf("TABLESPOONS\n"); yylval.measure = TABLESPOON_MEASURE; return(MEASURE);}
tsp|tsps {printf("TEA_SPOONS\n"); yylval.measure = TEASPOON_MEASURE; return(MEASURE);}
cup|cups {printf("CUP(S)\n"); yylval.measure = CUPS_MEASURE; return(MEASURE);}
""	{
		yylval.measure = ITEM_MEASURE; 
		return(MEASURE);
	}

mins|minutes	{printf("MINUTES\n"); yylval.time = MINUTES_TIME_UNITS; return(TIME);}
"hours"				{printf("HOURS\n"); yylval.time = HOURS_TIME_UNITS; return(TIME);}
celsius|C		{printf("CELSIUS\n"); yylval.temp = CELSIUS_TEMP_UNITS; return(TEMP);}
fahrenheit|F	{printf("FARENHEIT\n"); yylval.temp = FAHRENHEIT_TEMP_UNITS; return(TEMP);}
"."	{printf("PERIOD\n"); return(period);}
[a-zA-Z_][a-zA-Z_0-9]*	{
							printf("IDENTIFIER\n");
			  				yylval.termIdentifier = strdup(yytext);
			  				return(identifier);
						} 
[ \t\n]			{ /* ignore whitespace */ }
%%

//  PURPOSE:  To return the next char of input.
int		ourInput(char* buffer, int maxSize)
{
  int	n	= MIN(maxSize,textEndPtr - textPtr);

  if  (n > 0)
  {
    memcpy(buffer,textPtr,n);
    textPtr	+= n;
  }

  return(n);
}


//  PURPOSE:  To return '1' when should stop after reach EOF.
int		yywrap		()
				{ return(1); }