(************************************************************************************

Advanced IEC Check Functions Library

File: AdvIecChk.st
Description: Implentation of library functions
Authors:
    - Matt Adams (B&R Industrial Automation)
    - Varad Darji (B&R Industrial Automation)
    - Marcus Mangel (B&R Industrial Automation)

************************************************************************************)

(* Called before the division/module using a SINT value. Returns the divisor if no errors are found *)
(* Replaces CheckDivByte, which may return incorrect results *)
FUNCTION CheckDivSint
    
    IF divisor=0 THEN
        CheckDivSint := 1;
        MakeEntry(55555,divisor,'SINT div by 0');
    ELSE
        CheckDivSint := divisor;
    END_IF
    
END_FUNCTION
    
(* Called before the division/module using a USINT value. Returns the divisor if no errors are found *)
(* Replaces CheckDivByte, which may return incorrect results *)
FUNCTION CheckDivUsint
    
    IF divisor=0 THEN
        CheckDivUsint := 1;
        MakeEntry(55555,divisor,'USINT div by 0');
    ELSE
        CheckDivUsint := divisor;
    END_IF
    
END_FUNCTION

(* Called before the division/module using an INT value. Returns the divisor if no errors are found *)
(* Replaces CheckDivWord, which may return incorrect results *)
FUNCTION CheckDivInt
    
    IF divisor=0 THEN
        CheckDivInt := 1;
        MakeEntry(55555,divisor,'INT div by 0');
    ELSE
        CheckDivInt := divisor;
    END_IF
    
END_FUNCTION

(* Called before the division/module using a UINT value. Returns the divisor if no errors are found *)
(* Replaces CheckDivWord, which may return incorrect results *)
FUNCTION CheckDivUint
    
    IF divisor=0 THEN
        CheckDivUint := 1;
        MakeEntry(55555,divisor,'UINT div by 0');
    ELSE
        CheckDivUint := divisor;
    END_IF
    
END_FUNCTION

(* Called before the division/module using a DINT value. Returns the divisor if no errors are found *)
(* Replaces CheckDivDWord, which may return incorrect results *)
FUNCTION CheckDivDint
    
    IF divisor=0 THEN
        CheckDivDint := 1;
        MakeEntry(55555,divisor,'DINT div by 0');
    ELSE
        CheckDivDint := divisor;
    END_IF
    
END_FUNCTION

(* Called before the division/module using a UDINT value. Returns the divisor if no errors are found *)
(* Replaces CheckDivDWord, which may return incorrect results *)
FUNCTION CheckDivUdint
    
    IF divisor=0 THEN
        CheckDivUdint := 1;
        MakeEntry(55555,divisor,'UDINT div by 0');
    ELSE
        CheckDivUdint := divisor;
    END_IF
    
END_FUNCTION

(* Called before the division/module using a REAL value. Returns the divisor if no errors are found *)
FUNCTION CheckDivReal
    
    IF divisor=0 THEN
        CheckDivReal := 1;
        MakeEntry(55555,0,'REAL div by 0');
    ELSE
        CheckDivReal := divisor;
    END_IF
    
END_FUNCTION

(* Called before the division/module using a LREAL value. Returns the divisor if no errors are found *)
(* CANNOT BE USED on SG3 OR SGC targets!! *)
FUNCTION CheckDivLReal
    
    IF divisor=0 THEN
        CheckDivLReal := 1;
        MakeEntry(55555,0,'LREAL div by 0');
    ELSE
        CheckDivLReal := divisor;
    END_IF
    
END_FUNCTION

