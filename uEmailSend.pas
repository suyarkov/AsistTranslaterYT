unit uEmailSend;

interface

uses
  IdCoderMIME, IdMessage, IdSMTP,
  IdSSLOpenSSL, IdIOHandler, IdAttachmentFile, IdExplicitTLSClientServerBase,
  idCharSets, idText, System.SysUtils;

type
  // -- вспомогательный класс-заглушка для подвязки события компонента indy
  Tindystub = class(tobject)
  public
    procedure OnInitISO(var VHeaderEncoding: Char; var VCharSet: string);
  end;

procedure SendEmail(aSmtpServer: string; aSmtpPort: integer; aSmtpLogin: string;
  aSmtpPassword: string; aFromAddress: string; aFromName: string;
  aToAddress: string; aMessageSubject: string; aMessageText: string;
  aAttachmentFileFullName: string; aUseSSL: boolean = false);

implementation

procedure Tindystub.OnInitISO(var VHeaderEncoding: Char; var VCharSet: string);
begin
  VCharSet := IdCharsetNames[idcs_UTF_8];
end;

procedure SendEmail(aSmtpServer: string; aSmtpPort: integer; aSmtpLogin: string;
  aSmtpPassword: string; aFromAddress: string; aFromName: string;
  aToAddress: string; aMessageSubject: string; aMessageText: string;
  aAttachmentFileFullName: string; aUseSSL: boolean = false);
var
  lMessage: TIDMessage;
  lSMTP: TIdSMTP;
  attach: TIdAttachmentFile;
  sslHandler: TIdSSLIOHandlerSocketOpenSSL;
  lindystub: Tindystub;
  idtTextPart: TIdText;
begin
  lMessage := TIDMessage.Create(nil);
  lSMTP := TIdSMTP.Create(nil);
  sslHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  lindystub := Tindystub.Create();
  try
    lSMTP.AuthType := satDefault;

    lSMTP.Host := aSmtpServer; // Хост
    lSMTP.Port := aSmtpPort; // Порт (25 - по умолчанию)
    //Порт (25 - по умолчанию)
    //Порты mail.ru: 587 и 2525 (без шифрования) или 465 (с шифрованием)

    lSMTP.Username := aSmtpLogin;
    lSMTP.Password := aSmtpPassword;     //ztna ixma usff pmvq


    // -- решаем проблему отправки писем, если у компьютера руссоке имя
    lSMTP.HeloName := 'tfo';

    // -- отправляем почту через SSL, если надо (пока тестировал только на ukr.net)
    if (aUseSSL) then
    begin
      SSLHandler.Destination := aSmtpServer+':'+IntToStr(aSmtpPort);
      sslHandler.Host := aSmtpServer;
      sslHandler.Port := aSmtpPort;
      sslHandler.DefaultPort := 0;
      sslHandler.SSLOptions.Method := sslvSSLv23;
      sslHandler.SSLOptions.Mode := sslmUnassigned;
      lSMTP.IOHandler := sslHandler;
      lSMTP.UseTLS := utUseImplicitTLS;
    end;

    // -- решаем вопрос кодировки темы письма
    lMessage.OnInitializeISO := lindystub.OnInitISO;

    lMessage.Subject := aMessageSubject;
    lMessage.From.Address := aFromAddress;
    lMessage.From.Name := aFromName;
    lMessage.Recipients.EMailAddresses := aToAddress;

    // -- решаем вопрос кодировки тела письма
    idtTextPart := TIdText.Create(lMessage.MessageParts, nil);
    // idtTextPart.ContentType := 'text/plain';  // а нам нужен веб
    idtTextPart.ContentType := 'text/html; charset=utf-8';
//    idtTextPart.CharSet := 'Windows-1251';

    idtTextPart.Body.Text := aMessageText;

    // -- работа со вложенными файлами
    if (aAttachmentFileFullName <> '') then
    begin
      attach := TIdAttachmentFile.Create(lMessage.MessageParts,
        aAttachmentFileFullName); // Вложение
    end;

    // -- собственно отправка
    lSMTP.Connect;
    try
      lSMTP.Send(lMessage);
    finally
      lSMTP.Disconnect;
    end;

  finally
    sslHandler.Free;
    lMessage.Free;
    lSMTP.Free;
    lindystub.Free;
  end;

end;

{ пример вызова
  procedure TfMain.ButtonEmail2Click(Sender: TObject);
  begin
    SendEmail('smtp.mail.ru', 465, 'brest20133@mail.ru',
    '0wxKM9nE60HAwsvhGbN5', 'brest20133@mail.ru', 'aFromName',
    'suyarkov@gmail.com', 'Тема пирога', 'Привет от асиста',
    '', true);
  end;
}

{   просто для наглядности, ни когда не работала,так как нужно SSl

procedure TfMain.ButtonEmailClick(Sender: TObject);
//var
//attach: TidAttachment;
begin

//  IdSMTP1.AuthenticationType:= atLogin;
//  IdSMTP1.Authenticate;// .Authentication:= True;
//  IdSMTP1.AuthType := satNone;
//IdSSLIOHandlerSocketOpenSSL
  IdSMTP1.Username:='brest20133@mail.ru'; //Логин
  IdSMTP1.Password:='0wxKM9nE60HAwsvhGbN5'; //Пароль
  IdSMTP1.Host:='smtp.mail.ru'; //Хост
  //Хосты: smtp.inbox.ru; smtp.list.ru; smtp.bk.ru; smtp.yandex.ru и т.д.
  IdSMTP1.Port:=2525; //Порт (25 - по умолчанию)
  //Порты mail.ru: 587 и 2525 (без шифрования) или 465 (с шифрованием)

  IdMessage1.CharSet:='windows-1251'; //Кодировка в теле сообщения
  IdMessage1.ContentType:='text/plain';
  // или
  //IdMessage1.ContentType:='text/html';
  //если в теле сообщения будет присутствовать HTML код
  IdMessage1.Body.text:='Привет от асиста'; //Текст сообщения
//  IdMessage1.Subject:=ConvertToWIN1251('Тема'); //Тема сообщения
  IdMessage1.Subject:=('Тема пирога'); //Тема сообщения
  IdMessage1.From.Address:='brest20133@mail.ru'; //Адрес отправителя
  //IdMessage1.From.Name:=ConvertToWIN1251('User'); //Имя отправителя
  IdMessage1.Recipients.EMailAddresses:='suyarkov@gmail.com';
   //Кому отправить письмо (можно через запятую если несколько e-mail'ов)
  IdMessage1.IsEncoded:=true;
  //attach:=TIdAttachment.Create(IdMessage1.MessageParts,'Путь до файла'); //Вложение
  try
    //Соединение с почтовым сервером
    IdSMTP1.Connect();
    IdSMTP1.Send(IdMessage1);
    showmessage('Сообщение отправлено');
  except
    showmessage('Ошибка при отправке сообщения');
  end;
//Отсоединяемся от почтового сервера
IdSMTP1.Disconnect;
end;

}

end.
