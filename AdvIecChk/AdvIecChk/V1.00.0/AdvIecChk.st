(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: IecCheck
 * Author: adamsm
 * Created: August 20, 2012
 ********************************************************************
 * Implementation of library IecCheck
 ********************************************************************)

(* Check divisor for DINT and UDINT division *)
FUNCTION CheckDivDWord
	IF divisor=0 THEN
		CheckDivDWord:=1;
		MakeEntry(55555,divisor,'Divide by Zero - Double Word');
	ELSE
		CheckDivDWord:=divisor;
	END_IF
END_FUNCTION

(* Check divisor for INT and UINT division *)
FUNCTION CheckDivWord
	IF divisor=0 THEN
		CheckDivWord:=1;
		MakeEntry(55555,divisor,'Divide by Zero - Word');
	ELSE
		CheckDivWord:=divisor;
	END_IF
END_FUNCTION

(* Check divisor for SINT and USINT division *)
FUNCTION CheckDivByte
	IF divisor=0 THEN
		CheckDivByte:=1;
		MakeEntry(55555,divisor,'Divide by Zero - Byte');
	ELSE
		CheckDivByte:=divisor;
	END_IF
END_FUNCTION

(* Check divisor for REAL division *)
FUNCTION CheckDivReal
	IF divisor=0 THEN
		CheckDivReal:=1;
		MakeEntry(55555,0,'Divide by Zero - Real');
	ELSE
		CheckDivReal:=divisor;
	END_IF
END_FUNCTION

(* Check divisor for LREAL division *)
FUNCTION CheckDivLReal
	IF divisor=0 THEN
		CheckDivLReal:=1;
		MakeEntry(55555,0,'Divide by Zero - Long Real');
	ELSE
		CheckDivLReal:=divisor;
	END_IF
END_FUNCTION

(* Check range for enumeration *)
FUNCTION CheckRange
	IF value < lower THEN
		CheckRange := lower;
		MakeEntry(55555,value,'ENUM-Check Low');
	ELSIF value > upper THEN
		CheckRange := upper;
		MakeEntry(55555,value,'ENUM-Check High');
	ELSE
		CheckRange := value;
	END_IF
END_FUNCTION

(* Check range for subrange of signed data types *)
FUNCTION CheckSignedSubrange
	IF value < lower THEN
		CheckSignedSubrange := lower;
		MakeEntry(55555,value,'CheckSignedSubrange Low');
	ELSIF value > upper THEN
		CheckSignedSubrange := upper;
		MakeEntry(55555,value,'CheckSignedSubrange High');
	ELSE
		CheckSignedSubrange := value;
	END_IF
END_FUNCTION

(* Check range for subrange of unsigned data types *)
FUNCTION CheckUnsignedSubrange
	IF value < lower THEN
		CheckUnsignedSubrange := lower;
		MakeEntry(55555,value,'CheckUnsignedSubrange Low');
	ELSIF value > upper THEN
		CheckUnsignedSubrange := upper;
		MakeEntry(55555,value,'CheckUnsignedSubrange High');
	ELSE
		CheckUnsignedSubrange := value;
	END_IF
END_FUNCTION

(* Check address when reading dynamic variables *)
FUNCTION CheckReadAccess
	IF address=0 THEN
		(* TODO: Insert an appropriate code, see AutomationStudio help for further information *)
		MakeEntry(55555,address,'Attempt to read from address of zero / NULL');
	END_IF

	CheckReadAccess:=0;
END_FUNCTION

(* Check address when writing dynamic variables *)
FUNCTION CheckWriteAccess
	IF address=0 THEN
		(* TODO: Insert an appropriate code, see AutomationStudio help for further information *)
		MakeEntry(55555,address,'Attempt to write to address of zero / NULL');
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
	ELSE
		CheckBounds := index;
	END_IF
END_FUNCTION

FUNCTION MakeEntry (* Makes a log book entry *)
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
	ERRxfatal(number,index,ADR(out_text));	
END_FUNCTION
