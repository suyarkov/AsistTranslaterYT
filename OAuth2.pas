unit OAuth2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.StrUtils,
  //FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  //MimeDelpta,
  JSON,
  Rest.Client,
  Rest.Types,
  Generics.Collections,
  FMX.Dialogs,
  uWinHardwareInfo,
  System.NetEncoding,
  IdHTTP,
  IdSSLOpenSSL,
  IdGlobal,
  IdURI, IdException,
  System.Net.HttpClient, System.Net.Mime, System.Net.URLClient
  ;

const
  redirect_uri = 'http://127.0.0.1:1904';

type
  TOAuth = class(TObject)//class
  private
    FClientID: string; // id клиента
    FClientSecret: string; // секретный ключ клиента приложения
    FScope: string;        // тип необходимых разрешения
    FExpires_in: TDateTime;
    FRefresh_token: string; // токен подключения -- токен обновлений
    FAccess_token: string;  // ключ доступа  -- токен доступа
    FResponseCode: string;  // точка доступа     -- код авторизации, который
                            //приложение может обменять на токен доступа и токен обновления.

    FFireBaseToken: string; // токен для складывания  в Fire базу - у нас это не используется, это доступ к Сашиному Fire

    procedure SetClientID(const Value: string);
    procedure SetScope(const Value: string);

    function ParamValue(ParamName, JSONString: string): string;
    procedure SetAccess_token(const Value: string);      // установить ключ доступа
    procedure SetRefresh_token(const Value: string);     // установить токен длинный - обменный
    procedure SendRequest(URL: string; AFile: string); overload;  // перегруженная отправка
    function SendRequest(URL: string; Params: TDictionary<string, string>; Headers: TDictionary<string, string>; JSON: string; Method: TRESTRequestMethod; AFile: string = ''): string; overload;
    procedure SetResponseCode(const Value: string);   // установка ответного кода
    procedure ServerResponseToFile(AResponse: TRestResponse; AFileName: string);

  public
    function SubtitleDelete(SubtitleID: string): string;
    function SubtitleList(VideoID: string): string;
//    function SubtitleDownload(CaptionID, TargetLang: string): string;
    function SubtitleDownload(const CaptionID: string): string;
    function SubtitleInsert3(const FileName,VideoID, Language, SubtitleName: String; IsDraft: Boolean = False): Boolean;
    function SubtitleInsert2(const FileName: String): Boolean;
    function SubtitleInsert(const JSON: string; const FileName: String): string;

    function TitleDelete(LangID: string): string;
    function TitleInsert(LangID,KeyTitle, KeyDescription: string): string;

    function Language: string;
    function GetTokenInfo: string;  // информация о токене? а для чего она то нужна?

    function VideoInfo(AVideoID: string): string;   // об одном видео
    function VideoUpdate(JSON: string): string;

    function MyVideos(AChannelID: string; NextToken: string = ''): string; // данные о всех виде
    function MyChannels: string;       // данные о канале
    function ChannelInfo(AChannelID: string ): string; // об одном канале
    function AccessURL: string;        // урл подключения
    function GetAccessToken: string;   // получить соединительный токен подключения
    function RefreshAccessToken: string;     // временный ключ получить по RefreshToken токену (а зачем так часто я дергаю этот номер? а не юзаю временный)

    function FireBaseAuth: string;
    function FireBaseGet(ACollection: string): string;
    function FireBaseUpdate(ACollection, JSON: string): string;
    function FireBaseInsert(ACollection, ADocID, JSON: string): string;

    function UserGet(ACollection, ACollection2: string): string;
    function UserAdd(ACollection, ACollection2, ACollection3: string): string;
    function Clicks(ACollection, ACollection2, ACollection3, ACollection4: string): string;
    function Version(): string;
    function TestDoubleEmail(AEmail: string): integer;


    constructor Create;
    destructor destroy; override;

    property ClientID: string read FClientID write SetClientID;
    property Scope: string read FScope write SetScope;
    property ClientSecret: string read FClientSecret write FClientSecret;
    property Access_token: string read FAccess_token write SetAccess_token;
    property Refresh_token: string read FRefresh_token write SetRefresh_token;
    property ResponseCode: string read FResponseCode write SetResponseCode;
  end;

implementation

function TOAuth.AccessURL: string;
const
  oauth_url = 'https://accounts.google.com/o/oauth2/v2/auth?scope=%s&access_type=offline&include_granted_scopes=true&state=security_token&response_type=code&redirect_uri=%s&client_id=%s';
begin
  Result := Format(oauth_url, [Scope, redirect_uri, ClientID]);
end;

constructor TOAuth.Create;
begin
  inherited;
   // Инициализация ClientID и ClientSecret при создании объекта
  FClientID := '701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com';
  FClientSecret := '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';

end;

destructor TOAuth.destroy;
begin
  inherited;
end;

procedure TOAuth.SetAccess_token(const Value: string);
begin
  FAccess_token := Value;
end;

procedure TOAuth.SetClientID(const Value: string);
begin
  FClientID := Value;
end;

procedure TOAuth.SetRefresh_token(const Value: string);
begin
  FRefresh_token := Value;
end;

procedure TOAuth.SetResponseCode(const Value: string);
begin
  FResponseCode := Value;
end;

procedure TOAuth.SetScope(const Value: string);
begin
  FScope := Value;
end;

procedure TOAuth.SendRequest(URL: string; AFile: string);
var
  FRest: TRestClient;
  FRequest: TRestrequest;
  FResponse: TRestResponse;
  i: integer;
  Key: String;
  LParam: TRESTRequestParameter;
