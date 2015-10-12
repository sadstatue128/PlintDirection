unit uPlintDirection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, StdCtrls, PlintDef;

type
  TfrmPlintDirection = class(TFrame)
    grPlintDirections: TStringGrid;
    btAdd: TButton;
    btDelete: TButton;
    lblPlintDir: TLabel;
  private
    fPlint: TPlint;
  public
    procedure Refresh;
    procedure AssignPlint(aPlint: TPlint);
  end;

implementation

{$R *.dfm}

{ TfrmPlintDirection }

procedure TfrmPlintDirection.AssignPlint(aPlint: TPlint);
begin
  fPlint := aPlint;
end;

procedure TfrmPlintDirection.Refresh;
begin

end;

end.
