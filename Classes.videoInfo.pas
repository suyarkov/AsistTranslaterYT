unit Classes.videoInfo;

interface

uses Classes.shearche.pageInfo, Classes.videoinfo.iteminfo;

type
  TObjvideoinfo = class
  type Titems = array of Tvideoinfo_iteminfo;
  private
    Fkind: string;
    Fetag: string;
    FnextPageToken: string;
    FpageInfo : Tshearche_pageInfo;
    Fitems: Titems;

  public
    property kind: string read Fkind write Fkind;
    property etag: string read Fetag write Fetag;
    property nextPageToken: string read FnextPageToken write FnextPageToken;
    property pageInfo: Tshearche_pageInfo read FpageInfo write FpageInfo;
    property items: Titems read Fitems write Fitems;
  end;

implementation

end.