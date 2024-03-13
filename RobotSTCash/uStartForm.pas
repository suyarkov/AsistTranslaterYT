unit uStartForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Generics.Collections, FMX.Platform, Winapi.Windows, uMain, uScheduler,
  FMX.Objects, System.ImageList, FMX.ImgList, System.RegularExpressions, Messages, uTypes, uWork, uSettings, System.Threading;

type

  TStartForm = class(TForm)
    GridPanelLayout1: TGridPanelLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    btnScenario: TCornerButton;
    btnScheduler: TCornerButton;
    Timer: TTimer;
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    btnStart: TSpeedButton;
    ImageBtn: TImage;
    ImageList: TImageList;
    Label1: TLabel;
    btnSettings: TCornerButton;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnSchedulerClick(Sender: TObject);
    procedure btnScenarioClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
  private
    FScenarioList: TList<TDict>;
    FSchedulerList: TList<integer>;
    IsStarted: boolean;
    FScenarioItems: TList<TDict>;

    FSchedulerNext: integer;
    WindowName: PWideChar;
    FScheduler: TFormScheduler;
    FMain: TScenarioEditForm;
    FSettings: TFormSettings;
    FWnd: THANDLE;
    HotKey: integer;
    FWork: TWork;
    FIDSheduler: integer;
    FThread: ITask;
    function ExecuteScenario(IdScenario: integer): boolean;
    procedure NextScheduler;
    procedure NextScenario;
    procedure GoItemPos(HintText: string);
    procedure WindowProc(var AMsg: TMessage);
    procedure NextStep(IsSuccess: boolean);
    procedure SendResult;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartForm: TStartForm;

implementation

{$R *.fmx}

procedure TStartForm.TimerTimer(Sender: TObject);
var
  I: integer;
  AKey: integer;
begin

  if FSchedulerList.Count = 0 then
  begin
    FSchedulerNext := 0;
    IsStarted := False;

    GoItemPos('0-0');
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;

  ExeQ(FDQuery, 'select * from startlist;', tsActive);

  FDQuery.First;

  while NOT FDQuery.Eof do
  begin
    AKey := FDQuery.FieldByName('id').AsInteger;

    if FSchedulerList.IndexOf(AKey) = -1 then
      FSchedulerList.Add(AKey);

    FDQuery.Next;
  end;

  if (Not IsStarted) and (FSchedulerList.Count <> 0) then
  begin
    NextScheduler;
  end;

end;

procedure TStartForm.NextStep(IsSuccess: boolean);
var
  J: integer;
begin

  if Not IsSuccess and (FScenarioList.Count <> 0) then
    for J := 0 to FScenarioList[0].Value.ToInteger() - 1 do
      FScenarioList.Delete(0);

  FScenarioList.Delete(0);

  NextScenario;
end;

procedure TStartForm.NextScheduler;
var
  I: integer;
begin
  I := 0;
  IsStarted := true;

  if FSchedulerNext <= FSchedulerList.Count - 1 then
  begin
    FIDSheduler := FSchedulerList[FSchedulerNext];
    ExeQ(FDQuery, 'insert into log_schedulers(id_scheduler,sys_date,type_start) values (' + FIDSheduler.ToString + ',current_timestamp,1)', tsExec);

    GetTree(FScenarioList, FIDSheduler, 0, FDQuery);
    Inc(FSchedulerNext);
    NextScenario;
  end
  else
  begin
    FSchedulerList.Clear;
  end;
end;

procedure TStartForm.SendResult;
var
  J: integer;
  LastScenarioName: string;
  Send: TStringList;
  Res: string;
begin

  ExeQ(FDQuery, 'select sc_name, res,sr_name from get_send where id = ' + FIDSheduler.ToString, tsActive);
  LastScenarioName := FDQuery.FieldByName('sr_name').AsString;

  Send := TStringList.Create;
  J := 1;

  try
    while NOT FDQuery.Eof do
    begin
      case FDQuery.FieldByName('res').AsInteger of
        1:
          Res := 'Успешно';
        0:
          Res := 'Ошибка';
        2:
          Res := 'Пропущено';
      end;

      Send.Append('<p style="text-align:left">' + J.ToString + ') ' + FDQuery.FieldByName('sc_name').AsString + ' - ' + Res + '</p>');

      Inc(J);
      FDQuery.Next;
    end;

    TTask.Run(
      procedure
      var
        Query: TFDQuery;
        SendText: TStringList;
      begin
        Query := TFDQuery.Create(nil);
        Query.Connection := FDQuery.Connection;
        SendText := TStringList.Create;
        SendText.Append('<!DOCTYPE html><html>  <head></head><body>' + '<p  style="text-align:center"></p>');
        SendText.Append('<hr /><p style="text-align:center"><strong>' + 'Результат выполнения!' + '</strong></p>');
        SendText.Append('<p style="text-align:center">' + 'Результат выполнения "' + LastScenarioName + '" от ' + DateToStr(Now()) + '</p>');
        SendText.AddStrings(Send);
        // Текст сообщения
        try
          SendMessage('Результат выполнения RobotCash', SendText, Query);
        finally
          Send.Free;
          SendText.Free;
          Query.Free;
        end;

      end);
  finally

  end;
