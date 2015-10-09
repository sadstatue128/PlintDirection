unit PlintDef;

interface

uses System.Generics.Collections;

type

TRecord = class
  private
    Id: Integer;
  public
    constructor Create(aId: Integer);
end;

TRecordList<T: TRecord, constructor> = class(TObjectList<T>)
end;

TCUList = class;

TNode = class(TRecord)
  private
    fCUs: TCUList;
  public
    constructor Create(aId: Integer);
    destructor Destroy;
end;

TNodeList = class(TRecordList<TNode>)
end;

TPlintList = class;

TCU = class(TRecord)
  private
    fPlints: TPlintList;
  public
    constructor Create(aId: Integer);
    destructor Destroy;
end;

TCUList = class(TRecordList<TCU>)
end;

TPlint = class(TRecord)
end;

TPlintList = class(TRecordList<TPlint>)
end;


implementation

{ TRecord }

constructor TRecord.Create(aId: Integer);
begin
  Id := aId;
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
  fPlints := TPlintList.Create(true);
end;

destructor TCU.Destroy;
begin
  fPlints.Free;
end;

end.