//  Boundary: string;
begin
  FRest := TRestClient.Create(URL);
  FResponse := TRestResponse.Create(nil);

  FRequest := TRestrequest.Create(nil);
  FRequest.Client := FRest;
  FRequest.Method := rmGet;
  FRequest.Response := FResponse;

  try

    FRequest.Execute;
    case FResponse.StatusCode of
      200:
        begin

          if Length(FResponse.RawBytes) <> 0 then
            ServerResponseToFile(FResponse, AFile);
        end;
    end;
  finally

  end;

end;


//Используйте только для обычных запросов. Для multipart/related (аналогично upload/youtube/v3/captions) — это не работает!
//не заработало! нужно логику менять под частные случаи
{function TOAuth.SendRequest(
  URL: string;
  Params: TDictionary<string, string>;
  Headers: TDictionary<string, string>;
  JSON: string;
  Method: TRESTRequestMethod;
  AFile: string = ''
): string;
var
  FRest: TRESTClient;
  FRequest: TRESTRequest;
  FResponse: TRESTResponse;
  Key: string;
begin
  FRest := nil;
  FRequest := nil;
  FResponse := nil;
  Result := '';
  try
    FRest := TRESTClient.Create(URL);
    FResponse := TRESTResponse.Create(nil);
    FRequest := TRESTRequest.Create(nil);
    FRequest.Client := FRest;
    FRequest.Method := Method;
    FRequest.Response := FResponse;

    if Params <> nil then
      for Key in Params.Keys do
        FRequest.Params.AddItem(Key, Params.Items[Key], pkGETorPOST);

    if Headers <> nil then
      for Key in Headers.Keys do
        FRequest.Params.AddHeader(Key, Headers.Items[Key]);

    if JSON <> '' then
      FRequest.AddBody(JSON, TRESTContentType.ctAPPLICATION_JSON);

    if (AFile <> '') and (JSON = '') then
      FRequest.AddFile('file', AFile, ctAPPLICATION_OCTET_STREAM);

    FRequest.Execute;
    Result := FResponse.Content;
  finally
    FResponse.Free;
    FRequest.Free;
    FRest.Free;
  end;
end;
}

function TOAuth.SendRequest(URL: string; Params: TDictionary<string, string>;
    Headers: TDictionary<string, string>; JSON: string; Method: TRESTRequestMethod; AFile: string = ''): string;
var
  FRest: TRestClient;
  FRequest: TRestrequest;
  FResponse: TRestResponse;
  i: integer;
  Key: String;
  LParam: TRESTRequestParameter;
//  Boundary: string;
begin
  FRest := TRestClient.Create(URL);
  FResponse := TRestResponse.Create(nil);

  FRequest := TRestrequest.Create(nil);
  FRequest.Client := FRest;
  FRequest.Method := Method;
  FRequest.Response := FResponse;

  if Headers <> nil then
    for Key in Headers.Keys do
      if NOT FRequest.Params.ContainsParameter(Key) then
      begin
        with FRequest.Params.AddHeader(Key, Headers.Items[Key]) do
          Options := Options + [poDoNotEncode];
      end;

  if Params <> nil then
    for Key in Params.Keys do
      if NOT FRequest.Params.ContainsParameter(Key) then
        FRequest.Params.AddItem(Key, Params.Items[Key]);

  if JSON <> '' then
  begin
    FRequest.AddBody(JSON, 'application/json');
//     showmessage('в тело вставляем JSON:' + JSON);
    if AFile <> '' then
    begin
      showmessage('в тело вставляем file:' + AFile);
      FRequest.AddFile('file', AFile, ctAPPLICATION_OCTET_STREAM);
    end;
  end;

  try
    FRequest.Execute;
//    showmessage('выполенение' + IntToStr(FResponse.StatusCode));
    case FResponse.StatusCode of
      200:
        begin
          if Pos('captions/', URL) <> 0 then
            if Length(FResponse.RawBytes) <> 0 then
            begin
//              showmessage('что то есть для сохранения! captions');
              ServerResponseToFile(FResponse, 'default.sbv');  // он сам автоматом прибавит текущую дирректорию
            end;
          if Pos(';', FResponse.Content) <> 0 then    // ответы от базы нашей, где активация
            Result := FResponse.Content // '200' +  + URL
          else
            Result := FResponse.JSONText; // '200' +  + URL
          //  FResponse.Content

        end;
      403:
        begin
          Result := '403' + FResponse.JSONText;
        end;
      400:
        begin
          //Result := '400' + FResponse.JSONText;
          if FResponse.StatusText = 'Bad Request' then
            Result := IntToStr(FResponse.StatusCode) + ' JSON ' + FResponse.JSONText + ' TEXT ' + FResponse.StatusText + ' Плохой запрос. Права к ресурсу ограничены!'
          else
            Result := IntToStr(FResponse.StatusCode) + ' JSON ' + FResponse.JSONText + ' TEXT ' + FResponse.StatusText + ' Требуется переподключиться к аккаунту!';

          showmessage(Result);
        end;
        else // 404 и другие
        begin
          Result := IntToStr(FResponse.StatusCode) + ' JSON ' + FResponse.JSONText + ' TEXT ' + FResponse.StatusText + ' ???';
          showmessage(Result);
        end;
    end;
  finally
//    Result := 'finally '  + Result;
  end;
end;

