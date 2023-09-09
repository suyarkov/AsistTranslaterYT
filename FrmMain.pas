unit FrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Net.HTTPClient, System.NetEncoding,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FmFirst, FmChannels, Data.DB,
  PnChannel, PnVideo,
  FrmDataSQLite, FMX.Objects, FmProgressBar, FmProgressEndLess,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  Winapi.ShellAPI,
  IdContext, OAuth2,
  Classes.channel, Classes.video,
  REST.JSON, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Edit, IdMessage,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  //IdMessageClient, //IdSMTPBase, IdSMTP,
  Classes.shearche.image,
  uEmailSend, uQ,
  Classes.channel.statistics, FmMainChannel, FmVideos;

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
    Image3: TImage;
    Button5: TButton;
    Label2: TLabel;
    Button6: TButton;
    FrameProgressBar: TFrameProgressBar;
    ButtonPaint: TButton;
    TCPServerYouTubeAnswers: TIdTCPServer;
    BGetTokkens: TButton;
    BGetChannel: TButton;
    Memo1: TMemo;
    Edit4: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    ButtonEmail2: TButton;
    ButtonQ: TButton;
    FrameMainChannel: TFrameMainChannel;
    Button200: TButton;
    FrameVideos: TFrameVideos;
    procedure Button1Click(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure FrameFirst1ButtonLogClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonSelChannelsClick(Sender: TObject);
    procedure DinButtonDeleteChannelClick(Sender: TObject);
    procedure DinPanelClick(Sender: TObject);
    procedure DinPanelVideoClick(Sender: TObject);
    procedure DinPanelMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure FrameChannelsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ButtonPaintClick(Sender: TObject);
    procedure FrameChannelsButtonAddChannelClick(Sender: TObject);
    procedure TCPServerYouTubeAnswersExecute(AContext: TIdContext);
    procedure BGetTokkensClick(Sender: TObject);
    procedure BGetChannelClick(Sender: TObject);
    procedure ButtonEmail2Click(Sender: TObject);
    procedure ButtonQClick(Sender: TObject);
    procedure Button200Click(Sender: TObject);
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

  TProgressThread = class(TThread)
  private
    procedure SetActualProgress;
  protected
    procedure Execute; override;
  end;

var
  fMain: TfMain;
  PanChannels: array [1 .. 50] of TChannelPanel;
  PanVideos: array [1 .. 1000] of TVideoPanel;
  vEventMove: integer; // 10 - обратно, 11- вправо. первую форму
  vState: integer; // 1 - первая форма - пароль,// 2 вторая форма каналы,
  // 3 третья - один канал // 4- конкретный ролик
  // PanVideos: array [1 .. 50] of TMyVideoPanel;
  lastPanel: TPanel;
  vDefaultColor: TAlphaColor;
  vProgressBarStatus: integer;
  GlobalProgressThread: TProgressThread;
  FrameProgressEndLess: TFrameProgressEndLess;
  vResponceChannel : string;
  vResponceVideo : string;
  EdAccessCode : string;
  EdRefresh_token :string;
  EdAccess_token :string;

implementation

{$R *.fmx}

procedure TfMain.DinPanelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
var
  panel: TChannelPanel;
begin
  panel := Sender as TChannelPanel;
  Label1.text := panel.ChName.text;
  if lastPanel <> nil then
    if lastPanel <> panel then
    begin
      (lastPanel.Controls[0] as TShape).Fill.Color := vDefaultColor;
      // TAlphaColorRec.Darkgreen; //TAlphaColor($8B0000)
      (lastPanel.Controls[0] as TRectangle).Stroke.Color := vDefaultColor;
      // lastPanel. .Color := clBtnFace;
      // lastPanel.Font.Color := clBlack;
      lastPanel := nil;
    end;

  begin
    (panel.Controls[0] as TShape).Fill.Color := TAlphaColors.White;
    (panel.Controls[0] as TRectangle).Stroke.Color := TAlphaColors.White;
    // panel.Color := clWhite; // clblack;
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
  vDefaultColor := TAlphaColors.Gray;
  // fMain.Fill.Color; // as TRectangle).Stroke.Color
  // по центру поместим форму
  fMain.FrameFirst1.Position.X :=
    Round((fMain.Width - fMain.FrameFirst1.Width) / 2);
  fMain.FrameFirst1.Position.Y := 56;
  // спрячем второй фрейм за границу видимости
  fMain.FrameChannels.Position.X := Round(fMain.Width + 1);
  fMain.FrameChannels.Position.Y := 56;

  // спрячем третий фрейм за границу видимости
  fMain.FrameMainChannel.Position.X := Round(fMain.Width + 1);
  fMain.FrameMainChannel.Position.Y := 56;

    // спрячем третий фрейм за границу видимости
  fMain.FrameVideos.Position.X := Round(fMain.Width + 1);
  fMain.FrameVideos.Position.Y := 56;

  FrameProgressBar.Visible := false;

  if not Assigned(FrameProgressEndLess) then
  begin
    FrameProgressEndLess := TFrameProgressEndLess.Create(Self);
    FrameProgressEndLess.Visible := false;
    FrameProgressEndLess.Parent := fMain;
    FrameProgressEndLess.Align := TAlignLayout.Center;
  end;

  fMain.FrameFirst1.EditName.Text := uQ.LoadReestr('Name');

end;

// смотри статус не снеси
// разбор полученного ответа в vResponceChannel по каналу от сервера youtube и создание коротного описания каналов
procedure TfMain.BGetChannelClick(Sender: TObject);
var
  vObj: Tchannel;//Tchannel;
  res, i: Integer;
  urlget: string;
  vChannel: TShortChannel;
//  vTest : Tshearche_image;
  vImgUrl: string;
  // S: AnsiString;
  Bitimg: TBitmap;
  S: string;
  AAPIUrl: String;
  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  Stream : TStream;
begin
  s := '0';
  vObj:= Tchannel.Create;
  // в мемо должен быть уже строка с канала
  vObj := TJson.JsonToObject<Tchannel>(Memo1.Text);


  for i := 0 to Length(vObj.Items) - 1 do
  begin
    vChannel.id_channel := vObj.Items[i].id;
    vChannel.name_channel := vObj.Items[i].snippet.title;
    vChannel.lang :=vObj.Items[i].snippet.country;
//    vChannel.lang :=vObj.Items[i].snippet.defaultLanguage;
    vImgUrl := vObj.Items[i].snippet.thumbnails.default.URL;
    Edit4.Text := vImgUrl;
    try
      S := StringReplace(Edit4.Text, #13, '', [rfReplaceAll, rfIgnoreCase]);
      AAPIUrl := StringReplace(S, #10, '', [rfReplaceAll, rfIgnoreCase]);
      FHTTPClient := THTTPClient.Create;
      FHTTPClient.UserAgent :=
        'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
      try
        AResponce := FHTTPClient.Get(AAPIUrl);
      except
        showmessage('нет подключения');
      end;
      if Not Assigned(AResponce) then
      begin
        showmessage('Пусто');
      end;

      Bitimg := TBitmap.Create;
      Bitimg.LoadFromStream(AResponce.ContentStream);
      vChannel.img := TBitmap.Create;
      vChannel.img := Bitimg;
      vChannel.img_channel := TBlobType(Bitimg);
    except
       showmessage('Что except');
    end;

    vChannel.refresh_token := EdRefresh_token;
    if vChannel.lang = '' then
    begin
      vChannel.lang :=vObj.Items[i].snippet.defaultLanguage;
    end;
    // vChannel.sel_lang := vObj.;
    vChannel.deleted := 0;
    res := SQLiteModule.InsRefreshToken(vChannel);
  end;

end;


// запуск получения токенов канала по полученному ключу доступа  в Edit1.Text
procedure TfMain.BGetTokkensClick(Sender: TObject);

var
  Access_token: string;      // токен выполнения операций
  Refresh_token: string;     // токен получения следующего токена на выполнение

  OAuth2: TOAuth;
  vString: string;
begin
  OAuth2 := TOAuth.Create;
  OAuth2.ClientID :=
    '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
  OAuth2.ClientSecret := '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';
  OAuth2.ResponseCode := EdAccessCode;// Edit1.Text;//
  Edit1.Text := EdAccessCode;

  Access_token := OAuth2.GetAccessToken;
  Refresh_token := OAuth2.refresh_token;

  Edit4.Text := Access_token + ' иии ' + refresh_token;

  vResponceChannel := OAuth2.MyChannels;
  Memo1.Text := vResponceChannel;
  OAuth2.Free;
  EdRefresh_token :=  Refresh_token;
  BGetChannelClick(Sender);
  ButtonSelChannelsClick(Sender); // обновление не забудь!!!
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

// получить списко видео по каналу
procedure TfMain.Button200Click(Sender: TObject);
var
  Access_token: string;      // токен выполнения операций
  Refresh_token: string;     // токен получения следующего токена на выполнение

  OAuth2: TOAuth;
  vString: string;
begin
  OAuth2 := TOAuth.Create;
  OAuth2.ClientID :=
    '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
  OAuth2.ClientSecret := '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';
  // крайне важно
  OAuth2.refresh_token := FrameMainChannel.Label3.text;
  vResponceVideo := OAuth2.MyVideos(FrameMainChannel.Label2.text);
  //  Memo1.Text := vResponceVideo;
  OAuth2.Free;

end;

// поток для прогресс бара
procedure TProgressThread.Execute;
var
  i: integer;
begin
  while not Terminated do
  begin
    sleep(1);
    inc(vProgressBarStatus);
    if vProgressBarStatus > 4000 then
      vProgressBarStatus := 1;
    Synchronize(SetActualProgress);
  end;
  { for i := 0 to 2000 do
    begin
    inc(vProgressBarStatus);
    Synchronize(SetActualProgress);
    end; }
end;

procedure TProgressThread.SetActualProgress;
begin
  fMain.Label2.text := IntToStr(vProgressBarStatus);
  fMain.FrameProgressBar.SetProgress(vProgressBarStatus);

  FrameProgressEndLess.SetProgress(vProgressBarStatus);
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

// установка актаульного фрейма
procedure TNewThread.SetActualFrame;
var
  vLeftBorderFrame, vStepSize, vLeftBorderFrame2, vLeftBorderFrame3,
  vLeftBorderFrame4: integer;
begin
  vStepSize := 10;
  vLeftBorderFrame := Round((fMain.Width - fMain.FrameFirst1.Width) / 2);
  vLeftBorderFrame2 := Round((fMain.Width - fMain.FrameChannels.Width) / 2);
  vLeftBorderFrame3 := Round((fMain.Width - fMain.FrameMainChannel.Width) / 2);
  vLeftBorderFrame4 := Round((fMain.Width - fMain.FrameVideos.Width) / 2);

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

    // вторая форма заменяется третьей с каналами  FrameMainChannel
  if vEventMove = 21 then
  begin
    If fMain.FrameChannels.Position.X < (fMain.Width + 1) then
    begin
      fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X + vStepSize;
    end;

    If fMain.FrameMainChannel.Position.X >= fMain.Width then
    begin
      fMain.FrameMainChannel.Position.X := -fMain.FrameMainChannel.Width - 1;
    end;

    If fMain.FrameMainChannel.Position.X < (vLeftBorderFrame3) then
    begin
      // если сдвиг больше шага сдвига до левой границы помещения формы
      if ABS(fMain.FrameMainChannel.Position.X - vLeftBorderFrame3) > vStepSize
      then
        fMain.FrameMainChannel.Position.X := fMain.FrameMainChannel.Position.X +
          vStepSize
      else // если уже меньше, от просто подставим форму в нужное место
        fMain.FrameMainChannel.Position.X := vLeftBorderFrame3;
    end;

    If fMain.FrameMainChannel.Position.X = (vLeftBorderFrame3) then
    begin
      fMain.FrameMainChannel.Visible := true;
    end;

  end;

  // форма с каналом видео заменяется второй со списком каналов
  if vEventMove = 20 then
  begin
    If fMain.FrameChannels.Position.X > vLeftBorderFrame2 then
    begin
      // если сдвиг больше шага сдвига до левой границы помещения формы
      if fMain.FrameChannels.Position.X - vLeftBorderFrame2 > vStepSize then
        fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X - vStepSize
      else // если уже меньше, от просто подставим форму в нужное место
        fMain.FrameChannels.Position.X := vLeftBorderFrame2;
    end;

    If fMain.FrameMainChannel.Position.X > -fMain.FrameMainChannel.Width then
    begin
      fMain.FrameMainChannel.Position.X := fMain.FrameMainChannel.Position.X -
        vStepSize;
    end;

  end;

   // третья форма с видео, заменяется подробной для редакции описания видео
  if vEventMove = 31 then
  begin
    If fMain.FrameMainChannel.Position.X < (fMain.Width + 1) then
    begin
      fMain.FrameMainChannel.Position.X := fMain.FrameMainChannel.Position.X + vStepSize;
    end;

    If fMain.FrameVideos.Position.X >= fMain.Width then
    begin
      fMain.FrameVideos.Position.X := -fMain.FrameVideos.Width - 1;
    end;

    If fMain.FrameVideos.Position.X < (vLeftBorderFrame4) then
    begin
      // если сдвиг больше шага сдвига до левой границы помещения формы
      if ABS(fMain.FrameVideos.Position.X - vLeftBorderFrame4) > vStepSize
      then
        fMain.FrameVideos.Position.X := fMain.FrameVideos.Position.X +
          vStepSize
      else // если уже меньше, от просто подставим форму в нужное место
        fMain.FrameVideos.Position.X := vLeftBorderFrame4;
    end;

    If fMain.FrameVideos.Position.X = (vLeftBorderFrame4) then
    begin
      fMain.FrameVideos.Visible := true;
    end;

  end;

  // форма с подробностями видео заменяется третьей со списком видео
  if vEventMove = 30 then
  begin
    If fMain.FrameMainChannel.Position.X > vLeftBorderFrame3 then
    begin
      // если сдвиг больше шага сдвига до левой границы помещения формы
      if fMain.FrameMainChannel.Position.X - vLeftBorderFrame3 > vStepSize then
        fMain.FrameMainChannel.Position.X := fMain.FrameMainChannel.Position.X - vStepSize
      else // если уже меньше, от просто подставим форму в нужное место
        fMain.FrameMainChannel.Position.X := vLeftBorderFrame2;
    end;

    If fMain.FrameVideos.Position.X > -fMain.FrameVideos.Width then
    begin
      fMain.FrameVideos.Position.X := fMain.FrameVideos.Position.X -
        vStepSize;
    end;

  end;

  // Form1.ProgressBar1.Position:=Progress;
  // Form1.Label1.Caption := UnitRead.Read('22_') + IntToStr(Progress);
  // fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X + 5;
  fMain.Label1.text := IntToStr(Round(fMain.FrameChannels.Position.X)) + ' : ' +
    IntToStr(Round(vLeftBorderFrame2)) + ', ' +
    IntToStr(Round(fMain.FrameChannels.Position.Y)) + ', ';
end;

procedure TfMain.Button5Click(Sender: TObject);
var
  aShape: TShape;
  r, x0, y0: integer;
  ProgressThread: TProgressThread;
begin
  // r:=100;     // радиус
  // x0:=300;   // координата центра
  // y0:=200;   // координата центра
  // image1.Canvas.(FMX.Objects.DrawEllipse(x0, y0, r)); //.Ellipse(x0-r,y0-r,x0+r,y0+r);
  //
  // image1.canvas.
  if Assigned(GlobalProgressThread) then
  begin
    Label1.text := BoolToStr(GlobalProgressThread.Terminated);
    if GlobalProgressThread.Terminated = false or
      GlobalProgressThread.Terminated = true then
    begin
      if GlobalProgressThread.Terminated = true then
      begin
        Label1.text := Label1.text + ' true';
        GlobalProgressThread.Free;
      end
      else
      begin
        if GlobalProgressThread.Terminated = false then
          Label1.text := Label1.text + ' false'
        else if GlobalProgressThread.Terminated = null then
          Label1.text := Label1.text + ' null'
        else
          Label1.text := 'НЕ НЕСУЩЕСТВУЕТ';
      end;
    end
  end
  else
    Label1.text := 'объекта нет созданного';

  if not Assigned(GlobalProgressThread) then
  begin
    GlobalProgressThread := TProgressThread.Create(true);
  end;
  if BoolToStr(GlobalProgressThread.Terminated) = '-1' then
    GlobalProgressThread := TProgressThread.Create(true);
  if vProgressBarStatus = 0 then
  begin
    vProgressBarStatus := 0;

    GlobalProgressThread.FreeOnTerminate := true;
    // GlobalProgressThread.Priority := tpLower;
    GlobalProgressThread.Resume;
  end;

  FrameProgressBar.Visible := true;
  FrameProgressEndLess.Visible := true;
end;

procedure TfMain.Button6Click(Sender: TObject);
begin
  if Assigned(GlobalProgressThread) then
  begin
    Label1.text := BoolToStr(GlobalProgressThread.Terminated);
    if GlobalProgressThread.Terminated = false then
      GlobalProgressThread.Terminate;
    Label1.text := Label1.text + '  ' +
      BoolToStr(GlobalProgressThread.Terminated);
    if GlobalProgressThread.Terminated = null then
      Label1.text := Label1.text + ' null';

  end;
  if Assigned(GlobalProgressThread) then
  begin
    GlobalProgressThread.Free;
  end;
  vProgressBarStatus := 0;

  FrameProgressBar.Visible := false;
  FrameProgressEndLess.Visible := false;
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

procedure TfMain.ButtonEmail2Click(Sender: TObject);
begin
  SendEmail('smtp.mail.ru', 465, 'brest20133@mail.ru',
  '0wxKM9nE60HAwsvhGbN5', 'brest20133@mail.ru', 'aFromName',
  'suyarkov@gmail.com', 'Тема пирога', 'Привет от асиста',
  '', true);
end;

procedure TfMain.ButtonPaintClick(Sender: TObject);
begin
//      fMaim.
end;



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

procedure TfMain.ButtonSelChannelsClick(Sender: TObject);
var
  //
  i: integer;
  results: TDataSet;
  vPos: integer;
  vBitmap: TBitmap;
  vDefaulBitmap: TBitmap;
begin

  i := 1;
  // загружаю данные из локальной таблицы
  results := SQLiteModule.SelRefreshToken();
  // разбираю курсор в объект - бордер
  if not results.IsEmpty then
  begin
    results.First;
    while not results.Eof do
    begin
        try
          vBitmap := TBitmap(results.FieldByName('img_channel'));
        except
//          vBitmap := vDefaulBitmap;
        end;

      vPos := 30 + (i - 1) * 120;
      PanChannels[i] := TChannelPanel.Create(FrameChannels.BoxChannels, vPos, i,
        results.FieldByName('id_channel').AsString,
        results.FieldByName('refresh_token').AsString,
        results.FieldByName('name_channel').AsString,
        results.FieldByName('lang').AsString, vBitmap);
      PanChannels[i].Parent := FrameChannels.BoxChannels;
      PanChannels[i].ButtonDel.OnClick := DinButtonDeleteChannelClick;
      PanChannels[i].OnMouseMove := DinPanelMouseMove;
      PanChannels[i].OnClick := DinPanelClick; // Type (sender, 'TPanel');
      PanChannels[i].ChImage.OnClick := DinPanelClick;
      PanChannels[i].ChName.OnClick := DinPanelClick;
      PanChannels[i].ChLang.OnClick := DinPanelClick;
      // это рабочий вариант прямо с поля взять, не из таблицы!!
      // g.Assign(results.FieldByName('img_channel'));
      // Image1.Picture.Assign(g);
      inc(i);
      results.Next;
    end;
  end;
  Label1.text := IntToStr(i - 1);

end;

// обработка пароля
procedure TfMain.FrameChannelsButtonAddChannelClick(Sender: TObject);
var
  {$IFDEF ANDROID}
  Intent: JIntent;
  {$ENDIF}
  {$IFDEF IOS}
  NSU: NSUrl;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Res: HINST;
  {$ENDIF}
begin
// подключение
//  EditStatusConnect.Text := 'Waiting for connection ...';
  // 1.Включить сервер

  if TCPServerYouTubeAnswers.Active = false then
  begin
    TCPServerYouTubeAnswers.Bindings.Add.Port := 1904;
    TCPServerYouTubeAnswers.Active := true;
//    IdTCPServer1.OnExecute(true);
//    AContext.Connection.Disconnect;
//    AContext.Connection.IOHandler.Free;

  end;
  // 2. Открыть регистрацию
    {$IFDEF MSWINDOWS}     // версия для винды
  ShellExecute(0{Handle}, 'open',
    PChar('https://accounts.google.com/o/oauth2/v2/auth?' +
    'scope=https://www.googleapis.com/auth/youtube.force-ssl&' +
    'access_type=offline&include_granted_scopes=true' + '&state=security_token'
    + '&response_type=code' + '&redirect_uri=http://127.0.0.1:1904' +
    '&client_id=701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com'
    + '&service=lso&o2v=2&flowName=GeneralOAuthFlow'), nil, nil, 1{SW_SHOWNORMAL});
    {$ENDIF}
end;

procedure TfMain.FrameChannelsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
  if lastPanel <> nil then
  begin
    (lastPanel.Controls[0] as TShape).Fill.Color := vDefaultColor;
    // TAlphaColorRec.Darkgreen; //TAlphaColor($8B0000)
    (lastPanel.Controls[0] as TRectangle).Stroke.Color := vDefaultColor;
    // lastPanel. .Color := clBtnFace;
    // lastPanel.Font.Color := clBlack;
    lastPanel := nil;
  end; //
end;

procedure TfMain.FrameFirst1ButtonLogClick(Sender: TObject);
var
  vOk: boolean;
  vLog, vPas, vResponce: string;
  OAuth2: TOAuth;
begin
  vOk := false;
  vLog := fMain.FrameFirst1.EditName.text;
  vPas := fMain.FrameFirst1.EditPas.text;

  // проверка логина и пароля
  if (pos('@', vLog) > 0) and (pos('.', vLog) > 0) then
    vOk := true
  else
    vOk := false;

  // проверка на сервере подлинность
  OAuth2 := TOAuth.Create;
  vResponce := OAuth2.UserGet('name='+vLog);
  edit2.Text :=  vResponce;
  OAuth2.Free;

  // реакция
  if vOk = false then
  // ошибка идентификации
  begin
    fMain.FrameFirst1.LabelError.Visible := true;
    fMain.FrameFirst1.LabelForgot.Visible := true;
  end
  else
  // идентификация успешна
  begin
    uQ.SaveReestr('Name',vLog);
    LabelMail.text := fMain.FrameFirst1.EditName.text;
    fMain.FrameFirst1.LabelError.Visible := false;
    fMain.FrameFirst1.LabelForgot.Visible := false;
    fMain.Button1Click(Sender);
    // загрузим видимость каналов
    fMain.ButtonSelChannelsClick(Sender);
  end;
end;


// ОБРАБОТКА  поступление согласлования или не согласования выдачи прав на канал пользователем
procedure TfMain.TCPServerYouTubeAnswersExecute(AContext: TIdContext);
const
  cNameFile: string = 'AccessCode';
var
  Port: Integer;
  PeerPort: Integer;
  PeerIP: string;

  msgFromClient: string;
  vPosBegin, vPosEnd: Integer;
  vAccessCode: string;  // код доступа к каналу

  vPath: string;
  vFullNameFile: string;
  vFileText: TStringList;

begin
  vAccessCode := '';
  msgFromClient := AContext.Connection.IOHandler.ReadLn;

  PeerIP := AContext.Binding.PeerIP;
  PeerPort := AContext.Binding.PeerPort;

  if Pos('GET', msgFromClient) > 0 then
  begin
    if Pos('error=', msgFromClient) = 0 then
    begin
      vPosBegin := Pos('code=', msgFromClient);
      vPosEnd := Pos('scope=', msgFromClient);
      if (vPosBegin > 0) and (vPosEnd > 0) then
      begin
        vPosBegin := vPosBegin + 5;
        vAccessCode := copy(msgFromClient, vPosBegin, vPosEnd - vPosBegin - 1);
//        vAccessCode := msgFromClient;
        // промежуточное хранение сохраняем для передачи в процедуру сохранения канала
        Edit1.Text := vAccessCode;
        if vAccessCode <> '' then
        begin
          vPath := GetCurrentDir();
          vFullNameFile := vPath + '/' + cNameFile;
          vFileText := TStringList.Create;
          vFileText.Add(vAccessCode);
          // сохраняем
          vFileText.SaveToFile(vFullNameFile);
        end;
      end;
      AContext.Connection.IOHandler.WriteLn('HTTP/1.0 200 OK');
      AContext.Connection.IOHandler.WriteLn('Content-Type: text/html');
      AContext.Connection.IOHandler.WriteLn('Connection: close');
      AContext.Connection.IOHandler.WriteLn;
      AContext.Connection.IOHandler.write('<html>');
      AContext.Connection.IOHandler.write('<head>');
      AContext.Connection.IOHandler.
        write('<meta HTTP-EQUIV="Content-Type" Content="text-html; charset=windows-1251">');
      AContext.Connection.IOHandler.
        write('<title>"AssistIQ connected!</title>');
      AContext.Connection.IOHandler.write('</head>');

      AContext.Connection.IOHandler.write('<body bgcolor="white">');
      AContext.Connection.IOHandler.write(' <p>&nbsp;</p>');
      AContext.Connection.IOHandler.
        write('<h3 style="text-align: center; color: #ff2a2;">Everything ended successfully. You can close this window.</h3>');
      AContext.Connection.IOHandler.
        write('<p style="text-align: center;"><img style="text-align: center;" src="http://suyarkov.com/wp-content/uploads/2023/04/AssistTranslateYT_240.jpg" />');
      // write('<p style="text-align: center;"><img style="text-align: center;" src="https://play-lh.googleusercontent.com/-v_3PwP5PejV308DBx8VRtOWp2W_nkgIBZOt1X536YwGD7ytPPI2of2h3hG_uk7siAuh=w240-h480-rw" />');

      AContext.Connection.IOHandler.write('</p>');
      AContext.Connection.IOHandler.
        write('<h3 style="text-align: center; color: #ff2a2;">Thank you for being with us. Team "AssistIQ"</h3>');
      AContext.Connection.IOHandler.write('</body>');

      AContext.Connection.IOHandler.write('</html>');
      AContext.Connection.IOHandler.WriteLn;
      EdAccessCode :=  vAccessCode;
      // вызов процедуры запроса данных по каналу и их сохранение
      //BGetTokkens.OnClick(fMain);
      //BGetChannel.OnClick(fMain);
    end
    else
    begin
      AContext.Connection.IOHandler.WriteLn('HTTP/1.0 200 OK');
      AContext.Connection.IOHandler.WriteLn('Content-Type: text/html');
      AContext.Connection.IOHandler.WriteLn('Connection: close');
      AContext.Connection.IOHandler.WriteLn;
      AContext.Connection.IOHandler.write('<html>');
      AContext.Connection.IOHandler.write('<head>');
      AContext.Connection.IOHandler.
        write('<meta HTTP-EQUIV="Content-Type" Content="text-html; charset=windows-1251">');
      AContext.Connection.IOHandler.
        write('<title>AssistIQ connected!</title>');
      AContext.Connection.IOHandler.write('</head>');

      AContext.Connection.IOHandler.write('<body bgcolor="white">');
      AContext.Connection.IOHandler.write(' <p>&nbsp;</p>');
      AContext.Connection.IOHandler.
        write('<h3 style="text-align: center; color: #ff2a2;">Not connected. You can close this window.</h3>');
      AContext.Connection.IOHandler.
        write('<p style="text-align: center;"><img style="text-align: center;" src="http://suyarkov.com/wp-content/uploads/2023/04/AssistTranslateYT_240.jpg" />');
      // write('<p style="text-align: center;"><img style="text-align: center;" src="https://play-lh.googleusercontent.com/-v_3PwP5PejV308DBx8VRtOWp2W_nkgIBZOt1X536YwGD7ytPPI2of2h3hG_uk7siAuh=w240-h480-rw" />');

      AContext.Connection.IOHandler.write('</p>');
      AContext.Connection.IOHandler.
        write('<h3 style="text-align: center; color: #ff2a2;">What a pity. Team "AssistIQ"</h3>');
      AContext.Connection.IOHandler.write('</body>');

      AContext.Connection.IOHandler.write('</html>');
      AContext.Connection.IOHandler.WriteLn;
      EdAccessCode :=  '';
    end;
    // IdTCPServer1.Active := false;
    Edit2.Text := 'чудо !!';
  end
  else
  begin
     Edit2.Text := msgFromClient;
  end;
  // а вот тут танцы с бубнами как же прикрыть работу сервера
//  AContext.Connection.IOHandler.CloseGracefully;
//  AContext.Connection.Socket.CloseGracefully;
//  AContext.Connection.Socket.Close;

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
  vIdChannel := PanChannels[vNPanel].chId.text;
  vNameChannel := PanChannels[vNPanel].ChName.text;
  strQuestionDelete := 'Delete 3' + vNameChannel + ' ?';

  if FMX.Dialogs.MessageDlg(strQuestionDelete, TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo) = mrYes
  then
  begin
     SQLiteModule.DelChannel(vIdChannel);

    try
      for i := 1 to 50 do
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
  vMessage, vIdChannel, vNameChannel, vToken: string;
  vNPanel: integer;
  NewThread: TNewThread;

  vObjVideo : TObjvideo;
  S: string;
  i, vPosY: integer;
  vVideo : TVideo;

  AAPIUrl: String;
  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  Bitimg: TBitmap;
//  vPanVideo: array [1 .. 1000] of TVideoPanel;
begin
  vNPanel := TButton(Sender).Tag;
  vIdChannel := PanChannels[vNPanel].chId.text;
  // vToken := PanChannels[vNPanel].chToken.Caption;
  vNameChannel := PanChannels[vNPanel].ChName.text;
  vToken := PanChannels[vNPanel].chToken.Text;
  // Для сообщения при отладке что нажали
  //  vMessage := 'Click ' + vNameChannel + ' !' + vIdChannel + ' ' +
  //  IntToStr(vNPanel);
  //  showmessage(vMessage);
  FrameMainChannel.ImageChannel.Bitmap := PanChannels[vNPanel].ChImage.Bitmap;
  FrameMainChannel.Label1.text := vNameChannel;
  FrameMainChannel.Label2.text := vIdChannel;
  FrameMainChannel.Label3.text := vToken;
  // запрос на сервер по видео на канале, но нужно бы ещё перед этим и рисунок грузануть
  fMain.Button200Click(Sender);
  //  vResponceVideo -- проверить на первые символы есть ли они до {, если есть то обработать ошибку
  //Наполняем панель видео

  s := '0';
  vObjVideo:= TObjvideo.Create;
  // в мемо должен быть уже строка с канала
  vObjVideo := TJson.JsonToObject<TObjvideo>(vResponceVideo);


  for i := 0 to Length(vObjVideo.Items) - 1 do
  begin
    vVideo.videoId := vObjVideo.Items[i].id.videoId;
    vVideo.channelId := vObjVideo.Items[i].snippet.channelId;
    vVideo.title := vObjVideo.Items[i].snippet.title;
    vVideo.description := vObjVideo.Items[i].snippet.description;
    vVideo.urlDefault := vObjVideo.Items[i].snippet.thumbnails.default.url;
    vVideo.publishedAt := vObjVideo.Items[i].snippet.publishedAt;
    vVideo.publishTime := vObjVideo.Items[i].snippet.publishTime;
       // решил тут не грузить видео по урлу, сделаю это внутри панели
    try
      S := StringReplace(vVideo.urlDefault, #13, '', [rfReplaceAll, rfIgnoreCase]);
      AAPIUrl := StringReplace(S, #10, '', [rfReplaceAll, rfIgnoreCase]);
      FHTTPClient := THTTPClient.Create;
      FHTTPClient.UserAgent :=
        'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
      try
        AResponce := FHTTPClient.Get(AAPIUrl);
      except
        showmessage('нет подключения');
      end;
      if Not Assigned(AResponce) then
      begin
        showmessage('Пусто');
      end;

      Bitimg := TBitmap.Create;
      Bitimg.LoadFromStream(AResponce.ContentStream);
      vVideo.img := TBitmap.Create;
      vVideo.img := Bitimg;
    except
       showmessage('Что except load video');
    end;

    vPosY := 30 + (i) * 120;
                                                          //PanelVideos
    PanVideos[i+1] := TVideoPanel.Create(FrameMainChannel.BoxVideos, vPosY, i+1,
        vVideo.videoId,
        vVideo.channelId,
        vVideo.title,
        vVideo.description,
        'нету',
        vVideo.img);
      PanVideos[i+1].Parent := FrameMainChannel.BoxVideos;

      //PanChannels[i].ButtonDel.OnClick := DinButtonDeleteChannelClick;
      //PanChannels[i].OnMouseMove := DinPanelMouseMove;
      PanVideos[i+1].OnClick := DinPanelVideoClick; // Type (sender, 'TPanel');
      PanVideos[i+1].VdImage.OnClick := DinPanelVideoClick;
      //vPanVideo[i+1].VdTitle.OnClick := DinPanelVideoClick;
      //vPanVideo[i+1].VdDescription.OnClick := DinPanelVideoClick;

  end;
  //
  vEventMove := vState * 10 + 1;
  vState := 3;
  ButtonBack.Enabled := true;
  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;

end;


// Нажатие для выбора видео
procedure TfMain.DinPanelVideoClick(Sender: TObject);
const
  tokenurl = 'https://accounts.google.com/o/oauth2/token';
var
  vMessage, vTitle, vDescription, vToken: string;
  vNPanel: integer;
  NewThread: TNewThread;

  vObjVideo : TObjvideo;
  S: string;
  i, vPosY: integer;
  vVideo : TVideo;

  AAPIUrl: String;
  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  Bitimg: TBitmap;
//  vPanVideo: array [1 .. 1000] of TVideoPanel;
begin
  vNPanel := TButton(Sender).Tag;
  vTitle := PanVideos[vNPanel].VdTitle.text;
  vDescription := PanVideos[vNPanel].VdDescription.text;
//  vIdChannel := PanVideos[vNPanel].chId.text;
  // vToken := PanChannels[vNPanel].chToken.Caption;
//  vNameChannel := PanChannels[vNPanel].ChName.text;
//  vToken := PanChannels[vNPanel].chToken.Text;

  // Для сообщения при отладке что нажали
  vMessage := 'Click ' + vTitle + ' !' + vDescription + ' ' + IntToStr(vNPanel);
  showmessage(vMessage);

//  showmessage(vPanVideo[1].VdTitle.Text);
  FrameVideos.ImageVideo.Bitmap := PanVideos[vNPanel].VdImage.Bitmap;
  FrameVideos.MemoTitle.Text := PanVideos[vNPanel].VdTitle.Text;
  FrameVideos.MemoDescription.Text := PanVideos[vNPanel].VdDescription.Text;
  {
  FrameMainChannel.ImageChannel.Bitmap := PanChannels[vNPanel].ChImage.Bitmap;
  FrameMainChannel.Label1.text := vNameChannel;
  FrameMainChannel.Label2.text := vIdChannel;
  FrameMainChannel.Label3.text := vToken;
  // запрос на сервер по видео на канале, но нужно бы ещё перед этим и рисунок грузануть
  fMain.Button200Click(Sender);
  //  vResponceVideo -- проверить на первые символы есть ли они до {, если есть то обработать ошибку
  //Наполняем панель видео

  s := '0';
  vObjVideo:= TObjvideo.Create;
  // в мемо должен быть уже строка с канала
  vObjVideo := TJson.JsonToObject<TObjvideo>(vResponceVideo);


  for i := 0 to Length(vObjVideo.Items) - 1 do
  begin
    vVideo.videoId := vObjVideo.Items[i].id.videoId;
    vVideo.channelId := vObjVideo.Items[i].snippet.channelId;
    vVideo.title := vObjVideo.Items[i].snippet.title;
    vVideo.description := vObjVideo.Items[i].snippet.description;
    vVideo.urlDefault := vObjVideo.Items[i].snippet.thumbnails.default.url;
    vVideo.publishedAt := vObjVideo.Items[i].snippet.publishedAt;
    vVideo.publishTime := vObjVideo.Items[i].snippet.publishTime;
       // решил тут не грузить видео по урлу, сделаю это внутри панели
    try
      S := StringReplace(vVideo.urlDefault, #13, '', [rfReplaceAll, rfIgnoreCase]);
      AAPIUrl := StringReplace(S, #10, '', [rfReplaceAll, rfIgnoreCase]);
      FHTTPClient := THTTPClient.Create;
      FHTTPClient.UserAgent :=
        'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
      try
        AResponce := FHTTPClient.Get(AAPIUrl);
      except
        showmessage('нет подключения');
      end;
      if Not Assigned(AResponce) then
      begin
        showmessage('Пусто');
      end;

      Bitimg := TBitmap.Create;
      Bitimg.LoadFromStream(AResponce.ContentStream);
      vVideo.img := TBitmap.Create;
      vVideo.img := Bitimg;
    except
       showmessage('Что except load video');
    end;

    vPosY := 30 + (i) * 120;
                                                          //PanelVideos
    vPanVideo[i+1] := TVideoPanel.Create(FrameMainChannel.BoxVideos, vPosY, i+1,
        vVideo.videoId,
        vVideo.channelId,
        vVideo.title,
        vVideo.description,
        'нету',
        vVideo.img);
      vPanVideo[i+1].Parent := FrameMainChannel.BoxVideos;
      {
      PanChannels[i].ButtonDel.OnClick := DinButtonDeleteChannelClick;
      PanChannels[i].OnMouseMove := DinPanelMouseMove;
      PanChannels[i].OnClick := DinPanelClick; // Type (sender, 'TPanel');
      PanChannels[i].ChImage.OnClick := DinPanelClick;
      PanChannels[i].ChName.OnClick := DinPanelClick;
      PanChannels[i].ChLang.OnClick := DinPanelClick;

  end;
  //
  }

  vEventMove := vState * 10 + 1;
  vState := 4;
  ButtonBack.Enabled := true;
  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;

end;

end.
