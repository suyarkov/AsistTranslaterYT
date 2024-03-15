unit uWork;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types, WinApi.Windows, generics.Collections,
  FMX.Platform, System.Threading, FireDAC.Comp.Client, System.RegularExpressions, FMX.Dialogs, uTypes, VCL.Graphics, FMX.Forms;

type
  TWork = class
  private
    FScenaries: TList<TDict>;
    Svc: IFMXClipboardService;
    FThread: ITask;
    FNextItem: integer;
    FDExe: TFDQuery;
    ATimer: TTimer;
    ItemHint: PWideChar;
    FProc: TProcedure;
    FConnection: TFDConnection;
    ThreadWork: TWork;
    LastScenarioID: integer;
    FIsMakeScreenShot: boolean;
    IsDestroy: boolean;
    FIDScenario: integer;
    FIDSheduler: integer;

    procedure AddScenarioFromDialog(IdScenario: integer);
    function FindCloseEx(h: hwnd; WinName: string): boolean;
    procedure FindEx(h: hwnd; WinName: string; ScenarioID: integer);
    procedure GoItemPos(HintText: string);
    procedure GoWaitWindow(HintText: string; OnWait: TOnWait);
    procedure OnWaitWindow(Sender: TObject);
    procedure PostKeyEx32(Key: Word; const shift: TShiftState; numClick: Word = 1);
    procedure MainNextStep(IsSuccess: boolean);
    procedure MakeScreenShot(AFileName: string);
    procedure InsertLog(Result: boolean);
    procedure MakeScreenShotError;

  public
    Stopping: boolean;
    FTimerEnabled: boolean;
    procedure Start(ANext: integer = 0);
    procedure Stop;
    property Scenaries: TList<TDict> read FScenaries write FScenaries;
    property Proc: TProcedure read FProc write FProc;
    property IsMakeScreenShot: boolean read FIsMakeScreenShot write FIsMakeScreenShot;
    property IDSheduler: integer read FIDSheduler write FIDSheduler;
    property IdScenario: integer read FIDScenario write FIDScenario;

    constructor Create(AConnection: TFDConnection);
  end;

implementation

procedure TWork.Stop;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Stopping := true;

      if ThreadWork <> nil then
        ThreadWork.Stop;

      if FThread <> nil then
      begin
        FThread.Cancel;
        FThread := nil;
      end;
    end);
end;

procedure TWork.Start(ANext: integer = 0);
var
  I, J: integer;

  tmpPos: string;
  s: string;
  aSS: TShiftState;
  Litter: Word;
  ThreadScenarioID: string;
  IsSuccess: boolean;
  MessageText: TStringList;
  FileSend: string;
  HintTmp: string;
  LastScenarioName: string;
  uClipBoard: IFMXClipboardService;
  ValueClipBoard: String;
  AParamName: string;
  ACondition: string;
  SqlText: string;
  res : string;
  numClick : word;
