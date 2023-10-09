unit Classes.subtitlelist.item;

interface

uses Classes.subtitlelist.snippet, Classes.shearche.id;

type
  Tsubtitlelist_item = class
  private
    Fkind: string;
    Fetag: string;
    Fid: string;
    Fsnippet: Tsubtitlelist_snippet; // описание субтитров
  public
    property kind: string read Fkind write Fkind;
    property etag: string read Fetag write Fetag;
    property id: string read Fid write Fid;
    property snippet: Tsubtitlelist_snippet read Fsnippet write Fsnippet;
  end;

implementation

end.