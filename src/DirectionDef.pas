unit DirectionDef;

interface

uses Contnrs, PlintDef;

const
  ERROR_DUPLICATE = 'Список плинтонаправлений уже содержит связь "%s"';

type
TPlintDirection = class
  private
    fStartPlint: TPlint;
    fEndPlint: TPlint;
end;

TPlintDirectionList = class(TObjectList)
  private
    function GetItem (const AIndex: Integer): TPlintDirection;
  public
    property Items [const Index: Integer]: TPlintDirection read GetItem;
    function Contains(aPlintDir: TPlintDirection): Boolean;
end;

TPlintDirectionController = class
  private
    fPlintDirs: TPlintDirectionList;
    procedure SortPlints(aStartPlint, aEndPlint: TPlint);
  public
    constructor Create;
    destructor Destroy;
    procedure AddNewPlintDir(const aStartPlint: TPlint; const aEndPlint: TPlint);
end;

implementation

{ TPlintDirectionList }

function TPlintDirectionList.Contains(aPlintDir: TPlintDirection): Boolean;
var
  i: Integer;
  LPlintDir: TPlintDirection;
begin
  result := false;
  for i := 0 to Count - 1 do
  begin
    LPlintDir := Items[i];
    if (LPlintDir.fStartPlint = aPlintDir.fStartPlint) and (LPlintDir.fEndPlint = aPlintDir.fEndPlint)
    or (LPlintDir.fEndPlint = aPlintDir.fStartPlint) and (LPlintDir.fStartPlint = aPlintDir.fEndPlint)
     then
     begin
       result := true;
       Exit;
     end;    
  end;
end;

function TPlintDirectionList.GetItem(const AIndex: Integer): TPlintDirection;
begin
  result := TPlintDirection(Items[AIndex]);
end;

{ TPlintDirectionController }

constructor TPlintDirectionController.Create;
begin
  fPlintDirs := TPlintDirectionList.Create(true);
end;

destructor TPlintDirectionController.Destroy;
begin
  fPlintDirs.Free;
end;

procedure TPlintDirectionController.AddNewPlintDir(aStartPlint: TPlint; aEndPlint: TPlint);
begin

end;

procedure TPlintDirectionController.SortPlints(aStartPlint: TPlint; aEndPlint: TPlint);
var
  aHelpPlint: TPlint;
begin
  if aEndPlint.UniqueIndex > aStartPlint.UniqueIndex then
    Exit
  else
  begin
    aHelpPlint := aStartPlint;
    aStartPlint := 
  end;
end;

end.