begin
  I := ANext;

  if (FIsMakeScreenShot) and (I <> 0) then
  begin
    sleep(1000);
    MakeScreenShotError;
    FIsMakeScreenShot := false;
  end;

  if FThread = nil then
    FThread := TTask.Create(nil);

  IsSuccess := true;

  if ThreadWork <> nil then
    IsSuccess := NOT ThreadWork.IsDestroy;

  while I <= FScenaries.Count - 1 do
    if Not Stopping then
    begin

      if ThreadWork <> nil then
        if ThreadWork.IsDestroy then
        begin
          IsSuccess := false;
          break;
        end;

      sleep(500);

      LastScenarioID := FScenaries[I].Parent;

      case FScenaries[I].Key of
        itemPos:
          begin
            GoItemPos(Copy(FScenaries[I].Value, pos('<sep>', FScenaries[I].Value) + 5));
          end;
        itemSleep:
          begin
            sleep(FScenaries[I].Value.ToInteger * 1000);
          end;
        itemClick:
          begin
            GoItemPos(Copy(FScenaries[I].Value, pos('<sep>', FScenaries[I].Value) + 5));
            sleep(500);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          end;
        itemScroll:
          begin
            mouse_event(MOUSEEVENTF_WHEEL, 0, 0, DWord(FScenaries[I].Value.ToInteger), 0);
          end;

        itemRightClick:
          begin
            GoItemPos(Copy(FScenaries[I].Value, pos('<sep>', FScenaries[I].Value) + 5));
            sleep(500);
            mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
          end;
        itemDoubleClick:
          begin
            GoItemPos(Copy(FScenaries[I].Value, pos('<sep>', FScenaries[I].Value) + 5));
            sleep(500);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          end;

        itemCtrlA:
          begin
            PostKeyEx32(Ord('A'), [ssctrl]);
          end;
        itemCtrlC:
          begin
            PostKeyEx32(Ord('C'), [ssctrl]);
          end;
        itemCtrlV:
          begin
            PostKeyEx32(Ord('V'), [ssctrl]);
          end;
        itemTab:
          begin
            PostKeyEx32(9, [ssctrl]);
          end;
        itemEnter:
          begin
            PostKeyEx32(13, [ssctrl]);
          end;
        itemText:
          begin
            Svc.SetClipboard(FScenaries[I].Value);
            PostKeyEx32(Ord('V'), [ssctrl]);
          end;
        itemHotKey:
          begin
            s := FScenaries[I].Value;

            case Copy(s, 1, 1).ToInteger of
              0:
                aSS := [ssAlt];
              1:
                aSS := [ssCtrl];
              2:
                aSS := [ssShift];
              3:
                aSS := [ssAlt, ssCtrl];
              4:
                aSS := [ssAlt, ssShift];
              5:
                aSS := [ssCtrl, ssShift];
            end;
            s := Copy(s, 3);
            if pos('+', s) <> 0 then
            begin
              Litter := Literals[Copy(s, 1, pos('+', s) - 1).ToInteger];
              numClick := Copy(s, pos('+', s) + 1).ToInteger;
            end
            else
            begin
              Litter := Literals[Copy(s, 1).ToInteger];
              numClick := 1;
            end;
            // вызов нажатия
            PostKeyEx32(Litter, aSS, numClick);
          end;
        itemWaitWindow:
          begin
            FNextItem := I + 1;
            GoWaitWindow(FScenaries[I].Value, OnWaitWindow);
            exit;
          end;
        itemStop:
          begin

            ThreadScenarioID := FScenaries[I].Value;

            FThread := TTask.Run(
              procedure
              var
                ADict: TDict;
                ThreadScenaries: TList<TDict>;
                ThreadFDExe: TFDQuery;

              begin
                ThreadScenaries := TList<TDict>.Create;

                ThreadFDExe := TFDQuery.Create(nil);
                ThreadFDExe.Connection := FConnection;

                ExeQ(ThreadFDExe, 'select id,value from scenario_item where id_scenario = ' + ThreadScenarioID + '  order by order_id ', tsActive);

                ThreadFDExe.First;

                while NOT ThreadFDExe.Eof do
                begin
                  ADict.Key := ThreadFDExe.FieldByName('id').AsInteger;
                  ADict.Value := ThreadFDExe.FieldByName('value').AsString;
                  ADict.Parent := LastScenarioID;

                  ThreadScenaries.Add(ADict);
                  ThreadFDExe.Next;
                end;

                ThreadFDExe.Free;

                if ThreadWork <> nil then
                  FreeAndNil(ThreadWork);

                ThreadWork := TWork.Create(FConnection);
                ThreadWork.Scenaries := ThreadScenaries;
                ThreadWork.IDSheduler := 0;
                ThreadWork.IdScenario := ThreadScenarioID.ToInteger();
                ThreadWork.Proc := MainNextStep;
                ThreadWork.FIsMakeScreenShot := true;
                ThreadWork.Start();

              end);
          end;
        itemScenario:
          begin
            FNextItem := I + 1;
            AddScenarioFromDialog(FScenaries[I].Value.ToInteger());
          end;
        itemStep:
          begin
            HintTmp := FScenaries[I].Value;

            AParamName := Copy(HintTmp, 1, pos('<sep>', HintTmp) - 1);
            Delete(HintTmp, 1, pos('<sep>', HintTmp) + 4);
            ACondition := Copy(HintTmp, 1, pos('<sep>', HintTmp) - 1);
            Delete(HintTmp, 1, pos('<sep>', HintTmp) + 4);

            ACondition := StringReplace(ACondition, '%s', 'value', [rfReplaceAll]);
            ACondition := StringReplace(ACondition, '%n', 'value', [rfReplaceAll]);
