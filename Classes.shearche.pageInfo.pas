unit Classes.shearche.pageInfo;

interface

type
  Tshearche_pageInfo = class

  private
    FtotalResults: integer;
    FresultsPerPage: integer;

  public
    property totalResults: integer read FtotalResults write FtotalResults;
    property resultsPerPage: integer read FresultsPerPage write FresultsPerPage;
  end;

implementation

end.