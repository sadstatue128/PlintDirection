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
    function GetItem (const AId: Integer): TCU;
    function GetItemById (const AId: Integer): TCU;
  public
    property Items [const Id: Integer]: TCU read GetItemById; default;
    property ItemsById [const Id: Integer]: TCU read GetItemById;
end;

TPlint = class(TRecord)
  private
    fCU: TCU;
    function GetNode: TNode;
  public
    constructor Create(aId: Integer; aCU: TCU);
    function Info: String; override;
    property CU: TCU read fCU;
    property Node: TNode read GetNode;
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
end;

function TNodeList.GetItem(const AId: Integer): TNode;
begin
  result := TNode(inherited Items[AId]);
end;

function TNodeList.GetItemById(const AId: Integer): TNode;
begin
  result := TNode(inherited GetItemById(AId));
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

function TCUList.GetItem(const AId: Integer): TCU;
begin
  result := TCU(inherited Items[AId]);
end;

function TCUList.GetItemById(const AId: Integer): TCU;
begin
  result := TCU(inherited GetItemById(AId));
end;

{$Endregion}

{$Region 'TPlintList' }

function TPlintList.GetItem(const AId: Integer): TPlint;
begin
  result := TPlint(inherited Items[AId]);
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
