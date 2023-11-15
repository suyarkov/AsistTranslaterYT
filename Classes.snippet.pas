unit Classes.snippet;

interface

type
  Tsnippet = class

  private
    Flanguage: string;
    Fname: string;
    FvideoId: string;

  public
    property language: string read Flanguage write Flanguage;
    property name: string read Fname write Fname;
    property videoId: string read FvideoId write FvideoId;
  end;

implementation

end.