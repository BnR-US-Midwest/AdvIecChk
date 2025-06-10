# Advanced IEC Check Functions Library

## Important Notes
- Unlike the official IecCheck library, this library is not officially supported by B&R
- Just like IECCheck library, this library only works if a programming error was caused in a program written in an IEC language. This library will NOT help to troubleshoot pagefaults caused in C or C++.
- Automation Runtime Simulation (ARSim) does not provide consistent backtrace with this library.
- This library is capable OF catching many types OF IEC programming errors but not all. Example: Consider a pointer that points to an incorrect memory location. The memory location is not invalid or corrupted, and the pointer is not a null pointer. A memory copy (memcpy) function to this memory area may corrupt it, but this library will not catch that because the memory area is valid at the time of writing. When the processor then tries to access this memory later, a pagefault will occur. However, at that point, there is no way to tell what caused the corruption.

## How to isolate pagefaults using the AdvIecCheck library

	1. Overview			
        - **1.1 What is a pagefault (Processor Exception Error)?** While a system is running, if the processor is commanded TO access an invalid or protected memory location, it throws an exception to the operating system (Automation Runtime). AR logs these types of serious memory violation errors as pagefaults.
        
        - **1.2 What can cause a pagefault?** Sometimes it can be very difficult to find the root cause of pagefaults. They are often caused by programming errors, such as:
            - Null OR incorrect pointer handles
            - Division by zero
            - Invalid range of an enumeration
            - Invalid index access of an array
        
        - *1.3 What is the purpose of the Automation Studio default IEC Check library?* The IEC Check library which is provided with Automation Studio checks for various memory access errors, such as those above. Without this library, if a pagefault is encountered, there will be a logbook entry with a backtrace that may or may not show the line of code which caused the pagefault. The IEC Check library checks these operations before they are performed. If the processor finds any OF these checks to be incorrect, a logbook error entry will detail the type of error and which task class caused it, but there will be no backtrace.
        
        - **1.4 What is the difference between the default IecCheck library and the AdvIecCheck library?** The Advanced IEC Check library performs the same basic functions as IEC Check, but it also provides the following additional data about the location of an error:
            - Last executed task class cyclic
            - Last executed task name
            - Type of programming error
            - Variable values from the last executed line of code
            - Backtrace pointing to the last executed line of code
        
    2 Required Software
        - Automation Studio 4 (or higher)
        - Automation Runtime Embedded, Automation Runtime Windows, or Hypervisor

    3. How to use the AdvIecCheck Library to find the root cause of a pagefault
        1. Clone this repository and add the files to your Automation Studio project as an Existing Library
        2. Make sure the newly added AdvIecChk library is included in the Software Configuration under Library Objects
        3. Rebuild the project and install it on the target
        4. Wait for a pagefault to occur. Try to have multiple pagefaults in mind and a repeatable way to reproduce them before opening the logbook
        5. A Warning entry will give you the following information about any pagefaults trapped by AdvIecChk:
            - Cyclic task class of the task
            - Name of the task
            - Type of programming error (e.g. Unsigned Subrange was outside valid range)
            - Value of the variable that ended up causing this fault
            - Maximum and minimum valid values of the variable that caused this fault (e.g. the valid range for a USINT was [3..20] aand the element the program was trying TO access was at location 0)
        6. Click on the Error entry and go to the backtrace, 
        7. Double-click on the function start position’ of the task name that you found inside the last warning message. Wherever the Automation Studio takes you is the line of code where the pagefault was encountered
        8. After fixing the code, repeat the steps that you used to cause the pagefault and make sure the programing error is resolved

    5 How to disable IecCheck or AdvIecCheck library in the project
        IF the option -D _IGNORE_CHECKLIB is enabled in the additional build options, then the functions
        in this library are not used. Additionally, you can delete the library from your Logical View. THE COMPILER WILL USE THIS LIBRARY IF IT IS IN THE LOGICAL VIEW, EVEN IF IT IS NOT IN THE SOFTWARE CONFIGURATION. This can lead to build error.

    6 Best practices to catch a pagefault
        Check FOR the following types OF operations:
            - Memory set, move, copy, and compare
            - String set, move, copy, and compare
            - Loop enumeration and array ranges
            - Use OF ADR(), ACCESS, and pointer handles TO function blocks

    7 Additional note
        - You can customize AdvIecChk library to get more or different information from it
        - IF a non IEC language is causing pagefault, declare a remanent variable and change value of that variable in your program at different points. After a pagefault, you can connect to the target and read the value of that remanent variable. This will tell you after which point the pagefault occured.