unit PlintDef;

interface

uses Classes, SysUtils, Contnrs, DB;

const
  С_NODE = 'Узел';
  С_CU = 'Коннектор';
  С_PLINT = 'Плинт';

type
TChosenType = (chNode, chCU, chPlint);

//базовый класс

TRecord = class
  private
    fId: Integer;
  public
    property Id: Integer read fId;
    constructor Create(aId: Integer);
    function Info: String; virtual; abstract;
end;

TRecordList = class(TObjectList)
  private
    function GetItemById (const AId: Integer): TRecord;
  public
    property ItemsById [const Id: Integer]: TRecord read GetItemById; 
end;

TCUList = class;

TNode = class(TRecord)
  private
    fCUs: TCUList;
  public
    constructor Create(aId: Integer);
    destructor Destroy;
    property CUs: TCUList read fCUs;
    function Info: String; override;
end;

TPlintList = class;

TNodeList = class(TRecordList)
  private
    fAllPlints: TPlintList;
    function GetItem (const AIndex: Integer): TNode;
    function GetItemById (const AId: Integer): TNode;
    function GetAllPlints: TPlintList;
    procedure SetPlintUniqueIndexes;
  public
    constructor Create(aOwnsObjects: Boolean);
    destructor Destroy;
    property Items [const AIndex: Integer]: TNode read GetItem; default;
    property ItemsById [const Id: Integer]: TNode read GetItemById;
    procedure FillRandomValues(aNodeCount: Integer);
    property AllPlints: TPlintList read GetAllPlints;
end;

TCU = class(TRecord)
  private
    fPlints: TPlintList;
    fNode: TNode;
  public
    constructor Create(aId: Integer; aNode: TNode);
    destructor Destroy;
    function Info: String; override;
    property Plints: TPlintList read fPlints;
    property Node: TNode read fNode;
end;

TCUList = class(TRecordList)
  private
    function GetItem (const AIndex: Integer): TCU;
    function GetItemById (const AId: Integer): TCU;
  public
    property Items [const AIndex: Integer]: TCU read GetItem; default;
    property ItemsById [const Id: Integer]: TCU read GetItemById;
end;

TPlint = class(TRecord)
  private
    fUnIndex: Integer;
    fCU: TCU;
    function GetNode: TNode;
  public
    constructor Create(aId: Integer; aCU: TCU);
    function Info: String; override;
    property CU: TCU read fCU;
    property Node: TNode read GetNode;
    property UniqueIndex: Integer read fUnIndex;
end;

TPlintList = class(TRecordList)
  private
    function GetItem (const AIndex: Integer): TPlint;
    function GetItemById (const AId: Integer): TPlint;
  public
    property Items [const AIndex: Integer]: TPlint read GetItem; default;
    property ItemsById [const Id: Integer]: TPlint read GetItemById;
    procedure CopyTo(aPlintList: TPlintList);
    procedure ExtractList(aPlintList: TPlintList);
end;

implementation

{$Region 'TRecord' }

constructor TRecord.Create(aId: Integer);
begin
  fId := aId;
end;

{$Endregion}

{$Region 'TNode' }

constructor TNode.Create(aId: Integer);
begin
  inherited;
  fCUs := TCUList.Create(true);
end;

destructor TNode.Destroy;
begin
  fCUs.Free;
end;

function TNode.Info: String;
begin
  result := С_NODE + ':' + IntToStr(Id);
end;

{$Endregion}

{$Region 'TCU' }

constructor TCU.Create(aId: Integer; aNode: TNode);
begin
  inherited Create(aId);
  fPlints := TPlintList.Create(true);
  fNode := aNode;
end;

destructor TCU.Destroy;
begin
  fPlints.Free;
end;

function TCU.Info: String;
begin
  result := fNode.Info + ' ' + С_CU + ':' + IntToStr(Id);
end;

{$Endregion}

{$Region 'TNodeList' }

constructor TNodeList.Create(aOwnsObjects: Boolean);
begin
  fAllPlints := TPlintList.Create(false);
  inherited Create(aOwnsObjects);
