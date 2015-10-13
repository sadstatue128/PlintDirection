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
    procedure CopyToAndSort(aPlintDirList: TPlintDirectionList);
    function GetMinStartUniqueIndex: Integer;
    function GetMinEndUniqueIndex: Integer;
  public
    property Items [const AIndex: Integer]: TPlintDirection read GetItem; default;
    function Contains(aPlintDir: TPlintDirection): Boolean;
    procedure CopyTo(aPlintDirs: TPlintDirectionList);
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

TDirection = class
  private
    fPlintDirs: TPlintDirectionList;
    fLNodeId, fRNodeId:Integer;
    fLCuId, fRCuId: Integer;
    fLFirstPlintId, fLLastPlintId: Integer;
    fRFirstPlintId, fRLastPlintId: Integer;
    procedure AddPlintDir(aPlintDir: TPlintDirection);
  public
    function Info: String;
    constructor Create(aPlintDir: TPlintDirection);
    destructor Destroy;
    function isOK(aPlintDir: TPlintDirection): Boolean;
end;

TDirectionList = class(TObjectList)
  private
    function GetItem (const AIndex: Integer): TDirection;
  public
    property Items [const AIndex: Integer]: TDirection read GetItem; default;
end;

TDirectionController = class
  private
    fDirs: TDirectionList;
    fPlintDirs: TPlintDirectionList;
  public
    constructor Create;
    destructor Destroy;
    procedure AssignPlintList(aPlintDirs: TPlintDirectionList);
    procedure Calculate;
    property Dirs: TDirectionList read fDirs;
end;

implementation

{$Region 'TPlintDirectionList' }

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

procedure TPlintDirectionList.CopyTo(aPlintDirs: TPlintDirectionList);
var
  i: Integer;
begin
  aPlintDirs.Clear;
  for i := 0 to Count - 1 do
  begin
    aPlintDirs.Add(Items[i]);
  end;
end;

function TPlintDirectionList.GetItem(const AIndex: Integer): TPlintDirection;
begin
  result := TPlintDirection(inherited Items[AIndex]);
end;

procedure TPlintDirectionList.CopyToAndSort(aPlintDirList: TPlintDirectionList);
var
  LCopList, LTempList: TPlintDirectionList;
  LPlintDir: TPlintDirection;
begin
  CopyTo(LCopList);
  LTempList := TPlintDirectionList.Create(false);
  LCopList := TPlintDirectionList.Create(false);
  try
    Self.CopyTo(LCopList);


    
  finally
    LTempList.Free;
    LCopList.Free;
  end;
end;

function TPlintDirectionList.GetMinStartUniqueIndex: Integer;
var
  LPlintDir: TPlintDirection;
  i: Integer;
  Min: Integer;
begin
  if Count = 0  then
    Exit;
  Min := Items[0].fStartPlint.UniqueIndex;
  for i := 0 to Count - 1 do
  begin
    LPlintDir := Items[i];
    if LPlintDir.fStartPlint.UniqueIndex < Min then
      Min := LPlintDir.fStartPlint.UniqueIndex;
  end;
  result := Min;    
end;

function TPlintDirectionList.GetMinEndUniqueIndex: Integer;
var
  LPlintDir: TPlintDirection;
  i: Integer;
  Min: Integer;
begin
  if Count = 0  then
    Exit;
  Min := Items[0].fEndPlint.UniqueIndex;
  for i := 0 to Count - 1 do
  begin
    LPlintDir := Items[i];
    if LPlintDir.fEndPlint.UniqueIndex < Min then
      Min := LPlintDir.fEndPlint.UniqueIndex;
  end;
  result := Min;   
end;

{$EndRegion}

{$Region 'TPlintDirectionController' }

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

{$EndRegion}

{$Region 'TPlintDirection' }

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

{$EndRegion}

{$Region 'TDirection' }

constructor TDirection.Create(aPlintDir: TPlintDirection);
begin
  fPlintDirs := TPlintDirectionList.Create(False);
  fPlintDirs.Add(aPlintDir);

  with aPlintDir.fStartPlint do
  begin
    fLNodeId := Node.Id;
    fLCuId := CU.Id;
    fLFirstPlintId := Id;
    fLLastPlintId := Id;
  end;

  with aPlintDir.fEndPlint do
  begin
    fRNodeId := Node.Id;
    fRCuId := CU.Id;
    fRFirstPlintId := Id;
    fRLastPlintId := Id;
  end;
end;

destructor TDirection.Destroy;
begin
  fPlintDirs.Free;
end;

function TDirection.Info: String;
begin
  result := С_NODE + ':' + IntToStr(fLNodeId) + ' ' +  С_CU + ':' + IntToStr(fLCuId) +
   ' ['   + IntToStr(fLFirstPlintId) + ':' + IntToStr(fLLastPlintId) + '] ' +
    С_NODE + ':' + IntToStr(fRNodeId) + ' ' +  С_CU + ':' + IntToStr(fRCuId) +
   ' ['   + IntToStr(fRFirstPlintId) + ':' + IntToStr(fRLastPlintId) + '] '
end;

function TDirection.isOK(aPlintDir: TPlintDirection): Boolean;
var
  LisLNodeId, LisRNodeId,
  LisLCuId, LisRCuId,
  LisLPlintId,
  LisRPlintId: Boolean;
begin
  with aPlintDir.fStartPlint do
  begin
    LisLNodeId := fLNodeId = Node.Id;
    LisLCuId := fLCuId = CU.Id;
    LisLPlintId := (Id - fLLastPlintId) = 1;
  end;

  with aPlintDir.fEndPlint do
  begin
    LisRNodeId := fRNodeId = Node.Id;
    LisRCuId := fRCuId = CU.Id;
    LisRPlintId:= (Id - fRLastPlintId) = 1;
  end;

  result := LisLNodeId and LisLCuId and LisLPlintId and LisRNodeId and LisRCuId and LisRPlintId;
end;

procedure TDirection.AddPlintDir(aPlintDir: TPlintDirection);
begin
  if isOK(aPlintDir) then
  begin
    fLLastPlintId := aPlintDir.fStartPlint.Id;
    fRLastPlintId := aPlintDir.fEndPlint.Id;
  end;  
end;

{$EndRegion}

{$Region 'TDirectionList' }

function TDirectionList.GetItem(const AIndex: Integer): TDirection;
begin
  result := TDirection(inherited Items[AIndex]);
end;

{$EndRegion}

{$Region 'TDirectionController' }

procedure TDirectionController.AssignPlintList(aPlintDirs: TPlintDirectionList);
begin
  aPlintDirs.CopyTo(fPlintDirs);
end;

procedure TDirectionController.Calculate;
var
  LPlintDir: TPlintDirection;
  i: Integer;
begin
  for i := 0 to fPlintDirs.Count - 1 do
   begin
     LPlintDir := fPlintDirs[i];
     
   end;
end;

constructor TDirectionController.Create;
begin
  fDirs := TDirectionList.Create(true);
  fPlintDirs := TPlintDirectionList.Create(false);
end;

destructor TDirectionController.Destroy;
begin
  fDirs.Free;
  fPlintDirs.Free;
end;

{$EndRegion}

end.
