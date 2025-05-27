unit FrmDataSQLite;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Dialogs, FMX.Graphics,
  IdTCPClient, System.Net.HTTPClient, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FMX.Objects;

// короткое описание всех подключенных каналов
type
  TShortChannel = record
    id_channel: string;
    name_channel: string;
    img_channel: TBlobType; // tfGraphic;//TBlobType;
    img: TBitmap;
    refresh_token: string;
    lang: string;
    sel_lang: string;
    deleted: integer;
    viewCount: integer;
    subscriberCount: integer;
    videoCount: integer;
  end;

  // описание активного, текущего видео
type
  TVideo = record
    videoId: string;
    channelId: string;
    title: string;
    description: string; // 5000?
    urlDefault: string;
    publishedAt: string;
    publishTime: string;
    img: TBitmap;
    language: string;
    {
      publishedAt: TDateTime;//"2023-04-08T17:37:31Z"
      publishTime: TDateTime;//"2023-04-08T17:37:31Z"
    }
  end;

  // запись - язык для перевода
type
  TLanguage = record
    Id: integer; // номер по порядку
    LnCode: string;
    NameRussian: string;
    NameEnglish: string;
    NameLocal: string;
    Activ: integer;
  end;

  // список всех субтитров которые есть на видео
type
  TSubtitle = record
    subtitleId: string; // ID субтитров
    language: string;
  end;

  // запись по объектным названиям - возможно не буду использовать
type
  TLocalization = record
    lang: string;
    id_component: string;
    name_components: string;
  end;

  // текущие все названия элементов приложения на выбранном языке
type
  TAppLocalization = record
    language: string;

    MsgInfoUpdate :string;

    PanelTop_LabelYouTube: string;
    PanelTop_ButtonMonеy: string;
    PanelTop_ButtonUpdate: string;

    First_LabelName: string;
    First_LabelPas: string;
    First_ButtonLog: string;
    First_ButtonReg: string;

    AddUser_LabelEmail: string;
    AddUser_LabelPass1: string;
    AddUser_LabelPass2: string;
    AddUser_ButtonSend: string;
    AddUser_MsgEmail: string;
    AddUser_MsgPassword1: string;
    AddUser_MsgPassword2: string;

    Channels_LabelChannels: string;
    Channels_ButtonAddChannel: string;

    MainChannel_LabelNameChannel: string;
    MainChannel_ButtonAddNextVideo: string;

    MainVideos_LabelVideos: string;
    MainVideos_LanguageCheckBox: string;
    MainVideos_LabelTitle: string;
    MainVideos_LabelDescription: string;
    MainVideos_BTranslater: string;

    FrameLanguages_LabelTextCount: string;
    FrameLanguages_ButtonTitle: string;
    FrameLanguages_ButtonSubtitles: string;

  end;

Type
  TShortChannels = Array [1 .. 50] of TShortChannel; // ограничим 50 каналами
  TVideos = Array [1 .. 1000] of TVideo; // ограничим 1000 видеороликами
  // все языки на которые можно переводить
  TListLanguages = Array [1 .. 300] of TLanguage;
  // название компонент на всех языках - это не используем
  TListLocalization = Array [1 .. 1000] of TLocalization;

type
  TSQLiteModule = class(TDataModule)
    SQL: TFDConnection;
    SQLQuery: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetScore(): integer;
    Procedure SetScore(i : integer);
    function SelRefreshToken(): tDataSet;
    function SelInfoChannels(): TShortChannels;
    function InsRefreshToken(pShortChanel: TShortChannel): integer;
    function LoadAnyImage(pUrl: string): TStream;
    procedure SaveTestImage(pSS3: TBitmap);
    procedure DelChannel(pId: String);
    function Upd_sel_Lang_RefreshToken(pId_channel: string;
      pSel_Lang: string): integer;
    function LoadLanguage(): TListLanguages;
    function LoadAddVideo(pIdChannel: string): TShortChannels;
    function GetAppLocalization(CurrentLanguage: string): TAppLocalization;
  end;

