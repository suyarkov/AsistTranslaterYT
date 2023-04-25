unit Classes.channel.item;

interface

uses Classes.channel.snippet, Classes.channel.statistics;

type
  Tchannel_item = class
  private
    Fkind: string;
    Fetag: string;
    Fid: string; // id ������
    Fsnippet: Tchannel_snippet; // �������� ������
    Fstatistics: Tchannel_statistics; // �������� �����
  public
    property kind: string read Fkind write Fkind;
    property etag: string read Fetag write Fetag;
    property id: string read Fid write Fid;
    property snippet: Tchannel_snippet read Fsnippet write Fsnippet;
    property statistics: Tchannel_statistics read Fstatistics write Fstatistics;
  end;

implementation

end.