(************************************************************************************

Advanced IEC Check Functions Library

File: AdvIecChk.st
Description: Implentation of library functions
Authors:
    - Matt Adams (B&R Industrial Automation)
    - Varad Darji (B&R Industrial Automation)
    - Marcus Mangel (B&R Industrial Automation)

************************************************************************************)

(* Check divisor for DINT and UDINT division *)
FUNCTION CheckDivDWord
	IF divisor=0 THEN
		CheckDivDWord:=1;
		MakeEntry(55555,divisor,'Divide by Zero - Double Word');
	
		//Note: DarjiV, creating a pagefault on purpose to get the backtrace data
		//				This function does not provide consistant back
		memcpy(1,1,1);

	ELSE
		CheckDivDWord:=divisor;
	END_IF
END_FUNCTION

(* Check divisor for INT and UINT division *)
FUNCTION CheckDivWord
	IF divisor=0 THEN
		CheckDivWord:=1;
		MakeEntry(55555,divisor,'Divide by Zero - Word');
		
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	ELSE
		CheckDivWord:=divisor;
	END_IF
END_FUNCTION

(* Check divisor for SINT and USINT division *)
FUNCTION CheckDivByte
	IF divisor=0 THEN
		CheckDivByte:=1;
		MakeEntry(55555,divisor,'Divide by Zero - Byte');
		
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	ELSE
		CheckDivByte:=divisor;
	END_IF
END_FUNCTION

(* Check divisor for REAL division *)
FUNCTION CheckDivReal
	IF divisor=0 THEN
		CheckDivReal:=1;
		MakeEntry(55555,0,'Divide by Zero - Real');
		
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	ELSE
		CheckDivReal:=divisor;
	END_IF
END_FUNCTION

(* Check divisor for LREAL division *)
FUNCTION CheckDivLReal
	IF divisor=0 THEN
		CheckDivLReal:=1;
		MakeEntry(55555,0,'Divide by Zero - Long Real');
		
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	ELSE
		CheckDivLReal:=divisor;
	END_IF
END_FUNCTION

(* Check range for enumeration *)
FUNCTION CheckRange
	IF value < lower THEN
		CheckRange := lower;
		
		itoa(lower, ADR(LowString));
		itoa(upper, ADR(UpString));
		itoa(value, ADR(IndexString));
		strcpy(ADR(text),ADR('ENUM-Check Low. Value '));
		strcat(ADR(text),ADR(IndexString));
		strcat(ADR(text),ADR(' is outside ['));
		strcat(ADR(text),ADR(LowString));
		strcat(ADR(text),ADR('..'));
		strcat(ADR(text),ADR(UpString));
		strcat(ADR(text),ADR(']'));
		MakeEntry(55555,value,text);
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
		
	ELSIF value > upper THEN
		CheckRange := upper;
		
		itoa(lower, ADR(LowString));
		itoa(upper, ADR(UpString));
		itoa(value, ADR(IndexString));
		strcpy(ADR(text),ADR('ENUM-Check High. Value '));
		strcat(ADR(text),ADR(IndexString));
		strcat(ADR(text),ADR(' is outside ['));
		strcat(ADR(text),ADR(LowString));
		strcat(ADR(text),ADR('..'));
		strcat(ADR(text),ADR(UpString));
		strcat(ADR(text),ADR(']'));
		MakeEntry(55555,value,text);
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	ELSE
		CheckRange := value;
	END_IF
END_FUNCTION

(* Check range for subrange of signed data types *)
FUNCTION CheckSignedSubrange
	IF value < lower THEN
		CheckSignedSubrange := lower;
		
		itoa(lower, ADR(LowString));
		itoa(upper, ADR(UpString));
		itoa(value, ADR(IndexString));
		strcpy(ADR(text),ADR('Signed Subrange Index '));
		strcat(ADR(text),ADR(IndexString));
		strcat(ADR(text),ADR(' is outside ['));
		strcat(ADR(text),ADR(LowString));
		strcat(ADR(text),ADR('..'));
		strcat(ADR(text),ADR(UpString));
		strcat(ADR(text),ADR(']'));
		MakeEntry(55555,value,text);		
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
		
	ELSIF value > upper THEN
		CheckSignedSubrange := upper;		
		
		itoa(lower, ADR(LowString));
		itoa(upper, ADR(UpString));
		itoa(value, ADR(IndexString));
		strcpy(ADR(text),ADR('Signed Subrange Index '));
		strcat(ADR(text),ADR(IndexString));
		strcat(ADR(text),ADR(' is outside ['));
		strcat(ADR(text),ADR(LowString));
		strcat(ADR(text),ADR('..'));
		strcat(ADR(text),ADR(UpString));
		strcat(ADR(text),ADR(']'));
		MakeEntry(55555,value,text);
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	ELSE
		CheckSignedSubrange := value;
	END_IF
