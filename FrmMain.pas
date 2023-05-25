unit FrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FmFirst, FmChannels, Data.DB,
  ChannelPanel, FrmDataSQLite, FMX.Objects;

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
    procedure DinButtonDeleteChannelClick(Sender: TObject);
    procedure DinPanelClick(Sender: TObject);
    procedure DinPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
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
  PanChannels: array [1 .. 20] of TChannelPanel;
  vEventMove: integer; // 10 - обратно, 11- вправо. первую форму
  vState: integer; // 1 - первая форма - пароль,
//  PanVideos: array [1 .. 50] of TMyVideoPanel;
  lastPanel: TPanel;

implementation

{$R *.fmx}

procedure TfMain.DinPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  panel: TPanel;
begin
  panel := Sender as TPanel;
  if lastPanel <> nil then
    if lastPanel <> panel then
    begin
      (lastPanel.Controls[0] as TShape).Fill.Color := TAlphaColorRec.Red;
//      lastPanel. .Color := clBtnFace;
//      lastPanel.Font.Color := clBlack;
      lastPanel := nil;
    end;

  begin
//    panel.Color := clWhite; // clblack;
//    (lastPanel.Controls[0] as TShape).Fill.Color := TAlphaColorRec.White;
    // panel.Font.Color := clWhite;
    // запоминаем панельку, над которой изменили цвет,
    // чтобы когда произойдет движенье мышью над формой вернуть его обратно
    lastPanel := panel;
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  fMain.Width := 871;
  lastPanel := nil;
  vState := 1; // пароль
  // по центру поместим форму
  fMain.FrameFirst1.Position.X :=
    Round((fMain.Width - fMain.FrameFirst1.Width) / 2);
  fMain.FrameFirst1.Position.Y := 56;
  // спрячем второй фрейм за границу видимости
  fMain.FrameChannels.Position.X := Round(fMain.Width + 1);
  fMain.FrameChannels.Position.Y := 56;
  // fMain.FrameChannels.Visible := false;

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
  for i := 0 to fMain.Width do
  begin
    // sleep(1);
    Progress := i;
    Synchronize(SetActualFrame);
  end;
end;

procedure TNewThread.SetActualFrame;
var
  vLeftBorderFrame, vStepSize, vLeftBorderFrame2: integer;
begin
  vStepSize := 10;
  vLeftBorderFrame := Round((fMain.Width - fMain.FrameFirst1.Width) / 2);
  vLeftBorderFrame2 := Round((fMain.Width - fMain.FrameChannels.Width) / 2);

  // первая форма заменяется второй с каналами
  if vEventMove = 11 then
  begin
    If fMain.FrameFirst1.Position.X < (fMain.Width + 1) then
    begin
      fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X + vStepSize;
    end;

    If fMain.FrameChannels.Position.X >= fMain.Width then
    begin
      fMain.FrameChannels.Position.X := -fMain.FrameChannels.Width - 1;
    end;

    If fMain.FrameChannels.Position.X < (vLeftBorderFrame2) then
    begin
      // если сдвиг больше шага сдвига до левой границы помещения формы
      if ABS(fMain.FrameChannels.Position.X - vLeftBorderFrame2) > vStepSize
      then
        fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X +
          vStepSize
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

    If fMain.FrameChannels.Position.X > -fMain.FrameChannels.Width then
    begin
      fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X -
        vStepSize;
    end;

  end;

  // Form1.ProgressBar1.Position:=Progress;
  // Form1.Label1.Caption := UnitRead.Read('22_') + IntToStr(Progress);
  // fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X + 5;
  fMain.Label1.Text := inttostr(Round(fMain.FrameChannels.Position.X)) + ' : ' +
    inttostr(Round(vLeftBorderFrame2)) + ', ' +
    inttostr(Round(fMain.FrameChannels.Position.Y)) + ', ';
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
    vEventMove := vState * 10;
  end;

  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;
end;

procedure TfMain.ButtonSelChannelsClick(Sender: TObject);
var
  //
  i: integer;
  results: TDataSet;
  // g: TGraphic;
  vPos: integer;
