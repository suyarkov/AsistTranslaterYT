unit FmVideos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList;

type
  TFrameVideos = class(TFrame)
    LabelVideos: TLabel;
    procedure ImageAddVideoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameVideos.ImageAddVideoClick(Sender: TObject);
begin
//   ImageAddVideo.
end;

end.