var
  SQLiteModule: TSQLiteModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

// загрузка данных по очкам
function TSQLiteModule.GetScore(): integer;
var
  res, i: integer;
  results: tDataSet;
begin
  try
    // затем поменять запрос
    SQLiteModule.SQL.ExecSQL('select * from refresh_token where deleted = 0',
      nil, results);
  except
    on E: Exception do
      showmessage('Exception raised with message: ' + E.Message);
  end;
  if not results.IsEmpty then
  begin
    results.First;
    i := 0;
    while not results.Eof do
    begin
//      i := results.FieldByName('deleted').AsInteger;
      i := 100; // что делать
      res := i * 1;
      results.Next;
    end;
  end;

  Result := res;
end;

// сохранение данных по очкам
Procedure TSQLiteModule.SetScore(i : integer);

begin
  try
    // !!! поменять запрос на реальные данные
    SQLQuery.SQL.Text :=
      'update refresh_token set img_channel= :photo where id_channel = "UCta8Fu2bQ9uVNr4VzARiwLA";';
     SQLQuery.Params[0].AsInteger := i;
    // SQLQuery.Params[0].Assign(i);
    SQLQuery.ExecSQL;
    SQLiteModule.SQL.Commit;

  except
    on E: Exception do
    begin
      SQLiteModule.SQL.Rollback;
      showmessage('Exception insert with message: ' + E.Message);
    end;
  end;

  SQLiteModule.SQL.Commit;

end;

// загрузка данных по не удаленным каналам
function TSQLiteModule.SelRefreshToken(): tDataSet;
var
  i: integer;
  results: tDataSet;
  Channel: Array [1 .. 1000] of TShortChannel;
  Bitimg: TBitmap;
begin
  try
    SQLiteModule.SQL.ExecSQL('select * from refresh_token where deleted = 0',
      nil, results);
  except
    on E: Exception do
      showmessage('Exception raised with message: ' + E.Message);
  end;
  if not results.IsEmpty then
  begin
    results.First;
    i := 0;
    while not results.Eof do
    begin
      inc(i);
      Channel[i].id_channel := results.FieldByName('id_channel').AsString;
      Channel[i].name_channel := results.FieldByName('name_channel').AsString;
      Channel[i].img_channel := TBlobType(results.FieldByName('img_channel'));
      Channel[i].refresh_token := results.FieldByName('refresh_token').AsString;
      Channel[i].lang := results.FieldByName('lang').AsString;
      Channel[i].sel_lang := results.FieldByName('sel_lang').AsString;
      Channel[i].deleted := results.FieldByName('deleted').AsInteger;
      results.Next;
    end;
  end;

  Result := results;
end;

// загрузка данных по всем каналам  и удаленным в том числе
function TSQLiteModule.SelInfoChannels(): TShortChannels;
var
  i: integer;
  results: tDataSet;
  Channels: TShortChannels;
begin
  try
    SQLiteModule.SQL.ExecSQL('select * from refresh_token', nil, results);
  except
    on E: Exception do
      showmessage('Exception raised with message: ' + E.Message);
  end;
  if not results.IsEmpty then
  begin
    results.First;
    i := 0;
    while not results.Eof do
    begin
      inc(i);

      Channels[i].id_channel := results.FieldByName('id_channel').AsString;
      Channels[i].name_channel := results.FieldByName('name_channel').AsString;
      Channels[i].img_channel := TBlobType(results.FieldByName('img_channel'));
      Channels[i].refresh_token := results.FieldByName('refresh_token')
        .AsString;
      Channels[i].lang := results.FieldByName('lang').AsString;
      Channels[i].sel_lang := results.FieldByName('sel_lang').AsString;
      Channels[i].deleted := results.FieldByName('deleted').AsInteger;
      results.Next;
    end;
  end;

  Result := Channels;
