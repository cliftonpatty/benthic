''SOME RULES''

file names snake_lowercase
node names PascalCase

/assets : art, shaders, sounds, etc... foundational pieces 
/entities : scripts and scenes, combinations of assets 
/scripts : globals and overarching scripts
/UI : self contained with its own art, scripts, 

Recommended code order----------------------------------------------------------
01. tool
02. class_name
03. extends
04. # docstring

05. signals
06. enums
07. constants
08. exported variables
09. public variables
10. private variables
11. onready variables

12. optional built-in virtual _init method
13. built-in virtual _ready method
14. remaining built-in virtual methods
15. public methods
16. private methods
