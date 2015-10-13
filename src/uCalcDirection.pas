unit uCalcDirection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
  TfmCalcDirection = class(TForm)
    grDirections: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    procedure ClearGrDirection;
    procedure FillGrDirection;
  end;

var
  fmCalcDirection: TfmCalcDirection;

implementation

uses uDM, DirectionDef;

{$R *.dfm}

procedure TfmCalcDirection.FormCreate(Sender: TObject);
begin
  DM.CalculateDirections;
  FillGrDirection;
end;

procedure TfmCalcDirection.FillGrDirection;
var
  LDir: TDirection;
  i: Integer;
begin
  ClearGrDirection;
  GrDirections.RowCount := DM.DirectionController.Dirs.Count;
  for i := 0 to DM.DirectionController.Dirs.Count - 1 do
  begin
    LDir := DM.DirectionController.Dirs[i];
    GrDirections.Cells[0, i] := LDir.Info;
  end;
end;

procedure TfmCalcDirection.ClearGrDirection;
var
  i: Integer;
begin
  for i := 0 to grDirections.RowCount - 1 do
    grDirections.Rows[i].Clear;
  grDirections.RowCount := 0;
end;

end.