end;

procedure TStartForm.NextScenario;
begin
  FScenarioItems.Clear;

  if FScenarioList.Count = 0 then
  begin
    SendResult;
    NextScheduler;
  end
  else
  begin
    ExecuteScenario(FScenarioList[0].Key);
  end;

end;

procedure TStartForm.btnScenarioClick(Sender: TObject);
begin
  Self.Hide;
  FMain := TScenarioEditForm.Create(nil);
  FMain.ShowModal;
  Self.Show;
end;

procedure TStartForm.btnSchedulerClick(Sender: TObject);
begin
  FScheduler := TFormScheduler.Create(nil);
  FScheduler.ShowModal;
end;

procedure TStartForm.btnSettingsClick(Sender: TObject);
begin
  Self.Hide;
  FSettings := TFormSettings.Create(nil);
  FSettings.ShowModal;
  Self.Show;
end;

procedure TStartForm.btnStartClick(Sender: TObject);
begin

  Timer.Enabled := NOT Timer.Enabled;

  if Timer.Enabled then
  begin
    ImageBtn.MultiResBitmap[0].Bitmap.Assign(ImageList.Source[1].MultiResBitmap[0].Bitmap);
    RegisterHotkey(FWnd, HotKey, mod_control, HotKey);
  end
  else
  begin
    ImageBtn.MultiResBitmap[0].Bitmap.Assign(ImageList.Source[0].MultiResBitmap[0].Bitmap);
    UnregisterHotKey(FWnd, HotKey);

    if FThread <> nil then
    begin
      FThread.Cancel;
      FThread := nil;
    end;
  end;
end;

function TStartForm.ExecuteScenario(IdScenario: integer): boolean;
var
  I: integer;
  ADict: TDict;
begin
  ExeQ(FDQuery, Format('select id,value from scenario_item where id_scenario = %d order by order_id', [IdScenario]), tsActive);

  FDQuery.First;

  while NOT FDQuery.Eof do
  begin
    ADict.Key := FDQuery.FieldByName('id').AsInteger;
    ADict.Value := FDQuery.FieldByName('value').AsString;
    ADict.Parent := IdScenario;

    FScenarioItems.Add(ADict);
    FDQuery.Next;
  end;

  FThread := TTask.Run(
    procedure
    begin
      FWork.Stopping := False;
      FWork.IDSheduler := FIDSheduler;
      FWork.IdScenario := IdScenario;
      FWork.Start;
    end);
end;

procedure TStartForm.GoItemPos(HintText: string);
var
  tmpPoint: TPoint;
begin
  tmpPoint.X := Round(StrToInt(Copy(HintText, 1, Pos('-', HintText) - 1)));
  tmpPoint.Y := Round(StrToInt(Copy(HintText, Pos('-', HintText) + 1)));
  SetCursorPos(tmpPoint.X, tmpPoint.Y);
end;

procedure TStartForm.FormCreate(Sender: TObject);
begin
  FDConnection.Params.Database := ExtractFilePAth(paramstr(0)) + '\base.db';
  FDConnection.Connected := true;
  FScenarioList := TList<TDict>.Create;
  FScenarioItems := TList<TDict>.Create;
  FSchedulerList := TList<integer>.Create;

  FWnd := AllocateHWnd(WindowProc);
  HotKey := vk_f1;

  FWork := TWork.Create(FDConnection);
  FWork.Proc := NextStep;
  FWork.Scenaries := FScenarioItems;
end;

procedure TStartForm.WindowProc(var AMsg: TMessage);
begin

  if Timer.Enabled then
    case AMsg.Msg of
      WM_HOTKEY:
        if TWMHotKey(AMsg).HotKey = HotKey then
        begin
          btnStartClick(nil);
        end;
    end;
end;

end.