//            ACondition := StringReplace(ACondition, '%n', 'CAST(value as number)', [rfReplaceAll]);
            ACondition := StringReplace(ACondition, '''', '''''', [rfReplaceAll]);
//            SqlText := 'select count(1) as res from params where param_name = ' + AParamName + ' and ' + ACondition;
//            ExeQ(FDExe, Format('insert into log_global (timenow, id_scenario, block, value) values (DateTimeToStr(Now()), 0, HintTmp,''%s'')', [ AParamName]), tsExec);
            try
//              ExeQ(FDExe, 'insert into log_global(timenow, block) values(''' + DateTimeToStr(Now())+ ''',''' + ACondition +''')', tsExec);
//              ExeQ(FDExe, 'insert into log_global(timenow, block) values(''' + DateTimeToStr(Now())+ ''',''' + AParamName +''')', tsExec);
//              ExeQ(FDExe, Format('insert into log_global (value) values (''%s'')', [SqlText]), tsExec);
              ExeQ(FDExe, 'select count(1) as res from params where param_name = ''' + AParamName + ''' and ' + ACondition , tsActive);
              res :=  FDExe.FieldByName('res').AsString;
//              ExeQ(FDExe, 'insert into log_global(timenow, block) values(''' + DateTimeToStr(Now())+ ''','' результат = ' + res +''')', tsExec);

              if res = '1' then
              begin
//              ExeQ(FDExe, 'insert into log_global(block) values(''Ошибка обработки 1'')', tsExec);
                I := HintTmp.ToInteger();
//              ExeQ(FDExe, 'insert into log_global(block) values(''Ошибка обработки 2 I = ' + IntToStr(I)+ ''')', tsExec);
                continue;
//              ExeQ(FDExe, 'insert into log_global(block) values(''Ошибка обработки 3'')', tsExec);
              end;
            except
