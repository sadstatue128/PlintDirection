unit PlintDef;

interface

uses Classes, SysUtils, Contnrs, DB;

type

TChosenType = (chNode, chCU, chPlint);

TRecord = class
  private
    fId: Integer;
  public
    property Id: Integer read fId;
    constructor Create(aId: Integer);
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
end;

TNodeList = class(TRecordList)
  private
    function GetItem (const AId: Integer): TNode;
    function GetItemById (const AId: Integer): TNode;
  public
    property Items [const Id: Integer]: TNode read GetItemById; default;
    property ItemsById [const Id: Integer]: TNode read GetItemById;
    procedure FillRandomValues(aNodeCount: Integer);
end;

TPlintList = class;

TCU = class(TRecord)
  private
    fPlints: TPlintList;
  public
    constructor Create(aId: Integer);
    destructor Destroy;
    property Plints: TPlintList read fPlints;
end;

TCUList = class(TRecordList)
  private
    function GetItem (const AId: Integer): TCU;
    function GetItemById (const AId: Integer): TCU;
  public
    property Items [const Id: Integer]: TCU read GetItemById; default;
    property ItemsById [const Id: Integer]: TCU read GetItemById;
end;

TPlint = class(TRecord)
end;

TPlintList = class(TRecordList)
  private
    function GetItem (const AId: Integer): TPlint;
    function GetItemById (const AId: Integer): TPlint;
  public
    property Items [const Id: Integer]: TPlint read GetItemById; default;
    property ItemsById [const Id: Integer]: TPlint read GetItemById;
end;


implementation

{ TRecord }

constructor TRecord.Create(aId: Integer);
begin
  fId := aId;
end;

{ TNode }

constructor TNode.Create(aId: Integer);
begin
  inherited;
  fCUs := TCUList.Create(true);
end;

destructor TNode.Destroy;
begin
  fCUs.Free;
end;

{ TCU }

constructor TCU.Create(aId: Integer);
begin
  inherited;
  fPlints := TPlintList.Create(true);
end;

destructor TCU.Destroy;
begin
  fPlints.Free;
end;

{ TNodeList }

procedure TNodeList.FillRandomValues(aNodeCount: Integer);

procedure FillCU(aCU: TCU);
  var
    PlintCount: Integer;
    i: Integer;
begin
  PlintCount := 1 + Random(8);
  for i := 0 to PlintCount do
  begin
    aCU.Plints.Add(TPlint.Create(i));
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
    LCU := TCU.Create(i);
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
end;

function TNodeList.GetItem(const AId: Integer): TNode;
begin
  result := TNode(inherited Items[AId]);
end;

function TNodeList.GetItemById(const AId: Integer): TNode;
begin
  result := TNode(inherited GetItemById(AId));
end;

{ TRecordList }

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

{ TCUList }

function TCUList.GetItem(const AId: Integer): TCU;
begin
  result := TCU(inherited Items[AId]);
end;

function TCUList.GetItemById(const AId: Integer): TCU;
begin
  result := TCU(inherited GetItemById(AId));
end;

{ TPlintList }

function TPlintList.GetItem(const AId: Integer): TPlint;
begin
  result := TPlint(inherited Items[AId]);
end;

function TPlintList.GetItemById(const AId: Integer): TPlint;
begin
  result := TPlint(inherited GetItemById(AId));
end;

end.
