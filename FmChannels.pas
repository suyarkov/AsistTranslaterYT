unit FmChannels;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList,
  FMX.Layouts;

type
  TFrameChannels = class(TFrame)
    LabelChannels: TLabel;
    ButtonAddChannel: TButton;
    ImageAddChannel: TImage;
    BoxChannels: TVertScrollBox;
    procedure ImageAddChannelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameChannels.ImageAddChannelClick(Sender: TObject);
begin
//   ImageAddChannel.
end;

end.
