unit Classes.shearche.items;

interface

uses Classes.shearche.item;

type
  Tshearche_items = class
    {
      //��������
      A: array of TMyClass

      //���������� �����
      SetLength(A,Length(A)+1);

      //������ ������
      A[i]:= TMyClass.Create;
    }

  private type
    Titems = array of Tshearche_item;
  var
    Fitems: Titems;

  public
    property items: Titems read Fitems write Fitems;

  end;

implementation

end.
