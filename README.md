##   bash-functions

these files are the __bashlib__ functions.  a _bashlib_ is a
source-able file of shell functions with a few regular 
properties:

* name ends in ...lib
* no comments in the library (see below)
* only executable statement in the library is

      ...lib_init

* a canonical reconstruction of the library is done:

     $ ( declare -f $(functions {lib}); echo {lib}_init 
       ) > new{lib}
* the _init function does any "source"ing of other libs
* supporting functions are named  {lib}_doc, {lib}_help,
    {lib}_manpp, etc.
* any output from the source {lib}, which necessarily 
    invokes {lib}_init must be on stderr

###	current challenges

* how to supply local functions to multiple functions
  in the same library?

* consider low-level libraries, like __programlib__ to
  have two sub-libraries:  one from only commnads, and
  the other which uses local functions.

* what is the exposure of the embedded function outside
  it's enclosing function?

