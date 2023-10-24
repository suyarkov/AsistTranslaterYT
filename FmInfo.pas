unit FmInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.Objects;

type
  TFrameInfo = class(TFrame)
    Panel1: TPanel;
    BtnOk: TButton;
    LabelMessage: TLabel;
    MemoMessage: TMemo;
    Image1: TImage;
    procedure BtnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    status : integer;
  end;

implementation

{$R *.fmx}

procedure TFrameInfo.BtnOkClick(Sender: TObject);
begin
    status := 1;
end;

end.
