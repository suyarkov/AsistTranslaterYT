unit Classes.subtitlelist;

interface

uses Classes.shearche.pageInfo, Classes.subtitlelist.item;

type
  TObjSubtitleList = class
  type Titems = array of Tsubtitlelist_item;
  private
    Fkind: string;
    Fetag: string;
    Fitems: Titems;

  public
    property kind: string read Fkind write Fkind;
    property etag: string read Fetag write Fetag;
    property items: Titems read Fitems write Fitems;
  end;

implementation

end.