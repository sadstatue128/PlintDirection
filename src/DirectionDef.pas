unit DirectionDef;

interface

uses Contnrs, SysUtils, PlintDef;

const
  ERROR_DUPLICATE = 'Список плинтонаправлений уже содержит связь "%s"';
  ERROR_NO_SUCH_PLINT = 'Плинтонаправление "%s" не включает в себя плинт "%s"';
  C_PLINT_DIR = ' <=> ';

type
EPlintDirException = class(Exception)
end;

TPlintDirection = class
  private
    fStartPlint: TPlint;
    fEndPlint: TPlint;
  public
    function Info: String;
    constructor Create(aStartPlint, aEndPlint: TPlint);
    function Contains(aPlint: TPlint): Boolean;
    function GetOtherPlint(aPlint:TPlint): TPlint;
end;

TPlintDirectionList = class(TObjectList)
  private
    function GetItem (const AIndex: Integer): TPlintDirection;
  public
    property Items [const AIndex: Integer]: TPlintDirection read GetItem; default;
    function Contains(aPlintDir: TPlintDirection): Boolean;
end;

TPlintDirectionController = class
  private
    fPlintDirs: TPlintDirectionList;
    procedure SortPlints(var aStartPlint: TPlint; var aEndPlint: TPlint);
  public
    constructor Create;
    destructor Destroy;
    procedure AddNewPlintDir(aStartPlint: TPlint; aEndPlint: TPlint);
    procedure GetPlintDirsFor(aPlint: TPlint; aPlintDirs: TPlintDirectionList);
    procedure GetBindedPlintsFor(aPlint: TPlint; aPlints: TPlintList);
    property Dirs: TPlintDirectionList read fPlintDirs;
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
  result := TPlintDirection(inherited Items[AIndex]);
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

procedure TPlintDirectionController.GetBindedPlintsFor(aPlint: TPlint;
  aPlints: TPlintList);
var
  LPlintDirs: TPlintDirectionList;
  LPlintDir: TPlintDirection;
  LPlint: TPlint;
  i: Integer;
begin
  LPlintDirs := TPlintDirectionList.Create(false);
  try
    GetPlintDirsFor(aPlint, LPlintDirs);
    for i := 0 to LPlintDirs.Count - 1 do
    begin
      LPlintDir := LPlintDirs[i];
      LPlint := LPlintDir.GetOtherPlint(aPlint);
      if not Assigned(LPlint) then
      begin
        raise EPlintDirException.Create(Format(ERROR_NO_SUCH_PLINT, [LPlintDir.Info, aPlint.Info]));
        Exit;
      end;
      aPlints.Add(LPlint);      
    end;
  finally
    LPlintDirs.Free;
  end;
end;

procedure TPlintDirectionController.GetPlintDirsFor(aPlint: TPlint;
  aPlintDirs: TPlintDirectionList);
var
  i: Integer;
  LPlintDir: TPlintDirection;
begin
  for i := 0 to fPlintDirs.Count - 1 do
  begin
    LPlintDir := fPlintDirs[i];
    if LPlintDir.Contains(aPlint) then
      aPlintDirs.Add(LPlintDir);    
  end;
end;

procedure TPlintDirectionController.AddNewPlintDir(aStartPlint: TPlint; aEndPlint: TPlint);
var
  LPlintDir: TPlintDirection;
begin
  SortPlints(aStartPlint, aEndPlint);
  LPlintDir := TPlintDirection.Create(aStartPlint, aEndPlint);
  try
    if fPlintDirs.Contains(LPlintDir) then
    begin
      raise EPlintDirException.Create(Format(ERROR_DUPLICATE, [LPlintDir.Info]));
      Exit;
    end;
    fPlintDirs.Add(LPlintDir);
  except
    LPlintDir.Free;
  end;
end;

procedure TPlintDirectionController.SortPlints(var aStartPlint: TPlint; var aEndPlint: TPlint);
var
  aHelpPlint: TPlint;
begin
  if aEndPlint.UniqueIndex > aStartPlint.UniqueIndex then
    Exit
  else
  begin
    aHelpPlint := aStartPlint;
    aStartPlint := aEndPlint;
    aEndPlint := aHelpPlint;
  end;
end;

{ TPlintDirection }

function TPlintDirection.Contains(aPlint: TPlint): Boolean;
begin
  result :=  (fStartPlint = aPlint) or (fEndPlint =  aPlint);  
end;

constructor TPlintDirection.Create(aStartPlint, aEndPlint: TPlint);
begin
  fStartPlint := aStartPlint;
  fEndPlint := aEndPlint;
end;

function TPlintDirection.GetOtherPlint(aPlint: TPlint): TPlint;
begin
  result := nil;
  if fStartPlint = aPlint then
    result := fEndPlint
  else if fEndPlint = aPlint then
    result := fStartPlint;  
end;

function TPlintDirection.Info: String;
begin
  result := fStartPlint.Info + C_PLINT_DIR + fEndPlint.Info;
end;

end.
