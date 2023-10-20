unit FmLanguages;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation;

type
  TFrameLanguages = class(TFrame)
    BoxLanguages: TVertScrollBox;
    ButtonTitle: TButton;
    LabelTextCount: TLabel;
    LabelCount: TLabel;
    LabelLanguages: TLabel;
    ButtonSubtitles: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang(pLabelTextCount, pButtonTitle, pButtonSubtitles : string);
  end;

implementation

{$R *.fmx}

procedure TFrameLanguages.SetLang(pLabelTextCount, pButtonTitle, pButtonSubtitles : string);
begin
  if pLabelTextCount <> '' then
    LabelTextCount.Text := pLabelTextCount;
  if pButtonTitle <> '' then
    ButtonTitle.Text := pButtonTitle;
  if pButtonSubtitles <> '' then
    ButtonSubtitles.Text := pButtonSubtitles;
end;

end.
