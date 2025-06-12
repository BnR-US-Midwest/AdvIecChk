# Advanced IEC Check Functions Library

This is a library for B&R controllers. It is installed via Automation Studio for the Automation Runtime operating system. The purpose of this library is to catch programming mistakes before they cause a memory violation and to notify the programmer as to where and how the issue occurred.

For sample usage of this library, as well as unit tests, see the Advanced IEC Check Library project. **ToDo add a link**

## How This Library Works
The IEC Check functions in this library are recognized by the processor and are called automatically before every one of their respective operations. For example, the CheckDivReal function is called before any divison operation on REAL datatypes. This does not need to be done by the user. The purpose of these automatically-called functions is to catch an issue (i.e. division by zero) before it occurs, to safely mitigate the issue before it causes a memory access violation (i.e. Pagefault), and to notify the programmer about the issue.

While the AdvIecChk library is not an official Automation Studio library, these functions are officially supported by the native IEC Check library. The Advanced IEC Check library simply provides different implementations for the functions with the goal of providing the user with more debug information. The native version of these functions is documented in the Automation Studio help or the B&R Online Help:
 - [AS 4 Online Help](https://help.br-automation.com/#/en/4/libraries%2Flibraries%2Fiecchecklibrary%2Fprogrammingmodel_libraries_iecchecklibrary.html)
 - [AS 6 Online Help](https://help.br-automation.com/#/en/6/libraries%2Flibraries%2Fiecchecklibrary%2Fprogrammingmodel_libraries_iecchecklibrary.html)

## Dependencies
 - AsBrStr
 - Sys_lib

## Important Notes
- Unlike the IecCheck library that is natively available in Automation Studio, this library is not officially supported by B&R
- This library only works if a programming error was caused in a program written in an IEC 1131 language or Automation Basic. This library will NOT help to troubleshoot pagefaults caused in C or C++
- This library cannot be used in conjunction with the native IEC Check library as that would mean multiple declarations of the same functions.
- Automation Runtime Simulation (ARSim) does not provide consistent backtrace information with this library
- This library is capable of catching many types of IEC programming errors but not all. Example: Consider a pointer that points to an incorrect memory location. The memory location is not invalid or corrupted, and the pointer is not a null pointer. A memory copy (memcpy) function to this memory area may corrupt it, but this library will not catch that because the memory area is valid at the time of writing. When the processor then tries to access this memory later, a pagefault will occur. However, at that point, there is no way to tell what caused the corruption
- These function implementations can be modified, **however the function declarations cannot**. In order for the processor to recognize these functions as check functions, their names, parameters, and parameter datatypes must match *exactly*. When modifying these functions, keep in mind that they will be called every time an operation occurs. They should therefore be as lean as possible
- After adding, removing, modifying the functions of, or modifying build options related to this library, a rebuild of the entire project is required to ensure these changes are captured in the compiled code

## Functions in This Library

### Check Functions
**ToDo**

### Helper Functions
These functions are not official check functions, but are called by the check functions in order to log data to the logbook (Logger).

**UDINT StrCatToMaxLen(UDINT pDest, UDINT pSrc, UDINT MaxLength)**: This function concatenates a string at pSrc to the string at pDest where pSrc and pDest are pointers to IEC STRING datatypes. As the inputs are UDINTS, any nonzero address is considered valid. This means that any length string can be passed and the user must ensure the correct address is used. The concatenation ensures that the string at pDest never exceeds the character length specified by MaxLength. If the operation would cause this to happen, only the allowed number of characters are copied, resulting in a truncated concatenation. The resulting string will be null terminated since the final character is not part of the declared size of IEC STRINGs (i.e. a string declared as STRING[32] will actually be 33 bytes in size). The return value is the size of the string at pDest after the concatenation.

**UDINT MakeEntry(UINT number, DINT index, STRING[ADVIECCHK_MAX_STRING_LEN] text)**: This function uses the error information provided by the Check functions to create a logbook entry for every failed check. Each check function provides a string containing information for the log entry. The MakeEntry function adds the current task and then publishes the result using the [ERRxwarning](https://help.br-automation.com/#/en/6/libraries%2Fsys_lib%2Ffbks%2Ferrxwarning.html) function from the sys_lib library. This function requires that the logbook message string be more than 32 characters and so every string used by this function is limited to 32 characters (via the constant ADVIECCHK_MAX_STRING_LEN) using the StrCatToMaxLen function. The return value is the length of the final logbook message string.

## Available Build Options

**ToDo**
How to disable IecCheck or AdvIecCheck library in the project
    If the option -D _IGNORE_CHECKLIB is enabled in the additional build options, then the functions
    in this library are not used. Additionally, you can delete the library from your Logical View. **THE COMPILER WILL USE THIS LIBRARY IF IT IS IN THE LOGICAL VIEW, EVEN IF IT IS NOT IN THE SOFTWARE CONFIGURATION.** This can lead to build error.

## How to isolate pagefaults using the AdvIecCheck library

1. Overview			
    **1.1 What is a pagefault (Processor Exception Error)?** While a system is running, if the processor is commanded to access an invalid or protected memory location, it throws an exception to the operating system (Automation Runtime). AR logs these types of serious memory violation errors as pagefaults.
    
    **1.2 What can cause a pagefault?** Sometimes it can be very difficult to find the root cause of pagefaults. They are often caused by programming errors, such as:
    - Null or incorrect pointer handles
    - Division by zero
    - Invalid range of an enumeration
    - Invalid index access of an array
    
    **1.3 What is the difference between the default IecCheck library and the AdvIecCheck library?** The Advanced IEC Check library performs the same basic functions as IEC Check, but it also provides the following additional data about the location of an error:
    - Last executed task class cyclic
    - Last executed task name
    - Type of programming error
    - Variable values from the last executed line of code
    - Backtrace pointing to the last executed line of code
    
2. Required Software
- Automation Studio 4 (or higher)
- Automation Runtime Embedded, Automation Runtime Windows, or Hypervisor

3. How to use the AdvIecCheck Library to find the root cause of a pagefault
    1. Clone this repository and add the files to your Automation Studio project as an Existing Library. You can also add this library to your project as a git submodule.
    2. Make sure the newly added AdvIecChk library is included in the Software Configuration under Library Objects
    3. Rebuild the project and install it on the target
    4. Wait for a pagefault to occur. Try to have multiple pagefaults in mind and a repeatable way to reproduce them before opening the logbook
    5. A Warning entry in the System logbook will give you the following information about any pagefaults trapped by AdvIecChk:
        - Cyclic task class of the task in which the error occurred
        - Name of the task in which the error occurred
        - Type of programming error (e.g. Unsigned Subrange was outside valid range)
        - Value of the variable that caused the fault
        - Maximum and minimum valid values of the variable that caused the fault (e.g. the valid range for a USINT was [3..20] and the element the program was trying to access was at location 0)
    6. Click on the Error entry and go to the backtrace
    7. Double-click on the function start position of the task name that you found inside the last warning message. Wherever the Automation Studio takes you is the line of code where the pagefault was encountered
    8. After fixing the code, repeat the steps that you used to cause the pagefault and make sure the programing error is resolved


5. Best practices to catch a pagefault
    Check for the following types of operations:
    - Memory set, move, copy, and compare
    - String set, move, copy, and compare
    - Loop enumeration and array ranges
    - Use OF ADR(), ACCESS, and pointer handles to function blocks

6. A note about non-IEC languages:
    If a non-IEC language is causing pagefault, declare a remanent variable and change value of that variable in your program at different points. This mimics the use of a "print" statement. After a pagefault, you can connect to the target and read the value of that remanent variable. This will tell you which line or section of code ran right before the fault.