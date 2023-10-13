unit FmTextInput;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Edit;

type
  TFrameTextInput = class(TFrame)
    Panel1: TPanel;
    BtnNo: TButton;
    BtnYes: TButton;
    LabelMessage: TLabel;
    EditText: TEdit;
    procedure BtnYesClick(Sender: TObject);
    procedure BtnNoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    status : integer;
  end;

implementation

{$R *.fmx}

procedure TFrameTextInput.BtnNoClick(Sender: TObject);
begin
    status := 0;
end;

procedure TFrameTextInput.BtnYesClick(Sender: TObject);
begin
    if EditText.Text = '' then
      showmessage('Enter the text')
    else
      status := 1;
end;

end.