(* Called before accessing an array. Returns the index if no errors are found.
Otherwise, returns the problematic index bound *)
FUNCTION CheckBounds
    
    IF index < lower THEN
        CheckBounds := lower; // Unless: See end of function
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(index, ADR(IndexString));
        brsstrcpy(ADR(ErrorText),ADR('Arr Idx '));
        StrCatToMaxLen(ADR(ErrorText),ADR(IndexString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(' not in ['),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(LowString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR('..'),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(UpString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(']'),ADVIECCHK_MAX_STRING_LEN);
        MakeEntry(55555,index,ErrorText);
    ELSIF index > upper THEN
        CheckBounds := upper; // Unless: See end of function
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(index, ADR(IndexString));
        brsstrcpy(ADR(ErrorText),ADR('Arr Idx '));
        StrCatToMaxLen(ADR(ErrorText),ADR(IndexString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(' not in ['),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(LowString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR('..'),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(UpString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(']'),ADVIECCHK_MAX_STRING_LEN);
        MakeEntry(55555,index,ErrorText);
    ELSE
        CheckBounds := index;
    END_IF
    
    #if defined(_CHECKLIB_KEEP_INDEX_VALUES)
    // Don't modify accessed index
    // This may lead to undefined behavior!
    CheckBounds := index;
    #endif
    
END_FUNCTION

(* Called before write accessing an enumeration variable. Returns the value if no errors are found.
Otherwise, returns the problematic value bound *)
FUNCTION CheckRange
    
    IF value < lower THEN
        CheckRange := lower; // Unless: See end of function
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Enum Val '));
        StrCatToMaxLen(ADR(ErrorText),ADR(ValueString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(' not in ['),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(LowString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR('..'),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(UpString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(']'),ADVIECCHK_MAX_STRING_LEN);
        MakeEntry(55555,value,ErrorText);	
    ELSIF value > upper THEN
        CheckRange := upper; // Unless: See end of function
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Enum Val '));
        StrCatToMaxLen(ADR(ErrorText),ADR(ValueString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(' not in ['),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(LowString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR('..'),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(UpString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(']'),ADVIECCHK_MAX_STRING_LEN);
        MakeEntry(55555,value,ErrorText);
    ELSE
        CheckRange := value;
    END_IF
    
    #if defined(_CHECKLIB_KEEP_INDEX_VALUES)
    // Don't modify accessed value
    // This may lead to undefined behavior!
    CheckRange := value;
    #endif
    
END_FUNCTION

(* Called before write access to a variable with the data type "Subrange" if the subrange is used on a signed data type. Returns the value if no errors are found.
Otherwise, returns the problematic value bound *)
FUNCTION CheckSignedSubrange
    
    IF value < lower THEN
        CheckSignedSubrange := lower; // Unless: See end of function
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Subrng Idx '));
        StrCatToMaxLen(ADR(ErrorText),ADR(ValueString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(' not in ['),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(LowString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR('..'),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(UpString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(']'),ADVIECCHK_MAX_STRING_LEN);
        MakeEntry(55555,value,ErrorText);	
    ELSIF value > upper THEN
        CheckSignedSubrange := upper; // Unless: See end of function	
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        StrCatToMaxLen(ADR(ErrorText),ADR('Subrng Idx '),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(ValueString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(' not in ['),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(LowString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR('..'),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(UpString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(']'),ADVIECCHK_MAX_STRING_LEN);
        MakeEntry(55555,value,ErrorText);
    ELSE
        CheckSignedSubrange := value;
    END_IF
    
    #if defined(_CHECKLIB_KEEP_INDEX_VALUES)
    // Don't modify accessed value
    // This may lead to undefined behavior!
    CheckSignedSubrange := value;
    #endif
    
END_FUNCTION

(* Called before write access to a variable with the data type "Subrange" if the subrange is used on an unsigned data type. Returns the value if no errors are found.
Otherwise, returns the problematic value bound *)
FUNCTION CheckUnsignedSubrange
    
    IF value < lower THEN
        CheckUnsignedSubrange := lower; // Unless: See end of function
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Subrng Idx '));
        StrCatToMaxLen(ADR(ErrorText),ADR(ValueString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(' not in ['),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(LowString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR('..'),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(UpString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(']'),ADVIECCHK_MAX_STRING_LEN);
        MakeEntry(55555,value,ErrorText);	
    ELSIF value > upper THEN
        CheckUnsignedSubrange := upper; // Unless: See end of function
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Subrng Idx '));
        StrCatToMaxLen(ADR(ErrorText),ADR(ValueString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(' not in ['),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(LowString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR('..'),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(UpString),ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(ErrorText),ADR(']'),ADVIECCHK_MAX_STRING_LEN);
        MakeEntry(55555,value,ErrorText);
    ELSE
        CheckUnsignedSubrange := value;
    END_IF
    
    #if defined(_CHECKLIB_KEEP_INDEX_VALUES)
    // Don't modify accessed value
    // This may lead to undefined behavior!
    CheckUnsignedSubrange := value;
    #endif
    
END_FUNCTION

(* Called before (read) accessing a memory address using a dynamic variable (ADR). Returns the input address *)
// Note: We cannot substitute in any addresses here
// This always returns a zero address
// That means a pagefault will occur no matter what, but at least we can log why
FUNCTION CheckReadAccess
    
    IF address=0 THEN
        MakeEntry(55555,address,'Read from zero ADR');
        CheckReadAccess:=0;
    ELSE
        CheckReadAccess:=address;
    END_IF
    
END_FUNCTION

(* Called before (write) accessing a memory address using a dynamic variable (ADR). Returns the input address *)
// Note: We cannot substitute in any addresses here
// This always returns a zero address
// That means a pagefault will occur no matter what, but at least we can log why
FUNCTION CheckWriteAccess
    
    IF address=0 THEN
        MakeEntry(55555,address,'Write zero ADR'); 
        CheckWriteAccess:=0;
    ELSE
        CheckWriteAccess:=address;
    END_IF
    
END_FUNCTION

(* Creates a Logger entry detailing any errors. Returns a pointer to out_text *)
FUNCTION MakeEntry
    
    // Check inputs
    IF (number < ERRXWARNING_MIN_ERRNR) OR (number > ERRXWARNING_MAX_ERRNR) THEN
        MakeEntry := 0;
        RETURN;
    END_IF;
    
    // Get task name and add to error text string
    status_name := ST_name(0,ADR(taskname),ADR(group));
    
    StrCatToMaxLen(ADR(out_text),ADR(text), ADVIECCHK_MAX_STRING_LEN); // Errxwarning() errorstring max 32 characters! See AS Help
    StrCatToMaxLen(ADR(out_text),ADR(' > task '), ADVIECCHK_MAX_STRING_LEN);
    
    IF status_name = 0 THEN
        StrCatToMaxLen(ADR(out_text),ADR('"'), ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(out_text),ADR(taskname), ADVIECCHK_MAX_STRING_LEN);
        StrCatToMaxLen(ADR(out_text),ADR('"'), ADVIECCHK_MAX_STRING_LEN);
    ELSE
        StrCatToMaxLen(ADR(out_text),ADR('UNKNOWN'), ADVIECCHK_MAX_STRING_LEN);
    END_IF;
    
    // Finalize logbook entry
    MakeEntry := brsstrlen(ADR(out_text));	
    ERRxwarning(number,index,ADR(out_text)); // Causes log entry, but not Service Mode
    
    // The sys_lib logging functions are mostly replaced with the ArEventLog library, but are still available
    // as of AS 6.1. I like the idea of replacing these to be more future-proof, but the single function call
    // with no setup required (i.e. logbook creation) makes a lot more sense for this library.
    
    #if defined(_CHECKLIB_FORCE_RESTART)
    brsmemcpy(1,1,1); // Create a pagefault on purpose to get the backtrace data
    #endif
	
END_FUNCTION

(* Concatenates two strings, but keeps the result under the max allowed length.
Also ensures the the string ends in a zero (null).
Returns the length of the new string *)
FUNCTION StrCatToMaxLen
    
    IF (pDest = 0) OR (pSrc = 0) OR (MaxLength = 0) THEN
        StrCatToMaxLen := 0;
        RETURN;
    END_IF;
    
    destLen := brsstrlen(pDest);
    srcLen := brsstrlen(pSrc);
    
    lenToCopy := MIN(srcLen,(MaxLength - destLen)); // Copy the full src string if possible, otherwise copy a partial string
    brsmemcpy(pDest + destLen, pSrc, lenToCopy);
    brsmemset(pDest + destLen + lenToCopy, 0, 1); // Ensure trailing null character
    StrCatToMaxLen := destLen + lenToCopy;

END_FUNCTION
