unit cls_id;
(** ////////////////////////////////////////////////////////////////////// **)
(**(c) NPS, 1997 	- Idea, realisation, adoptation IsCPUID_Available) **)
(**                       kvk@estpak.ee                                    **)
(**(c) Alex Abreu, 1997 - IsCPUID_Available source and idea                **)
(**                       simonet@bhnet.com.br                             **)
(**Gordon Bamber,June1998 Converted into a class                           **)
(**                       gbamber@mistral.co.uk                            **)
(** ///////////////////////////////////////////////////////////////////////**)

interface

const
 ID_BIT=$200000; (** EFLAGS ID bit **)
type
 TCPUIDARRAY=array[1..4] of Longint;
 TVendor=array [0..11] of char;
Type TCPUID=Class(TOBJECT)
Private
 fIDAvailable:Boolean;
 fId1:LongInt;
 fId2:LongInt;
 fId3:LongInt;
 fId4:LongInt;
 fProcessorType:LongInt;
 fFamily:LongInt;
 fModel:LongInt;
 fStepping:LongInt;
 fVendor:TVendor;
 fsVendor:String;
 Function GetIDInfo:Boolean;
Public
  Constructor Create;
  Property IDAvailable:Boolean read fIDAvailable;
  Property ID1:LongInt read fID1;
  Property ID2:LongInt read fID2;
  Property ID3:LongInt read fID3;
  Property ID4:LongInt read fID4;
  Property ProcessorType:LongInt read fProcessorType;
  Property Family:LongInt read fFamily;
  Property Model:LongInt read fModel;
  Property Stepping:LongInt read fStepping;
  Property Vendor:String read fsVendor;
end;

(** These functions cannot be members of the class **)
function IsCPUID_Available : Boolean;register;
function GetCPUID : TCPUIDARRAY;register;
function GetCPUVendor : TVendor;register;

implementation
(******************************************************************************)

Constructor TCPUID.Create;
begin
Inherited Create;
fProcessorType:=0;
fFamily:=0;
fModel:=0;
fStepping:=0;
fsVendor:='unknown';
if GetIDInfo then fIDAvailable:=True else fIDAvailable:=False;
end;

(******************************************************************************)

Function TCPUID.GetIDInfo:Boolean;
var
  I     : Integer;
  CPUIDARRAY:TCPUIDARRAY;
begin
Result:=False;
for I := Low(CPUIDARRAY) to High(CPUIDARRAY)  do CPUIDARRAY[I] := -1;
if IsCPUID_Available then
 begin
  CPUIDARRAY:=GetCPUID;

  fID1:=CPUIDARRAY[1];
  fID2:=CPUIDARRAY[2];
  fID3:=CPUIDARRAY[3];
  fID4:=CPUIDARRAY[4];

  fProcessorType:=(CPUIDARRAY[1] shr 12 and 3);
  fFamily:=(CPUIDARRAY[1] shr 8 and $f);
  fModel:=(CPUIDARRAY[1] shr 4 and $f);
  fStepping:=(CPUIDARRAY[1] and $f);
  fVendor := GetCPUVendor;
  fsVendor:=String(fVendor);
  Result:=True;
 end;
end;

(******************************************************************************)

function IsCPUID_Available : Boolean;assembler;register;
asm
  PUSHFD							{direct access to flags no possible, only via stack}
  POP     EAX					{flags to EAX}
  MOV     EDX,EAX			{save current flags}
  XOR     EAX,ID_BIT	{not ID bit}
  PUSH    EAX					{onto stack}
  POPFD								{from stack to flags, with not ID bit}
  PUSHFD							{back to stack}
  POP     EAX					{get back to EAX}
  XOR     EAX,EDX			{check if ID bit affected}
  JZ      @exit				{no, CPUID not availavle}
  MOV     AL,True			{Result=True}
@exit:
end;

(******************************************************************************)

function GetCPUID : TCPUIDARRAY; assembler;register;
asm
  PUSH    EBX         {Save affected register}
  PUSH    EDI
  MOV     EDI,EAX     {@Resukt}
  MOV     EAX,1
  DW      $A20F       {CPUID Command}
  STOSD			          {CPUID[1]}
  MOV     EAX,EBX
  STOSD               {CPUID[2]}
  MOV     EAX,ECX
  STOSD               {CPUID[3]}
  MOV     EAX,EDX
  STOSD               {CPUID[4]}
  POP     EDI					{Restore registers}
  POP     EBX
end;

(******************************************************************************)

function GetCPUVendor : TVendor; assembler;register;
asm
  PUSH    EBX					{Save affected register}
  PUSH    EDI
  MOV     EDI,EAX			{@Result (TVendor)}
  MOV     EAX,0
  DW      $A20F				{CPUID Command}
  MOV     EAX,EBX
  XCHG		EBX,ECX     {save ECX result}
  MOV			ECX,4
@1:
  STOSB
  SHR     EAX,8
  LOOP    @1
  MOV     EAX,EDX
  MOV			ECX,4
@2:
  STOSB
  SHR     EAX,8
  LOOP    @2
  MOV     EAX,EBX
  MOV			ECX,4
@3:
  STOSB
  SHR     EAX,8
  LOOP    @3
  POP     EDI					{Restore registers}
  POP     EBX
end;

(******************************************************************************)
(******************************************************************************)

end.
