%{
/*-------------------------------------------------------------------------*
 *---									---*
 *---		bakingLang.y						---*
 *---									---*
 *---	    This file defines a parser FOR the baking language.		---*
 *---									---*
 *---	----	----	----	----	----	----	----	----	---*
 *---									---*
 *---	Version 1a		2018 February 18	Joseph Phillips	---*
 *---									---*
 *-------------------------------------------------------------------------*/

#include	"bakingLang.h"


%}

%union
{
  double  numNode;
  char* termIdentifier;
  ingredient_ty ingredient;
  measure_ty  measure;
  time_ty time;
  temp_ty temp;
  Node* nonTerm;
}

%start RECIPE;
%token <termIdentifier> identifier;
%token <numNode> number;
%type <nonTerm> RECIPE;
%type <nonTerm> STEP;
%type <nonTerm> LIST;
%type <nonTerm> ITEM; 
%token <ingredient> INGREDIENT;
%token <measure> MEASURE;
%token <time> TIME;
%token <temp> TEMP;
%token bake;
%token combine;
%token into;
%token mix;
%token to;
%token make;
%token FOR;
%token at;
%token period;
%%

RECIPE : STEP RECIPE 
    {
      $$ = $1;
      $1->addStep($2);
      recipeRootPtr = $$;
    }
  |
    {
      $$ = NULL;
    }
STEP  : combine identifier into identifier period 
    {
      $$ = new CombineNode($2,$4);
    }
  | mix LIST to make identifier period 
    {
      $$ = new MixNode($2, $5);
    }
  | bake identifier FOR number TIME at number TEMP period 
    {
      $$ = new BakeNode($2, $4, $5, $7, $8);
    }
LIST  : ITEM LIST
    {
      $$ = $1;
      $1->addItem($2);
    }
  |
    {
      $$ = NULL;
    }
ITEM  : number MEASURE INGREDIENT
    {
      $$ = new IngredientNode($3, $2, $1);
    }
  | number INGREDIENT
    {
      $$ = new IngredientNode($2, ITEM_MEASURE, $1);
    }
%%

//  PURPOSE:  To hold the names of the ingredients.
const char*	ingredientNames[]
		= { "flour",
		    "egg(s)",
		    "sugar",
		    "honey",
		    "cocoa",
		    "vanilla",
		    "cinnamon",
		    "butter",
		    "vegetable oil",
		    "milk",
		    "water",
		    "baking soda",
		    "baking powder"
		  };


//  PURPOSE:  To  hold the names of the measures.
const char*	measureNames[]
		= { "teaspoons",
		    "tablespoons",
		    "cups",
		    ""
		  };

//  PURPOSE:  To hold the names of the baking time units.
const char*	timeNames[]
		= { "minutes",
		    "hours"
		  };


//  PURPOSE:  To hold the names of the baking temperature units.
const char*	tempNames[]
		= { "C",
		    "F"
		  };



//  PURPOSE:  To point to the current position at which tokenizing should be
//	done.
char*		textPtr		= NULL;


//  PURPOSE:  To point to the end of the tokenizing input.
char*		textEndPtr	= NULL;


//  PURPOSE:  To hold the root of the recipe.
Node*		recipeRootPtr	= NULL;


//  PURPOSE:  To print parse-time error 'cPtr'.  No return value.
int		yyerror		(const char*	cPtr
				)
{
  fprintf(stderr,"%s, sorry!\n",cPtr);
  return(0);
}


//  PURPOSE:  To get input, run the parser, and display the result if the parse
//	was successful.  Return 'EXIT_SUCCESS' on success or 'EXIT_FAILURE'
//	otherwise.
int		main		(int	argc,
				 char*	argv[]
				)
{
  char	line[LINE_LEN];
  int	toReturn	= EXIT_SUCCESS;

  if  (argc >= 2)
  {
    textPtr	= argv[1]; 
  }
  else
  {
    printf("Please enter a recipe: ");
    textPtr	= fgets(line,LINE_LEN,stdin);
  }

  textEndPtr	= textPtr + strlen(textPtr);

  try
  {

    if  ( (yyparse() == 0)  &&  (recipeRootPtr != NULL) )
    {
      recipeRootPtr->print();
      delete(recipeRootPtr);
    }
    else
    {
      toReturn	= EXIT_FAILURE;
    }

  }
  catch  (const char* cPtr)
  {
    fprintf(stderr,"Error: %s\n",cPtr);
    toReturn	= EXIT_FAILURE;
  }

  return(toReturn);
}
