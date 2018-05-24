/*-------------------------------------------------------------------------*
 *---									---*
 *---		BakingNode.h						---*
 *---									---*
 *---	    This file declares and defines classes that represent parse	---*
 *---	Nodes.								---*
 *---									---*
 *---	----	----	----	----	----	----	----	----	---*
 *---									---*
 *---	Version 1a		2018 February 18	Joseph Phillips	---*
 *---									---*
 *-------------------------------------------------------------------------*/


class		Node
{
public :
  Node		()		{}

  virtual
  ~Node		()		{}

  virtual
  void		addItem		(Node*	nodePtr
  				)
				{
				  throw "Attempt to add an item"
				  	" to a non-ingredient";
				}

  virtual
  void		addStep		(Node*	nodePtr
  				)
				{
				  throw "Attempt to add a step"
				  	" to a non-step";
				}

  virtual
  void		print		()
				const
  				= 0;

};


class		IngredientNode : public Node
{
  ingredient_ty			ingredient_;
  measure_ty			measure_;
  double			number_;
  IngredientNode*		nextPtr_;

public :
  IngredientNode		(ingredient_ty		newIngredient,
				 measure_ty		newMeasure,
				 double			newNumber
				) :
				Node(),
				ingredient_(newIngredient),
				measure_(newMeasure),
				number_(newNumber),
				nextPtr_(NULL)
				{ }

  ~IngredientNode		()
  				{
				  delete(nextPtr_);
				}

  ingredient_ty	getIngredient	()
				const
				{ return(ingredient_); }

  measure_ty	getMeasure	()
  				const
				{ return(measure_); }

  double	getNumber	()
  				const
				{ return(number_); }

  IngredientNode*
		getNextPtr	()
				const
				{ return(nextPtr_); }

  void		addItem		(Node*	nodePtr
  				)
				{
				  IngredientNode*	iPtr;

				  if  (nodePtr == NULL)
				    return;

				  iPtr = dynamic_cast<IngredientNode*>(nodePtr);

				  if  (iPtr == NULL)
				  {
				    throw "Attempt to add a non-ingredient";
				  }

				  if  (nextPtr_ == NULL)
				    nextPtr_ = iPtr;
				  else
				    nextPtr_->addItem(iPtr);

				}

  void		print		()
				const
				{
				  if  (getMeasure() == ITEM_MEASURE)
				    printf("  %g %s\n",
				    	   getNumber(),
					   ingredientNames[getIngredient()]
					  );
				  else
				    printf("  %g %s of %s\n",
				    	   getNumber(),
					   measureNames[getMeasure()],
					   ingredientNames[getIngredient()]
					  );

				  if  (getNextPtr() != NULL)
				    getNextPtr()->print();
				}

};


class		StepNode : public Node
{
  StepNode*			nextPtr_;

public :
  StepNode			() :
  				Node(),
				nextPtr_(NULL)
				{ }

  ~StepNode			()
  				{
				  delete(nextPtr_);
				}

  StepNode*	getNextPtr	()
				const
				{ return(nextPtr_); }

  void		addStep		(Node*	nodePtr
  				)
				{
				  StepNode*	sPtr;

				  if  (nodePtr == NULL)
				    return;

				  sPtr = dynamic_cast<StepNode*>(nodePtr);

				  if  (sPtr == NULL)
				  {
				    throw "Attempt to add a non-step";
				  }

				  if  (nextPtr_ == NULL)
				    nextPtr_ = sPtr;
				  else
				    nextPtr_->addStep(sPtr);

				}

};


class		MixNode : public StepNode
{
  IngredientNode*		list_;

  char*				mixtureNameCPtr_;

public :
  MixNode			(Node*	newList,
  				 char*	newMixtureNameCPtr
  				) :
				StepNode(),
				list_(NULL),
				mixtureNameCPtr_(newMixtureNameCPtr)
				{
				  if  (newMixtureNameCPtr == NULL)
				  {
				    throw "Missing name to StepNode";
				  }

				  if  (newList != NULL)
				  {
				    list_ = dynamic_cast<IngredientNode*>
						(newList);

				    if  (list_ == NULL)
				    {
				      throw "Bad list to StepNode";
				    }
				  }
				}

  ~MixNode			()
  				{
				  free(mixtureNameCPtr_);
				  delete(list_);
				}
  
  void		print		()
				const
				{
				  printf("Mix:\n");

				  if  (list_ != NULL)
				  {
				    list_->print();
				  }

				  printf("to make %s.\n",mixtureNameCPtr_);

				  if  (getNextPtr() != NULL)
				    getNextPtr()->print();
				}

};


class	CombineNode : public StepNode
{
  char*				addendPtr_;
  char*				accumulatorPtr_;

public :
  CombineNode			(char*		newAddendPtr,
				 char*		newAccumulatorPtr
				) :
				StepNode(),
				addendPtr_(newAddendPtr),
				accumulatorPtr_(newAccumulatorPtr)
				{ }

  ~CombineNode			()
				{
				  free(accumulatorPtr_);
				  free(addendPtr_);
				}

  void		print		()
				const
				{
				  printf("Combine %s into %s.\n",
					 addendPtr_,
					 accumulatorPtr_
					);

				  if  (getNextPtr() != NULL)
				    getNextPtr()->print();
				}

};


class	BakeNode : public StepNode
{
  char*				mixtureNameCPtr_;  
  double			timeNum_;
  time_ty			time_;
  double			tempNum_;
  temp_ty			temp_;

public :
  BakeNode			(char*		newMixtureNameCPtr,
				 double		newTimeNum,
				 time_ty	newTime,
				 double		newTempNum,
				 temp_ty	newTemp
				) :
				StepNode(),
				mixtureNameCPtr_(newMixtureNameCPtr),
				timeNum_(newTimeNum),
				time_(newTime),
				tempNum_(newTempNum),
				temp_(newTemp)
				{ }

  ~BakeNode			()
				{
				  free(mixtureNameCPtr_);
				}

  void		print		()
				const
				{
				  printf("Bake %s for %g %s at %g %s.\n",
					 mixtureNameCPtr_,
					 timeNum_,timeNames[time_],
					 tempNum_,tempNames[temp_]
					);

				  if  (getNextPtr() != NULL)
				    getNextPtr()->print();
				}

};