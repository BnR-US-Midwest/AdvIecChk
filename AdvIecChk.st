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
        CheckBounds := lower;
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(index, ADR(IndexString));
        brsstrcpy(ADR(ErrorText),ADR('Array Index '));
        brsstrcat(ADR(ErrorText),ADR(IndexString));
        brsstrcat(ADR(ErrorText),ADR(' is outside ['));
        brsstrcat(ADR(ErrorText),ADR(LowString));
        brsstrcat(ADR(ErrorText),ADR('..'));
        brsstrcat(ADR(ErrorText),ADR(UpString));
        brsstrcat(ADR(ErrorText),ADR(']'));
        MakeEntry(55555,index,ErrorText);
    ELSIF index > upper THEN
        CheckBounds := upper;
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(index, ADR(IndexString));
        brsstrcpy(ADR(ErrorText),ADR('Array Index '));
        brsstrcat(ADR(ErrorText),ADR(IndexString));
        brsstrcat(ADR(ErrorText),ADR(' is outside ['));
        brsstrcat(ADR(ErrorText),ADR(LowString));
        brsstrcat(ADR(ErrorText),ADR('..'));
        brsstrcat(ADR(ErrorText),ADR(UpString));
        brsstrcat(ADR(ErrorText),ADR(']'));
        MakeEntry(55555,index,ErrorText);
    ELSE
        CheckBounds := index;
    END_IF
END_FUNCTION

(* Called before write accessing an enumeration variable. Returns the value if no errors are found.
Otherwise, returns the problematic value bound *)
FUNCTION CheckRange
    IF value < lower THEN
        CheckRange := lower;
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Enum Value '));
        brsstrcat(ADR(ErrorText),ADR(ValueString));
        brsstrcat(ADR(ErrorText),ADR(' is outside ['));
        brsstrcat(ADR(ErrorText),ADR(LowString));
        brsstrcat(ADR(ErrorText),ADR('..'));
        brsstrcat(ADR(ErrorText),ADR(UpString));
        brsstrcat(ADR(ErrorText),ADR(']'));
        MakeEntry(55555,value,ErrorText);	
    ELSIF value > upper THEN
        CheckRange := upper;
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Enum Value '));
        brsstrcat(ADR(ErrorText),ADR(ValueString));
        brsstrcat(ADR(ErrorText),ADR(' is outside ['));
        brsstrcat(ADR(ErrorText),ADR(LowString));
        brsstrcat(ADR(ErrorText),ADR('..'));
        brsstrcat(ADR(ErrorText),ADR(UpString));
        brsstrcat(ADR(ErrorText),ADR(']'));
        MakeEntry(55555,value,ErrorText);
    ELSE
        CheckRange := value;
    END_IF
END_FUNCTION

(* Called before write access to a variable with the data type "Subrange" if the subrange is used on a signed data type. Returns the value if no errors are found.
Otherwise, returns the problematic value bound *)
FUNCTION CheckSignedSubrange
    IF value < lower THEN
        CheckSignedSubrange := lower;
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Signed Subrange Index '));
        brsstrcat(ADR(ErrorText),ADR(ValueString));
        brsstrcat(ADR(ErrorText),ADR(' is outside ['));
        brsstrcat(ADR(ErrorText),ADR(LowString));
        brsstrcat(ADR(ErrorText),ADR('..'));
        brsstrcat(ADR(ErrorText),ADR(UpString));
        brsstrcat(ADR(ErrorText),ADR(']'));
        MakeEntry(55555,value,ErrorText);	
    ELSIF value > upper THEN
        CheckSignedSubrange := upper;		
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Signed Subrange Index '));
        brsstrcat(ADR(ErrorText),ADR(ValueString));
        brsstrcat(ADR(ErrorText),ADR(' is outside ['));
        brsstrcat(ADR(ErrorText),ADR(LowString));
        brsstrcat(ADR(ErrorText),ADR('..'));
        brsstrcat(ADR(ErrorText),ADR(UpString));
        brsstrcat(ADR(ErrorText),ADR(']'));
        MakeEntry(55555,value,ErrorText);
    ELSE
        CheckSignedSubrange := value;
    END_IF
END_FUNCTION

