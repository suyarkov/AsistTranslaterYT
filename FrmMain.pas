unit FrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FmFirst, FmChannels, Data.DB, FrmDataSQLite,
  ChannelPanel;

type
  TfMain = class(TForm)
    Panel1: TPanel;
    FrameFirst1: TFrameFirst;
    Panel2: TPanel;
    LabelMail: TLabel;
    LabelCopyrigth: TLabel;
    ButtonBack: TButton;
    Label1: TLabel;
    FrameChannels: TFrameChannels;
    ButtonSelChannels: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure FrameFirst1ButtonLogClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonSelChannelsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TNewThread = class(TThread)
  private
    Progress: integer;
    procedure SetActualFrame;
  protected
    procedure Execute; override;
  end;

var
  fMain: TfMain;
  PanChannels: array [1 .. 20] of TMyPanel;
  vEventMove: integer; // 10 - обратно, 11- вправо. первую форму
  vState: integer; // 1 - первая форма - пароль,

implementation

{$R *.fmx}

procedure TfMain.FormCreate(Sender: TObject);
begin
  vState := 1; // пароль
  // по центру поместим форму
  fMain.FrameFirst1.Position.X :=
    Round((fMain.width - fMain.FrameFirst1.width) / 2);
  fMain.FrameFirst1.Position.Y := 56;
  // спрячем второй фрейм за границу видимости
  fMain.FrameChannels.Position.X := Round(fMain.width + 1);
  fMain.FrameChannels.Position.Y := 56;
//  fMain.FrameChannels.Visible := false;

end;

procedure TfMain.Button1Click(Sender: TObject);
var
  NewThread: TNewThread;
begin
  vEventMove := vState * 10 + 1;
  vState := 2;
  ButtonBack.Enabled := true;
  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;
end;

procedure TNewThread.Execute;
var
  i: integer;
begin
  for i := 0 to fMain.width do
  begin
    // sleep(1);
    Progress := i;
    Synchronize(SetActualFrame);
  end;
end;

procedure TNewThread.SetActualFrame;
var
  vLeftBorderFrame, vStepSize,
  vLeftBorderFrame2: integer;
begin
  vStepSize := 10;
  vLeftBorderFrame := Round((fMain.width - fMain.FrameFirst1.width) / 2);
  vLeftBorderFrame2 := Round((fMain.width - fMain.FrameChannels.width) / 2);

  // первая форма заменяется второй с каналами
  if vEventMove = 11 then
  begin
    If fMain.FrameFirst1.Position.X < (fMain.width + 1) then
    begin
      fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X + vStepSize;
    end;

    If fMain.FrameChannels.Position.X >= fMain.width  then
    begin
      fMain.FrameChannels.Position.X := - fMain.FrameChannels.width - 1;
    end;

    If fMain.FrameChannels.Position.X < (vLeftBorderFrame2) then
    begin
      // если сдвиг больше шага сдвига до левой границы помещения формы
      if ABS(fMain.FrameChannels.Position.X - vLeftBorderFrame2) > vStepSize then
        fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X + vStepSize
      else // если уже меньше, от просто подставим форму в нужное место
        fMain.FrameChannels.Position.X := vLeftBorderFrame2;
    end;

    If fMain.FrameChannels.Position.X = (vLeftBorderFrame2) then
    begin
       fMain.FrameChannels.Visible := true;
    end;

  end;

  // форма с каналами заменяется первой с паролем
  if vEventMove = 10 then
  begin
    If fMain.FrameFirst1.Position.X > vLeftBorderFrame then
    begin
      // если сдвиг больше шага сдвига до левой границы помещения формы
      if fMain.FrameFirst1.Position.X - vLeftBorderFrame > vStepSize then
        fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X - vStepSize
      else // если уже меньше, от просто подставим форму в нужное место
        fMain.FrameFirst1.Position.X := vLeftBorderFrame;
    end;

    If fMain.FrameChannels.Position.X > - fMain.FrameChannels.width  then
    begin
      fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X - vStepSize;
    end;

  end;

  // Form1.ProgressBar1.Position:=Progress;
  // Form1.Label1.Caption := UnitRead.Read('22_') + IntToStr(Progress);
  // fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X + 5;
  fMain.Label1.Text := inttostr(round(fMain.FrameChannels.Position.X)) + ' : '
    + inttostr(round(vLeftBorderFrame2)) + ', '
    + inttostr(round(fMain.FrameChannels.Position.Y)) + ', ';
end;

procedure TfMain.ButtonBackClick(Sender: TObject);
var
  NewThread: TNewThread;
begin
  if vState > 1 then
  begin
    vState := vState - 1;
    if vState = 1 then
      ButtonBack.Enabled := false;
    // что будем возвращать
    vEventMove := vState * 10 ;
  end;

  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;
end;

procedure TfMain.ButtonSelChannelsClick(Sender: TObject);
var
  //
  i: Integer;
  results: TDataSet;
//  g: TGraphic;
  vPos: Integer;
begin
  // g:=TJpegimage.Create;
//  g := TPNGImage.Create;
  // g:=TBitmap.Create;

  i := 1;

  // загружаю данные из локальной таблицы
  results := SQLiteModule.SelRefreshToken();

  // разбираю курсор в объект
  if not results.IsEmpty then
  begin
    results.First;
    while not results.Eof do
    begin

      vPos := (i - 1) * 120;
//      PanChannels[i] := TMyPanel.Create(FrameChannels, vPos, i,
//        results.FieldByName('id_channel').AsString,
//        results.FieldByName('refresh_token').AsString,
//        results.FieldByName('name_channel').AsString,
//        results.FieldByName('lang').AsString);
//      PanChannels[i].Parent := FrameChannels;
//      PanChannels[i].ButtonDel.OnClick := DinButtonDeleteChannelClick;
//      PanChannels[i].OnMouseMove := DinPanelMouseMove;
//      PanChannels[i].OnClick := DinPanelClick; // Type (sender, 'TPanel');
//      PanChannels[i].ChImage.OnClick := DinPanelClick;
//      PanChannels[i].chName.OnClick := DinPanelClick;
//      PanChannels[i].ChLang.OnClick := DinPanelClick;
      // это рабочий вариант прямо с поля взять, не из таблицы!!
      // g.Assign(results.FieldByName('img_channel'));
      // Image1.Picture.Assign(g);
      inc(i);
      results.Next;
    end;
  end;

end;

// обработка пароля
procedure TfMain.FrameFirst1ButtonLogClick(Sender: TObject);
var
  vOk: boolean;
  vLog, vPas: string;
begin
  vOk := false;
  vLog := fMain.FrameFirst1.EditName.text;
  vPas := fMain.FrameFirst1.EditPas.text;

  // проверка логина и пароля
  if (pos('@', vLog) > 0) and (pos('.', vLog) > 0) then
    vOk := true
  else
    vOk := false;

  // рекация
  if vOk = false then
  // ошибка идентификации
  begin
    fMain.FrameFirst1.LabelError.Visible := true;
    fMain.FrameFirst1.LabelForgot.Visible := true;
  end
  else
  // идентификация успешна
  begin
    LabelMail.text := fMain.FrameFirst1.EditName.text;
    fMain.FrameFirst1.LabelError.Visible := false;
    fMain.FrameFirst1.LabelForgot.Visible := false;
    fMain.Button1Click(Sender);
  end;
end;

end.
