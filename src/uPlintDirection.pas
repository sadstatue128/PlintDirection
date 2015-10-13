unit uPlintDirection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, StdCtrls, PlintDef, DirectionDef;

type
  TfrmPlintDirection = class(TFrame)
    grPlintDirections: TStringGrid;
    btAdd: TButton;
    lblPlintDir: TLabel;
  private
    fPlint: TPlint;
    fPlints: TPlintList;
    procedure FillGrPlintDirections;
    procedure ClearGrPlintDirections;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    procedure AssignPlint(aPlint: TPlint);
  end;

implementation

uses uDM;

{$R *.dfm}

{ TfrmPlintDirection }

constructor TfrmPlintDirection.Create(aOwner: TComponent);
begin
  inherited;
  fPlints := TPlintList.Create(false);
end;

destructor TfrmPlintDirection.Destroy;
begin
  fPlints.Free;
  inherited;
end;

procedure TfrmPlintDirection.AssignPlint(aPlint: TPlint);
begin
  fPlint := aPlint;
end;

procedure TfrmPlintDirection.Refresh;
begin
  //получить связи для текущего плинта
  fPlints.Clear;
  DM.PlintDirController.GetBindedPlintsFor(fPlint, fPlints);
  //заполнить ими гриду
  FillGrPlintDirections;
end;

procedure  TfrmPlintDirection.FillGrPlintDirections;
var
  i: Integer;
  LPlint: TPlint;
begin
  ClearGrPlintDirections;
  GrPlintDirections.RowCount := fPlints.Count;
  for i := 0 to fPlints.Count - 1 do
  begin
    LPlint := fPlints[i];
    GrPlintDirections.Objects[0, i] := TObject(LPlint);
    GrPlintDirections.Cells[0, i] := LPlint.Info;
  end;
end;

procedure  TfrmPlintDirection.ClearGrPlintDirections;
var
  i: Integer;
begin
  for i := 0 to grPlintDirections.RowCount - 1 do
    grPlintDirections.Rows[i].Clear;
  grPlintDirections.RowCount := 0;
end;

end.
