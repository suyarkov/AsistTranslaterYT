unit Classes.title;

interface

type
  Ttitle = class

  private
    Ftitle: string;
    Fdescription: string;

  public
    property title: string read Ftitle write Ftitle;
    property description: string read Fdescription write Fdescription;
  end;

implementation

end.