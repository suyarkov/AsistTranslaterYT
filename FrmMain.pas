unit FrmMain;

interface

uses
  // MimeDelpta,
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Net.HTTPClient,
  System.NetEncoding,
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
  // IdMessageClient, //IdSMTPBase, IdSMTP,
  Classes.shearche.image,
  uEmailSend, uQ,
  Classes.channel.statistics, FmMainChannel, FmVideos,
  Classes.videoInfo, Classes.subtitlelist,
  Classes.title, Classes.snippet, Classes.snippetInsert,
  uLanguages, FmLanguages, PnLanguage, uTranslate,
  FmAsk, FmInfo, FmAddUser, FmTextInput, FMX.Colors,
  FmHelp, FmAddMoney, System.ImageList, FMX.ImgList,
  //IdSocketHandle,
  IdGlobal;

type
  TfMain = class(TForm)
    PanelTop: TPanel;
    FrameFirst: TFrameFirst;
    PanelButton: TPanel;
    LabelMail: TLabel;
    LabelCopyrigth: TLabel;
    ButtonBack: TButton;
    FrameChannels: TFrameChannels;
    TCPServerYouTubeAnswers: TIdTCPServer;
    FrameVideos: TFrameVideos;
    FrameLanguages: TFrameLanguages;
    PanelAlpha_ForTest: TPanel;
    BGetTokkens: TButton;
    BGetChannel: TButton;
    Edit2: TEdit;
    ButtonSelChannels: TButton;
    Button200: TButton;
    Label2: TLabel;
    Image3: TImage;
    Button5: TButton;
    Button6: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    ButtonPaint: TButton;
    Edit4: TEdit;
    Memo1: TMemo;
    ButtonQ: TButton;
    ButtonEmail2: TButton;
    MyStyleBook: TStyleBook;
    AniIndicator1: TAniIndicator;
    TestAniingicator: TButton;
    ButtonUpdate: TButton;
    LabelYouTube: TLabel;
    ButtonHelp: TButton;
    Panel1: TPanel;
    LabelScore: TLabel;
    ButtonMon�y: TButton;
    ButtonMoneyInfo: TButton;
    ImageDel: TImage;
    FrameMainChannel: TFrameMainChannel;
    SpeedButton1: TSpeedButton;
    ImageList1: TImageList;
    FrameProgressBar: TFrameProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure FrameFirstButtonLogClick(Sender: TObject);
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
    procedure ButtonVideoInfoClick(Sender: TObject);
    procedure FrameVideosBTranslaterClick(Sender: TObject);
    procedure DinLanguageClick(Sender: TObject);
    procedure PanelButtonClick(Sender: TObject);
    procedure FrameFirstImage0Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FrameLanguagesButtonTitleClick(Sender: TObject);
    procedure FrameLanguagesButtonSubtitlesClick(Sender: TObject);
    procedure FrameFirstButtonRegClick(Sender: TObject);
    procedure TestAniingicatorClick(Sender: TObject);
    procedure ButtonMoneyInfoClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonMon�yClick(Sender: TObject);
    procedure FrameMainChannelButtonAddNextVideoClick(Sender: TObject);
    function TestScore(Sender: TObject; pCount: integer): integer;
    procedure StartProgressBar(Sender: TObject);
    procedure FinishProgressBar(Sender: TObject);
    procedure FrameLanguagesButtonAddAllLanguagesClick(Sender: TObject);
    procedure FrameLanguagesButtonDelAllLanguagesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    MsgInfoUpdate: string; // '���� ����������!'
    iScore: integer;
    sVersion: string;

  public
    { Public declarations }
    function FrameAsk(Sender: TObject; AskText: string): integer;
    function FrameTextInput(Sender: TObject; AskText: string): string;
    procedure FrameInfo(Sender: TObject; InfoText: string; Status: integer = 0);
    procedure FrameInfoError(Sender: TObject; InfoText: string);
    procedure FrameHelp(Sender: TObject; InfoText: string);
    procedure FrameAddMoney(Sender: TObject; InfoText: string);

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
  PanLanguages: array [1 .. 300] of TLanguagePanel;
  vEventMove: integer; // 10 - �������, 11- ������. ������ �����
  vState: integer; // 1 - ������ ����� - ������,// 2 ������ ����� ������,
  // 3 ������ - ���� ����� // 4- ���������� ����� // 5 - ����
  // PanVideos: array [1 .. 50] of TMyVideoPanel;
  lastPanel: TPanel;
  vDefaultColor: TAlphaColor;
  vProgressBarStatus: integer;
  GlobalProgressThread: TProgressThread;
  FrameProgressEndLess: TFrameProgressEndLess;
  vResponceChannel: string;
  vResponceVideo: string;
  vResponceInfoVideo: string;
  EdAccessCode: string;
  EdRefresh_token: string;
  EdAccess_token: string;
  vCurrentPanChannel: integer;
  vGlobalList: TListLanguages;
  vInterfaceLanguage: string;
  vTotalCountVideo, vNowCountVideo: integer;
  vnextPageTokenVideo: string;
  vClientId: integer;

implementation

{$R *.fmx}

// ��������� ������ �������� ����!!!
procedure TfMain.FinishProgressBar(Sender: TObject);
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
  showmessage('FinishBar');
end;

// ������ ������ �������� ����!!!
procedure TfMain.StartProgressBar(Sender: TObject);
var
  aShape: TShape;
  r, x0, y0: integer;
  ProgressThread: TProgressThread;
begin
  // r:=100;     // ������
  // x0:=300;   // ���������� ������
  // y0:=200;   // ���������� ������
  // image1.Canvas.(FMX.Objects.DrawEllipse(x0, y0, r)); //.Ellipse(x0-r,y0-r,x0+r,y0+r);
  //
  // image1.canvas.
  if Assigned(GlobalProgressThread) then
  begin
    if GlobalProgressThread.Terminated = false or
      GlobalProgressThread.Terminated = true then
    begin
      if GlobalProgressThread.Terminated = true then
      begin
        GlobalProgressThread.Free;
      end
    end
  end;
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
    GlobalProgressThread.Resume;
  end;
  FrameProgressBar.Visible := true;
  // showmessage('startBar');
end;

// �������� ������ �� �� ��������� �������
function TfMain.TestScore(Sender: TObject; pCount: integer): integer;
var
  res, i: integer;
  results: tDataSet;
begin
  res := 0;
  if pCount > iScore then
  begin
    res := pCount - iScore;
    // �������� �������
    FrameInfo(Sender, '��������� ' + IntToStr(res) + ' ���������!' + #13 + #10 +
      ' ��������� ������!');
  end;

  Result := 0; // res;
end;

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
    // ���������� ��������, ��� ������� �������� ����,
    // ����� ����� ���������� �������� ����� ��� ������ ������� ��� �������
    lastPanel := panel;
  end;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // TCPServerYouTubeAnswers.Active := false;
  // TCPServerYouTubeAnswers.Destroy;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  sVersion := '0.0.1. 01';
  fMain.Caption := 'AssistIQ ' + sVersion;
  // !!!!!!!!
  // !!!!!!!! ���� ����� ��������� ������ ��� ������������ �� ��� ���� ��������
  fMain.PanelAlpha_ForTest.Visible := false;
  fMain.PanelAlpha_ForTest.Position.X := 0;

  fMain.LabelMail.text := '';
  fMain.Width := 871;
  lastPanel := nil;
  vState := 1; // ������
  vInterfaceLanguage := 'en';
  vDefaultColor := TAlphaColors.Gray;
  // fMain.Fill.Color; // as TRectangle).Stroke.Color
  // �� ������ �������� �����
  fMain.FrameFirst.Position.X :=
    Round((fMain.Width - fMain.FrameFirst.Width) / 2);
  fMain.FrameFirst.Position.Y := // 56;
    Round((fMain.Height - fMain.FrameFirst.Height - 200) / 2);

  // ������� ������ ����� �� ������� ���������
  fMain.FrameChannels.Position.X := Round(fMain.Width + 1);
  fMain.FrameChannels.Position.Y := 35;

  // ������� ������ ����� �� ������� ���������
  fMain.FrameMainChannel.Position.X := Round(fMain.Width + 1);
  fMain.FrameMainChannel.Position.Y := 20;

  // ������� ��������� ����� �� ������� ���������
  fMain.FrameVideos.Position.X := Round(fMain.Width + 1);
  fMain.FrameVideos.Position.Y := 56;

  // ������� ����� (�����) ����� �� ������� ���������
  fMain.FrameLanguages.Position.X := Round(fMain.Width + 1);
  fMain.FrameLanguages.Position.Y := 56;
  FrameProgressBar.Visible := false;

  if not Assigned(FrameProgressEndLess) then
  begin
    FrameProgressEndLess := TFrameProgressEndLess.Create(Self);
    FrameProgressEndLess.Visible := false;
    FrameProgressEndLess.Parent := fMain;
    FrameProgressEndLess.Align := TAlignLayout.Center;
  end;

  fMain.FrameFirst.EditName.text := uQ.LoadReestr('Name');

end;

procedure TfMain.FormShow(Sender: TObject);
var
  i, j: integer;
  vAppLocalization: TAppLocalization;
  vResponce, vTemp: string;
  OAuth2: TOAuth;
  vList: TListLanguages;
begin
  OAuth2 := TOAuth.Create;
  // �������� ����� � ��� ���������
  vInterfaceLanguage := uQ.LoadReestr('Local');
  // ��������� ���� ����������, ���� ������ �� �������� !!

  // ��������� �������� ������� ��� ����������
  vAppLocalization := SQLiteModule.GetAppLocalization(vInterfaceLanguage);

  // ���������� ������� �� ��� ������!
  MsgInfoUpdate := vAppLocalization.MsgInfoUpdate;

  LabelYouTube.text := vAppLocalization.PanelTop_LabelYouTube;
  ButtonMon�y.text := vAppLocalization.PanelTop_ButtonMon�y;
  ButtonUpdate.text := vAppLocalization.PanelTop_ButtonUpdate;

  FrameFirst.SetLang(vAppLocalization.First_LabelName,
    vAppLocalization.First_LabelPas, vAppLocalization.First_ButtonLog,
    vAppLocalization.First_ButtonReg);
  FrameChannels.SetLang(vAppLocalization.Channels_LabelChannels,
    vAppLocalization.Channels_ButtonAddChannel);
  FrameMainChannel.SetLang(vAppLocalization.MainChannel_LabelNameChannel,
    vAppLocalization.MainChannel_ButtonAddNextVideo);
  FrameVideos.SetLang(vAppLocalization.MainVideos_LabelVideos,
    vAppLocalization.MainVideos_LanguageCheckBox,
    vAppLocalization.MainVideos_LabelTitle,
    vAppLocalization.MainVideos_LabelDescription,
    vAppLocalization.MainVideos_BTranslater);

  // �������� ������
  vResponce := OAuth2.Version();
  // ������ ��������� ������, ������� = ';'
  if vResponce <> '' then
  begin
    vResponce := Copy(vResponce, 1, Length(vResponce) - 1);
  end;

  if ((vResponce <> sVersion) and (vResponce <> '')) then
  begin
    FrameInfo(Sender, '����� ����� ������ ��������� - ' + vResponce + '!');
  end;


  // FrameFirst.ButtonLog.text := GoogleTranslate(FrameFirst.ButtonLog.text, 'en',
  // vInterfaceLanguage);

  // �������� ��������� ����� �������
  vGlobalList := SQLiteModule.LoadLanguage();
  iScore := SQLiteModule.GetScore();
  LabelScore.text := IntToStr(iScore);
  // ��������� �������� ������ �� ���� ���������
  // TranslateListLanguages(vInterfaceLanguage, vGlobalList);

  // '���� ���� ����������!' - �� ���� �������� ���.
  {
    vResponce := OAuth2.Version();
    FrameInfo(Sender, vResponce);
    if vResponce <> '01.01.01' then
    FrameInfo(Sender, MsgInfoUpdate);
  }

  // ���������� ���������� ���������� ������ � ����� ����� ����������
  vList := vGlobalList;
  i := 1;
  repeat
    fMain.FrameVideos.LanguageComboBox.Items.Add(vList[i].LnCode);
    inc(i);
  until (i >= 300) or (vList[i].LnCode = '');

  // ����������� �������� � ����������
  for i := 0 to fMain.FrameVideos.LanguageComboBox.Items.Count - 1 do
    for j := i + 1 to fMain.FrameVideos.LanguageComboBox.Items.Count - 1 do
      if CompareStr(fMain.FrameVideos.LanguageComboBox.Items[i],
        fMain.FrameVideos.LanguageComboBox.Items[j]) > 0 then
      begin
        vTemp := fMain.FrameVideos.LanguageComboBox.Items[i];
        fMain.FrameVideos.LanguageComboBox.Items[i] :=
          fMain.FrameVideos.LanguageComboBox.Items[j];
        fMain.FrameVideos.LanguageComboBox.Items[j] := vTemp
      end;
  // � ������ �� ��������� fMain.FrameVideos.LanguageComboBox.Sorted := true;

