unit FmAddUser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

type
  TFrameAddUser = class(TFrame)
    Panel1: TPanel;
    cLabelEmail: TLabel;
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
  public
    { Public declarations }
    status : integer;
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
  if (pos('@', EditEmail.Text) = 0) or (pos('.', EditEmail.Text) = 0) then
  begin
    showmessage('Неверный почтовый адрес');
    EditEmail.SetFocus;
    exit;
  end;

  if (pass1.Text = '') then
  begin
    showmessage('Пароли не заданы');
    Pass1.SetFocus;
    exit;
  end;

  if (pass1.Text <> pass2.Text) then
  begin
    showmessage('Пароли не совпадаеют');
    Pass1.SetFocus;
    exit;
  end;

  status := 1;
end;

end.
