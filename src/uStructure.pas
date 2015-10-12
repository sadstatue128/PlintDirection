unit uStructure;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, ComCtrls, PlintDef;

type
  TChange = procedure (aRecord: TRecord; aType: TChosenType) of object;

  TfrmStructure = class(TFrame)
    tvComStruct: TTreeView;
    procedure tvComStructChange(Sender: TObject; Node: TTreeNode);
  private
    fSelected: TRecord;
    fChosenType: TChosenType;
    procedure HandleSelectedData(LSelNode: TTreeNode);
    procedure OnSelectedDataChange;
  public
    ChangeEvent: TChange;
    procedure FillStruct;
  end;

implementation

uses uDM;

{$R *.dfm}

procedure TfrmStructure.FillStruct;
var
  LNode: TNode;
  LNodeNode, LCUNode, LPlintNode: TTreeNode;
  LCU: TCU;
  LPlint: TPlint;
  i, j, k: Integer;  
begin
  tvComStruct.Items.Clear;
  for i := 0 to DM.NodeList.Count - 1 do
  begin
    LNode := DM.NodeList[i];
    LNodeNode := tvComStruct.Items.AddObject(nil, 'Node ' + IntToStr(LNode.id), TObject(LNode));
    for j := 0 to LNode.CUs.Count -1 do
    begin
      LCU := LNode.CUs[j];
      LCUNode := tvComStruct.Items.AddChildObject(LNodeNode, 'CU '+ IntToStr(LCU.id), TObject(LCU));
      for k := 0 to LCU.Plints.Count - 1 do
      begin
        LPlint := LCU.Plints[k];
        LPlintNode := tvComStruct.Items.AddChildObject(LCUNode, 'Plint '+ IntToStr(LPlint.id), TObject(LPlint));
      end;
    end;
  end;
end;


procedure TfrmStructure.tvComStructChange(Sender: TObject; Node: TTreeNode);
begin
  HandleSelectedData(Node);
  OnSelectedDataChange;
end;

procedure TfrmStructure.HandleSelectedData(LSelNode: TTreeNode);
begin
  fSelected := TRecord(tvComStruct.Selected.Data);
  if fSelected is TNode then
    fChosenType := chNode
  else if fSelected is TCU then
    fChosenType := chCU
  else if fSelected is TPlint then
    fChosenType := chPlint;
end;

procedure TfrmStructure.OnSelectedDataChange;
begin
  if Assigned(ChangeEvent) then
    ChangeEvent(fSelected, fChosenType);
end;

end.