//              ExeQ(FDExe, 'insert into log_global(block) values(''Ошибка обработки'')', tsExec);
            end;
          end;
        itemScreenShot:
          begin
            CreateDirectory(PWideChar(ExtractFilePath(paramstr(0)) + '\SendFile'), 0);
            MakeScreenShot(ExtractFilePath(paramstr(0)) + '\SendFile\' + FScenaries[I].Value);
          end;
        itemSend:
          begin
            HintTmp := FScenaries[I].Value;

            FileSend := Copy(HintTmp, 1, pos('<sep>', HintTmp) - 1);
            Delete(HintTmp, 1, pos('<sep>', HintTmp) + 4);
            Delete(HintTmp, 1, pos('<sep>', HintTmp) + 4);

            MessageText := TStringList.Create;
            try
              ExeQ(FDExe, 'select name from scenaries where id = ' + LastScenarioID.ToString, tsActive);
              LastScenarioName := FDExe.FieldByName('name').AsString;

              MessageText.Append('Сценарий "' + LastScenarioName + '".');
              MessageText.Append(HintTmp);

              SendMessage('Обратите внимание', MessageText, FDExe, ExtractFilePath(paramstr(0)) + '\SendFile\' + FileSend);
            finally
              MessageText.Free;
            end;
          end;
        itemBuffer:
          begin
            HintTmp := FScenaries[I].Value;

            if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, uClipBoard) then
              ValueClipBoard := uClipBoard.GetClipboard.ToString;

            ExeQ(FDExe, Format('select 1 from params where  param_name = ''%s''', [FScenaries[I].Value]), tsActive);

            if FDExe.RecordCount = 0 then
              ExeQ(FDExe, Format('insert into params (param_name, value) values (''%s'',''%s'')', [FScenaries[I].Value, ValueClipBoard]), tsExec)
            else
              ExeQ(FDExe, Format('update params set value = ''%s'' where param_name = ''%s''', [ValueClipBoard, FScenaries[I].Value]), tsExec);
          end;
      end;

      Inc(I);
    end;

  if FThread <> nil then
  begin
    while (FScenaries[0].Key = itemStop) and (FThread.getStatus <> TTaskStatus.Completed) and ThreadWork.IsDestroy and NOT Stopping do
    begin
      sleep(100);
    end;
    FThread := nil;
  end;

  if ThreadWork <> nil then
  begin
    ThreadWork.FTimerEnabled := false;
    FreeAndNil(ThreadWork);
  end;

  TThread.Synchronize(nil,
    procedure
    begin
      if Not Stopping then
      begin
        InsertLog(IsSuccess);
        Proc(IsSuccess);
      end;
    end);
end;

procedure TWork.InsertLog(Result: boolean);
begin
  ExeQ(FDExe, Format('insert into log (id_log_scheduler,id_scenario,result,sys_date) values ((select MAX(id) from log_schedulers),%d,%d,current_timestamp) ', [FIDScenario, Result.ToInteger]), tsExec);
end;

procedure TWork.MakeScreenShotError;
var
  LastScenarioName: string;
  FileName: string;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      ExeQ(FDExe, 'select name from scenaries where id = ' + LastScenarioID.ToString, tsActive);
      LastScenarioName := FDExe.FieldByName('name').AsString;

      CreateDirectory(PWideChar(ExtractFilePath(paramstr(0)) + '\ErrorLogs'), 0);
      FileName := ExtractFilePath(paramstr(0)) + '\ErrorLogs\' + StringReplace(DateTimeToStr(Now()), ':', '_', [rfReplaceAll]) + ' ' + LastScenarioName;
      MakeScreenShot(FileName);
    end);

end;

procedure TWork.MakeScreenShot(AFileName: string);
var
  LastScenarioName: string;
  Bmp: VCL.Graphics.TBitMap;
begin
  TThread.Synchronize(nil,
    procedure
    begin

      Bmp := VCL.Graphics.TBitMap.Create;
      try
        Bmp.Width := Round(GetDeviceCaps(GetDC(0), HORZRES));
        Bmp.Height := Round(GetDeviceCaps(GetDC(0), VERTRES));
        BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, GetDC(0), 0, 0, SRCCOPY);
        Bmp.SaveToFile(AFileName + '.bmp');
      finally
        Bmp.Free;
      end;
    end);

end;

procedure TWork.MainNextStep(IsSuccess: boolean);
var
  LastScenarioName: string;
begin
  ExeQ(FDExe, 'select name from scenaries where id = ' + LastScenarioID.ToString, tsActive);
  LastScenarioName := FDExe.FieldByName('name').AsString;

  TTask.Run(
    procedure
    var
      SendText: TStringList;
    begin
      SendText := TStringList.Create;
      SendText.Append('<!DOCTYPE html><html>  <head></head><body>' + '<p  style="text-align:center"></p>');
      SendText.Append('<hr /><p style="text-align:center"><strong>' + 'В работе РОБОТА возникли ошибки!' + '</strong></p>');
      SendText.Append('<p style="text-align:center">' + 'При выполнении сценария "' + LastScenarioName + '" от ' + DateToStr(Now()) + ' возникли ошибки. Примите меры по решению проблемы.' + '</p>');
      // Текст сообщения
      try
        SendMessage('Ошибка работы RobotCash', SendText, FDExe);
      finally
        SendText.Free;
      end;

    end);
