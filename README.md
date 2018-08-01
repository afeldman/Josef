# Josef
Josef Capek is the brother of Karel Capek. This Projekt is named after him.
Josef (this program) is a very basic FANUC KAREL document generator. 
For the moment it reads in a karel file search for the routine key word and builds a documentation from the upper documentation of
this routine.
In furture more functions should be included. the current version only scans for the @return and @param tag. 
I want to split the KAREL file into parts and then I want to write a perl module to work with each part of the KAREL and gernerat files using the perl Template2 module.

| TAG | Description |
| --- | --- |
| @file | The File name |
| @copyright | The copy right information |
| @todo | on todo task at a time. but this can used mutible time |
| @author | one author but this can used mutiple times |
| @date | date of the last change|
| @license | the license terms |
| @brief | one line description |
| @return | return value of the routine |
| @param | parameter for the routine. The syntax is TYPE DESCRIPTION|