procedure TOAuth.ServerResponseToFile(AResponse: TRestResponse; AFileName: string);
var
  SomeStream: TMemoryStream;
  local_filename: string;
begin
{$IF DEFINED(MsWindows)}
  local_filename := ExtractFilePath(ParamStr(0)) + AFileName;
{$ENDIF}
  SomeStream := TMemoryStream.Create;
  SomeStream.WriteData(AResponse.RawBytes, Length(AResponse.RawBytes));
  SomeStream.SaveToFile(local_filename);
  SomeStream.Free;
end;

function TOAuth.GetAccessToken: string;
const
  tokenurl = 'https://oauth2.googleapis.com/token';
//'https://accounts.google.com/o/oauth2/token';
//  https://www.googleapis.com/oauth2/v4/token

var
  Params: TDictionary<String, String>;
  Response: string;
begin
  Params := TDictionary<String, String>.Create;


  Params.Add('client_id', ClientID);
  Params.Add('client_secret', ClientSecret);
  Params.Add('code', StringReplace(ResponseCode, '%2F', '/', [rfReplaceAll]));
{  Params.Add('client_id','701561007019-tm4gfmequr8ihqbpqeui28rp343lpo8b.apps.googleusercontent.com');
  Params.Add('client_secret','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');
  //key AIzaSyApGfcEMp2QK8Z_enQdbZnPGWCEI8TWAXY
  //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
  Params.Add('code','4/0Adeu5BX2xn5jUnFllh5K9xt_FBwdXRl1yHkAi60rO1vEz1NqCPx2QMZa0O5WbDSNBI8MWg');}
  Params.Add('redirect_uri', redirect_uri);
  Params.Add('grant_type', 'authorization_code'); //'authorization_code'


  Response := SendRequest(tokenurl, Params, nil, '', rmPost);

