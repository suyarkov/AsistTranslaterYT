unit FmAsk;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TFrameAsk = class(TFrame)
    Panel1: TPanel;
    BtnNo: TButton;
    BtnYes: TButton;
    LabelMessage: TLabel;
    MemoMessage: TMemo;
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

procedure TFrameAsk.BtnNoClick(Sender: TObject);
begin
  status := 0;
end;

procedure TFrameAsk.BtnYesClick(Sender: TObject);
begin
  status := 1;
end;

end.
