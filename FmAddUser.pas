unit FmAddUser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

type
  TFrameAddUser = class(TFrame)
    Panel1: TPanel;
    LabelEmail: TLabel;
    EditEmail: TEdit;
    LabelPass1: TLabel;
    Pass1: TEdit;
    LabelPass2: TLabel;
    Pass2: TEdit;
    ButtonSend: TButton;
    Button1: TButton;
    procedure ButtonSendClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    MsgEmail: string;
    MsgPassword1: string;
    MsgPassword2: string;
  public
    { Public declarations }
    status: integer;
    procedure SetLang(pLabelEmail, pLabelPass1, pLabelPass2, pButtonSend,
      pMsgEmail, pMsgPassword1, pMsgPassword2: string);
  end;

implementation

{$R *.fmx}

procedure TFrameAddUser.Button1Click(Sender: TObject);
begin
  status := 0;
end;

procedure TFrameAddUser.ButtonSendClick(Sender: TObject);
begin
  // проверка логина и пароля
  if (pos('@', EditEmail.Text) = 0) or (pos('.', EditEmail.Text) = 0)
      or (pos('-', EditEmail.Text) > 0) or (pos('-', EditEmail.Text) > 0)then // заменить второй - на +
  begin
//    showmessage('Неверный почтовый адрес');
    showmessage(MsgEmail);
    EditEmail.SetFocus;
    exit;
  end;

  if (Pass1.Text = '') then
  begin
//    showmessage('Пароли не заданы');
    showmessage(MsgPassword1);
    Pass1.SetFocus;
    exit;
  end;

  if (Pass1.Text <> Pass2.Text) then
  begin
//    showmessage('Пароли не совпадаеют');
    showmessage(MsgPassword2);
    Pass1.SetFocus;
    exit;
  end;

  status := 1;
end;

procedure TFrameAddUser.SetLang(pLabelEmail, pLabelPass1, pLabelPass2,
  pButtonSend, pMsgEmail, pMsgPassword1, pMsgPassword2: string);
begin
  LabelEmail.Text := pLabelEmail;
  LabelPass1.Text := pLabelPass1;
  LabelPass2.Text := pLabelPass2;
  ButtonSend.Text := pButtonSend;
  MsgEmail := pMsgEmail;
  MsgPassword1 := pMsgPassword1;
  MsgPassword2 := pMsgPassword2;
end;

end.