(* Called before write access to a variable with the data type "Subrange" if the subrange is used on an unsigned data type. Returns the value if no errors are found.
Otherwise, returns the problematic value bound *)
FUNCTION CheckUnsignedSubrange
    IF value < lower THEN
        CheckUnsignedSubrange := lower;
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Unsigned Subrange Index '));
        brsstrcat(ADR(ErrorText),ADR(ValueString));
        brsstrcat(ADR(ErrorText),ADR(' is outside ['));
        brsstrcat(ADR(ErrorText),ADR(LowString));
        brsstrcat(ADR(ErrorText),ADR('..'));
        brsstrcat(ADR(ErrorText),ADR(UpString));
        brsstrcat(ADR(ErrorText),ADR(']'));
        MakeEntry(55555,value,ErrorText);	
    ELSIF value > upper THEN
        CheckUnsignedSubrange := upper;
		
        brsitoa(lower, ADR(LowString));
        brsitoa(upper, ADR(UpString));
        brsitoa(value, ADR(ValueString));
        brsstrcpy(ADR(ErrorText),ADR('Unsigned Subrange Index '));
        brsstrcat(ADR(ErrorText),ADR(ValueString));
        brsstrcat(ADR(ErrorText),ADR(' is outside ['));
        brsstrcat(ADR(ErrorText),ADR(LowString));
        brsstrcat(ADR(ErrorText),ADR('..'));
        brsstrcat(ADR(ErrorText),ADR(UpString));
        brsstrcat(ADR(ErrorText),ADR(']'));
        MakeEntry(55555,value,ErrorText);
    ELSE
        CheckUnsignedSubrange := value;
    END_IF
END_FUNCTION

(* Called before (read) accessing a memory address using a dynamic variable (ADR). Always returns 0 *)
FUNCTION CheckReadAccess
    IF address=0 THEN
        MakeEntry(55555,address,'Try to read from ADR of zero');
    END_IF

    CheckReadAccess:=0;
END_FUNCTION

(* Called before (write) accessing a memory address using a dynamic variable (ADR). Always returns 0 *)
FUNCTION CheckWriteAccess
    IF address=0 THEN
        MakeEntry(55555,address,'Try to write to ADR of zero');
    END_IF

    CheckWriteAccess:=0;
END_FUNCTION

(* Creates a Logger entry detailing any errors. Returns a pointer to out_text *)
FUNCTION MakeEntry
    status_name := ST_name(0,ADR(taskname),ADR(group));
    
    StrCatToMaxLen(ADR(out_text),ADR(text), 32); // Errxwarning() errorstring max 32 characters! See AS Help
    StrCatToMaxLen(ADR(out_text),ADR(' > task '), 32);
    
    IF status_name = 0 THEN
        StrCatToMaxLen(ADR(out_text),ADR('"'), 32);
        StrCatToMaxLen(ADR(out_text),ADR(taskname), 32);
        StrCatToMaxLen(ADR(out_text),ADR('"'), 32);
    ELSE
        StrCatToMaxLen(ADR(out_text),ADR('UNKNOWN'), 32);
    END_IF;
    
    MakeEntry := ADR(out_text);	
    ERRxwarning(number,index,ADR(out_text)); // Causes log entry, but not Service Mode
    
    // The sys_lib logging functions are mostly replaced with the ArEventLog library, but are still available
    // as of AS 6.1. I like the idea of replacing these to be more future-proof, but the single function call
    // with no setup required (i.e. logbook creation) makes a lot more sense for this library.
    
    #if defined(_CHECKLIB_FORCE_RESTART)
    brsmemcpy(1,1,1); // Create a pagefault on purpose to get the backtrace data
    #endif
	
END_FUNCTION

(* Concatenates two strings, but keeps the result under the max allowed length.
Returns the length of the new string *)
FUNCTION StrCatToMaxLen
    
    destLen := brsstrlen(pDest);
    srcLen := brsstrlen(pSrc);
    StrCatToMaxLen := destLen;
    
    IF (destLen >= MaxLength) OR ((srcLen + destLen) > MaxLength) THEN
        RETURN;
    END_IF;
    
    brsstrcat(pDest, pSrc);
    StrCatToMaxLen := destLen + srcLen;

END_FUNCTION
