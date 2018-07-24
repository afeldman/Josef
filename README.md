# Josef
Josef Capek is the brother of Karel Capek. This Projekt is named after him.
Josef, the program, is a very basic FANUC KAREL document generator. 
For the moment it reads in a karel file search for the routine key word and builds a documentation from the upper documentation of
this routine.
In furture more functions should be included. the current version only scans for the @return and @param tag. 
I want to split the KAREL file into parts and then I want to write a perl module to work with each part of the KAREL and gernerat files using the perl Template2 module.

| TAG | Description |
| --- | --- |
| @file | The File name |
| @copyright | The copy right information |
| @todo | list of all future extentions |
| @author | list of all the authors |
| @date | date of the last change|
| @license | the license terms |
| @brief | one line description |
| @return | return value |
| @param | parameter for the routine. The syntax is TYPE DESCRIPTION|
| @see | a Anker to structure in this KAREL file. |