begin
  // g:=TJpegimage.Create;
  // g := TPNGImage.Create;
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

      vPos := 30 + (i - 1) * 120;
      PanChannels[i] := TChannelPanel.Create(FrameChannels, vPos, i,
        results.FieldByName('id_channel').AsString,
        results.FieldByName('refresh_token').AsString,
        results.FieldByName('name_channel').AsString,
        results.FieldByName('lang').AsString);
      PanChannels[i].Parent := FrameChannels;
      PanChannels[i].ButtonDel.OnClick := DinButtonDeleteChannelClick;
       PanChannels[i].OnMouseMove := DinPanelMouseMove;
       PanChannels[i].OnClick := DinPanelClick; // Type (sender, 'TPanel');
      // PanChannels[i].ChImage.OnClick := DinPanelClick;
       PanChannels[i].chName.OnClick := DinPanelClick;
       PanChannels[i].ChLang.OnClick := DinPanelClick;
      // это рабочий вариант прямо с поля взять, не из таблицы!!
      // g.Assign(results.FieldByName('img_channel'));
      // Image1.Picture.Assign(g);
      inc(i);
      results.Next;
    end;
  end;
  Label1.Text := inttostr(i - 1);

end;

// обработка пароля
procedure TfMain.FrameFirst1ButtonLogClick(Sender: TObject);
var
  vOk: boolean;
  vLog, vPas: string;
begin
  vOk := false;
  vLog := fMain.FrameFirst1.EditName.Text;
  vPas := fMain.FrameFirst1.EditPas.Text;

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
    LabelMail.Text := fMain.FrameFirst1.EditName.Text;
    fMain.FrameFirst1.LabelError.Visible := false;
    fMain.FrameFirst1.LabelForgot.Visible := false;
    fMain.Button1Click(Sender);
  end;
end;



// удaление канала
procedure TfMain.DinButtonDeleteChannelClick(Sender: TObject);
// Sender : TComponent;
var
  strQuestionDelete, vIdChannel, vNameChannel: string;
  vNPanel: integer;
  i: integer;
begin
  lastPanel := nil;
  vNPanel := TButton(Sender).Tag;
  vIdChannel := PanChannels[vNPanel].chId.Text;
  vNameChannel := PanChannels[vNPanel].chName.Text;
  strQuestionDelete := 'Delete ' + vNameChannel + ' ?';
  if FMX.Dialogs.MessageDlg(strQuestionDelete, TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo) = mrYes

  then
  begin
    // SQLiteModule.DelChannel(vIdChannel);

    try
      for i := 1 to 20 do
        PanChannels[i].Free;
    finally
      lastPanel := nil;
      ButtonSelChannelsClick(Sender);
    end;
  end;

end;

// Нажатие по каналу чтоб выбрать видео
procedure TfMain.DinPanelClick(Sender: TObject);
const
  tokenurl = 'https://accounts.google.com/o/oauth2/token';
var
  vMessage, vIdChannel, vNameChannel: string;
  vNPanel: Integer;
{  Params: TDictionary<String, String>;
  Response: string;
  Access_token: string;
  refresh_token: string;

  OAuth2: TOAuth;
  vString: string;

  strQuestionDelete, vIdChannel, vNameChannel: string;
  vNPanel: Integer;
  vToken: string;

  // vObj: Tvideo;
  vObjVideo: Tchannel;
  res, i: Integer;
  urlget: string;
  AJsonString: string;

  vImgUrl: string;
  g: TGraphic;
  ssimg: TStringStream;
  vSS: TStringStream;
  SS: TStringStream;

  jpegimg: TJPEGImage;
  S: string;
  AAPIUrl: String;
  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  vVideo: TrVideo;

  vPosX, vPosY: Integer;  }

begin
  lastPanel := nil;
{
  //Button4Click(Sender);
  try
    for i := 1 to 50 do
      PanVideos[i].Free;
  finally
    lastPanel := nil;
  end;
}
  vNPanel := TButton(Sender).Tag;
  vIdChannel := PanChannels[vNPanel].chId.Text;
//  vToken := PanChannels[vNPanel].chToken.Caption;
  vNameChannel := PanChannels[vNPanel].chName.Text;
  // Для сообщения при отладке что нажали
  vIdChannel := PanChannels[vNPanel].chId.Text;
  vMessage := 'Click ' + vNameChannel + ' !' + vIdChannel +' ' + IntToStr(vNPanel);
  showmessage(vMessage);

end;

end.