end;

procedure TWork.GoItemPos(HintText: string);
var
  tmpPoint: TPoint;
begin
  tmpPoint.X := Round(StrToInt(Copy(HintText, 1, pos('-', HintText) - 1)));
  tmpPoint.Y := Round(StrToInt(Copy(HintText, pos('-', HintText) + 1)));
  SetCursorPos(tmpPoint.X, tmpPoint.Y);
end;

procedure TWork.GoWaitWindow(HintText: string; OnWait: TOnWait);
begin
  ItemHint := PWideChar(HintText);

  FTimerEnabled := true;

  while FTimerEnabled do
  begin
    sleep(300);
    OnWait(nil);
  end;

end;

procedure TWork.AddScenarioFromDialog(IdScenario: integer);
var
  ADict: TDict;
  I: integer;
begin
  ExeQ(FDExe, 'select id,value from scenario_item where id_scenario = ' + IdScenario.ToString + '  order by order_id ;', tsActive);

  FDExe.First;
  I := 0;
  while NOT FDExe.Eof do
  begin
    ADict.Key := FDExe.FieldByName('id').AsInteger;
    ADict.Value := FDExe.FieldByName('value').AsString;
    ADict.Parent := IdScenario;

    FScenaries.Insert(FNextItem + I, ADict);
    FDExe.Next;
    Inc(I);
  end;
end;

procedure TWork.OnWaitWindow(Sender: TObject);
var
  h: hwnd;
  Count: integer;
  DialogItems, ScenarioItems, TypeItems, str: string;
  I: integer;
  ScenarioID, TypeItem: integer;
  Window: PWideChar;
  nm: array [0 .. 255] of char;
begin
  if (FScenaries[0].Key = itemStop) and (FThread.getStatus = TTaskStatus.Completed) then
  begin
    FTimerEnabled := false;

    Start(FNextItem);
    exit;
  end;

  Count := Copy(ItemHint, 1, pos('<sep_d>', ItemHint) - 1).ToInteger();
  DialogItems := Copy(ItemHint, pos('<sep_d>', ItemHint) + 7, pos('<sep_s>', ItemHint) - 8 - Count.ToString.Length);
  ScenarioItems := Copy(ItemHint, pos('<sep_s>', ItemHint) + 7, pos('<sep_t>', ItemHint) - 8 - Count.ToString.Length - DialogItems.Length);
  TypeItems := Copy(ItemHint, pos('<sep_t>', ItemHint) + 7);

  for I := 1 to Count do
  begin
    Window := PWideChar(Copy(DialogItems, 1, pos('<sep>', DialogItems) - 1));
    Delete(DialogItems, 1, pos('<sep>', DialogItems) + 4);

    ScenarioID := Copy(ScenarioItems, 1, pos('<sep>', ScenarioItems) - 1).ToInteger();
    Delete(ScenarioItems, 1, pos('<sep>', ScenarioItems) + 4);

    TypeItem := Copy(TypeItems, 1, pos('<sep>', TypeItems) - 1).ToInteger();
    Delete(TypeItems, 1, pos('<sep>', TypeItems) + 4);

    case TypeItem of
      0: // Открытие окна
        begin
          h := FindWindow(0, Window);

          if h <> 0 then
          begin
            IsDestroy := true;
            FTimerEnabled := false;

            if ScenarioID <> -1 then
              AddScenarioFromDialog(ScenarioID);

            Start(FNextItem);
          end
          else
            FindEx(h, Window, ScenarioID);

        end;
      -1: // Закрытие
        begin
          h := FindWindow(nil, Window);
          if h = 0 then
            if NOT FindCloseEx(0, Window) then
            begin
              IsDestroy := true;
              FTimerEnabled := false;

              if ScenarioID <> -1 then
                AddScenarioFromDialog(ScenarioID);

              Start(FNextItem);
            end;
        end;
    end;

  end;
