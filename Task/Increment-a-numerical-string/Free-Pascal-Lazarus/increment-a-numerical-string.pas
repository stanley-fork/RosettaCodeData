program StrInc;
//increments a positive numerical string in different bases.
//the string must be preset with a value, length >0 ;
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$IFDEF FPC}
  {$Mode Delphi} {$Optimization ON,ALL}{$Align 32}
  uses
    sysutils;
{$ELSE}
  uses
    system.SysUtils;
{$ENDIF}
type
  tMyNumString = Ansistring; //string[31];//

function IncLoop(ps: pChar;le,Base: NativeInt):NativeInt;inline;
//Add 1 and correct carry
//returns 0, if no overflow, else 1
var
  dgt: nativeInt;
Begin
  //convert base to the highest char in base  2 > '1' ;10 -> '9'
  base += Ord('0')-1;
  dec(le);//ps is 0-based

  result := 0;
  repeat
    dgt := ord(ps[le]);
    IF dgt < base then
    begin
      ps[le] := chr(dgt+1);
      EXIT;
    end;
    ps[le] := '0';
    dec(le);
  until (le<0);
  result:= 1;
end;

procedure IncIntStr(base:NativeInt;var s:tMyNumString);
var
  le: NativeInt;
begin
  le := length(s);
  //overflow -> prepend a '1' to string
  if (IncLoop(pChar(@s[1]),le,base) <>0) then
  Begin
//    s := '1'+s;
    setlength(s,le+1);
    move(s[1],s[2],le);
    s[1] := '1';
  end;
end;

procedure IncMyString(var NumString: tMyNumString);
var
	i: integer;
	f_code: word;
begin
  // string to num
  val(Numstring,i,f_code);
  //num to string
  if f_code= 0 then
    str(i+1,NumString);
end;

procedure IncMyStringOrg(var NumString: tMyNumString);
var
  i: integer;
begin
  readStr(NumString, i);
  writeStr(NumString, succ(i));
end;

const
  strLen = 26;
  MAX = 1 shl strLen -1;

var
  s  : tMyNumString;
  i,base : nativeInt;
  T0: TDateTime;
Begin
  writeln(MAX,' increments in base');
  For base := 2 to 10 do
  Begin
    //s := '0' doesn't work
    setlength(s,1);
    s[1]:= '0';
{   //Zero pad string
    setlength(s,strLen);fillchar(s[1],strLen,'0');
}
    T0 := time;
    For i := 1 to MAX do
      IncIntStr(Base,s);
    T0 := (time-T0)*86400;
    if base = 10 then
      writeln(' IncAnsiString '); ;
    writeln(s:strLen,' base ',base:2,T0:8:3,' s');
  end;

  writeln(' val -> str ');
  setlength(s,1);
  s[1]:= '0';
  T0 := time;
  For i := 1 to MAX do
    IncMyString(s);
  T0 := (time-T0)*86400;
  writeln(s:strLen,' base ',10:2,T0:8:3,' s');

  writeln(' readstr -> writestring ');
  setlength(s,1);
  s[1]:= '0';
  T0 := time;
  For i := 1 to MAX do
    IncMyStringOrg(s);
  T0 := (time-T0)*86400;
  writeln(s:strLen,' base ',10:2,T0:8:3,' s');

  s:='';
 {$IFDEF WINDOWS}
    readln;
  {$ENDIF}
end.
