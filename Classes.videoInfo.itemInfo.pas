unit Classes.videoinfo.iteminfo;

interface

uses Classes.video.snippet, Classes.shearche.id;

type
  Tvideoinfo_iteminfo = class
  private
    Fkind: string;
    Fetag: string;
    Fid: string; // id видео
    Fsnippet: Tvideo_snippet; // описание видео
  public
    property kind: string read Fkind write Fkind;
    property etag: string read Fetag write Fetag;
    property id: string read Fid write Fid;
    property snippet: Tvideo_snippet read Fsnippet write Fsnippet;
  end;

implementation

end.