//  showmessage(Response);

  Access_token := TRIM(ParamValue('access_token', Response));
  Refresh_token := StringReplace(TRIM(ParamValue('refresh_token', Response)), '\', '', [rfReplaceAll]);
  Result := Access_token;
end;

// получение информация о токете обновлений???   действителен ли он все ещё рабочий
function TOAuth.GetTokenInfo: string;
const
  tokenurl = 'https://www.googleapis.com/oauth2/v3/tokeninfo';
var
  Params: TDictionary<String, String>;
  Response: string;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('access_token', RefreshAccessToken);

  Response := SendRequest(tokenurl, Params, nil, '', rmGet);
  Result := ParamValue('access_type', Response);
end;

// My channels
function TOAuth.MyChannels: string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/channels';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('part', 'snippet,statistics');
  Params.Add('mine', 'true');

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');

  Result := SendRequest(URL, Params, Headers, '', rmGet);

  Params.Free;
  Headers.Free
end;

// channel
function TOAuth.ChannelInfo(AChannelID: string ): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/channels';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('id', AChannelID);
  Params.Add('part', 'snippet,statistics');
  Params.Add('mine', 'true');

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');

  Result := SendRequest(URL, Params, Headers, '', rmGet);

  Params.Free;
  Headers.Free
end;

// My videos
function TOAuth.MyVideos(AChannelID: string; NextToken: string = ''): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/search';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('part', 'snippet');
  Params.Add('forMine', 'true');
  Params.Add('maxResults', '10');
  Params.Add('type', 'video');

  if NextToken <> '' then
    Params.Add('pageToken', NextToken);

  if AChannelID <> '' then
    Params.Add('channelID', AChannelID);

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');

  Result := SendRequest(URL, Params, Headers, '', rmGet);
end;

// Info video
function TOAuth.VideoInfo(AVideoID: string): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/videos';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('part', 'snippet');
  Params.Add('id', AVideoID);

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');

  Result := SendRequest(URL, Params, Headers, '', rmGet);
end;

// Language
function TOAuth.Language: string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/i18nLanguages';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('part', 'snippet');
  Params.Add('hl', 'en_US');

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');

  Result := SendRequest(URL, Params, Headers, '', rmGet);
end;

// Update video
function TOAuth.VideoUpdate(JSON: string): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/videos';
var
  Response: string;
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
//{
//  "id": "YOUR_VIDEO_ID",
//  "localizations": {
//    "es": {
//      "title": "no hay nada a ver aqui",
//      "description": "Esta descripcion es en español."
//    }
//  }
//}
  Params := TDictionary<String, String>.Create;
  Params.Add('part', 'snippet,status,localizations');
  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');

  Response := SendRequest(URL, Params, Headers, JSON, rmPUT);
  Result := Response;
//  Result := TRIM(ParamValue('channelId', Response));
end;

// Subtitle list
function TOAuth.SubtitleList(VideoID: string): string;
const
  URL = 'https://www.googleapis.com/youtube/v3/captions';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('part', 'snippet');
  Params.Add('videoId', VideoID);

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');

  Result := SendRequest(URL, Params, Headers, '', rmGet);
end;

{
function TOAuth.SubtitleDownload(const CaptionID: string): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/captions/%s';
var
  client: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  client := TIdHTTP.Create(nil);
  ssl := TIdSSLIOHandlerSocketOpenSSL.Create(client);
  try
    client.IOHandler := ssl;
    client.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + RefreshAccessToken;
    // Не задаём Accept, Content-Type!
    Result := client.Get(Format(URL + '?tfmt=sbv', [CaptionID]));
  finally
    ssl.Free;
    client.Free;
  end;
end;
}

function TOAuth.SubtitleDownload(const CaptionID: string): string;
const
  CAPTIONS_API_URL = 'https://youtube.googleapis.com/youtube/v3/captions/%s';
var
  httpClient: TIdHTTP;
  sslHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  httpClient := TIdHTTP.Create(nil);
  sslHandler := TIdSSLIOHandlerSocketOpenSSL.Create(httpClient);
  try
    // Настройка SSL
    sslHandler.SSLOptions.Method := sslvTLSv1_2;
    sslHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    sslHandler.SSLOptions.Mode := sslmClient;

    httpClient.IOHandler := sslHandler;
    httpClient.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + RefreshAccessToken;
    httpClient.Request.Accept := 'text/plain'; // Для субтитров обычно используется text/plain

    // Установка таймаутов
    httpClient.ConnectTimeout := 5000; // 5 секунд на соединение
    httpClient.ReadTimeout := 15000;   // 15 секунд на чтение данных

    try
      Result := httpClient.Get(Format(CAPTIONS_API_URL + '?tfmt=sbv', [TIdURI.ParamsEncode(CaptionID)]));

      if httpClient.ResponseCode <> 200 then
        raise Exception.CreateFmt('Ошибка загрузки субтитров. Код ответа: %d: %s',
          [httpClient.ResponseCode, httpClient.ResponseText]);

    except
      on E: EIdHTTPProtocolException do
        raise Exception.CreateFmt('Ошибка протокола HTTP %d: %s', [E.ErrorCode, E.Message]);
//      on E: EIdSocketError do
//        raise Exception.Create('Ошибка сетевого соединения: ' + E.Message);
      on E: Exception do
        raise Exception.Create('Ошибка при загрузке субтитров: ' + E.Message);
    end;

  finally
    sslHandler.Free;
    httpClient.Free;
  end;
end;


{
function TOAuth.SubtitleDownload(CaptionID, TargetLang: string): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/captions/%s';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  try
    Params.Add('tfmt', 'sbv');
    if Trim(TargetLang) <> '' then
      Params.Add('tlang', TargetLang);

    Headers := TDictionary<String, String>.Create;
    try
      Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken); // используйте access_token
      Headers.Add('Accept', 'text/plain');
      // Заголовок Content-Type здесь для GET не нужен и даже вреден

      Result := SendRequest(Format(URL, [CaptionID]), Params, Headers, '', rmGet);
    finally
      Headers.Free;
    end;
  finally
    Params.Free;
  end;
end;
}
{
function TOAuth.SubtitleDownload(const CaptionID: string): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/captions/%s';
var
  client: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  client := TIdHTTP.Create(nil);
  ssl := TIdSSLIOHandlerSocketOpenSSL.Create(client);
  try
    // Настройка SSL
    ssl.SSLOptions.Method := sslvTLSv1_2;
    ssl.SSLOptions.SSLVersions := [sslvTLSv1_2];
    ssl.SSLOptions.Mode := sslmClient;

    client.IOHandler := ssl;
    client.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + RefreshAccessToken;
    client.Request.Accept := 'application/json'; // или 'text/xml', 'text/plain' в зависимости от формата

    try
      Result := client.Get(Format(URL + '?tfmt=sbv', [TIdURI.ParamsEncode(CaptionID)]));

      // Проверка кода ответа
      if client.ResponseCode <> 200 then
        raise Exception.CreateFmt('HTTP error %d: %s', [client.ResponseCode, client.ResponseText]);

    except
      on E: EIdHTTPProtocolException do
        raise Exception.CreateFmt('HTTP error %d: %s', [E.ErrorCode, E.Message]);
      on E: Exception do
        raise;
    end;

  finally
    ssl.Free;
    client.Free;
  end;
end;
}
{
// Subtitle download
function TOAuth.SubtitleDownload(CaptionID, TargetLang: string): string;
const
    URL = 'https://youtube.googleapis.com/youtube/v3/captions/%s';
//    URL = 'https://youtube.googleapis.com/youtube/v3/captions/';
//    URL = 'https://youtube.googleapis.com/youtube/v3/captions/%s';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
//  Params.Add('id', CaptionID);  // по идее это лишнее
  Params.Add('tfmt', 'sbv');
  if TargetLang <> '' then
    Params.Add('tlang', 'TargetLang');

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');
//  Headers.Add('Content-Type', 'multipart/related; boundary=AUTO');
//  Headers.Add('Content-Type', 'multipart/related; boundary=AA0512');
//  showmessage('Куда стучимся =  ' + Format(URL, [CaptionID]));
//  Result := SendRequest(URL, Params, Headers, '', rmGet);
  Result := SendRequest(Format(URL, [CaptionID]), Params, Headers, '', rmGet);
end;
}

// Subtitle delete
function TOAuth.SubtitleDelete(SubtitleID: string): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/captions';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('id', SubtitleID);

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');

  Result := SendRequest(URL, Params, Headers, '', rmDelete, '');
end;

{
// Subtitle insert
function TOAuth.SubtitleInsert(JSON: string; FileName: String): string;
const
//  URL = 'https://youtube.googleapis.com/upload/youtube/v3/captions';
//    URL = 'https://youtube.googleapis.com/youtube/v3/captions?part=snippet&key=[YOUR_API_KEY]';
//  URL = 'https://youtube.googleapis.com/youtube/v3/captions';
  URL = 'https://www.googleapis.com/upload/youtube/v3/captions';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('part', 'snippet');

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshToken);
  Headers.Add('Accept', 'application/json');
