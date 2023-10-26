unit FmMainChannel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList,
  FMX.Layouts;

type
  TFrameMainChannel = class(TFrame)
    ImageChannel: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BoxVideos: TVertScrollBox;
    ButtonAddNextVideo: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label4: TLabel;
    Label5: TLabel;
    LabelNameChannel: TLabel;
    LabelCount: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang(pLabelNameChannel, pButtonAddNextVideo: string);
  end;

implementation

{$R *.fmx}

procedure TFrameMainChannel.SetLang(pLabelNameChannel, pButtonAddNextVideo: string);
begin
  if pLabelNameChannel <> '' then
    LabelNameChannel.Text := pLabelNameChannel;
  if pButtonAddNextVideo <> '' then
    ButtonAddNextVideo.Text := pButtonAddNextVideo;
end;

end.
