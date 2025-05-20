unit uEmailSend;

interface

uses
  IdCoderMIME, IdMessage, IdSMTP,
  IdSSLOpenSSL, IdIOHandler, IdAttachmentFile, IdExplicitTLSClientServerBase,
  idCharSets, idText, System.SysUtils;

type
  // -- ��������������� �����-�������� ��� �������� ������� ���������� indy
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

    lSMTP.Host := aSmtpServer; // ����
    lSMTP.Port := aSmtpPort; // ���� (25 - �� ���������)
    //���� (25 - �� ���������)
    //����� mail.ru: 587 � 2525 (��� ����������) ��� 465 (� �����������)

    lSMTP.Username := aSmtpLogin;
    lSMTP.Password := aSmtpPassword;     //ztna ixma usff pmvq


    // -- ������ �������� �������� �����, ���� � ���������� ������� ���
    lSMTP.HeloName := 'tfo';

    // -- ���������� ����� ����� SSL, ���� ���� (���� ���������� ������ �� ukr.net)
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

    // -- ������ ������ ��������� ���� ������
    lMessage.OnInitializeISO := lindystub.OnInitISO;

    lMessage.Subject := aMessageSubject;
    lMessage.From.Address := aFromAddress;
    lMessage.From.Name := aFromName;
    lMessage.Recipients.EMailAddresses := aToAddress;

    // -- ������ ������ ��������� ���� ������
    idtTextPart := TIdText.Create(lMessage.MessageParts, nil);
    // idtTextPart.ContentType := 'text/plain';  // � ��� ����� ���
    idtTextPart.ContentType := 'text/html; charset=utf-8';
//    idtTextPart.CharSet := 'Windows-1251';

    idtTextPart.Body.Text := aMessageText;

    // -- ������ �� ���������� �������
    if (aAttachmentFileFullName <> '') then
    begin
      attach := TIdAttachmentFile.Create(lMessage.MessageParts,
        aAttachmentFileFullName); // ��������
    end;

    // -- ���������� ��������
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

{ ������ ������
  procedure TfMain.ButtonEmail2Click(Sender: TObject);
  begin
    SendEmail('smtp.mail.ru', 465, 'brest20133@mail.ru',
    '0wxKM9nE60HAwsvhGbN5', 'brest20133@mail.ru', 'aFromName',
    'suyarkov@gmail.com', '���� ������', '������ �� ������',
    '', true);
  end;
}

{   ������ ��� �����������, �� ����� �� ��������,��� ��� ����� SSl

procedure TfMain.ButtonEmailClick(Sender: TObject);
//var
//attach: TidAttachment;
begin

//  IdSMTP1.AuthenticationType:= atLogin;
//  IdSMTP1.Authenticate;// .Authentication:= True;
//  IdSMTP1.AuthType := satNone;
//IdSSLIOHandlerSocketOpenSSL
  IdSMTP1.Username:='brest20133@mail.ru'; //�����
  IdSMTP1.Password:='0wxKM9nE60HAwsvhGbN5'; //������
  IdSMTP1.Host:='smtp.mail.ru'; //����
  //�����: smtp.inbox.ru; smtp.list.ru; smtp.bk.ru; smtp.yandex.ru � �.�.
  IdSMTP1.Port:=2525; //���� (25 - �� ���������)
  //����� mail.ru: 587 � 2525 (��� ����������) ��� 465 (� �����������)

  IdMessage1.CharSet:='windows-1251'; //��������� � ���� ���������
  IdMessage1.ContentType:='text/plain';
  // ���
  //IdMessage1.ContentType:='text/html';
  //���� � ���� ��������� ����� �������������� HTML ���
  IdMessage1.Body.text:='������ �� ������'; //����� ���������
//  IdMessage1.Subject:=ConvertToWIN1251('����'); //���� ���������
  IdMessage1.Subject:=('���� ������'); //���� ���������
  IdMessage1.From.Address:='brest20133@mail.ru'; //����� �����������
  //IdMessage1.From.Name:=ConvertToWIN1251('User'); //��� �����������
  IdMessage1.Recipients.EMailAddresses:='suyarkov@gmail.com';
   //���� ��������� ������ (����� ����� ������� ���� ��������� e-mail'��)
  IdMessage1.IsEncoded:=true;
  //attach:=TIdAttachment.Create(IdMessage1.MessageParts,'���� �� �����'); //��������
  try
    //���������� � �������� ��������
    IdSMTP1.Connect();
    IdSMTP1.Send(IdMessage1);
    showmessage('��������� ����������');
  except
    showmessage('������ ��� �������� ���������');
  end;
//������������� �� ��������� �������
IdSMTP1.Disconnect;
end;

}

end.
