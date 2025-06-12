# Advanced IEC Check Functions Library

This is a library for B&R controllers. It is installed via Automation Studio for the Automation Runtime operating system. The purpose of this library is to catch programming mistakes before they cause a memory violation and to notify the programmer as to where and how the issue occurred.

For sample usage of this library, as well as unit tests, see the [Advanced IEC Check Library project](https://github.com/BnR-US-Midwest/AdvIecCheckProject).

## How This Library Works

The IEC Check functions in this library are recognized by the processor and are called automatically before every one of their respective operations. For example, the CheckDivReal function is called before any division operation on REAL datatypes. This does not need to be done by the user. The purpose of these automatically-called functions is to catch an issue (i.e. division by zero) before it occurs, to safely mitigate the issue before it causes a memory access violation (i.e. pagefault), and to notify the programmer about the issue.

While the AdvIecChk library is not an official Automation Studio library, these functions are officially supported by the native IEC Check library. The Advanced IEC Check library simply provides different implementations for the functions with the goal of providing the user with more debug information. The native version of these functions is documented in the Automation Studio help or the B&R Online Help:

- [AS 4 Online Help](https://help.br-automation.com/#/en/4/libraries%2Flibraries%2Fiecchecklibrary%2Fprogrammingmodel_libraries_iecchecklibrary.html)
- [AS 6 Online Help](https://help.br-automation.com/#/en/6/libraries%2Flibraries%2Fiecchecklibrary%2Fprogrammingmodel_libraries_iecchecklibrary.html)

## How This Library Differs from the Native IEC Check Library

The Advanced IEC Check library performs the same basic functions as IEC Check, but it has some additional features and improvements:

1. Log entries are created with the ArEventLog library, which replaces the depreciated Sys_lib logging functions
2. A failed check does not necessarily result in a forced reboot into Service Mode (unless the relevant [build option](#available-build-options) is selected). Note: The CheckReadAccess and CheckWriteAccess functions will always cause a pagefault!
3. Log entries include additional information about the error including task name, type of error, and erroneous value
4. If the relevant [build option](#available-build-options) is selected, additional log entries will created that provide backtrace information. This will point to the exact line of code that caused the issue, but requires a forced reboot into Service Mode

## Dependencies

- ArEventLog
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

These functions are fully documented in the Automation Studio Help file, or the B&R Online Help (see above). They broadly fall into three categories:

**CheckDiv**
There exists a CheckDiv function for each base IEC datatype (SINT, USINT, INT, UINT, DINT, UDINT, REAL, and LREAL). The proper function is called before a division or modulo operation involving that datatype. The main goal is to prevent division by zero.

**Check Bounds/Range**
These functions are used to prevent a bounded object from being assigned an out-of-bounds value.

- CheckBounds checks array indexes against the declared bounds of the array
- CheckRange checks enumerated values against the upper and lower limits of the enumeration
- CheckSignedSubrange and CheckUnsignedSubrange check value assignments to variables with [subranges](https://help.br-automation.com/#/en/6/programming%2Fdatatypes%2Fprogrammingmodel_datatypes_derived_subrange.html).

**Check Memory Access**
These functions are used to prevent a dynamic variable from reading or writing to a zero address.

### Helper Functions

These functions are not official check functions, but are called by the check functions in order to log data to the logbook (Logger).

**UDINT StrCatToMaxLen(UDINT pDest, UDINT pSrc, UDINT MaxLength)**: This function concatenates a string at pSrc to the string at pDest where pSrc and pDest are pointers to IEC STRING datatypes. As the inputs are UDINTS, any nonzero address is considered valid. This means that any length string can be passed and the user must ensure the correct address is used. The concatenation ensures that the string at pDest never exceeds the character length specified by MaxLength. If the operation would cause this to happen, only the allowed number of characters are copied, resulting in a truncated concatenation. The resulting string will be null terminated since the final character is not part of the declared size of IEC STRINGs (i.e. a string declared as STRING[32] will actually be 33 bytes in size). The return value is the size of the string at pDest after the concatenation. This function is used to ensure there are no buffer overruns during creation of the logbook error string.

**UDINT MakeEntry(UINT number, DINT index, STRING[ADVIECCHK_MAX_STRING_LEN] text)**: This function uses the error information provided by the Check functions to create a logbook entry for every failed check. Each check function provides a string containing information for the log entry. The MakeEntry function adds the current task name to the string and then publishes the result to the system-created User logbook via the [ArEventLog](https://help.br-automation.com/#/en/6/libraries%2Fareventlog%2Fareventlog.html) library. The return value is the length of the final logbook message string.

## Available Build Options

The following build options can be declared in the Automation Studio project settings in order to modify the behavior of this library. After changing the build options, a rebuild of the project is required!

**_IGNORE_CHECKLIB**
Enabling this option will stop the functions from being used, even if the library is still in the project. You can also completely remove the library from the project to accomplish this. **THE COMPILER WILL USE THIS LIBRARY IF IT IS IN THE LOGICAL VIEW, EVEN IF IT IS NOT IN THE SOFTWARE CONFIGURATION.** This will lead to build errors. Therefore the library must either be disabled via this build option, or removed from the project completely.

**_CHECKLIB_FORCE_RESTART**
Enabling this option will force a pagefault and controller reboot after any failed checks. This will allow the Logger to provide more detailed backtrace information that points directly to the line of code which caused the error. However, it does mean that any issues guarantee a reboot into Service Mode. This option should only be used if the machine is being closely monitored.

**_CHECKLIB_KEEP_INDEX_VALUES**
The following functions are used to check that an index value is within a valid range:

- Check Bounds
- Check Range
- CheckSignedSubrange
- CheckUnsignedSubrange

For example, these would prevent access to index 10 of an array that is defined as Array[2..7] See above for more information about these functions.

By default, if an index violation occurs, the closest valid index will be used instead. Following the last example, this means that Array[0] will actually return Array[2] and Array[10] will return Array[7]. While this prevents memory issues, it may also lead to the application using incorrect values for an operation. This build option will log the error and return the same index that was input, i.e. Array[10] will return Array[10]. This option can cause memory issues and pagefaults, and you should only use it if you understand what it does and how the controller's memory is allocated!

## How to isolate pagefaults using the AdvIecCheck library

### Overview

**What is a pagefault (Processor Exception Error)?** While a system is running, if the processor is commanded to access an invalid or protected memory location, it throws an exception to the operating system (Automation Runtime). AR logs these types of serious memory violation errors as pagefaults.

**What can cause a pagefault?** Sometimes it can be very difficult to find the root cause of pagefaults. They are often caused by programming errors, such as:

- Null or incorrect pointer handles
- Division by zero
- Invalid range of an enumeration
- Invalid index access of an array

### How to use the AdvIecCheck Library to find the root cause of a pagefault

1. Clone this repository and add the files to your Automation Studio project as an Existing Library. You can also add this library to your project as a git submodule.
2. Make sure the newly added AdvIecChk library is included in the Software Configuration under Library Objects
3. Rebuild the project and install it on the target
4. Wait for a pagefault to occur. Try to have multiple pagefaults in mind and a repeatable way to reproduce them before opening the logbook
5. An Error entry in the System logbook will give you the following information about any pagefaults trapped by AdvIecChk:
   - Name of the task in which the error occurred
   - Type of programming error (e.g. Unsigned Subrange was outside valid range)
   - Value of the variable that caused the fault
   - Maximum and minimum valid values of the variable that caused the fault (e.g. the valid range for an array is [0..20] and the element the program was trying to access was at location 21)
6. If _CHECKLIB_FORCE_RESTART is enabled, look for a nearby EXCEPTION Page fault entry. Click on that log entry and go to the backtrace
7. Double-click on the function start position of the task name that you found inside the last warning message. Wherever the Automation Studio takes you is the line of code where the pagefault was encountered
8. After fixing the code, repeat the steps that you used to cause the pagefault and make sure the programing error is resolved

### Best practices to catch a pagefault

Check for the following types of operations:

- Memory set, move, copy, and compare
- String set, move, copy, and compare
- Loop enumeration and array ranges
- Use OF ADR, ACCESS, and pointer handles to function blocks