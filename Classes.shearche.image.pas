unit Classes.shearche.image;

interface

type
  Tshearche_image = class
  private
    Furl: string;
    Fwidth: integer;
    Fheight: integer;

  public
//    constructor Create;
//    destructor destroy; override;

    property url: string read Furl write Furl;
    property width: integer read Fwidth write Fwidth;
    property height: integer read Fheight write Fheight;
  end;

implementation
{
constructor Tshearche_image.Create;
begin
  inherited;
end;

destructor Tshearche_image.destroy;
begin
  inherited;
end;
}
end.