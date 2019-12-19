# PLEASE CHECK https://guides.github.com/features/mastering-markdown/ TO MASTER GITHUB MARKDOWN BEFORE EDITING AN ISSUE OR README TEXT 

## ----> QUALITY EXPECTED <----

* Type every variables when it doesn't needs dynamic typing.
* Use setget on externaly used variables.

* Comment every method you create: juste sumup its behaviour, what type of arguments it expects and what it returns.

* Encapsulate as much as you can: each Node should have a single purpose.
* Children contains only logic or Data, and parents only manage their children.

* Create the less dependencies possibles, a node whitout any child should be reusable and have, if possible, no direct dependancy at all.
* Parents give the NodeReference they needs to their children.

* Use Signal only to respond to a behaviour.
* Use a method call to start a behaviour.

**If one, or several of these rulls are not respected, a pull request can be rejected by a collegue.**


## ----> NAMING CONVENTION <----

* NameOfNode : PascalCase

* ClassNameBase : (Classes that are parent class for inherited children scripts) PascalCase

* CONSTANT : All caps
* ENUMERATION : All caps

* variable_name: snake_case
* _variable_name : variable private to a class
* node_name_node : variable containing a NodeReference
* variable_name_array : variable containing an array
* var_name(variables locals to a method): snake_case with abreviations

* method_name(): snake_case, recognizable with the parenthesis
* _method_name(): method private to a class

* NomDeSignal: PascalCase, usally a verb a past tense (ex: ButtonTriggered)
* on_NomDeSignal(): snake_case with the name of the signal at the end (ex: on_ButtonTriggered)
* _argument_name: argument not used in the method (frequently used when the method is declared as abstract in the parent class)



## ----> FOLDER ORGANISATION <----

| /GLOBAL |               |          |                                                                                             |
|:-------:|---------------|----------|---------------------------------------------------------------------------------------------|
|         | /BASE_CLASSES |          | (Contain abstract classes, and classes that are very frequently inherited by other classes) |
|         | /ASSETS       |          |                                                                                             |
|         |               | /SPRITES |                                                                                             |
|         |               | /SOUNDS  |                                                                                             |
| /SCENES |               |          |                                                                                             |
|         | /SCENE_A      |          |                                                                                             |
|         |               | /SCRIPT  |                                                                                             |
|         |               | /SPRITES |                                                                                             |
|         |               | /TSCN    |                                                                                             |