end;

// сохраняем данные загруженного канала
function TSQLiteModule.InsRefreshToken(pShortChanel: TShortChannel): integer;
var
  i: integer;
  results: tDataSet;
begin
  // showmessage('Что save 1');
  // pShortChanel.sel_lang := 'az, ay, ak, sq, am, en, ar, hy, as, af, bm, eu, be, bn, my, bg, bs, cy, hu, vi,';
  try
    SQLiteModule.SQL.ExecSQL
      ('delete from refresh_token where id_channel = :id_channel',
      [pShortChanel.id_channel]);
    { -- так не передать
      SQLiteModule.SQL.ExecSQL
      ('insert into refresh_token ( id_channel,name_channel,' +
      'refresh_token,lang, sel_lang, deleted, timeadd, img_channel )' +
      'values(:id_channel, :name_channel, :refresh_token,'+
      ':lang,:sel_lang,:deleted, :timeadd, :img_channel)',
      [pShortChanel.id_channel, pShortChanel.name_channel,
      pShortChanel.refresh_token, pShortChanel.lang,
      pShortChanel.sel_lang, pShortChanel.deleted, DateToStr(Date) + ' ' + TimeToStr(Time),
      TBlobType(pShortChanel.img)]);
      showmessage('SAVE Finish');
    }

    SQLQuery.SQL.Text := 'insert into refresh_token ( id_channel,name_channel,'
      + 'refresh_token,lang, sel_lang, deleted, timeadd, img_channel )' +
      'values(:id_channel, :name_channel, :refresh_token,' +
      ':lang,:sel_lang,:deleted, :timeadd, :img_channel);';
    SQLQuery.Params[0].AsString := pShortChanel.id_channel;
    SQLQuery.Params[1].AsString := pShortChanel.name_channel;
    SQLQuery.Params[2].AsString := pShortChanel.refresh_token;
    SQLQuery.Params[3].AsString := pShortChanel.lang;
    SQLQuery.Params[4].AsString := pShortChanel.sel_lang;
    SQLQuery.Params[5].AsInteger := pShortChanel.deleted;
    SQLQuery.Params[6].AsString := DateToStr(Date) + ' ' + TimeToStr(Time);
    SQLQuery.Params[7].Assign(pShortChanel.img);
    SQLQuery.ExecSQL;
    SQLiteModule.SQL.Commit;

  except
    on E: Exception do
    begin
      SQLiteModule.SQL.Rollback;
      showmessage('Exception insert with message: ' + E.Message);
    end;
  end;

  SQLiteModule.SQL.Commit;
  Result := 1;
end;

// где база находится
// а если вдруг нет базы данных модуля, то можно его создать?
procedure TSQLiteModule.DataModuleCreate(Sender: TObject);
begin
  // ClickConnection.Params.Add('Database='+mydir+'database.db');
  SQL.Params.Database := GetCurrentDir() + '\libast.dll';
  { try
    SQL.Connected := true;
    except
    on E: EDatabaseError do
    ShowMessage('Exception raised with message' + E.Message);
    end;
  }
end;

// загрузка фото из интернета по адресу
function TSQLiteModule.LoadAnyImage(pUrl: string): TStream; // TPicture;
var
  AValue, ConstSourceLang, ConstTargetLang: String;
  AResponce: IHTTPResponse;
  FHTTPClient: THTTPClient;
  AAPIUrl: String;
  // jpegimg: TJPEGImage;
  s: string;
  Ss: TStringStream;
