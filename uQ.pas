unit uQ;

interface
uses
  System.SysUtils, System.Types, REGISTRY;

procedure Code(var text: string; password: string;
  decode: boolean);

function StrToHex(const source: string): string;
function HexToStr(const source: string): string;
function LoadReestr(pKey:string) : string;
procedure SaveReestr(pKey:string; pValue: string);



implementation

//var
//  s: string;

procedure Code(var text: string; password: string;
  decode: boolean);
var
  i, PasswordLength: integer;
  sign: shortint;
begin
  PasswordLength := length(password);
  if PasswordLength = 0 then Exit;
  if decode
    then sign := -1
    else sign := 1;
  for i := 1 to Length(text) do
    text[i] := chr(ord(text[i]) + sign *
      ord(password[i mod PasswordLength + 1]));
end;


function StrToHex(const source: string): string;
var
  StrAsBytes:TBytes;
  i:cardinal;
begin
  StrAsBytes := TEncoding.UTF8.GetBytes(source);
  for i := 0 to length(StrAsBytes) - 1 do result:=result+IntToHex(StrAsBytes[i], 2);
end;


function HexToStr(const source: string): string;
var
  i, idx:Cardinal;
  StrAsBytes:TBytes;
begin
  SetLength(StrAsBytes, length(source) div 2);
  i:=1;
  idx:=0;
  while i <= length(source) do
  begin
    StrAsBytes[idx]:=StrToInt('$'+source[i]+source[i+1]);
    i:=i+2;
    idx:=idx+1;
  end;
  result:=TEncoding.UTF8.GetString(StrAsBytes);
end;


{ пример вызова

procedure TfMain.ButtonQClick(Sender: TObject);
var
  vText : string;
begin
  vText := 'проба пера';
  Code(vText, 'qwedfnkj123', true);
  showmessage(vText);
  Code(vText, 'qwedfnkj123', false);
  showmessage(vText);

  vText := StrToHex(vText);
  showmessage(vText);
  vText := HexToStr(vText);
  showmessage(vText);

end;
}

procedure SaveReestr(pKey:string; pValue: string);
// Сохранение в реестре
var
   Registry: TRegistry;
begin
   { создаём объект TRegistry }
   Registry := TRegistry.Create;

   { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
//   Registry.RootKey := hkey_current_user;

   { открываем и создаём ключ }
   Registry.OpenKey('software\AssistIQ',true);

   { записываем значение }
   Registry.WriteString(pKey, pValue);
//   Registry.WriteDate('date', DateTimePickerDate.Date);
//   Registry.WriteString('INValue', DBLookupComboboxEhIN.KeyValue);

   { закрываем и освобождаем ключ }
   Registry.CloseKey;
   Registry.Free;
end;

//procedure LoadReestr(pKey:string; pValue: string);
function LoadReestr(pKey:string) : string;
// Чтение из реестра
var
   Registry: TRegistry;
begin
   { создаём объект TRegistry }
   Registry := TRegistry.Create;

   { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
//   Registry.RootKey := hkey_current_user;

   { открываем и создаём ключ }
   Registry.OpenKey('software\AssistIQ',true);

   { записываем значение }
   result := Registry.ReadString(pKey);
   //Registry.ReadString('editValue');
   //DateTimePickerDate.Date := Registry.ReadDate('date');
   //DBLookupComboboxEhIN.KeyValue := Registry.ReadString('INValue');


   { закрываем и освобождаем ключ }
   Registry.CloseKey;
   Registry.Free;
end;

end.