//  Headers.Add('Content-Type', 'multipart/related; boundary=AUTO');
//  Headers.Add('Content-Type', 'multipart/form-data; boundary="AA0512"');
//  Headers.Add('Content-Type', 'multipart/related; boundary=AUTO');
//  Headers.Add('Content-Type', 'multipart/related; boundary=AUTO');
  Headers.Add('Content-Type', 'multipart/related; boundary=AA0512');
//  Headers.Add('Content-Type', 'application/json');


  Result := SendRequest(URL, Params, Headers, JSON, rmPost, FileName);
end;
}
{
function TOAuth.SubtitleInsert(const JSON: string; const FileName: String): string;
const
  URL = 'https://www.googleapis.com/upload/youtube/v3/captions';
  BOUNDARY = 'AA0512'; // boundary по сути можно рандомизировать
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
  Payload: TMemoryStream;
begin
  Params := TDictionary<String, String>.Create;
  Headers := TDictionary<String, String>.Create;
  try
    Params.Add('part', 'snippet');

    // !! Используйте корректный AccessToken. RefreshToken не подходит для Bearer.
    Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken); // AccessToken -- так говорил ИИ
    Headers.Add('Accept', 'application/json');
    Headers.Add('Content-Type', 'multipart/related; boundary=' + BOUNDARY);

    // Предполагаем, что функция SendRequest правильно формирует multipart-запрос
    // и использует JSON + FileName в запросе.
    // Хорошо бы проверить правильность работы SendRequest.

    // --- Если нужно вручную собрать multipart payload: делайте это ЗДЕСЬ ---
    // --- И передавайте уже готовый stream в SendRequest ---

    Result := SendRequest(URL, Params, Headers, JSON, rmPost, FileName);

  finally
    Params.Free;
    Headers.Free;
  end;
end;
}


function TOAuth.SubtitleInsert3(const FileName, VideoID, Language, SubtitleName: String; IsDraft: Boolean = False): Boolean;
var
  HTTPClient: THTTPClient;
  Params: TMultipartFormData;
  Response: IHTTPResponse;
  URL: String;
  SnippetJSON: TJSONObject;
  JSONBody: TStringStream;
  AccessToken: UTF8String;
begin
  AccessToken := RefreshAccessToken;
  Result := False;
  if not FileExists(FileName) then
    raise Exception.Create('Subtitle file not found: ' + FileName);

  HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ContentType := 'multipart/form-data';
    HTTPClient.CustomHeaders['Authorization'] := 'Bearer ' + AccessToken;

    // Создаем JSON для метаданных
    SnippetJSON := TJSONObject.Create;
    try
      SnippetJSON.AddPair('language', Language);
      SnippetJSON.AddPair('name', SubtitleName);
      SnippetJSON.AddPair('videoId', VideoID);
      SnippetJSON.AddPair('isDraft', TJSONBool.Create(IsDraft));
      showmessage('Отправляемый JSON: ' + SnippetJSON.ToJSON);
      Params := TMultipartFormData.Create;
      try
        // Добавляем метаданные как часть form-data
        Params.AddField('metadata', SnippetJSON.ToJSON, 'application/json; charset=UTF-8');
        // Добавляем файл субтитров
        Params.AddFile('file', FileName);

        URL := 'https://www.googleapis.com/upload/youtube/v3/captions?part=snippet';
        Response := HTTPClient.Post(URL, Params);

        if Response.StatusCode = 200 then
          Result := True
        else
          raise Exception.CreateFmt('YouTube API Error: %d. Response: %s',
            [Response.StatusCode, Response.ContentAsString]);
      finally
        Params.Free;
      end;
    finally
      SnippetJSON.Free;
    end;
  finally
    HTTPClient.Free;
  end;
end;

function TOAuth.SubtitleInsert2(const FileName: String): Boolean;
var
  HTTPClient: THTTPClient;
  RequestStream: TStream;
  Response: IHTTPResponse;
  URL: String;
  Params: TMultipartFormData;
  JSONResponse: TJSONObject;
  AccessToken: UTF8String;
begin
  AccessToken := RefreshAccessToken;
  Result := False;
  if not FileExists(FileName) then
    raise Exception.Create('Subtitle file not found: ' + FileName);

  HTTPClient := THTTPClient.Create;
  try
    try
      // Устанавливаем заголовки
      HTTPClient.ContentType := 'application/json';
      HTTPClient.CustomHeaders['Authorization'] := 'Bearer ' + AccessToken;

      // Создаем multipart/form-data запрос
      Params := TMultipartFormData.Create;
      try
        // Добавляем файл с субтитрами
        Params.AddFile('file', FileName);

        // Формируем URL для загрузки
        URL := 'https://www.googleapis.com/upload/youtube/v3/captions?part=snippet';

        // Отправляем запрос
        Response := HTTPClient.Post(URL, Params);

        // Проверяем ответ
        if Response.StatusCode = 200 then
        begin
          JSONResponse := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
          try
            if Assigned(JSONResponse) then
              Result := JSONResponse.GetValue('id') <> nil;
          finally
            JSONResponse.Free;
          end;
        end
        else
        begin
          raise Exception.CreateFmt('uploading. St: %d, Resp: %s',
            [Response.StatusCode, Response.ContentAsString]);
        end;
      finally
        Params.Free;
      end;
    except
      on E: Exception do
        raise Exception.Create('Subtitle upload: ' + E.Message);
    end;
  finally
    HTTPClient.Free;
  end;