begin
  begin
    s := StringReplace(pUrl, #13, '', [rfReplaceAll, rfIgnoreCase]);
    AAPIUrl := StringReplace(s, #10, '', [rfReplaceAll, rfIgnoreCase]);
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

    try
      // jpegimg := TJPEGImage.Create;
      // jpegimg.LoadFromStream(AResponce.ContentStream);
      // jpegimg.SaveToStream(Ss);
      // Result.Assign(jpegimg);
      // Image2.Picture.Assign(jpegimg);
      // Result.Assign(jpegimg);
      // Ss := TStringStream.Create(st);
      // Image1.Picture.Bitmap.SaveToStream(   (Ss);
    except
      // showmessage('Не Пусто1');
    end;
  end;
  Result := AResponce.ContentStream; // SS
end;

// просто для тестов, пересохранение рисунка по каналу в таблицу
procedure TSQLiteModule.SaveTestImage(pSS3: TBitmap);
begin
  begin
    SQLQuery.SQL.Text :=
      'update refresh_token set img_channel= :photo where id_channel = "UCta8Fu2bQ9uVNr4VzARiwLA";';
    // SQLQuery.Params[0].AsBlob := TBlobType(pSS3);
    SQLQuery.Params[0].Assign(pSS3);
    SQLQuery.ExecSQL;
    SQLiteModule.SQL.Commit;
  end;
end;

// удаление канала
procedure TSQLiteModule.DelChannel(pId: String);
begin
  begin
    SQLQuery.SQL.Text :=
      'update refresh_token set deleted = 1 where id_channel = :pId;';
    SQLQuery.Params[0].AsString := pId;
    SQLQuery.ExecSQL;
    SQLiteModule.SQL.Commit;
  end;
end;

// загрузка данных по всем каналам
function TSQLiteModule.LoadAddVideo(pIdChannel: string): TShortChannels;
var
  i: integer;
  results: tDataSet;
  Channels: TShortChannels;
begin
  try
    SQLiteModule.SQL.ExecSQL('select * from refresh_token', nil, results);
  except
    on E: Exception do
      showmessage('Exception raised with message: ' + E.Message);
  end;
  if not results.IsEmpty then
  begin
    results.First;
    i := 0;
    while not results.Eof do
    begin
      inc(i);

      Channels[i].id_channel := results.FieldByName('id_channel').AsString;
      Channels[i].name_channel := results.FieldByName('name_channel').AsString;
      Channels[i].img_channel := TBlobType(results.FieldByName('img_channel'));
      Channels[i].refresh_token := results.FieldByName('refresh_token')
        .AsString;
      Channels[i].lang := results.FieldByName('lang').AsString;
      Channels[i].sel_lang := results.FieldByName('sel_lang').AsString;
      Channels[i].deleted := results.FieldByName('deleted').AsInteger;
      results.Next;
    end;
  end;

  Result := Channels;
end;

// загрузка данных по всем языкам
function TSQLiteModule.LoadLanguage(): TListLanguages;
var
  i: integer;
  results: tDataSet;
  vList: TListLanguages;
begin
  try
    SQLiteModule.SQL.ExecSQL('select * from lang order by lang_name_en',
      nil, results);
  except
    on E: Exception do
      showmessage('Exception raised with message: ' + E.Message);
  end;
  if not results.IsEmpty then
  begin
    results.First;
    i := 0;
    while not results.Eof do
    begin
      inc(i);
      vList[i].Id := i;
      vList[i].LnCode := results.FieldByName('lang_code').AsString;
      vList[i].NameEnglish := results.FieldByName('lang_name_en').AsString;
      vList[i].NameLocal := vList[i].NameEnglish;
      results.Next;
    end;
  end;

  Result := vList;
end;

// сохранение выбранных языков в настройках канала
function TSQLiteModule.Upd_sel_Lang_RefreshToken(pId_channel: string;
  pSel_Lang: string): integer;
var
  i: integer;
  results: tDataSet;
begin
  // showmessage('Что save ' + pId_channel + 'строка ' + pSel_Lang);
  try
    SQLiteModule.SQL.ExecSQL
      ('update refresh_token set sel_lang = :sel_lang  where id_channel = :id_channel',
      [pSel_Lang, pId_channel]);

  except
    on E: Exception do
    begin
      SQLiteModule.SQL.Rollback;
      showmessage('Exception update sel_lang with message: ' + E.Message);
    end;
  end;

  SQLiteModule.SQL.Commit;
  Result := 1;
end;

function TSQLiteModule.GetAppLocalization(CurrentLanguage: string)
  : TAppLocalization;
var
  vLocalization: TAppLocalization;
begin
  with vLocalization do
  begin
    language := CurrentLanguage;

    if language = 'ru' then
    begin
      MsgInfoUpdate := 'Вышла новая версия программы! Обновитесь!';

      PanelTop_LabelYouTube := 'Создано совместно с YouTube';
      PanelTop_ButtonMonеy := 'Добавить';
      PanelTop_ButtonUpdate :=  'Обновить версию';

      First_LabelName := 'Введите Email';
      First_LabelPas := 'Пароль';
      First_ButtonLog := 'Войти';
      First_ButtonReg := 'Создать новый аккаунт';

      AddUser_LabelEmail := 'Введите ваш email';
      AddUser_LabelPass1 := 'Введите  пароль';
      AddUser_LabelPass2 := 'Повторно введите пароль';
      AddUser_ButtonSend := 'Зарегистрироваться';
      AddUser_MsgEmail := 'Неверный формат Email';
      AddUser_MsgPassword1 := 'Задайте пароли';
      AddUser_MsgPassword2 := 'Пароли не совпадают';

      Channels_LabelChannels := 'Ваши каналы';
      Channels_ButtonAddChannel := 'Подключить Youtube от Google';

      MainChannel_LabelNameChannel := 'Текущий канал';
      MainChannel_ButtonAddNextVideo := 'Показать предыдущие видео';

      MainVideos_LabelVideos := 'Текущее видео';
      MainVideos_LanguageCheckBox := 'Сменить язык для перевода';
      MainVideos_LabelTitle := 'Наименование';
      MainVideos_LabelDescription := 'Описание';
      MainVideos_BTranslater := 'Перевести';

      FrameLanguages_LabelTextCount := 'Выбрано языков:';
      FrameLanguages_ButtonTitle := 'Перевести описание';
      FrameLanguages_ButtonSubtitles := 'Перевести субтитры';
    end
    else // английский язык по умолчанию
    begin
      MsgInfoUpdate := 'New release! Update the program!';

      PanelTop_LabelYouTube := 'Developed with YouTube';
      PanelTop_ButtonMonеy := 'Add';
      PanelTop_ButtonUpdate :=  'Update the version';

      First_LabelName := 'Email';
      First_LabelPas := 'Password';
      First_ButtonLog := 'Log In';
      First_ButtonReg := 'Create new account';

      AddUser_LabelEmail := 'Enter your email';
      AddUser_LabelPass1 := 'Enter the password';
      AddUser_LabelPass2 := 'Enter the password again';
      AddUser_ButtonSend := 'Sign Up';
      AddUser_MsgEmail := 'Invalid email format';
      AddUser_MsgPassword1 := 'Enter passwords';
      AddUser_MsgPassword2 := 'Passwords don''t match';

      Channels_LabelChannels := 'Your channels';
      Channels_ButtonAddChannel := 'Add Channels with Google';

      MainChannel_LabelNameChannel := 'Your channel';
      MainChannel_ButtonAddNextVideo := 'Show previous videos';

      MainVideos_LabelVideos := 'Video';
      MainVideos_LanguageCheckBox := 'Change the language';
      MainVideos_LabelTitle := 'Title';
      MainVideos_LabelDescription := 'Description';
      MainVideos_BTranslater := 'Translate';

      FrameLanguages_LabelTextCount := 'Number of selected languages:';
      FrameLanguages_ButtonTitle := 'Translation of the description';
      FrameLanguages_ButtonSubtitles := 'Translation of subtitles';
    end;
  end;
  result := vLocalization;
end;

end.
