unit uWinHardwareInfo;

{
  Получение описания компьютера (процессор, память, диск C, серийник материнки) одной строкой
  Работает на Win32/Win64 под правами обычного пользователя.
  © OpenAI ChatGPT 2024
}

interface

uses
  SysUtils;

function GetWindowsHardwareSummary: string;

// По отдельности:
function GetProcessorInfo: string;
function GetMemoryInfo: string;
function GetSystemHDDInfo: string;
function GetMotherboardSerial: string;

implementation

uses
  Windows, Classes, ActiveX, ComObj, Variants;

function GetWMIProperty(const WMIClass, PropertyName: string): string;
var
  SWbemLocator, SWbemServices, SWbemObjectSet, SWbemObject: OLEVariant;
begin
  Result := '';
  try
    SWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    SWbemServices := SWbemLocator.ConnectServer('.', 'root\CIMV2', '', '');
    SWbemObjectSet := SWbemServices.ExecQuery('SELECT ' + PropertyName + ' FROM ' + WMIClass);
    if SWbemObjectSet.Count > 0 then
    begin
      SWbemObject := SWbemObjectSet.ItemIndex(0);
      Result := StringReplace(VarToStr(SWbemObject.Properties_.Item(PropertyName).Value), ' ', '', [rfReplaceAll]);
    end;
  except
    // Вернёт пустую строку при любой ошибке
  end;
end;

function GetProcessorInfo: string;
begin
  Result := Trim(GetWMIProperty('Win32_Processor', 'Name'));
end;

function GetMemoryInfo: string;
var
  MemoryStr: string;
  MemoryGB: Double;
begin
  MemoryStr := GetWMIProperty('Win32_ComputerSystem', 'TotalPhysicalMemory');
  if TryStrToFloat(MemoryStr, MemoryGB) then
    Result := Format('%.2fGB', [MemoryGB / 1024 / 1024 / 1024])
  else
    Result := '';
end;

function GetSystemHDDInfo: string;
var
  Value: string;
  DiskSize: Double;
begin
  Value := GetWMIProperty('Win32_LogicalDisk WHERE DeviceID="C:"', 'Size');
  if TryStrToFloat(Value, DiskSize) then
    Result := Format('%.2fGB', [DiskSize / 1024 / 1024 / 1024])
  else
    Result := '';
end;

function GetMotherboardSerial: string;
begin
  Result := Trim(GetWMIProperty('Win32_BaseBoard', 'SerialNumber'));
end;

function GetWindowsHardwareSummary: string;
begin
  Result := Format('CPU:%s;RAM:%s;HDD_C:%s;MB_SN:%s',
    [GetProcessorInfo, GetMemoryInfo, GetSystemHDDInfo, GetMotherboardSerial]);
end;

end.