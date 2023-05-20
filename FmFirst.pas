unit FmFirst;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

type
  TFrameFirst = class(TFrame)
    LabelName: TLabel;
    LabelPas: TLabel;
    EditName: TEdit;
    EditPas: TEdit;
    ButtonReg: TButton;
    ButtonLog: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
