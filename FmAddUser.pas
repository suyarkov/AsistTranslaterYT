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
    Edit1: TEdit;
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
    status := 1;
end;

end.
