unit uTypes;

interface

uses FireDAC.Comp.Client, WinApi.Windows, generics.Collections, System.Classes,
  IdSSLOpenSSL, IdSMTP, IdMessage, IdExplicitTLSClientServerBase, System.SysUtils, IdAttachmentFile;

type
  TDict = record
    Key: integer;
    Value: string;
    Parent: integer;
  end;

  TTypeSQL = (tsExec, tsActive);

  TOnWait = procedure(Sender: TObject) of object;
  TProcedure = procedure(AValue: boolean) of object;

const
  itemPos = 1;
  itemClick = 2;
  itemSleep = 3;
  itemScroll = 4;
  itemRightClick = 6;
  itemDoubleClick = 7;
  itemCtrlA = 8;
  itemCtrlC = 9;
  itemCtrlV = 12;
  itemStep = 13;
  itemTab = 15;
  itemEnter = 16;
  itemText = 17;
  itemBuffer = 20;
  itemHotKey = 22;
  itemWaitWindow = 23;
  itemStop = 24;
  itemScenario = 26;
  itemScreenShot = 27;
  itemSend = 33;

  tcCopy = 2;
  tcNew = 1;

  Literals: Array [0 .. 40] of word = (Ord('A'), Ord('B'), Ord('C'), Ord('D'), Ord('E'), Ord('F'), Ord('G'), Ord('H'), Ord('I'), Ord('J'), Ord('K'), Ord('L'), Ord('M'), Ord('N'), Ord('O'), Ord('P'),
    Ord('Q'), Ord('R'), Ord('S'), Ord('T'), Ord('U'), Ord('V'), Ord('W'), Ord('X'), Ord('Y'), Ord('Z'), Ord('1'), Ord('2'), Ord('3'), Ord('4'), Ord('5'), Ord('6'), Ord('7'), Ord('8'), Ord('9'),
    vk_f1, vk_f2, VK_UP, VK_DOWN,VK_LEFT, VK_RIGHT);

procedure ExeQ(var FDQuery: TFDQuery; SQL: string; AType: TTypeSQL);
function SendMessage(ASubject: string; AMessageText: TStrings; var FDQuery: TFDQuery; FileName: string = ''): boolean;
procedure GetTree(AScenarioList: TList<TDict>; IDScheduler: integer; ParentID: integer; var FDQuery: TFDQuery);

implementation

procedure ExeQ(var FDQuery: TFDQuery; SQL: string; AType: TTypeSQL);
begin

  FDQuery.Active := false;
  FDQuery.SQL.Clear;
  FDQuery.SQL.Add(SQL);

  case AType of
    tsExec:
      FDQuery.ExecSQL;

    tsActive:
      FDQuery.Active := true;
  end;
end;

function SendMessage(ASubject: string; AMessageText: TStrings; var FDQuery: TFDQuery; FileName: string = ''): boolean;
var
  Count, CorrectCount: integer;
  IdMessage: TIdMessage;
  IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSmtp;
  imgpart: TIdAttachmentFile;
begin

  ExeQ(FDQuery, 'select host,port,login,password,recipient from settings', TTypeSQL.tsActive);

  IdSMTP := TIdSmtp.Create(nil);
  try
    IdSMTP.Username := FDQuery.FieldByName('login').AsString; // Логин
    IdSMTP.Password := FDQuery.FieldByName('password').AsString; // Пароль
    IdSMTP.Host := FDQuery.FieldByName('host').AsString; // Хост
    IdSMTP.Port := FDQuery.FieldByName('port').AsInteger; // Порт (25 - по умолчанию)

    IdMessage := TIdMessage.Create(nil);
    try
      IdMessage.CharSet := 'UTF-8'; // Кодировка в теле сообщения

      IdMessage.Body := AMessageText;

      IdMessage.Subject := ASubject; // Тема сообщения
      IdMessage.From.Address := FDQuery.FieldByName('login').AsString; // 'robotcash@st.by'; // Адрес отправителя
      IdMessage.From.Name := 'Robot ST-Cash';
      IdMessage.Recipients.EMailAddresses := FDQuery.FieldByName('recipient').AsString; // Кому отправить письмо (можно через запятую если несколько e-mail'ов)

      if FileName <> '' then
      begin
        IdMessage.ContentType := 'multipart/alternative';
        IdMessage.MessageParts.Clear;
        IdMessage.IsEncoded := true;
        imgpart := TIdAttachmentFile.Create(IdMessage.MessageParts, FileName + '.bmp');
        imgpart.ContentType := 'image/jpeg';
      end
      else
        IdMessage.ContentType := 'text/html';

      IdSSLIOHandlerSocketOpenSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        IdSSLIOHandlerSocketOpenSSL1.DefaultPort := 0;
        IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvTLSv1;
        IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Mode := sslmUnassigned;

        IdSMTP.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
        IdSMTP.UseTLS := utUseExplicitTLS;
        try
          // Соединение с почтовым сервером
          IdSMTP.Connect();
          IdSMTP.Send(IdMessage);
          // Отсоединяемся от почтового сервера
          IdSMTP.Disconnect;
          Result := true;
        except
          on E: Exception do
          begin
            IdSMTP.Disconnect;
            Result := false;
          end;

        end;
      finally
        IdSSLIOHandlerSocketOpenSSL1.Free;
      end;
    finally
      IdMessage.Free;
    end;
  finally
    IdSMTP.Free;
  end;

end;

var
  FBeforeID: TList<TDict>;

procedure GetTree(AScenarioList: TList<TDict>; IDScheduler: integer; ParentID: integer; var FDQuery: TFDQuery);
var
  ADict, ADictNext: TDict;
  I: integer;
  ABefore: TDict;
begin
  if FBeforeID = nil then
    FBeforeID := TList<TDict>.Create;

  ExeQ(FDQuery, Format('select id_scenario, cnt from get_tree where parent_scenario = %d and id_scheduler = %d order by sorting;', [ParentID, IDScheduler]), tsActive);

  FDQuery.First;

  while NOT FDQuery.Eof do
  begin
    ADict.Key := FDQuery.FieldByName('id_scenario').AsInteger;
    ADict.Value := FDQuery.FieldByName('cnt').AsString;

    FDQuery.Next;
    I := 0;

    while NOT FDQuery.Eof do
    begin
      ADictNext.Key := FDQuery.FieldByName('id_scenario').AsInteger;
      ADictNext.Value := FDQuery.FieldByName('cnt').AsString;

      if FBeforeID.IndexOf(ADictNext) = -1 then
        FBeforeID.Insert(I, ADictNext);

      Inc(I);
      FDQuery.Next;
    end;

    if AScenarioList.IndexOf(ADict) = -1 then
    begin
      AScenarioList.Add(ADict);

      if ADict.Value.ToInteger() > 0 then
        GetTree(AScenarioList, IDScheduler, ADict.Key, FDQuery)
      else if FBeforeID.Count > 0 then
      begin
        ABefore := FBeforeID[0];

        if AScenarioList.IndexOf(ABefore) = -1 then
          AScenarioList.Add(ABefore);

        FBeforeID.Delete(0);
        GetTree(AScenarioList, IDScheduler, ABefore.Key, FDQuery);
      end;
    end;
  end;

  if FBeforeID.Count > 0 then
  begin
    ABefore := FBeforeID[0];

    if AScenarioList.IndexOf(ABefore) = -1 then
      AScenarioList.Add(ABefore);

    FBeforeID.Delete(0);
    GetTree(AScenarioList, IDScheduler, ABefore.Key, FDQuery);

  end;
end;

end.