END_FUNCTION

(* Check range for subrange of unsigned data types *)
FUNCTION CheckUnsignedSubrange
	IF value < lower THEN
		CheckUnsignedSubrange := lower;		
		
		itoa(lower, ADR(LowString));
		itoa(upper, ADR(UpString));
		itoa(value, ADR(IndexString));
		strcpy(ADR(text),ADR('Unsigned Subrange Index '));
		strcat(ADR(text),ADR(IndexString));
		strcat(ADR(text),ADR(' is outside ['));
		strcat(ADR(text),ADR(LowString));
		strcat(ADR(text),ADR('..'));
		strcat(ADR(text),ADR(UpString));
		strcat(ADR(text),ADR(']'));
		MakeEntry(55555,value,text);
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
		
	ELSIF value > upper THEN
		CheckUnsignedSubrange := upper;
		
		itoa(lower, ADR(LowString));
		itoa(upper, ADR(UpString));
		itoa(value, ADR(IndexString));
		strcpy(ADR(text),ADR('Unsigned Subrange Index '));
		strcat(ADR(text),ADR(IndexString));
		strcat(ADR(text),ADR(' is outside ['));
		strcat(ADR(text),ADR(LowString));
		strcat(ADR(text),ADR('..'));
		strcat(ADR(text),ADR(UpString));
		strcat(ADR(text),ADR(']'));
		MakeEntry(55555,value,text);
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	ELSE
		CheckUnsignedSubrange := value;
	END_IF
END_FUNCTION

(* Check address when reading dynamic variables *)
FUNCTION CheckReadAccess
	IF address=0 THEN
		(* TODO: Insert an appropriate code, see AutomationStudio help for further information *)
		MakeEntry(55555,address,'Attempt to read from address of zero / NULL');
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);

	END_IF

	CheckReadAccess:=0;
END_FUNCTION

(* Check address when writing dynamic variables *)
FUNCTION CheckWriteAccess
	IF address=0 THEN
		(* TODO: Insert an appropriate code, see AutomationStudio help for further information *)
		MakeEntry(55555,address,'Attempt to write to address of zero / NULL');
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	END_IF

	CheckWriteAccess:=0;
END_FUNCTION



FUNCTION CheckBounds (* Check range for array access *)
	IF index < lower OR index > upper THEN
		itoa(lower, ADR(LowString));
		itoa(upper, ADR(UpString));
		itoa(index, ADR(IndexString));
		CheckBounds := upper;
		strcpy(ADR(text),ADR('Array Index '));
		strcat(ADR(text),ADR(IndexString));
		strcat(ADR(text),ADR(' is outside ['));
		strcat(ADR(text),ADR(LowString));
		strcat(ADR(text),ADR('..'));
		strcat(ADR(text),ADR(UpString));
		strcat(ADR(text),ADR(']'));
		MakeEntry(55555,index,text);
		//creating a pagefault on purpose to get the backtrace data
		memcpy(1,1,1);
	ELSE
		CheckBounds := index;
	END_IF
END_FUNCTION

FUNCTION MakeEntry (* Makes a log book entry. Note that gIecChkSec must be a global DINT! *)
    status_name := ST_name(0,ADR(taskname),ADR(group));
    PV_xgetadr(ADR('gIecChkSec'), ADR(pv_adr), ADR(data_len));
    IF pv_adr > 0 AND data_len > 0 THEN
        memcpy(ADR(SectionData),pv_adr,data_len);
        itoa(SectionData,ADR(SectionString));
    END_IF
		
    strcpy(ADR(out_text),ADR(text));
    strcat(ADR(out_text),ADR(' in task "'));
    strcat(ADR(out_text),ADR(taskname));
    strcat(ADR(out_text),ADR('" Section:'));
    strcat(ADR(out_text),ADR(SectionString));
    MakeEntry := ADR(out_text);	
	
    // Making Logger entry & restarting
    ERRxwarning(number,index,ADR(out_text));	
    // Change Note DarjiV: Change ERRxfatel_FB to ERRxwarning_FB because to get additional data.
    // 						Because I want TO finish this function and go back TO whichever function started this function and cause a pagefault there to get backtrace to the CODE.
    //						Now the AdvanceIEC Check library will give a pagefault location in CODE & the values of those variable when the pagefault happened.
	
END_FUNCTION
