unit Classes.snippetInsert;

interface
uses  Classes.snippet;

type
  TsnippetInsert = class
  private
    Fsnippet: Tsnippet;
  public
    property snippet: Tsnippet read Fsnippet write Fsnippet;
  end;

implementation

end.