end;

// ������ ������ �� �����
// ������ ����������� ������ � vResponceChannel �� ������ �� ������� youtube � �������� ��������� �������� �������
procedure TfMain.BGetChannelClick(Sender: TObject);
var
  vObj: Tchannel; // Tchannel;
  res, i: integer;
  urlget: string;
  vChannel: TShortChannel;
  // vTest : Tshearche_image;
  vImgUrl: string;
  // S: AnsiString;
  Bitimg: TBitmap;
  S: string;
  AAPIUrl: String;
  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  Stream: TStream;
begin
  S := '0';
  vObj := Tchannel.Create;
  // � ���� ������ ���� ��� ������ � ������
  vObj := TJson.JsonToObject<Tchannel>(Memo1.text);

  for i := 0 to Length(vObj.Items) - 1 do
  begin
    vChannel.id_channel := vObj.Items[i].id;
    vChannel.name_channel := vObj.Items[i].snippet.title;
    vChannel.lang := vObj.Items[i].snippet.country;
    // vChannel.lang :=vObj.Items[i].snippet.defaultLanguage;
    vImgUrl := vObj.Items[i].snippet.thumbnails.default.URL;
    Edit4.text := vImgUrl;
    // try
    S := StringReplace(Edit4.text, #13, '', [rfReplaceAll, rfIgnoreCase]);
    AAPIUrl := StringReplace(S, #10, '', [rfReplaceAll, rfIgnoreCase]);
    FHTTPClient := THTTPClient.Create;
    FHTTPClient.UserAgent :=
      'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
    try
      AResponce := FHTTPClient.Get(AAPIUrl);
    except
      showmessage('��� �����������_1');
    end;
    if Not Assigned(AResponce) then
    begin
      showmessage('�����');
    end;

    Bitimg := TBitmap.Create;
    Bitimg.LoadFromStream(AResponce.ContentStream);
    vChannel.img := TBitmap.Create;
    vChannel.img := Bitimg;
    vChannel.img_channel := TBlobType(Bitimg);
    { except                                                                         ��
      showmessage('��� except');
      end; }

    vChannel.refresh_token := EdRefresh_token;
    if vChannel.lang = '' then
    begin
      vChannel.lang := vObj.Items[i].snippet.defaultLanguage;
    end;
    // vChannel.sel_lang := vObj.;
    vChannel.deleted := 0;
    res := SQLiteModule.InsRefreshToken(vChannel);
  end;

end;

// ������ ��������� ������� ������ �� ����������� ����� �������  � Edit1.Text
// � �������� �������
procedure TfMain.BGetTokkensClick(Sender: TObject);

var
  Access_token: string; // ����� ���������� ��������
  refresh_token: string; // ����� ��������� ���������� ������ �� ����������

  OAuth2: TOAuth;
  vString: string;

begin
  if EdAccessCode <> '' then
  begin

    OAuth2 := TOAuth.Create;
    OAuth2.ClientID :=
      '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
    OAuth2.ClientSecret := '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';
    OAuth2.ResponseCode := EdAccessCode; // Edit1.Text;//
    // Edit1.text := EdAccessCode;

    Access_token := OAuth2.GetAccessToken;
    refresh_token := OAuth2.refresh_token;

    Edit4.text := Access_token + ' ��� ' + refresh_token;

    vResponceChannel := OAuth2.MyChannels;
    Memo1.text := vResponceChannel;
    OAuth2.Free;
    EdRefresh_token := refresh_token;
    BGetChannelClick(Sender);
    ButtonSelChannelsClick(Sender); // ���������� �� ������!!!
    EdAccessCode := ''; // ���� ������ ��� �� �����
  end;
  if TCPServerYouTubeAnswers.Active = true then
  begin
    TThread.Queue(nil,
      procedure
      var      i: integer;
      begin
        TCPServerYouTubeAnswers.Active := false;
      for I := 0 to TCPServerYouTubeAnswers.Bindings.Count - 1 do
        begin
          TCPServerYouTubeAnswers.Bindings[i].ReuseSocket := TIdReuseSocket.rsTrue; // TIdSocketHandleReuseSocket.rsTrue;
        end;
      end);
  end;

end;

// ������ ����� ��� ��
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

// �������� ������ ����� �� ������
procedure TfMain.Button200Click(Sender: TObject);
var
  Access_token: string; // ����� ���������� ��������
  refresh_token: string; // ����� ��������� ���������� ������ �� ����������

  OAuth2: TOAuth;
  vString: string;
begin
  OAuth2 := TOAuth.Create;
  OAuth2.ClientID :=
    '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
  OAuth2.ClientSecret := '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';
  // ������ �����
  OAuth2.refresh_token := FrameMainChannel.Label4.text;
  vResponceVideo := OAuth2.MyVideos(FrameMainChannel.Label5.text);
  // � �� ������ ������ ���� ��������, ���� ���������� �� ������ ������ �����
  vResponceChannel := OAuth2.MyChannels;
  // showmessage(vResponceChannel);
  // Memo1.Text := vResponceVideo;
  OAuth2.Free;
end;

// ����� ��� �������� ����
procedure TProgressThread.Execute;
var
  i, vTransCount: integer;
  vTitle, vDescription, vTranslateTitle, vTranslateDescription: string;
  vObjTitle: Ttitle; // Tchannel;
  vJSON: string;
  vJSON_tmp: string;
begin
  { for i := 0 to fMain.Width do
    begin
    // sleep(1);
    Progress := i;
    Synchronize(SetActualFrame);
    end; }
  fMain.FrameProgressBar.Visible := true;
  Application.ProcessMessages;
  vTitle := fMain.FrameVideos.MemoTitle.text;
  vDescription := fMain.FrameVideos.MemoDescription.text;
  vTransCount := 0;
  for i := 1 to 300 do
  begin
    if PanLanguages[i] = nil then
      break;
    if (PanLanguages[i].ChImage.Visible = true) and
      (PanLanguages[i].ChLang.text <> fMain.FrameVideos.LanguageVideoLabel.text)
    then
    begin
      vTranslateTitle := GoogleTranslate(vTitle,
        fMain.FrameVideos.LanguageVideoLabel.text, PanLanguages[i].ChLang.text);
      vTranslateDescription := GoogleTranslate(vDescription,
        fMain.FrameVideos.LanguageVideoLabel.text, PanLanguages[i].ChLang.text);

      // ��������� ������ JSON
      if vTransCount > 0 then // ���������, ���� ��� ��� ������
        vJSON := vJSON + ',';
      vObjTitle := Ttitle.Create;
      vObjTitle.title := vTranslateTitle;
      vObjTitle.description := vTranslateDescription;
      vJSON_tmp := TJson.ObjectToJsonString(vObjTitle);
      // showmessage(vJSON_tmp);
      vObjTitle.Free;
      vJSON := vJSON + '"' + PanLanguages[i].ChLang.text + '" :' + vJSON_tmp;
      // ��� �� �������� � �������!!!
      // {"title":"' + vTranslateTitle // ��������
      // + '","description": "' + vTranslateDescription + '"}';
      inc(vTransCount);
    end;
  end;
  showmessage('df');
  fMain.FrameProgressBar.Visible := false;
end;

procedure TProgressThread.SetActualProgress;
begin
  fMain.Label2.text := IntToStr(vProgressBarStatus);
  fMain.FrameProgressBar.SetProgress(vProgressBarStatus, vProgressBarStatus);
  // FrameProgressEndLess.SetProgress(vProgressBarStatus);
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
  { for i := 0 to 2000 do
    begin
    inc(vProgressBarStatus);
    Synchronize(SetActualProgress);
    end; }
end;

// ��������� ����������� ������
procedure TNewThread.SetActualFrame;
var
  vLeftBorderFrame, vStepSize, vLeftBorderFrame2, vLeftBorderFrame3,
    vLeftBorderFrame4, vLeftBorderFrame5: integer;
begin
  vStepSize := fMain.Width; // 10;
  vLeftBorderFrame := Round((fMain.Width - fMain.FrameFirst.Width) / 2);
  vLeftBorderFrame2 := Round((fMain.Width - fMain.FrameChannels.Width) / 2);
  vLeftBorderFrame3 := Round((fMain.Width - fMain.FrameMainChannel.Width) / 2);
  vLeftBorderFrame4 := Round((fMain.Width - fMain.FrameVideos.Width) / 2);
  vLeftBorderFrame5 := Round((fMain.Width - fMain.FrameLanguages.Width) / 2);

  // ������ ����� ���������� ������ � ��������
  if vEventMove = 11 then
  begin
    If fMain.FrameFirst.Position.X < (fMain.Width + 1) then
    begin
      fMain.FrameFirst.Position.X := fMain.FrameFirst.Position.X + vStepSize;
    end;

    If fMain.FrameChannels.Position.X >= fMain.Width then
    begin
      fMain.FrameChannels.Position.X := -fMain.FrameChannels.Width - 1;
    end;

    If fMain.FrameChannels.Position.X < (vLeftBorderFrame2) then
    begin
      // ���� ����� ������ ���� ������ �� ����� ������� ��������� �����
      if ABS(fMain.FrameChannels.Position.X - vLeftBorderFrame2) > vStepSize
      then
        fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X +
          vStepSize
      else // ���� ��� ������, �� ������ ��������� ����� � ������ �����
        fMain.FrameChannels.Position.X := vLeftBorderFrame2;
    end;

    If fMain.FrameChannels.Position.X = (vLeftBorderFrame2) then
    begin
      fMain.FrameChannels.Visible := true;
    end;

  end;

  // ����� � �������� ���������� ������ � �������
  if vEventMove = 10 then
  begin
    If fMain.FrameFirst.Position.X > vLeftBorderFrame then
    begin
      // ���� ����� ������ ���� ������ �� ����� ������� ��������� �����
      if fMain.FrameFirst.Position.X - vLeftBorderFrame > vStepSize then
        fMain.FrameFirst.Position.X := fMain.FrameFirst.Position.X - vStepSize
      else // ���� ��� ������, �� ������ ��������� ����� � ������ �����
        fMain.FrameFirst.Position.X := vLeftBorderFrame;
    end;

    If fMain.FrameChannels.Position.X > -fMain.FrameChannels.Width then
    begin
      fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X -
        vStepSize;
    end;

  end;

  // ������ ����� ���������� ������� � ��������  FrameMainChannel
  if vEventMove = 21 then
  begin
    If fMain.FrameChannels.Position.X < (fMain.Width + 1) then
    begin
      fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X +
        vStepSize;
    end;

    If fMain.FrameMainChannel.Position.X >= fMain.Width then
    begin
      fMain.FrameMainChannel.Position.X := -fMain.FrameMainChannel.Width - 1;
    end;

    If fMain.FrameMainChannel.Position.X < (vLeftBorderFrame3) then
    begin
      // ���� ����� ������ ���� ������ �� ����� ������� ��������� �����
      if ABS(fMain.FrameMainChannel.Position.X - vLeftBorderFrame3) > vStepSize
      then
        fMain.FrameMainChannel.Position.X := fMain.FrameMainChannel.Position.X +
          vStepSize
      else // ���� ��� ������, �� ������ ��������� ����� � ������ �����
        fMain.FrameMainChannel.Position.X := vLeftBorderFrame3;
    end;

    If fMain.FrameMainChannel.Position.X = (vLeftBorderFrame3) then
    begin
      fMain.FrameMainChannel.Visible := true;
    end;

  end;

  // ����� � ������� ����� ���������� ������ �� ������� �������
  if vEventMove = 20 then
  begin
    If fMain.FrameChannels.Position.X > vLeftBorderFrame2 then
    begin
      // ���� ����� ������ ���� ������ �� ����� ������� ��������� �����
      if fMain.FrameChannels.Position.X - vLeftBorderFrame2 > vStepSize then
        fMain.FrameChannels.Position.X := fMain.FrameChannels.Position.X -
          vStepSize
      else // ���� ��� ������, �� ������ ��������� ����� � ������ �����
        fMain.FrameChannels.Position.X := vLeftBorderFrame2;
    end;

    If fMain.FrameMainChannel.Position.X > -fMain.FrameMainChannel.Width then
    begin
      fMain.FrameMainChannel.Position.X := fMain.FrameMainChannel.Position.X -
        vStepSize;
    end;

  end;

  // ������ ����� � �����, ���������� ��������� ��� �������� �������� �����
  if vEventMove = 31 then
  begin
    If fMain.FrameMainChannel.Position.X < (fMain.Width + 1) then
    begin
      fMain.FrameMainChannel.Position.X := fMain.FrameMainChannel.Position.X +
        vStepSize;
    end;

    If fMain.FrameVideos.Position.X >= fMain.Width then
    begin
      fMain.FrameVideos.Position.X := -fMain.FrameVideos.Width - 1;
    end;

    If fMain.FrameVideos.Position.X < (vLeftBorderFrame4) then
    begin
      // ���� ����� ������ ���� ������ �� ����� ������� ��������� �����
      if ABS(fMain.FrameVideos.Position.X - vLeftBorderFrame4) > vStepSize then
        fMain.FrameVideos.Position.X := fMain.FrameVideos.Position.X + vStepSize
      else // ���� ��� ������, �� ������ ��������� ����� � ������ �����
        fMain.FrameVideos.Position.X := vLeftBorderFrame4;
    end;

    If fMain.FrameVideos.Position.X = (vLeftBorderFrame4) then
    begin
      fMain.FrameVideos.Visible := true;
    end;

  end;

  // ����� � ������������� ����� ���������� ������� �� ������� �����
  if vEventMove = 30 then
  begin
    If fMain.FrameMainChannel.Position.X > vLeftBorderFrame3 then
    begin
      // ���� ����� ������ ���� ������ �� ����� ������� ��������� �����
      if fMain.FrameMainChannel.Position.X - vLeftBorderFrame3 > vStepSize then
        fMain.FrameMainChannel.Position.X := fMain.FrameMainChannel.Position.X -
          vStepSize
      else // ���� ��� ������, �� ������ ��������� ����� � ������ �����
        fMain.FrameMainChannel.Position.X := vLeftBorderFrame3;
    end;

    If fMain.FrameVideos.Position.X > -fMain.FrameVideos.Width then
    begin
      fMain.FrameVideos.Position.X := fMain.FrameVideos.Position.X - vStepSize;
    end;

  end;

  // ��������� ����� � ������������� ����� FrameVideos, ���������� �������  FrameLanguages
  if vEventMove = 41 then
  begin
    If fMain.FrameVideos.Position.X < (fMain.Width + 1) then
    begin
      fMain.FrameVideos.Position.X := fMain.FrameVideos.Position.X + vStepSize;
    end;

    If fMain.FrameLanguages.Position.X >= fMain.Width then
    begin
      fMain.FrameLanguages.Position.X := -fMain.FrameLanguages.Width - 1;
    end;

    If fMain.FrameLanguages.Position.X < (vLeftBorderFrame5) then
    begin
      // ���� ����� ������ ���� ������ �� ����� ������� ��������� �����
      if ABS(fMain.FrameLanguages.Position.X - vLeftBorderFrame5) > vStepSize
      then
        fMain.FrameLanguages.Position.X := fMain.FrameLanguages.Position.X +
          vStepSize
      else // ���� ��� ������, �� ������ ��������� ����� � ������ �����
        fMain.FrameLanguages.Position.X := vLeftBorderFrame5;
    end;

    If fMain.FrameLanguages.Position.X = (vLeftBorderFrame5) then
    begin
      fMain.FrameLanguages.Visible := true;
    end;

  end;

  // ����� � ������� ���������� ������� �� ����� � ������������� �����
  if vEventMove = 40 then
  begin
    If fMain.FrameVideos.Position.X > vLeftBorderFrame4 then
    begin
      // ���� ����� ������ ���� ������ �� ����� ������� ��������� �����
      if fMain.FrameVideos.Position.X - vLeftBorderFrame4 > vStepSize then
        fMain.FrameVideos.Position.X := fMain.FrameVideos.Position.X - vStepSize
      else // ���� ��� ������, �� ������ ��������� ����� � ������ �����
        fMain.FrameVideos.Position.X := vLeftBorderFrame4;
    end;

    If fMain.FrameLanguages.Position.X > -fMain.FrameLanguages.Width then
    begin
      fMain.FrameLanguages.Position.X := fMain.FrameLanguages.Position.X -
        vStepSize;
    end;

  end;
  // ������ ��� �������
  // Form1.ProgressBar1.Position:=Progress;
  // Form1.Label1.Caption := UnitRead.Read('22_') + IntToStr(Progress);
  // fMain.FrameFirst.Position.X := fMain.FrameFirst.Position.X + 5;
  // fMain.Label1.text := IntToStr(Round(fMain.FrameChannels.Position.X)) + ' : ' +
  // IntToStr(Round(vLeftBorderFrame2)) + ', ' +
  // IntToStr(Round(fMain.FrameChannels.Position.Y)) + ', ';
end;

procedure TfMain.Button5Click(Sender: TObject);
var
  aShape: TShape;
  r, x0, y0: integer;
  ProgressThread: TProgressThread;
begin
  // r:=100;     // ������
  // x0:=300;   // ���������� ������
  // y0:=200;   // ���������� ������
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
          Label1.text := '�� ������������';
      end;
    end
  end
  else
    Label1.text := '������� ��� ����������';

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
    // ��� ����� ����������
    vEventMove := vState * 10;
  end;

  // showmessage('vState = ' + IntToStr(vState) +  ' ' + IntToStr(vEventMove) );
  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;
end;

procedure TfMain.ButtonEmail2Click(Sender: TObject);
var
  vBody: string;
begin // ����������� ������ � ��������
  vBody := '<div class="overflow-auto mb-20" style="overflow-y: hidden !important"> <p style="text-align:center">'
    + '<img alt="" src="http://suyarkov.com/wp-content/uploads/2023/04/AssistTranslateYT_240.jpg" style="height:100px; width:100px"></p>'
    + '<hr><p style="text-align:center"><strong>��������� ������������ ���������� AssistIQ Desktop.</strong></p>'
    + '<p style="text-align:center">��� ���������� ����������� ������ � ����� �� ������ � �������� ������� ������ ��� ���������� AssistIQ Desktop.</p>'
    + '<p style="text-align:center"><strong>�������������� ���:</strong> 578723</p><p>&nbsp;</p>'
    + '<hr><p style="text-align:center"><span style="color:#e74c3c">���� �� �� ���������� ���� ������, �������������� ��� ������.</span></p>';

  SendEmail('smtp.gmail.com', 465, 'assistiq.info@gmail.com',
    'ztnaixmausffpmvq', 'assistiq.info@gmail.com', 'AssistIQ Desktop',
    'brestmk@mail.ru', 'AssistIQ : ����������� ���� ����� ����������� �����',
    vBody, '', true);
end;

procedure TfMain.ButtonHelpClick(Sender: TObject);
begin
  if vInterfaceLanguage = 'ru' then
    FrameHelp(Sender, '��������� ������ �� ����� assistiq.info@gmail.com! ')
  else
    FrameHelp(Sender,
      'Send your question to the mailbox assistiq.info@gmail.com! ');
end;

procedure TfMain.ButtonMoneyInfoClick(Sender: TObject);
begin

  FrameInfo(Sender,
    '1 ���������� ������� ����� �������� �������� � �������� ��� ��������� �� 1 ����. '
    + #10 + '���� �� ���������� ��������� � �������� �� 100 ������,�� ��������� 200 ������!');
end;

procedure TfMain.ButtonMon�yClick(Sender: TObject);
begin
  FrameAddMoney(Sender, '�������� �� ������!');
end;

procedure TfMain.ButtonPaintClick(Sender: TObject);
begin
  // fMaim.
end;

procedure TfMain.ButtonQClick(Sender: TObject);
var
  vText: string;
begin
  vText := '����� ����';
  Code(vText, 'qwedfnkj123', true);
  showmessage(vText);
  Code(vText, 'qwedfnkj123', false);
  showmessage(vText);

  vText := StrToHex(vText);
  showmessage(vText);
  vText := HexToStr(vText);
  showmessage(vText);

end;

// ������������ ������ ��� ��
procedure TfMain.ButtonSelChannelsClick(Sender: TObject);
var
  //
  i: integer;
  results: tDataSet;
  vPos: integer;
  vBitmap: TBitmap;
  vDefaulBitmap: TBitmap;
begin

  i := 1;
  // �������� ������ �� ��������� �������
  results := SQLiteModule.SelRefreshToken();
  // �������� ������ � ������ - ������
  if not results.IsEmpty then
  begin
    results.First;
    while not results.Eof do
    begin
      try
        vBitmap := TBitmap(results.FieldByName('img_channel'));
      except
        // vBitmap := vDefaulBitmap;
      end;

      vPos := 3 + (i - 1) * 120;
      PanChannels[i] := TChannelPanel.Create(FrameChannels.BoxChannels, vPos, i,
        results.FieldByName('id_channel').AsString,
        results.FieldByName('refresh_token').AsString,
        results.FieldByName('name_channel').AsString,
        results.FieldByName('lang').AsString, results.FieldByName('sel_lang')
        .AsString, vBitmap, ImageDel.Bitmap);
      PanChannels[i].Parent := FrameChannels.BoxChannels;
      PanChannels[i].ButtonDel.OnClick := DinButtonDeleteChannelClick;
      PanChannels[i].ImageDel.OnClick := DinButtonDeleteChannelClick;
      // PanChannels[i].OnMouseMove := DinPanelMouseMove;
      PanChannels[i].OnClick := DinPanelClick; // Type (sender, 'TPanel');
      PanChannels[i].ChImage.OnClick := DinPanelClick;
      PanChannels[i].ChName.OnClick := DinPanelClick;
      PanChannels[i].ChLang.OnClick := DinPanelClick;
      // ��� ������� ������� ����� � ���� �����, �� �� �������!!
      // g.Assign(results.FieldByName('img_channel'));
      // Image1.Picture.Assign(g);
      inc(i);
      results.Next;
    end;
  end;
  Label1.text := IntToStr(i - 1);

end;

procedure TfMain.ButtonVideoInfoClick(Sender: TObject);
var
  Access_token: string; // ����� ���������� ��������
  refresh_token: string; // ����� ��������� ���������� ������ �� ����������

  OAuth2: TOAuth;
  vString: string;
begin
  OAuth2 := TOAuth.Create;
  OAuth2.ClientID :=
    '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
  OAuth2.ClientSecret := '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';
  // ������ �����
  OAuth2.refresh_token := FrameMainChannel.Label4.text;
  vResponceInfoVideo := OAuth2.videoInfo(FrameMainChannel.Label5.text);
  Memo1.text := vResponceInfoVideo;
  OAuth2.Free;
end;

// ��������� ������
procedure TfMain.FrameChannelsButtonAddChannelClick(Sender: TObject);
var
{$IFDEF ANDROID}
  Intent: JIntent;
{$ENDIF}
{$IFDEF IOS}
  NSU: NSUrl;
{$ENDIF}
{$IFDEF MSWINDOWS}
  res: HINST;
{$ENDIF}
  i : Integer;
begin
  // �����������
  // EditStatusConnect.Text := 'Waiting for connection ...';
  // 1.�������� ������

  if TCPServerYouTubeAnswers.Active = false then
  begin
    for I := 0 to TCPServerYouTubeAnswers.Bindings.Count - 1 do
    begin
      TCPServerYouTubeAnswers.Bindings[i].ReuseSocket := TIdReuseSocket.rsTrue; // TIdSocketHandleReuseSocket.rsTrue;
    end;

    //TCPServerYouTubeAnswers.Bindings.Add.Port := 1904; // ��������� ������, ������ ����� ������!
    TCPServerYouTubeAnswers.DefaultPort := 1904;
    TCPServerYouTubeAnswers.Active := true;

  end;
  // 2. ������� �����������
{$IFDEF MSWINDOWS}     // ������ ��� �����
  ShellExecute(0 { Handle } , 'open',
    PChar('https://accounts.google.com/o/oauth2/v2/auth?' +
    'scope=https://www.googleapis.com/auth/youtube.force-ssl&' +
    'access_type=offline&include_granted_scopes=true' + '&state=security_token'
    + '&response_type=code' + '&redirect_uri=http://127.0.0.1:1904' +
    '&client_id=701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com'
    + '&service=lso&o2v=2&flowName=GeneralOAuthFlow'), nil, nil,
    1 { SW_SHOWNORMAL } );
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

procedure TfMain.FrameFirstButtonLogClick(Sender: TObject);
var
  vOk, vRes: integer;
  vLog, vPas, vResponce, vTmp: string;
  OAuth2: TOAuth;
  vidCl: integer;
  vScore: integer;
begin
  vOk := -1;
  vLog := fMain.FrameFirst.EditName.text;
  vPas := fMain.FrameFirst.EditPas.text;

  if (Date > EncodeDate(2026, 1, 1)) then
  /// ������ �� 1 ������ 2026 ����
  begin
    FrameInfoError(Sender, '������ ��������� ��������!');
    exit;
  end;

  // �������� ������ � ������
  if (pos('@', vLog) > 0) and (pos('.', vLog) > 0) and (Length(vPas) > 0) then
  begin
    // �������� �� ������� �����������
    OAuth2 := TOAuth.Create;
    vResponce := OAuth2.UserGet(vLog, vPas);
    // vResponce := OAuth2.UserGet('name=' + vLog);
    Edit2.text := vResponce;
    OAuth2.Free;
    vidCl := 0;
    if (pos(';', vResponce) > 0) then
    begin
      vRes := StrToInt(Copy(vResponce, 1, pos(';', vResponce) - 1));
      vTmp := Copy(vResponce, pos(';', vResponce) + 1, 1000);
      if (pos(';', vTmp) > 0) then
      begin
        vidCl := StrToInt(Copy(vTmp, 1, pos(';', vTmp) - 1));
        vTmp := Copy(vTmp, pos(';', vTmp) + 1, 1000);
        if (pos(';', vTmp) > 0) then
        begin
          vScore := StrToInt(Copy(vTmp, 1, pos(';', vTmp) - 1));
          // �������� ��� ����� �������� ���������� � ���� ���������
          iScore := vScore;
          LabelScore.text := IntToStr(iScore);
        end;
      end;
    end;
    if vRes = 1 then
    begin
      if vidCl > -1 then
      begin
        vClientId := vidCl;
        vOk := 1
      end
      else
        vOk := -1;
    end;
    if vRes < 0 then
      vOk := -1;
    if vRes = 0 then
      vOk := 0;
    if vRes = -55 then
      vOk := -55;
    if vRes = -99 then
      vOk := -99;
  end
  else
    vOk := -1;

  if (pos(';', vResponce) > 0) then
  begin
    vRes := StrToInt(Copy(vResponce, 1, pos(';', vResponce) - 1));
  end;

  // �������
  if vOk = -1 then
  // ������ �������������
  begin
    fMain.FrameFirst.LabelError.Visible := true;
    fMain.FrameFirst.LabelForgot.Visible := true;
  end
  else if vOk = 0 then
  // ������������ ������������ �� 15 ����� // ������ �������� �������
  begin
    fMain.FrameFirst.LabelError.Visible := true;
    fMain.FrameFirst.LabelForgot.Visible := true;
  end
  else if vOk = -55 then
  // ������������ ������������ �� 15 ����� // ������ �������� �������
  begin
    // fMain.FrameFirst.LabelError.Visible := true;
    // fMain.FrameFirst.LabelForgot.Visible := true;
    FrameInfo(Sender, '������������ �� �����������!');
  end
  else if vOk = -99 then
  // ������������ ������������ �� 15 ����� // ������ �������� �������
  begin
    // fMain.FrameFirst.LabelError.Visible := true;
    // fMain.FrameFirst.LabelForgot.Visible := true;
    FrameInfoError(Sender,
      '������������ ������������! ���������� � ��������������!');
  end
  else
  // ������������� �������
  begin
    uQ.SaveReestr('Name', vLog);
    LabelMail.text := fMain.FrameFirst.EditName.text;
    fMain.FrameFirst.LabelError.Visible := false;
    fMain.FrameFirst.LabelForgot.Visible := false;
    fMain.Button1Click(Sender);
    // �������� ��������� �������
    fMain.ButtonSelChannelsClick(Sender);
  end;
end;

// ����������� ������������
procedure TfMain.FrameFirstButtonRegClick(Sender: TObject);
var
  vFrameAddUser: TFrameAddUser;
  vRes, vCountTry, vKey: integer;
  vEnterText: string;
  vLog, vPas: string;
  vAppLocalization: TAppLocalization;

  vOk, vResponce: string;
  OAuth2: TOAuth;

  vBody: string; // ���� ������
begin
  // ��������� �������� ������� ��� ����������
  vAppLocalization := SQLiteModule.GetAppLocalization(vInterfaceLanguage);

  // ������ ����� ������ ������������
  vFrameAddUser := TFrameAddUser.Create(Self);
  // ������������� �������
  vFrameAddUser.SetLang(vAppLocalization.AddUser_LabelEmail,
    vAppLocalization.AddUser_LabelPass1, vAppLocalization.AddUser_LabelPass2,
    vAppLocalization.AddUser_ButtonSend, vAppLocalization.AddUser_MsgEmail,
    vAppLocalization.AddUser_MsgPassword1,
    vAppLocalization.AddUser_MsgPassword2);
  vFrameAddUser.Parent := fMain;
  vFrameAddUser.Status := -1;

  while vFrameAddUser.Status = -1 do
    Application.ProcessMessages; // wait

  vRes := vFrameAddUser.Status;
  vLog := vFrameAddUser.EditEmail.text;
  vPas := vFrameAddUser.Pass1.text;
  vFrameAddUser.Destroy;
  // ����� �� �������
  if vRes = 0 then
    exit;

  // �������� �� �� ���������� �� ��� ����� ������������
  OAuth2 := TOAuth.Create;
  vRes := OAuth2.TestDoubleEmail(vLog);

  // ��� ���� � ���� ����� ������������
  if vRes = 1 then
  begin
    FrameInfo(Sender,
      vLog + ' - ������������ � ��������� ������ ��� ����������!');
    exit;
  end;

  // ��������� ���� �����������
  vKey := 100000 + Random(900000); // 4 �����
  // vKey := 1111; // �� ����� �������

  // �������� ���� �� ���� �������� ������������

  vBody := '<div class="overflow-auto mb-20" style="overflow-y: hidden !important"> <p style="text-align:center">'
    + '<img alt="" src="http://suyarkov.com/wp-content/uploads/2023/04/AssistTranslateYT_240.jpg" style="height:100px; width:100px"></p>'
    + '<hr><p style="text-align:center"><strong>��������� ������������ ���������� AssistIQ Desktop.</strong></p>'
    + '<p style="text-align:center">��� ���������� ����������� ������ � ����� �� ������ � �������� ������� ������ ��� ���������� AssistIQ Desktop.</p>'
    + '<p style="text-align:center"><strong>�������������� ���:</strong> ' +
    IntToStr(vKey) + '</p><p>&nbsp;</p>' +
    '<hr><p style="text-align:center"><span style="color:#e74c3c">���� �� �� ���������� ���� ������, �������������� ��� ������.</span></p>';

  SendEmail('smtp.gmail.com', 465, 'assistiq.info@gmail.com',
    'ztnaixmausffpmvq', 'assistiq.info@gmail.com', 'AssistIQ Desktop', vLog,
    'AssistIQ : ����������� ���� ����� ����������� �����', vBody, '', true);

  FrameInfo(Sender, '��������� �����!');

  vCountTry := 3;
  // ���� ����, ���� ��� �� ������, �� ��� ��� �������

  repeat
    vEnterText := FrameTextInput(Sender, '������� ��� �� ������!');
    if vEnterText = '-9999' then
      exit;

    if vEnterText = IntToStr(vKey) then
    begin
      vCountTry := -100
    end
    else
    begin
      vCountTry := vCountTry - 1;
      FrameInfo(Sender, '��� �������! �������� ������� ' + IntToStr(vCountTry));
    end;
  until vCountTry <= 0;

  // ������� ���� �� ������
  if vEnterText <> IntToStr(vKey) then
    exit;

  FrameInfo(Sender, '��� �����, ������� ���������!');
  // -- ��� ����� ������ ��
  // �������� ���� � ���� � ��������������
  // �������� ���� � ����!!!

  // �������� ������ � ������
  // �������� �� ������� �����������

  vResponce := OAuth2.UserAdd(vLog, vPas, vInterfaceLanguage);
  Edit2.text := vResponce;
  FrameInfo(Sender, 'vResponce = ' + vResponce);
  OAuth2.Free;
  if (pos(';', vResponce) > 0) then
  begin
    vRes := StrToInt(Copy(vResponce, 1, pos(';', vResponce) - 1));
  end;

  // �������
  if vRes = -1 then
  // ������  ����������
  begin
    FrameInfo(Sender, '������������ �� �����������!');
    exit;
  end
  else if vRes = 0 then // ������������ ����������
  begin
    FrameInfo(Sender, '������������ ��� ����������!');
    exit;
  end
  else
  // ������������� �������
  begin
    uQ.SaveReestr('Name', vLog);
    LabelMail.text := fMain.FrameFirst.EditName.text;
    fMain.FrameFirst.LabelError.Visible := false;
    fMain.FrameFirst.LabelForgot.Visible := false;
    fMain.Button1Click(Sender);
    // �������� ��������� �������
    fMain.ButtonSelChannelsClick(Sender);
  end;
  //
  FrameInfo(Sender, '����������� �������!');

  FrameFirst.EditName.text := vLog;
  FrameFirst.EditPas.text := vPas;

  FrameFirstButtonLogClick(Sender);
end;

procedure TfMain.FrameFirstImage0Click(Sender: TObject);
var
  vButton: TImage;
  vN: integer;
  vAppLocalization: TAppLocalization;
begin
  vButton := Sender as TImage;
  vN := StrToInt(vButton.Name[6]);
  // FrameFirst.Image0Click(Sender);
  // vInterfaceLanguage :=  fMain.FrameFirst.LangCurrent;
  case vN of
    0:
      vInterfaceLanguage := 'en';
    1:
      vInterfaceLanguage := 'de';
    2:
      vInterfaceLanguage := 'fr';
    3:
      vInterfaceLanguage := 'es';
    4:
      vInterfaceLanguage := 'pt';
    5:
      vInterfaceLanguage := 'uk';
    6:
      vInterfaceLanguage := 'ru';
  end;
  // ����� ������ �� �� ������� ������� ��������
  FrameFirst.PanelIsLang.Position.X := vButton.Position.X;
  // vInterfaceLanguage := vButton.Name;
  // showmessage(vInterfaceLanguage);
  uQ.SaveReestr('Local', vInterfaceLanguage);

  // ��������� �������� ������� ��� ����������
  vAppLocalization := SQLiteModule.GetAppLocalization(vInterfaceLanguage);
  // ���������� ������� �� ��� ������!
  MsgInfoUpdate := vAppLocalization.MsgInfoUpdate;

  LabelYouTube.text := vAppLocalization.PanelTop_LabelYouTube;
  ButtonMon�y.text := vAppLocalization.PanelTop_ButtonMon�y;
  ButtonUpdate.text := vAppLocalization.PanelTop_ButtonUpdate;

  FrameFirst.SetLang(vAppLocalization.First_LabelName,
    vAppLocalization.First_LabelPas, vAppLocalization.First_ButtonLog,
    vAppLocalization.First_ButtonReg);
  FrameChannels.SetLang(vAppLocalization.Channels_LabelChannels,
    vAppLocalization.Channels_ButtonAddChannel);
  FrameMainChannel.SetLang(vAppLocalization.MainChannel_LabelNameChannel,
    vAppLocalization.MainChannel_ButtonAddNextVideo);
  FrameVideos.SetLang(vAppLocalization.MainVideos_LabelVideos,
    vAppLocalization.MainVideos_LanguageCheckBox,
    vAppLocalization.MainVideos_LabelTitle,
    vAppLocalization.MainVideos_LabelDescription,
    vAppLocalization.MainVideos_BTranslater);

end;

procedure TfMain.FrameVideosBTranslaterClick(Sender: TObject);
var
  i, vCountLanguages: integer;
  vRes, vPosX, vPosY, vMod, vDiv: integer;
  vWidth, vHeight: integer;
  vList: TListLanguages;
  vBitmap: TBitmap;
  vSelected, vCount: integer; // 1- ������,  0- �� ������
  vSelLanguages: string;
  NewThread: TNewThread;
  vEnabled: boolean;
begin
  vBitmap := Image3.Bitmap;
  FrameVideos.BTranslaterClick(Sender);
  vList := vGlobalList;
  // fMain.FrameVideos.Position.X := Round(fMain.Width +1);
  // fMain.FrameLanguages.Position.X := Round((fMain.Width - fMain.FrameLanguages.Width)/ 2);
  // vWidth := 0; vHeight := 0;
  vWidth := 236 + 1;
  vHeight := 36 + 1;
  i := 1;
  vCount := 0;
  repeat
    vDiv := (i - 1) div 3; // ����� ������
    vMod := (i - 1) mod 3; // ����� �������
    vPosY := vDiv * vHeight; // �� ������
    vPosX := (vMod) * vWidth; // �� ������
    // ��������� ���� �� ������ ���� � ���������
    vSelected := pos('/' + vList[i].LnCode + '/',
      PanChannels[vCurrentPanChannel].ChSelLang.text);
    // res := SQLiteModule.InsRefreshToken(vChannel);
    if vSelected > 0 then
    begin
      vSelected := 1;
      inc(vCount);
      // vSelLanguages := vSelLanguages + PanLanguages[vNPanel].ChLang + '/';
    end;
    //
    vEnabled := (FrameVideos.LanguageVideoLabel.text <> vList[i].LnCode);

    PanLanguages[i] := TLanguagePanel.Create(FrameLanguages.BoxLanguages, vPosX,
      vPosY, i, vSelected, vEnabled,
    // ��������, ����� �������� ������ ��������� ������
    IntToStr(vList[i].id), vList[i].NameRussian,
    // ������� �����������, �������� � ����� ����
    // vList[i].NameLocal + ' ' + IntToStr(i), // ����������� �� �������
    vList[i].NameLocal, // ����������� �� �������
    vList[i].LnCode, vBitmap); // ,            ,
    // vWidth := PanLanguages[i].Width;
    // vHeight := PanLanguages[i].Height;
    PanLanguages[i].Parent := FrameLanguages.BoxLanguages;
    PanLanguages[i].ButtonOnOff.OnClick := DinLanguageClick;
    inc(i);
  until (i >= 300) or (vList[i].LnCode = '');
  // ���������� ������� ������ �������
  fMain.FrameLanguages.LabelCount.text := IntToStr(vCount);

  // showmessage('��� �� ���� �� ������ ' + PanChannels[vCurrentPanChannel].ChSelLang.text);
  fMain.FrameLanguages.LabelLanguages.text := PanChannels[vCurrentPanChannel]
    .ChSelLang.text;
  // �����  ����� �� ��������
  vEventMove := vState * 10 + 1;
  vState := 5;
  ButtonBack.Enabled := true;
  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;
end;

procedure TfMain.PanelButtonClick(Sender: TObject);
begin

end;

// ���������  ����������� ������������� ��� �� ������������ ������ ���� �� ����� �������������
procedure TfMain.TCPServerYouTubeAnswersExecute(AContext: TIdContext);
const
  cNameFile: string = 'AccessCode';
var
  Port: integer;
  PeerPort: integer;
  PeerIP: string;

  msgFromClient: string;
  vPosBegin, vPosEnd: integer;
  vAccessCode: string; // ��� ������� � ������

  vPath: string;
  vFullNameFile: string;
  vFileText: TStringList;

begin
  vAccessCode := '';
  msgFromClient := AContext.Connection.IOHandler.ReadLn;

  PeerIP := AContext.Binding.PeerIP;
  PeerPort := AContext.Binding.PeerPort;

  if pos('GET', msgFromClient) > 0 then
  begin
    if pos('error=', msgFromClient) = 0 then
    begin
      vPosBegin := pos('code=', msgFromClient);
      vPosEnd := pos('scope=', msgFromClient);
      if (vPosBegin > 0) and (vPosEnd > 0) then
      begin
        vPosBegin := vPosBegin + 5;
        vAccessCode := Copy(msgFromClient, vPosBegin, vPosEnd - vPosBegin - 1);
        // vAccessCode := msgFromClient;
        // ������������� �������� ��������� ��� �������� � ��������� ���������� ������
        Edit1.text := vAccessCode;
        if vAccessCode <> '' then
        begin
          vPath := GetCurrentDir();
          vFullNameFile := vPath + '/' + cNameFile;
          vFileText := TStringList.Create;
          vFileText.Add(vAccessCode);
          // ���������
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
      EdAccessCode := vAccessCode;
      // ����� ��������� ������� ������ �� ������ � �� ����������
      BGetTokkens.OnClick(fMain);     // � ��� � �������� ������ ������� ������
      // BGetChannel.OnClick(fMain);
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
      AContext.Connection.IOHandler.write('<title>AssistIQ connected!</title>');
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
      EdAccessCode := '';
      // ����� ��������� ������� ������ �� ������ ������ ���� ���������� ������
      BGetTokkens.OnClick(fMain);
    end;
    // IdTCPServer1.Active := false;
    Edit2.text := '���� !!';
  end
  else
  begin
    Edit2.text := msgFromClient;
  end;
  // � ��� ��� ����� � ������� ��� �� �������� ������ �������
  // AContext.Connection.IOHandler.CloseGracefully;
  // AContext.Connection.Socket.CloseGracefully;
  // AContext.Connection.Socket.Close;
  {
  // ������ ���, ������ ��� � ��������� ��������� ���� ���, ��� ����� ����� � �������
  if TCPServerYouTubeAnswers.Active = true then
  begin
    TThread.Queue(nil,
      procedure
      begin
        TCPServerYouTubeAnswers.Active := false;
      end);
  end;
  }

end;

procedure TfMain.TestAniingicatorClick(Sender: TObject);
begin
  // AniIndicator1.
end;

// ��a����� ������
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
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo) = mrYes then
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

// ������� �� ������ ���� ��������� ����� ��� ����������� ������ � ����
procedure TfMain.DinPanelClick(Sender: TObject);
const
  tokenurl = 'https://accounts.google.com/o/oauth2/token';
var
  vMessage, vIdChannel, vNameChannel, vToken: string;
  vNPanel: integer;
  NewThread: TNewThread;

  vObjVideo: TObjvideo;
  S: string;
  i, vPosY: integer;
  vVideo: TVideo;

  AAPIUrl: String;
  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  Bitimg: TBitmap;

  vObj: Tchannel; // Tchannel;
  vImgUrl: string;

begin
  vNPanel := TButton(Sender).Tag;
  vCurrentPanChannel := vNPanel;
  vIdChannel := PanChannels[vNPanel].chId.text;
  // vToken := PanChannels[vNPanel].chToken.Caption;
  vNameChannel := PanChannels[vNPanel].ChName.text;
  vToken := PanChannels[vNPanel].chToken.text;
  // ��� ��������� ��� ������� ��� ������
  // vMessage := 'Click ' + vNameChannel + ' !' + vIdChannel + ' ' +
  // IntToStr(vNPanel);
  // showmessage(vMessage);
  FrameMainChannel.ImageChannel.Bitmap := PanChannels[vNPanel].ChImage.Bitmap;
  FrameMainChannel.LabelNameChannel.text := vNameChannel;
  FrameMainChannel.Label4.text := vToken;
  FrameMainChannel.Label5.text := vIdChannel;
  FrameMainChannel.ButtonAddNextVideo.Enabled := true;
  FrameMainChannel.ButtonAddNextVideo.text := 'V  V';
  // ������ �� ������ �� ����� �� ������, �� ����� �� ��� ����� ���� � ������� ���������
  fMain.Button200Click(Sender);
  // ��������� � vResponceChannel - �������� ���������� �� ���������
  S := '0';
  vObj := Tchannel.Create;
  // � ���� ������ ���� ��� ������ � ������
  vObj := TJson.JsonToObject<Tchannel>(vResponceChannel);

  for i := 0 to Length(vObj.Items) - 1 do
  begin
    FrameMainChannel.Label1.text :=
      IntToStr(vObj.Items[i].statistics.subscriberCount);
    FrameMainChannel.Label2.text :=
      IntToStr(vObj.Items[i].statistics.videoCount);
    FrameMainChannel.Label3.text :=
      IntToStr(vObj.Items[i].statistics.viewCount);

    vImgUrl := vObj.Items[i].snippet.thumbnails.default.URL;
    try
      S := StringReplace(vImgUrl, #13, '', [rfReplaceAll, rfIgnoreCase]);
      AAPIUrl := StringReplace(S, #10, '', [rfReplaceAll, rfIgnoreCase]);
      FHTTPClient := THTTPClient.Create;
      FHTTPClient.UserAgent :=
        'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
      try
        AResponce := FHTTPClient.Get(AAPIUrl);
      except
        showmessage('��� �����������_2');
        exit;
      end;
      if Not Assigned(AResponce) then
      begin
        showmessage('�����');
        exit;
      end;

      Bitimg := TBitmap.Create;
      Bitimg.LoadFromStream(AResponce.ContentStream);
      FrameMainChannel.ImageChannel.Bitmap := Bitimg;
    except
      showmessage('��� except');
      exit;
    end;

  end;

  // vResponceVideo -- ��������� �� ������ ������� ���� �� ��� �� {, ���� ���� �� ���������� ������
  // ��������� ������ �����
  S := '0';
  vObjVideo := TObjvideo.Create;
  // � ���� ������ ���� ��� ������ � ������
  vObjVideo := TJson.JsonToObject<TObjvideo>(vResponceVideo);
  // ������� �� ������� �� ����������!!!
  vnextPageTokenVideo := vObjVideo.nextPageToken;
  vNowCountVideo := vObjVideo.pageInfo.resultsPerPage;
  vTotalCountVideo := vObjVideo.pageInfo.totalResults;
  FrameMainChannel.LabelCount.text := IntToStr(vNowCountVideo) + '/' +
    IntToStr(vTotalCountVideo);

  for i := 0 to Length(vObjVideo.Items) - 1 do
  begin
    vVideo.videoId := vObjVideo.Items[i].id.videoId;
    vVideo.channelId := vObjVideo.Items[i].snippet.channelId;
    vVideo.title := vObjVideo.Items[i].snippet.title;
    vVideo.description := vObjVideo.Items[i].snippet.description;
    vVideo.urlDefault := vObjVideo.Items[i].snippet.thumbnails.default.URL;
    vVideo.publishedAt := vObjVideo.Items[i].snippet.publishedAt;
    vVideo.publishTime := vObjVideo.Items[i].snippet.publishTime;
    vVideo.publishTime := StringReplace(vVideo.publishTime, 'Z', '',
      [rfReplaceAll, rfIgnoreCase]);
    vVideo.publishTime := StringReplace(vVideo.publishTime, 'T', ' ',
      [rfReplaceAll, rfIgnoreCase]);
    // ����� ��� �� ������� ����� �� ����, ������ ��� ������ ������
    try
      S := StringReplace(vVideo.urlDefault, #13, '',
        [rfReplaceAll, rfIgnoreCase]);
      AAPIUrl := StringReplace(S, #10, '', [rfReplaceAll, rfIgnoreCase]);
      FHTTPClient := THTTPClient.Create;
      FHTTPClient.UserAgent :=
        'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
      try
        AResponce := FHTTPClient.Get(AAPIUrl);
      except
        showmessage('��� �����������_3');
      end;
      if Not Assigned(AResponce) then
      begin
        showmessage('�����');
      end;

      Bitimg := TBitmap.Create;
      Bitimg.LoadFromStream(AResponce.ContentStream);
      vVideo.img := TBitmap.Create;
      vVideo.img := Bitimg;
    except
      showmessage('��� except load video');
    end;

    vPosY := 1 + (i) * 120;
    // �������
    // PanelVideos
    PanVideos[i + 1] := TVideoPanel.Create(FrameMainChannel.BoxVideos, vPosY,
      i + 1, vVideo.videoId, vVideo.channelId, vVideo.title, vVideo.publishTime,
      '����', vVideo.img);
    PanVideos[i + 1].Parent := FrameMainChannel.BoxVideos;

    // PanChannels[i].ButtonDel.OnClick := DinButtonDeleteChannelClick;
    // PanChannels[i].OnMouseMove := DinPanelMouseMove;
    PanVideos[i + 1].OnClick := DinPanelVideoClick; // Type (sender, 'TPanel');
    PanVideos[i + 1].VdImage.OnClick := DinPanelVideoClick;
    // vPanVideo[i+1].VdTitle.OnClick := DinPanelVideoClick;
    // vPanVideo[i+1].VdDescription.OnClick := DinPanelVideoClick;

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

// ������� �� �������� ����� ��� ������ �����
procedure TfMain.DinPanelVideoClick(Sender: TObject);
const
  tokenurl = 'https://accounts.google.com/o/oauth2/token';
var
  vMessage, vTitle, vDescription, vToken: string;
  vNPanel: integer; // ��� ����� ������ � ������ �����  PanVideos[vNPanel]
  NewThread: TNewThread;

  vObjVideo: TObjvideoInfo;
  S: string;
  i, vPosY: integer;
  vVideo: TVideo;

  vVdId: string;

  AAPIUrl: String;
  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  Bitimg: TBitmap;

  Access_token: string; // ����� ���������� ��������
  refresh_token: string; // ����� ��������� ���������� ������ �� ����������
  OAuth2: TOAuth;
  vString: string;
begin
  vNPanel := TButton(Sender).Tag;
  vTitle := PanVideos[vNPanel].VdTitle.text;
  vDescription := PanVideos[vNPanel].VdDescription.text;
  vVdId := PanVideos[vNPanel].VdId.text;
  // vIdChannel := PanVideos[vNPanel].chId.text;
  // vToken := PanChannels[vNPanel].chToken.Caption;
  // ��� ��������� ��� ������� ��� ������
  // vMessage := 'Click ' + vTitle + ' !' + vDescription + ' ' + IntToStr(vNPanel);
  // showmessage(vMessage);

  // ������ � ����� ���������
  OAuth2 := TOAuth.Create;
  OAuth2.ClientID :=
    '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
  OAuth2.ClientSecret := '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';
  // ������ �����
  OAuth2.refresh_token := FrameMainChannel.Label4.text;
  vResponceInfoVideo := OAuth2.videoInfo(vVdId);
  Memo1.text := vResponceInfoVideo;
  OAuth2.Free;

  // ������ � ����� ���������
  S := '0';
  vObjVideo := TObjvideoInfo.Create;
  // � ���� ������ ���� ��� ������ � ������
  vObjVideo := TJson.JsonToObject<TObjvideoInfo>(vResponceInfoVideo);

  for i := 0 to Length(vObjVideo.Items) - 1 do
  begin
    vVideo.videoId := vObjVideo.Items[i].id;
    vVideo.channelId := vObjVideo.Items[i].snippet.channelId;
    vVideo.title := vObjVideo.Items[i].snippet.title;
    vVideo.description := vObjVideo.Items[i].snippet.description;
    vVideo.urlDefault := vObjVideo.Items[i].snippet.thumbnails.default.URL;
    vVideo.publishedAt := vObjVideo.Items[i].snippet.publishedAt;
    vVideo.publishTime := vObjVideo.Items[i].snippet.publishTime;
    vVideo.language := vObjVideo.Items[i].snippet.defaultLanguage;
    // ����� ��� �� ������� ����� �� ����, ������ ��� ������ ������
    try
      S := StringReplace(vVideo.urlDefault, #13, '',
        [rfReplaceAll, rfIgnoreCase]);
      AAPIUrl := StringReplace(S, #10, '', [rfReplaceAll, rfIgnoreCase]);
      FHTTPClient := THTTPClient.Create;
      FHTTPClient.UserAgent :=
        'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
      try
        AResponce := FHTTPClient.Get(AAPIUrl);
      except
        showmessage('��� �����������_4');
      end;
      if Not Assigned(AResponce) then
      begin
        showmessage('�����');
      end;

      Bitimg := TBitmap.Create;
      Bitimg.LoadFromStream(AResponce.ContentStream);
      vVideo.img := TBitmap.Create;
      vVideo.img := Bitimg;
    except
      showmessage('��� except load video');
    end;

  end;
  //

  FrameVideos.LanguageVideoLabel.text := vVideo.language;

  i := fMain.FrameVideos.LanguageComboBox.Items.IndexOf(vVideo.language);
  if i <> -1 then
  begin
    fMain.FrameVideos.LanguageComboBox.ItemIndex := i;
  end;

  FrameVideos.ImageVideo.Bitmap := vVideo.img;
  // PanVideos[vNPanel].VdImage.Bitmap;
  FrameVideos.MemoTitle.text := vVideo.title;
  FrameVideos.MemoDescription.text := vVideo.description;

  FrameVideos.LabelVideoId.text := vVideo.videoId;

  vEventMove := vState * 10 + 1;
  vState := 4;
  ButtonBack.Enabled := true;
  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;

end;

// ���������� ������ ��������� ������ ����� ������� �� ������ � ������
procedure TfMain.DinLanguageClick(Sender: TObject);
var
  strQuestionDelete, vIdLanguage: string;
  vNPanel: integer;
  i, vCount: integer;
  vSelLanguages: string;
begin
  lastPanel := nil;
  vNPanel := TButton(Sender).Tag;
  PanLanguages[vNPanel].ChImage.Visible :=
    not(PanLanguages[vNPanel].ChImage.Visible);
  if PanLanguages[vNPanel].ChImage.Visible = true then
    PanLanguages[vNPanel].ButtonOnOff.TextSettings.Font.Style :=
      [TFontStyle.fsBold]
  else
    PanLanguages[vNPanel].ButtonOnOff.TextSettings.Font.Style := [];
  vCount := 0;
  vSelLanguages := '/';
  for i := 1 to 300 do
  begin
    if PanLanguages[i] = nil then
      break;
    if PanLanguages[i].ChImage.Visible = true then
    begin
      inc(vCount);
      vSelLanguages := vSelLanguages + PanLanguages[i].ChLang.text + '/';
    end;
  end;
  vSelLanguages := vSelLanguages + '/';
  fMain.FrameLanguages.LabelCount.text := IntToStr(vCount);
  fMain.FrameLanguages.LabelLanguages.text := vSelLanguages;
  PanChannels[vCurrentPanChannel].ChSelLang.text := vSelLanguages;
  i := SQLiteModule.Upd_sel_Lang_RefreshToken(PanChannels[vCurrentPanChannel]
    .chId.text, vSelLanguages);

end;

// ��������� ���� � �������� � ���� ������ �� ����  (1-O�, 0-���)
// ������ ������   showmessage(IntToStr(FrameAsk(self, '��� �� ��� �� ��� �� �������� ������')));
function TfMain.FrameAsk(Sender: TObject; AskText: string): integer;
var
  vResult: integer;
  vFrameAsk: TFrameAsk;
begin
  vResult := 0;
  vFrameAsk := TFrameAsk.Create(Self);
  // vFrameAsk.Position.X := Round(fMain.Width/2 + 1);
  // vFrameAsk.Position.Y := Round(fMain.Height/2 + 1);
  vFrameAsk.MemoMessage.Visible := false;
  vFrameAsk.LabelMessage.text := AskText;
  vFrameAsk.Parent := fMain;
  vFrameAsk.Status := -1;

  while vFrameAsk.Status = -1 do
    Application.ProcessMessages; // wait
  vResult := vFrameAsk.Status;
  vFrameAsk.Destroy;

  Result := vResult;
end;

function TfMain.FrameTextInput(Sender: TObject; AskText: string): string;
var
  vResult: string;
  vStatus: integer;
  vFrameTextInput: TFrameTextInput;
begin
  vResult := '';
  vStatus := -1;
  vFrameTextInput := TFrameTextInput.Create(Self);

  vFrameTextInput.LabelMessage.text := AskText;
  vFrameTextInput.Parent := fMain;
  vFrameTextInput.Status := -1;

  while vFrameTextInput.Status = -1 do
    Application.ProcessMessages; // wait
  vStatus := vFrameTextInput.Status;
  vResult := vFrameTextInput.EditText.text;
  vFrameTextInput.Destroy;
  if vStatus = 0 then
    vResult := '-9999';
  Result := vResult;
end;

// ��������� ���� � ���������� � ����������� ������� ������ � ��� ��������� ����
procedure TfMain.FrameAddMoney(Sender: TObject; InfoText: string);
var
  vFrameInfo: TFrameAddMoney;
begin
  vFrameInfo := TFrameAddMoney.Create(Self);
  vFrameInfo.MemoMessage.Visible := false;
  vFrameInfo.LabelMessage.text := InfoText;
  vFrameInfo.Parent := fMain;
  vFrameInfo.Status := -1;

  while vFrameInfo.Status = -1 do
    Application.ProcessMessages; // wait
  vFrameInfo.Destroy;
end;

// ��������� ���� � ����������
// ������ ������   FrameInfo(self, '����� ������ ���')));
// procedure TfMain.FrameInfo(Sender: TObject; InfoText: string);
procedure TfMain.FrameInfo(Sender: TObject; InfoText: string;
Status: integer = 0);
var
  vFrameInfo: TFrameInfo;
begin
  try
    vFrameInfo := TFrameInfo.Create(Self);
  except
    on E: Exception do
      exit;
  end;

  if Status = 0 then
  begin
    vFrameInfo.Image1.Visible := true;
    vFrameInfo.Image2.Visible := false;
  end
  else
  begin
    vFrameInfo.Image1.Visible := false;
    vFrameInfo.Image2.Visible := true;
  end;

  // vFrameInfo.Position.X := Round(fMain.Width/2 + 1);
  // vFrameInfo.Position.Y := Round(fMain.Height/2 + 1);
  vFrameInfo.MemoMessage.Visible := false;
  vFrameInfo.LabelMessage.text := InfoText;
  vFrameInfo.Parent := fMain;
  vFrameInfo.Status := -1;

  while vFrameInfo.Status = -1 do
    Application.ProcessMessages; // wait
  vFrameInfo.Destroy;
end;

// ��������� ���� � �������
// ������ ������   FrameInfo(self, '����� ���! ��� �����!')));
procedure TfMain.FrameInfoError(Sender: TObject; InfoText: string);
var
  vFrameInfo: TFrameInfo;
begin

  try
    vFrameInfo := TFrameInfo.Create(Self);
  except
    on E: Exception do
      exit;
  end;

  // vFrameInfo.Position.X := Round(fMain.Width/2 + 1);
  // vFrameInfo.Position.Y := Round(fMain.Height/2 + 1);
  vFrameInfo.MemoMessage.Visible := false;
  vFrameInfo.LabelMessage.text := InfoText;
  vFrameInfo.Parent := fMain;
  vFrameInfo.Status := -1;

  while vFrameInfo.Status = -1 do
    Application.ProcessMessages; // wait
  vFrameInfo.Destroy;
end;

// ��������� ���� � ���������� � ������ - �������
// ������ ������   FrameInfo(self, '����� ������ ���')));
procedure TfMain.FrameHelp(Sender: TObject; InfoText: string);
var
  vFrameInfo: TFrameHelp;
begin
  try
    vFrameInfo := TFrameHelp.Create(Self);
  except
    on E: Exception do
      exit;
  end;
  // vFrameInfo.LabelMessage.Visible := false;
  vFrameInfo.LabelMessage.text := InfoText;
  vFrameInfo.MemoMessage.text := InfoText;
  vFrameInfo.Parent := fMain;
  vFrameInfo.Status := -1;

  while vFrameInfo.Status = -1 do
    Application.ProcessMessages; // wait
  vFrameInfo.Destroy;
end;

procedure TfMain.FrameLanguagesButtonAddAllLanguagesClick(Sender: TObject);
var
  i, vCount: integer;
  vSelLanguages: string;
begin
  lastPanel := nil;
  vCount := 0;
  vSelLanguages := '/';
  for i := 1 to 300 do
  begin
    if PanLanguages[i] = nil then
      break;
    PanLanguages[i].ChImage.Visible := true;

    PanLanguages[i].ButtonOnOff.TextSettings.Font.Style := [TFontStyle.fsBold];

    if PanLanguages[i].ChImage.Visible = true then
    begin
      inc(vCount);
      vSelLanguages := vSelLanguages + PanLanguages[i].ChLang.text + '/';
    end;
  end;
  vSelLanguages := vSelLanguages + '/';
  fMain.FrameLanguages.LabelCount.text := IntToStr(vCount);
  fMain.FrameLanguages.LabelLanguages.text := vSelLanguages;
  PanChannels[vCurrentPanChannel].ChSelLang.text := vSelLanguages;
  i := SQLiteModule.Upd_sel_Lang_RefreshToken(PanChannels[vCurrentPanChannel]
    .chId.text, vSelLanguages);
end;

procedure TfMain.FrameLanguagesButtonDelAllLanguagesClick(Sender: TObject);
var
  i, vCount: integer;
  vSelLanguages: string;
begin
  lastPanel := nil;
  vCount := 0;
  vSelLanguages := '/';
  for i := 1 to 300 do
  begin
    if PanLanguages[i] = nil then
      break;
    PanLanguages[i].ChImage.Visible := false;
    PanLanguages[i].ButtonOnOff.TextSettings.Font.Style := [];
  end;
  vSelLanguages := vSelLanguages + '/';
  fMain.FrameLanguages.LabelCount.text := IntToStr(vCount);
  fMain.FrameLanguages.LabelLanguages.text := vSelLanguages;
  PanChannels[vCurrentPanChannel].ChSelLang.text := vSelLanguages;
  i := SQLiteModule.Upd_sel_Lang_RefreshToken(PanChannels[vCurrentPanChannel]
    .chId.text, vSelLanguages);
end;

// ������ �������� ����
procedure TfMain.FrameLanguagesButtonSubtitlesClick(Sender: TObject);
var
  // ���� �� ��������� ����� ��� ��������
  vLength: integer;
  vPosBegin, vPosEnd: integer;
  vTransCount: integer;
  // ��� ���������� � ����
  vPath: string;
  vFullNameFile: string;
  vFileText: TStringList;

  // ����������� � YT3
  Access_token: string; // ����� ���������� ��������
  refresh_token: string; // ����� ��������� ���������� ������ �� ����������
  OAuth2: TOAuth;
  vResponceSubtitleList: string;

  // �������� ������ ������
  vObjSubtitles: TObjSubtitleList;
  vIndexMainLanguage, i: integer;
  vSubtitles: array [1 .. 300] of TSubtitle;
  vSCount: integer; // ���������� ��� ������������ ���������.
  vDeleteTranslate: integer; // ���������� ��� ������������ ���������.

  // ��������
  vResponceDelSubtitle: string;
  // �������
  vResponceLoadSubtitle: string;
  vResponceInsSubtitle: string;

  // vObj: TsnippetInsert;
  vObj: Tsnippet;
  vAddCaptionJSON: string;

  vFileText2: TStringList;
begin

  vFileText2 := TStringList.Create;
  vFileText2.Add('���? DD');
  // ���������
  vFileText2.SaveToFile('d:/tesf2.txt');

  vLength := Length(fMain.FrameLanguages.LabelLanguages.text);
  if vLength > 2 then
  begin
    if FrameAsk(Sender, '������ ������� ���������?') = 1 then
    begin
      // ���� ���, �� ������ �������� ���� � ������ ������ ��� ���������
      OAuth2 := TOAuth.Create;
      OAuth2.ClientID :=
        '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
      OAuth2.ClientSecret := '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';
      // ������ �����
      OAuth2.refresh_token := FrameMainChannel.Label4.text;
      // vString := OAuth2.SubtitleDownload(CaptionID, 'en');
      // �������� ������ ���������
      vResponceSubtitleList := OAuth2.subtitlelist
        (FrameVideos.LabelVideoId.text);

      // �������� � ����
      vPath := GetCurrentDir();
      vFullNameFile := vPath + '/' + 'sub.txt';
      // showmessage('vFullNameFile = ' + vFullNameFile);
      vFileText := TStringList.Create;
      vFileText.Add(vResponceSubtitleList);
      vFileText.SaveToFile(vFullNameFile);
      // showmessage('��������');

      vIndexMainLanguage := 0; // ���� ��� ��������� ������� ��������
      vSCount := 0; // ���-�� ��� ������������ ���������
      vObjSubtitles := TObjSubtitleList.Create;
      // � ���� ������ ���� ��� ������ � ������
      vObjSubtitles := TJson.JsonToObject<TObjSubtitleList>
        (vResponceSubtitleList);
      for i := 0 to Length(vObjSubtitles.Items) - 1 do
      begin
        inc(vSCount);
        vSubtitles[vSCount].subtitleId := vObjSubtitles.Items[i].id;
        vSubtitles[vSCount].language := vObjSubtitles.Items[i].snippet.language;
        // showmessage('���� ' + vSubtitles[vSCount].language);
        // if vSubtitles[vSCount].language = FrameVideos.LanguageVideoLabel.text
        if vSubtitles[vSCount].language = Copy
          (FrameVideos.LanguageVideoLabel.text, 1, 2) then
          vIndexMainLanguage := vSCount; // ����� ������� ��������� �����
      end;

      // ���� ��� ��������� ����� �� �������������� � �������� �������, ���� �����
      if vIndexMainLanguage = 0 then
      begin
        FrameInfo(Sender, '��� ��������� �����, ���������� �� � ����!');
      end
      else
      begin
        // FrameInfo(Sender, 'ID ������� � ������� ����� ��������� = ' + vSubtitles[vIndexMainLanguage].subtitleId);
        // ������ � ��������� �������� -- ����������� � ���� default.sbv � ������ �����
        vResponceLoadSubtitle := OAuth2.SubtitleDownload
          (vSubtitles[vIndexMainLanguage].subtitleId, '');
        // ���� ������ � ����� ��������� � ������
        // (vSubtitles[vIndexMainLanguage].subtitleId, 'ru'); //������ �� �� ���������
        // ('ru', ''); //������ �� �� ���������
        { vFullNameFile := vPath + '/' + 'subload';
          vFileText := TStringList.Create;
          vFileText.Add(vSubtitles[vIndexMainLanguage].subtitleId + vResponceLoadSubtitle);
          vFileText.SaveToFile(vFullNameFile); }

        // �������� ��������
        vDeleteTranslate := 0;
        for i := 1 to vSCount do
        begin
          // if vSubtitles[i].language <> FrameVideos.LanguageVideoLabel.text then
          if i <> vIndexMainLanguage then
          begin
            inc(vDeleteTranslate);
            // showmessage('������� ���� ' + vSubtitles[i].subtitleId);
            { vResponceDelSubtitle := OAuth2.SubtitleDelete (vSubtitles[i].subtitleId);
              vFullNameFile := vPath + '/' + 'subDel.txt';
              vFileText := TStringList.Create;
              vFileText.Add(vSubtitles[vIndexMainLanguage].subtitleId + ' � ����� ='+
              vResponceDelSubtitle);
              vFileText.SaveToFile(vFullNameFile);
            }
          end;
        end;
        FrameInfo(Sender, '������� ������ ' + IntToStr(vDeleteTranslate));
        // �������� ������ ������
        vTransCount := 0; // ���������� ������������ ������
        for i := 1 to 300 do
        begin
          if PanLanguages[i] = nil then
            break;
          if (PanLanguages[i].ChImage.Visible = true) and
            (PanLanguages[i].ChLang.text <> FrameVideos.LanguageVideoLabel.text)
          then
          begin
            inc(vTransCount);
            showmessage('��������� ���� ' + FrameVideos.LanguageVideoLabel.text
              + ' �� ' + PanLanguages[i].ChLang.text);
            // vString := OAuth2.SubtitleDownload(PanLanguages[i].ChLang.text, 'en');
            // ��������� � ���� ����� ��������
            // vResponceLoadSubtitle := OAuth2.SubtitleDownload(FrameVideos.LabelVideoId.Text, PanLanguages[i].ChLang.Text);
            // ��������� ��������� � �������� �����
            // JSON: string; FileName: String
            // vObj := TsnippetInsert.Create;
            vObj := Tsnippet.Create;
            vObj.videoId := FrameVideos.LabelVideoId.text;
            vObj.language := PanLanguages[i].ChLang.text; // 'en';
            vObj.Name := PanLanguages[i].ChName.text; // '';//
            { vObj.snippet := Tsnippet.Create;
              vObj.snippet.videoId := FrameVideos.LabelVideoId.text;
              vObj.snippet.language := PanLanguages[i].ChLang.text; //'en';
              vObj.snippet.name := PanLanguages[i].ChName.text; // '';// }
            vAddCaptionJSON := TJson.ObjectToJsonString(vObj);
            // vAddCaptionJSON := '{"kra":"dva"}';
            // vAddCaptionJSON :=  '{"snippet":'+ vAddCaptionJSON + '}';
            showmessage('vAddCaptionJSON = ' + vAddCaptionJSON);
            // vAddCaptionJSON := '{language:es,name:465,videoId:' + FrameVideos.LabelVideoId.text + '}';
            // vAddCaptionJSON :=  '{snippet:{ language:es, name:Spanish captions, videoId:' +
            // FrameVideos.LabelVideoId.text + ',isDraft:true}}';
            // vResponceInsSubtitle := OAuth2.SubtitleInsert(vAddCaptionJSON, '');
            // vResponceInsSubtitle := OAuth2.SubtitleV2Insert(vAddCaptionJSON,
            // 'default2.sbv', FrameVideos.LabelVideoId.text);
            vResponceInsSubtitle := OAuth2.SubtitleInsert(vAddCaptionJSON,
              'default2.sbv');

            // vResponceInsSubtitle := OAuth2.SubtitleInsert(vAddCaptionJSON,
            // '');
            FrameInfo(Sender, '����� �� �������� ' + vResponceInsSubtitle);
            Memo1.text := vResponceInsSubtitle;
            vObj.Free;
          end;
        end;
        FrameInfo(Sender, '�������� �� ' + IntToStr(vTransCount));
      end;
      OAuth2.Free;
    end
    else
    begin // '�� ��� � ���� ���'
      FrameInfo(Sender, '�� ��� � ���� ���');
    end;
  end
  else
    FrameInfo(Sender, '�������� ����� ��� ��������');
end;

// ������� ��������� ������������ � ��������
procedure TfMain.FrameLanguagesButtonTitleClick(Sender: TObject);
var
  // ���� �� ��������� ����� ��� ��������
  vLength: integer;
  vPosBegin, vPosEnd: integer;
  vTransCount: integer;

  // ����������� � YT3
  Access_token: string; // ����� ���������� ��������
  refresh_token: string; // ����� ��������� ���������� ������ �� ����������
  OAuth2: TOAuth;
  vResponceSubtitleList: string;

  // �������� ������ ������
  vObjSubtitles: TObjSubtitleList;
  vIndexMainLanguage, i: integer;
  vSubtitles: array [1 .. 300] of TSubtitle;
  vSCount: integer; // ���������� ��� ������������ ���������.

  vResponceInsTitle: string;
  vJSON: string;
  vJSON_tmp: string;

  vTitle: string;
  vDescription: string;

  vTranslateTitle: string;
  vTranslateDescription: string;
  vTransCountMax: integer;

  vTransCountTmp: integer;

  vObjTitle: Ttitle; // Tchannel;

  v�utTitle: string;

  OAuth3: TOAuth;
  vResponce3: string;
begin

  vTitle := FrameVideos.MemoTitle.text;
  vDescription := FrameVideos.MemoDescription.text;

  vLength := Length(fMain.FrameLanguages.LabelLanguages.text);
  if vLength > 2 then
  begin
    if FrameAsk(Sender, '������ ������� �������� � ��������?') = 1 then
    begin
      // ���� ���, �� ������ �������� ���� � ������ ������ ��� ���������
      OAuth2 := TOAuth.Create;
      OAuth2.ClientID :=
        '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
      OAuth2.ClientSecret := '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';
      // ������ �����
      OAuth2.refresh_token := FrameMainChannel.Label4.text;
      // vString := OAuth2.SubtitleDownload(CaptionID, 'en');
      // vResponceInsTitle := OAuth2.VideoUpdate(vJSON);
      // showmessage('�������� ' + vResponceInsTitle);

      vIndexMainLanguage := 0; // ���� ��� ��������� ������� ��������
      vSCount := 0; // ���-�� ��� ������������ ���������
      { vObjSubtitles := TObjSubtitleList.Create;
        // � ���� ������ ���� ��� ������ � ������
        vObjSubtitles := TJson.JsonToObject<TObjSubtitleList>
        (vResponceSubtitleList);
        for i := 0 to Length(vObjSubtitles.Items) - 1 do
        begin
        inc(vSCount);
        vSubtitles[vSCount].subtitleId := vObjSubtitles.Items[i].id;
        vSubtitles[vSCount].language := vObjSubtitles.Items[i].snippet.language;
        if vSubtitles[vSCount].language = FrameVideos.LanguageVideoLabel.text
        then
        vIndexMainLanguage := vSCount; // ����� ������� ��������� �����
        end;
      }
      // ���� ��� ��������� ����� �� �������������� � �������� �������, ���� �����
      vTransCount := 0;
      for i := 1 to 300 do
      begin
        if PanLanguages[i] = nil then
          break;
        if (PanLanguages[i].ChImage.Visible = true) and
          (PanLanguages[i].ChLang.text <> FrameVideos.LanguageVideoLabel.text)
        then
          inc(vTransCount);
      end;

      if vTransCount = 0 then // if vIndexMainLanguage = 0 then
      begin
        FrameInfo(Sender, '��� ��������� ������!');
      end
      else if TestScore(Sender, vTransCount) = 0 then
      begin
        vTransCountMax := vTransCount;
        vTransCountTmp := 0;
        // ������ � ��������� �������� -- ����������� � ���� default.sbv � ������ �����
        // vResponceLoadSubtitle := OAuth2.SubtitleDownload(vSubtitles[vIndexMainLanguage].subtitleId, 'ru');
        { vFullNameFile := vPath + '/' + 'subload';
          vFileText := TStringList.Create;
          vFileText.Add(vSubtitles[vIndexMainLanguage].subtitleId + vResponceLoadSubtitle);
          vFileText.SaveToFile(vFullNameFile); }

        // �������� �������� -- �� ���� ����� �� ���, �� �������� ��� ��� ������ ������� �� ������ ��� �����

        // for i := 1 to vSCount do
        // begin
        // if vSubtitles[i].language <> FrameVideos.LanguageVideoLabel.text then
        // if vSCount <> vIndexMainLanguage then
        // begin
        { vResponceDelSubtitle := OAuth2.SubtitleDelete(FrameVideos.LabelVideoId.Text);
          vFullNameFile := vPath + '/' + 'subDel';
          vFileText := TStringList.Create;
          vFileText.Add(vSubtitles[vIndexMainLanguage].subtitleId + vResponceDelSubtitle);
          vFileText.SaveToFile(vFullNameFile); }
        // end;
        // end;
        // FrameInfo(Sender, '������� ������ ' + IntToStr(vSCount));

        // �������� ������ ������
        // StartProgressBar(sender);

        // showmessage('startBar 2');
        // AniIndicator1.Visible := true;
        // AniIndicator1.Enabled := true;
        FrameProgressBar.Visible := true;
        // FrameProgressBar.Visible := true;
        Application.ProcessMessages;
        // vTransCount := 0; // ���������� ������������ ������

        // ����� �������� ���� JSON ��� ���� ������  ��� ����� YOUR_VIDEO_ID
        vJSON := '{"id":"' + FrameVideos.LabelVideoId.text +
          '",  "localizations": {';
        // showmessage('startBar 3');
        vTransCount := 0;
        v�utTitle := '';
        for i := 1 to 300 do
        begin
          // ������ ������, �� ����� ������
          Application.ProcessMessages;
          // showmessage('startBar 00' + inttostr(i));
          if PanLanguages[i] = nil then
            break;
          if (PanLanguages[i].ChImage.Visible = true) and
            (PanLanguages[i].ChLang.text <> FrameVideos.LanguageVideoLabel.text)
          then
          begin
            FrameProgressBar.SetProgress
              (TRUNC(((vTransCountTmp) * 100 / vTransCountMax)),
              vTransCountTmp + 1);
            inc(vTransCountTmp);
            // showmessage('��������� � ' + FrameVideos.LanguageVideoLabel.text
            // + ' �� ' + PanLanguages[i].ChLang.text);
            vTranslateTitle := GoogleTranslate(vTitle,
              FrameVideos.LanguageVideoLabel.text, PanLanguages[i].ChLang.text);
            // showmessage('���� ' + vTitle
            // + ' , ����� ' + vTranslateTitle +
            // ' , �����2 ' + copy( vTranslateTitle, 1, 100));
            if vTranslateTitle.Length > 100 then
            begin
              vTranslateTitle := Copy(vTranslateTitle, 1, 100);
              v�utTitle := v�utTitle + ' , ' + PanLanguages[i].ChLang.text;
            end;

            // ���� ��������� �� ����� ����� ����� ����������!!!

            vTranslateDescription := GoogleTranslate(vDescription,
              FrameVideos.LanguageVideoLabel.text, PanLanguages[i].ChLang.text);

            // showmessage('���� ' + vDescription
            // + ' , ����� ' + vTranslateDescription);

            // ��������� ������ JSON
            if vTransCount > 0 then // ���������, ���� ��� ��� ������
              vJSON := vJSON + ',';
            vObjTitle := Ttitle.Create;
            vObjTitle.title := vTranslateTitle;
            vObjTitle.description := vTranslateDescription;
            vJSON_tmp := TJson.ObjectToJsonString(vObjTitle);
            // showmessage(vJSON_tmp);
            vObjTitle.Free;
            vJSON := vJSON + '"' + PanLanguages[i].ChLang.text + '" :' +
              vJSON_tmp;
            // ��� �� �������� � �������!!!
            // {"title":"' + vTranslateTitle // ��������
            // + '","description": "' + vTranslateDescription + '"}';
            inc(vTransCount);
          end;
        end;
        vJSON := vJSON + '}}';
        // showmessage( vJSON);

        // showmessage('startBar 5 ������ � ����������!');
        if vTransCount > 0 then
        begin
          vResponceInsTitle := OAuth2.VideoUpdate(vJSON);
          // ������� ���� ���� ������ �� ������� ��� ��� �������
          // showmessage(vJSON + #13 + #10 + vResponceInsTitle + ' ' + #13 + #10
          // + vTranslateDescription);
          Memo1.text := vResponceInsTitle;
        end;
        // showmessage('startBar 6 � ��� � ����� �� ����!');
        // AniIndicator1.Visible := false;
        // AniIndicator1.Enabled := false;
        // FinishProgressBar(sender);
        FrameProgressBar.Visible := false;
        iScore := iScore - vTransCount;
        LabelScore.text := IntToStr(iScore);

        // ���������� ������
        OAuth3 := TOAuth.Create;
        vResponce3 := OAuth2.Clicks(IntToStr(vClientId), '0',
          IntToStr(vTransCount), '1');

        // FrameInfo(Sender, '���������� ��������� �� ' +
        // IntToStr(vTransCount), 1);
        FrameInfo(Sender, '�������� �������� ��' + IntToStr(vTransCount) +
          ' ������.');
      end;
      OAuth2.Free;
    end
    else
    begin // '�� ��� � ���� ���'
      FrameInfo(Sender, '�� ��� � ���� ���');
    end;
  end
  else
    FrameInfo(Sender, '�������� ����� ��� ��������!');
end;

// ������ ��� ���������� ������ (�����) �� �����
procedure TfMain.FrameMainChannelButtonAddNextVideoClick(Sender: TObject);
var
  Access_token: string; // ����� ���������� ��������
  refresh_token: string; // ����� ��������� ���������� ������ �� ����������
  OAuth2: TOAuth;
  vString: string;

  vObjVideo: TObjvideo;
  S: string;
  i, vPosY: integer;
  vVideo: TVideo;

  AAPIUrl: String;
  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  Stream: TStream;

  Bitimg: TBitmap;

  vCountVideoCreate: integer;
begin
  // ������ ���� ��� �� ��� ���������
  if vNowCountVideo >= vTotalCountVideo then
    exit;
  // ������ ��������� ������
  vCountVideoCreate := vNowCountVideo;
  OAuth2 := TOAuth.Create;
  OAuth2.ClientID :=
    '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
  OAuth2.ClientSecret := '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';
  // ������ �����
  OAuth2.refresh_token := FrameMainChannel.Label4.text;
  vResponceVideo := OAuth2.MyVideos(FrameMainChannel.Label5.text,
    vnextPageTokenVideo);
  // showmessage(vResponceChannel);
  OAuth2.Free;

  // vResponceVideo -- ��������� �� ������ ������� ���� �� ��� �� {, ���� ���� �� ���������� ������
  // ��������� ������ �����
  S := '0';
  vObjVideo := TObjvideo.Create;
  vObjVideo := TJson.JsonToObject<TObjvideo>(vResponceVideo);
  vnextPageTokenVideo := vObjVideo.nextPageToken;
  vNowCountVideo := vObjVideo.pageInfo.resultsPerPage + vNowCountVideo;
  vTotalCountVideo := vObjVideo.pageInfo.totalResults;
  if vNowCountVideo >= vTotalCountVideo then
  begin
    vNowCountVideo := vTotalCountVideo;
    FrameMainChannel.ButtonAddNextVideo.Enabled := false;
    FrameMainChannel.ButtonAddNextVideo.text := '';
  end;
  FrameMainChannel.LabelCount.text := IntToStr(vNowCountVideo) + '/' +
    IntToStr(vTotalCountVideo);

  for i := 0 to Length(vObjVideo.Items) - 1 do
  begin
    vVideo.videoId := vObjVideo.Items[i].id.videoId;
    vVideo.channelId := vObjVideo.Items[i].snippet.channelId;
    vVideo.title := vObjVideo.Items[i].snippet.title;
    vVideo.description := vObjVideo.Items[i].snippet.description;
    vVideo.urlDefault := vObjVideo.Items[i].snippet.thumbnails.default.URL;
    vVideo.publishedAt := vObjVideo.Items[i].snippet.publishedAt;
    vVideo.publishTime := vObjVideo.Items[i].snippet.publishTime;
    vVideo.publishTime := StringReplace(vVideo.publishTime, 'Z', '',
      [rfReplaceAll, rfIgnoreCase]);
    vVideo.publishTime := StringReplace(vVideo.publishTime, 'T', ' ',
      [rfReplaceAll, rfIgnoreCase]);
    // ����� ��� �� ������� ����� �� ����, ������ ��� ������ ������
    try
      S := StringReplace(vVideo.urlDefault, #13, '',
        [rfReplaceAll, rfIgnoreCase]);
      AAPIUrl := StringReplace(S, #10, '', [rfReplaceAll, rfIgnoreCase]);
      FHTTPClient := THTTPClient.Create;
      FHTTPClient.UserAgent :=
        'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
      try
        AResponce := FHTTPClient.Get(AAPIUrl);
      except
        showmessage('��� �����������_5');
      end;
      if Not Assigned(AResponce) then
      begin
        showmessage('�����');
      end;

      Bitimg := TBitmap.Create;
      Bitimg.LoadFromStream(AResponce.ContentStream);
      vVideo.img := TBitmap.Create;
      vVideo.img := Bitimg;
    except
      showmessage('��� except load video');
    end;

    vPosY := 1 + (i + vCountVideoCreate) * 120;
    // �������
    // PanelVideos
    PanVideos[vCountVideoCreate + i + 1] :=
      TVideoPanel.Create(FrameMainChannel.BoxVideos, vPosY,
      vCountVideoCreate + i + 1, vVideo.videoId, vVideo.channelId, vVideo.title,
      vVideo.publishTime, '����', vVideo.img);
    PanVideos[vCountVideoCreate + i + 1].Parent := FrameMainChannel.BoxVideos;
    PanVideos[vCountVideoCreate + i + 1].OnClick := DinPanelVideoClick;
    // Type (sender, 'TPanel');
    PanVideos[vCountVideoCreate + i + 1].VdImage.OnClick := DinPanelVideoClick;

  end;

end;

end.