end;

procedure TWork.FindEx(h: hwnd; WinName: string; ScenarioID: integer);
var
  wc, wcc: hwnd;
  nm: array [0 .. 255] of char;
  str: string;
begin

  wc := FindWindowEx(h, 0, 0, 0);

  while wc <> 0 do
  begin
    getwindowtext(wc, nm, 255);
    str := string(nm);
    if TRegEx.IsMatch(str, WinName) then
    begin
      IsDestroy := true;
      FTimerEnabled := false;

      if ScenarioID <> -1 then
        AddScenarioFromDialog(ScenarioID);

      Start(FNextItem);
      exit;
    end;

    if FindWindowEx(wc, 0, 0, 0) <> 0 then
      FindEx(wc, WinName, ScenarioID);
    wc := getnextwindow(wc, GW_HWNDNEXT);
  end;
end;

constructor TWork.Create(AConnection: TFDConnection);
begin
  TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Svc);
  FDExe := TFDQuery.Create(nil);
  FDExe.Connection := AConnection;
  FConnection := AConnection;
  IsMakeScreenShot := false;
  IsDestroy := false;
  Stopping := false;
end;

function TWork.FindCloseEx(h: hwnd; WinName: string): boolean;
var
  wc, wcc: hwnd;
  nm: array [0 .. 255] of char;
  str: string;
begin
  wc := FindWindowEx(h, 0, 0, 0);

  while wc <> 0 do
  begin
    getwindowtext(wc, nm, 255);
    str := string(nm);
    if TRegEx.IsMatch(str, WinName) then
    begin
      Result := true;
      exit;
    end;

    if FindWindowEx(wc, 0, 0, 0) <> 0 then
      if FindCloseEx(wc, WinName) then
      begin
        Result := true;
        exit
      end;
    wc := getnextwindow(wc, GW_HWNDNEXT);
  end;
  Result := false;
end;


procedure TWork.PostKeyEx32(Key: Word; const shift: TShiftState; numClick: Word = 1);
type
  TShiftKeyInfo = record
    shift: byte;
    vkey: byte;
  end;

  byteset = set of 0 .. 7;
const
  shiftkeys: array [1 .. 3] of TShiftKeyInfo = ((shift: Ord(ssCtrl); vkey: VK_CONTROL), (shift: Ord(ssShift); vkey: VK_SHIFT), (shift: Ord(ssAlt); vkey: VK_MENU));
var
  flag: DWord;
  bShift: byteset absolute shift;
  I: integer;
  vKey: byte;
begin

  vKey := Key;
  for I := 1 to 3 do
  begin
    if shiftkeys[I].shift in bShift then
      keybd_event(shiftkeys[I].vkey, MapVirtualKey(shiftkeys[I].vkey, 0), 0, 0);
  end;

//    keybd_event(VK_DOWN, MapVirtualKey(VK_DOWN, 0), 0, 0);
//    keybd_event(VK_DOWN, MapVirtualKey(VK_DOWN, 0), KEYEVENTF_KEYUP, 0);

  for I := 1 to numClick do
  begin
    flag := 0;
    keybd_event(vKey, MapVirtualKey(vKey, 0), flag, 0);
    flag := flag or KEYEVENTF_KEYUP;
    keybd_event(vKey, MapVirtualKey(vKey, 0), flag, 0);
    if I < numClick then
      sleep( 300); //0.3 секунды
  end;


  for I := 3 downto 1 do
  begin
    if shiftkeys[I].shift in bShift then
      keybd_event(shiftkeys[I].vkey, MapVirtualKey(shiftkeys[I].vkey, 0), KEYEVENTF_KEYUP, 0);
  end; { For }

end; { PostKeyEx32 }

end.