end;


//SubtitleInsert: реализация multipart/related через Indy
//Только этот способ работает для загрузки субтитров YouTube!

function TOAuth.SubtitleInsert(const JSON: string; const FileName: String): string;
const
  URL = 'https://www.googleapis.com/upload/youtube/v3/captions?part=snippet';
//  BOUNDARY = 'AA0512';
var
  IdHTTP: TIdHTTP;
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  PostStream: TMemoryStream;
  Line, AccessToken: UTF8String;
  FileStream: TFileStream;
  BOUNDARY: string;
begin
  BOUNDARY := 'Boundary_' + IntToHex(Random(MaxInt), 8); // Случайный boundary
  Result := '';
  if not FileExists(FileName) then
    raise Exception.Create('File not found: ' + FileName);

  IdHTTP := TIdHTTP.Create(nil);
  try
    IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    try
      IdHTTP.IOHandler := IdSSL;
      IdHTTP.ConnectTimeout := 30000; // 30 sec
      IdHTTP.ReadTimeout := 60000;    // 60 sec

      PostStream := TMemoryStream.Create;
      try
        FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
        try
          Line :=
            '--' + BOUNDARY + #13#10 +
            'Content-Type: application/json; charset=UTF-8' + #13#10#13#10 +
            UTF8String(JSON) + #13#10 +
            '--' + BOUNDARY + #13#10 +
            'Content-Type: application/octet-stream' + #13#10#13#10;
          PostStream.WriteBuffer(Line[1], Length(Line));
          PostStream.CopyFrom(FileStream, 0);
          Line := #13#10 + '--' + BOUNDARY + '--' + #13#10;
          PostStream.WriteBuffer(Line[1], Length(Line));
          PostStream.Position := 0;

          AccessToken := RefreshAccessToken;
          IdHTTP.Request.CustomHeaders.Clear;
          IdHTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + AccessToken);
          IdHTTP.Request.ContentType := 'multipart/related; boundary=' + BOUNDARY;
          IdHTTP.Request.Accept := 'application/json';

          try
            Result := IdHTTP.Post(URL, PostStream);
          except
            on E: EIdHTTPProtocolException do
              raise Exception.Create('HTTP Error: ' + E.ErrorMessage + ' | Response: ' + E.Message);
//            on E: EIdSocketError do
//              raise Exception.Create('Socket Error: ' + E.Message);
            on E: Exception do
              raise;
          end;
        finally
          FileStream.Free;
        end;
      finally
        PostStream.Free;
      end;
    finally
      IdSSL.Free;
    end;
  finally
    IdHTTP.Free;
  end;
end;

{
function TOAuth.SubtitleInsert(const JSON: string; const FileName: String): string;
const
  URL = 'https://www.googleapis.com/upload/youtube/v3/captions?part=snippet';
  BOUNDARY = 'AA0512';
var
  IdHTTP: TIdHTTP;
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  PostStream: TMemoryStream;
  Line, AccessToken: UTF8String;
  FileStream: TFileStream;
begin
  Result := '';
  if not FileExists(FileName) then
    raise Exception.Create('File not found: ' + FileName);

  IdHTTP := TIdHTTP.Create(nil);
  try
    IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    try
      IdHTTP.IOHandler := IdSSL;
      PostStream := TMemoryStream.Create;
      try
        // Read file to stream
        FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
        try
          // формируем тело вручную (multipart/related)
          Line :=
            '--' + BOUNDARY + #13#10 +
            'Content-Type: application/json; charset=UTF-8' + #13#10#13#10 +
            UTF8String(JSON) + #13#10 +  // Используем прямое приведение к UTF8String
            '--' + BOUNDARY + #13#10 +
            'Content-Type: application/octet-stream' + #13#10#13#10;
          PostStream.WriteBuffer(Line[1], Length(Line));
          PostStream.CopyFrom(FileStream, 0);
          Line := #13#10 + '--' + BOUNDARY + '--' + #13#10;
          PostStream.WriteBuffer(Line[1], Length(Line));
          PostStream.Position := 0;

          AccessToken := RefreshAccessToken;
          IdHTTP.Request.CustomHeaders.Clear;
          IdHTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + AccessToken);
          IdHTTP.Request.ContentType := 'multipart/related; boundary=' + BOUNDARY;
          IdHTTP.Request.Accept := 'application/json';

          try
            Result := IdHTTP.Post(URL, PostStream);
          except
            on E: EIdHTTPProtocolException do
              raise Exception.Create('HTTP error: ' + E.ErrorMessage);
            on E: Exception do
              raise;
          end;
        finally
          FileStream.Free;
        end;
      finally
        PostStream.Free;
      end;
    finally
      IdSSL.Free;
    end;
  finally
    IdHTTP.Free;
  end;