end;

destructor TNodeList.Destroy;
begin
  fAllPlints.Free;
  inherited;
end;

procedure TNodeList.FillRandomValues(aNodeCount: Integer);

procedure FillCU(aCU: TCU);
  var
    PlintCount: Integer;
    i: Integer;
begin
  PlintCount := 1 + Random(8);
  for i := 0 to PlintCount do
  begin
    aCU.Plints.Add(TPlint.Create(i, aCU));
  end;
end;

procedure FillNode(aNode: TNode);
  var
    CUCount: Integer;
    i: Integer;
    LCU: TCU;
begin
  CUCount := 1 + Random(5);
  for i := 0 to CUCount do
  begin
    LCU := TCU.Create(i, aNode);
    aNode.CUs.Add(LCU);
    FillCU(LCU);
  end;
end;

var
  i: Integer;
  LNode: TNode;
begin
  Clear;
  for i := 0 to aNodeCount - 1 do
    begin
      LNode := TNode.Create(i);
      Add(LNode);
      FillNode(LNode);
    end;

  SetPlintUniqueIndexes;
end;

function TNodeList.GetItem(const AIndex: Integer): TNode;
begin
  result := TNode(inherited Items[AIndex]);
end;

function TNodeList.GetItemById(const AId: Integer): TNode;
begin
  result := TNode(inherited GetItemById(AId));
end;

function TNodeList.GetAllPlints: TPlintList;
var
  i: Integer;
  LNode: TNode;
  LCU: TCU;
  LPlint: TPlint;
  j: Integer;
  k: Integer;
begin
  fAllPlints.Clear;
    for i := 0 to Count - 1 do
    begin
      LNode := Items[i];
      for j := 0 to LNode.fCUs.Count - 1 do
      begin
        LCU := LNode.fCUs[j];
        for k := 0 to LCU.fPlints.Count - 1 do
         begin
           LPlint := LCU.fPlints[k];
           fAllPlints.Add(LPlint);
         end;
      end;
    end;
   result := fAllPlints;
end;

procedure TNodeList.SetPlintUniqueIndexes;
var
  i: Integer;
  LPlint: TPlint;
begin
  GetAllPlints;
  for i := 0 to fAllPlints.Count - 1 do
  begin
    LPlint := fAllPlints[i];
    LPlint.fUnIndex := i;
  end;    
end;

{$Endregion}

{$Region 'TRecordList' }

function TRecordList.GetItemById(const AId: Integer): TRecord;
var
  i: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    result := TRecord(Items[i]);
    if result.fId = AId then
      Exit;
  end;
  result := nil;
end;

{$Endregion}

{$Region 'TCUList' }

function TCUList.GetItem(const AIndex: Integer): TCU;
begin
  result := TCU(inherited Items[AIndex]);
end;

function TCUList.GetItemById(const AId: Integer): TCU;
begin
  result := TCU(inherited GetItemById(AId));
end;

{$Endregion}

{$Region 'TPlintList' }

procedure TPlintList.CopyTo(aPlintList: TPlintList);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    aPlintList.Add(Items[i]);
  end;
end;

procedure TPlintList.ExtractList(aPlintList: TPlintList);
var
  i: Integer;
begin
  for i := 0 to aPlintList.Count - 1 do
  begin
    Self.Extract(aPlintList[i]);
  end;
end;

function TPlintList.GetItem(const AIndex: Integer): TPlint;
begin
  result := TPlint(inherited Items[AIndex]);
end;

function TPlintList.GetItemById(const AId: Integer): TPlint;
begin
  result := TPlint(inherited GetItemById(AId));
end;

{$Endregion}

{$Region 'TPlint' }

constructor TPlint.Create(aId: Integer; aCU: TCU);
begin
  inherited Create(aId);
  fCU := aCU;
end;

function TPlint.GetNode: TNode;
begin
  result := fCU.Node;
end;

function TPlint.Info: String;
begin
  result := fCU.Info + ' ' + С_PLINT + ':' + IntToStr(Id);
end;

{$Endregion}

end.