end;
}
{
function TOAuth.SubtitleInsert(const JSON: string; const FileName: String): string;
const
  URL = 'https://www.googleapis.com/upload/youtube/v3/captions?part=snippet';
  BOUNDARY = 'AA0512';
var
  IdHTTP: TIdHTTP;
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  MemStream, FileStream: TMemoryStream;
  Line, AccessToken: UTF8String;
begin
  Result := '';
  IdHTTP := TIdHTTP.Create(nil);
  IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
  MemStream := TMemoryStream.Create;
  FileStream := TMemoryStream.Create;
  try
    // Read file to stream
    FileStream.LoadFromFile(FileName);

    // формируем тело вручную (multipart/related)
    Line :=
      '--' + BOUNDARY + #13#10 +
      'Content-Type: application/json; charset=UTF-8' + #13#10#13#10 +
      UTF8Encode(JSON) + #13#10 +
      '--' + BOUNDARY + #13#10 +
      'Content-Type: application/octet-stream' + #13#10#13#10;
    MemStream.Write(Line[1], Length(Line));
    MemStream.CopyFrom(FileStream, 0);
    Line := #13#10 + '--' + BOUNDARY + '--' + #13#10;
    MemStream.Write(Line[1], Length(Line));
    MemStream.Position := 0;

    IdHTTP.IOHandler := IdSSL;
    AccessToken := RefreshAccessToken; // выдаёт рабочий access_token
    IdHTTP.Request.CustomHeaders.Clear;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + AccessToken);
    IdHTTP.Request.ContentType := 'multipart/related; boundary=' + BOUNDARY;
    IdHTTP.Request.Accept := 'application/json';

    Result := IdHTTP.Post(URL, MemStream);
  finally
    FileStream.Free;
    MemStream.Free;
    IdSSL.Free;
    IdHTTP.Free;
  end;
end;
}

// Title delete
function TOAuth.TitleDelete(LangID: string): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/captions';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('id', LangID);

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');
  Result := SendRequest(URL, Params, Headers, '', rmDelete, '');
end;

// Title replace
function TOAuth.TitleInsert(LangID,KeyTitle, KeyDescription: string): string;
const
  URL = 'https://youtube.googleapis.com/youtube/v3/captions';
//  PUT https://www.googleapis.com/youtube/v3/videos
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('id', LangID);

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + RefreshAccessToken);
  Headers.Add('Accept', 'application/json');
  Result := SendRequest(URL, Params, Headers, '', rmDelete, '');
end;

// Firebase Auth
function TOAuth.FireBaseAuth(): string;
const
  URL = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
  Response: string;
begin
  Params := TDictionary<String, String>.Create;
  Params.Add('key', 'AIzaSyApGfcEMp2QK8Z_enQdbZnPGWCEI8TWAXY');// AIzaSyBGKt8Nd_XY6m-eEVdgHpZMNcG2WKwa6SA
                 //  AIzaSyApGfcEMp2QK8Z_enQdbZnPGWCEI8TWAXY

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Content-Type', 'application/json');

  Response := SendRequest(URL, Params, Headers, '{"returnSecureToken":true}', rmPost);
  FFireBaseToken := TRIM(ParamValue('idToken', Response));
  Result := FFireBaseToken;
end;

// Firebase get
function TOAuth.FireBaseGet(ACollection: string): string;
const
  URL = 'https://firestore.googleapis.com/v1/projects/samasiuk-autoclicker/databases/(default)/documents/';
var
  Headers: TDictionary<String, String>;
begin
  FireBaseAuth();
  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + FFireBaseToken);
  Headers.Add('Accept', 'application/json');
  Headers.Add('Content-Type', 'application/json');

  Result := SendRequest(URL + ACollection, nil, Headers, '', rmGet);
end;

// Firebase update
function TOAuth.FireBaseUpdate(ACollection, JSON: string): string;
const
  URL = 'https://firestore.googleapis.com/v1/projects/samasiuk-autoclicker/databases/(default)/documents/';
var
  Headers: TDictionary<String, String>;
begin
  FireBaseAuth();
  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + FFireBaseToken);
  Headers.Add('Accept', 'application/json');
  Headers.Add('Content-Type', 'application/json');
  StringReplace(JSON, '\', '', [rfReplaceAll]);
  Result := SendRequest(URL + ACollection, nil, Headers, JSON, rmPatch);
end;

// Firebase insert
function TOAuth.FireBaseInsert(ACollection, ADocID, JSON: string): string;
const
  URL = 'https://firestore.googleapis.com/v1/projects/samasiuk-autoclicker/databases/(default)/documents/';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
begin
  FireBaseAuth();

  Params := TDictionary<String, String>.Create;
  Params.Add('documentId', ADocID);

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Authorization', 'Bearer ' + FFireBaseToken);
  Headers.Add('Accept', 'application/json');
  Headers.Add('Content-Type', 'application/json');

  StringReplace(JSON, '\', '', [rfReplaceAll]);

  Result := SendRequest(URL + ACollection, Params, Headers, JSON, rmPost);
end;

// вытаскиваем результат из ответа
function TOAuth.ParamValue(ParamName, JSONString: string): string;
const
  StripChars: set of char = ['"', ':', ','];
var
  i, j: integer;
begin
  i := Pos(LowerCase(ParamName), LowerCase(JSONString));
  if i > 0 then
  begin
    for j := i + Length(ParamName) to Length(JSONString) - 1 do
      if not(JSONString[j] in StripChars) then
        Result := Result + JSONString[j]
      else if JSONString[j] = ',' then
        break;
  end
  else
    Result := '';
end;

// что это?  -- это получение токена доступа access_token (сессионного) по токету обновлений,
// но трабл когда токен обновлений  refresh_token устарел
function TOAuth.RefreshAccessToken: string;
const
  TokenUrl = 'https://accounts.google.com/o/oauth2/token';
var
  Params: TDictionary<String, String>;
  Response: string;
  NewAccessToken: string;
begin
  Params := TDictionary<String, String>.Create;
  try
    Params.Add('client_id', ClientID);
    Params.Add('client_secret', ClientSecret);
    Params.Add('refresh_token', Refresh_token);
    Params.Add('grant_type', 'refresh_token');

    Response := SendRequest(TokenUrl, Params, nil, '', rmPost);

    NewAccessToken := Trim(ParamValue('access_token', Response));
    if NewAccessToken = '' then
      raise Exception.Create('Токен доступа не получен. Ответ: ' + Response);

    Access_token := NewAccessToken;
    Result := Access_token;
  finally
    Params.Free;
  end;
end;




// Подключение пользователя
function TOAuth.UserGet(ACollection, ACollection2: string): string;
const
  URL = 'http://assistiq.suyarkov.com/user_connect.php?';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
  JSON: string;
  URL_Params: string;
begin

  {
  Params := TDictionary<String, String>.Create;
  Params.Add('name', ACollection);
  Params.Add('age', ACollection2);

  Headers := TDictionary<String, String>.Create;
//  Headers.Add('Authorization', 'Bearer ' + FFireBaseToken);
  Headers.Add('Accept', 'application/json');
  Headers.Add('Content-Type', 'application/json');

  StringReplace(JSON, '\', '', [rfReplaceAll]);

  Result := SendRequest(URL + ACollection, Params, Headers, JSON, rmGet); //rmPost  + 'что?'
  }
//  FireBaseAuth();
  Params := TDictionary<String, String>.Create;
  Headers := TDictionary<String, String>.Create;
  try
    // Для GET-запроса параметры должны быть в URL, а не в теле
    URL_Params :=  URL + 'name=' + TNetEncoding.URL.Encode(ACollection) +
      '&age=' + TNetEncoding.URL.Encode(ACollection2);
    Result := SendRequest(
      URL_Params,
      nil,  // Params не передаём
      Headers,
      '',   // Тело пустое
      rmGet
    );
  finally
    Params.Free;
    Headers.Free;
  end;
end;


// My insert  ? добавление пользователя в базу
function TOAuth.UserAdd(ACollection, ACollection2, ACollection3: string): string;
const
  URL = 'http://assistiq.suyarkov.com/user_add.php?';//?name=vava&age=27
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
  JSON: string;
begin
  FireBaseAuth();

  Params := TDictionary<String, String>.Create;
  Params.Add('name', ACollection);
  Params.Add('name1', ACollection2);
  Params.Add('language', ACollection3);

  Headers := TDictionary<String, String>.Create;
//  Headers.Add('Authorization', 'Bearer ' + FFireBaseToken);
  Headers.Add('Accept', 'application/json');
  Headers.Add('Content-Type', 'application/json');

  StringReplace(JSON, '\', '', [rfReplaceAll]);

  Result := SendRequest(URL + ACollection, Params, Headers, JSON, rmGet); //rmPost
end;


// добавление данных о кликах
function TOAuth.Clicks(ACollection, ACollection2, ACollection3, ACollection4: string): string;
const
//  URL = 'http://assistiq.suyarkov.com/real_clicks.php?';
  URL = 'http://assistiq.suyarkov.com/real_clicks_2.php?';   // чтоб найти девайс
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
  JSON: string;
begin
  FireBaseAuth();
  Params := TDictionary<String, String>.Create;
  Params.Add('id', ACollection); // id клиента
  Params.Add('info_device', GetWindowsHardwareSummary()); // код девайса, то есть описание
  Params.Add('cl', ACollection3); // количество кликов
  Params.Add('typecl', ACollection4);
  Params.Add('type_device', 'desktop win'); // код девайса, то есть описание

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Accept', 'application/json');
  Headers.Add('Content-Type', 'application/json');

  StringReplace(JSON, '\', '', [rfReplaceAll]);

  Result := SendRequest(URL, Params, Headers, JSON, rmGet); //rmPost
end;

//  тест связи и версии
//function TOAuth.Version(ACollection, ACollection2: string): string;
function TOAuth.Version(): string;
const
  URL = 'http://assistiq.suyarkov.com/user_version.php?';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
  JSON: string;
begin
  JSON := '';
//  FireBaseAuth();

  Params := TDictionary<String, String>.Create;
//  Params.Add('ip', '22');   // пока ерунда
//  Params.Add('type', '44'); // пока ерунда

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Accept', 'application/json');
  Headers.Add('Content-Type', 'application/json');

  StringReplace(JSON, '\', '', [rfReplaceAll]);

  // ещё тут выводить что нет связи!!
  Result := SendRequest(URL, Params, Headers, JSON, rmGet); //rmPost  + 'что?'

end;


//  тест что не дубль логина
function TOAuth.TestDoubleEmail( AEmail: string): integer;
const
  URL = 'http://assistiq.suyarkov.com/user_checkdouble.php?';
var
  Params: TDictionary<String, String>;
  Headers: TDictionary<String, String>;
  JSON: string;
  vResult: string;
begin
  JSON := '';
  FireBaseAuth();

  Params := TDictionary<String, String>.Create;
  Params.Add('name', AEmail);

  Headers := TDictionary<String, String>.Create;
  Headers.Add('Accept', 'application/json');
  Headers.Add('Content-Type', 'application/json');

  StringReplace(JSON, '\', '', [rfReplaceAll]);

  vResult := SendRequest(URL, Params, Headers, JSON, rmGet); //rmPost  + 'что?'

  if vResult = '0' then
    Result := 0 // нет такого емейл в базе (нужно ещё проверить на дополнительные + в имени почты)
  else
    Result := 1; // есть уже такой пользователь
end;

end.