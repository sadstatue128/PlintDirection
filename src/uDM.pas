unit uDM;

interface

uses
  SysUtils, Classes, PlintDef, DirectionDef;

const
  APPLICATION_NAME = '�������� �����������';

type
  TDM = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fNodeList: TNodeList;
    fPlintDirController: TPlintDirectionController;
    fDirectionController: TDirectionController;
  public
    function CalculateDirections: TDirectionList;
    procedure AddTestNodes(aNodeCount: Integer);
    procedure GetPlintListForBinding(aPlint: TPlint; aPlintList: TPlintList);
    property PlintDirController: TPlintDirectionController read fPlintDirController;
    property NodeList: TNodeList read fNodeList;
    property DirectionController: TDirectionController read fDirectionController;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TDM.CalculateDirections: TDirectionList;
begin
  //�������� � DirectionController PlintDirections
  fDirectionController.AssignPlintList(fPlintDirController.Dirs);
  //����������
  fDirectionController.Calculate;
  //�������� ���������
  result := fDirectionController.Dirs;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  fNodeList := TNodeList.Create(true);
  fPlintDirController := TPlintDirectionController.Create;
  fDirectionController :=  TDirectionController.Create;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  fNodeList.Free;
  fPlintDirController.Free;
  fDirectionController.Free;
end;

procedure TDM.AddTestNodes(aNodeCount: Integer);
begin
  fNodeList.FillRandomValues(aNodeCount);
end;

procedure TDM.GetPlintListForBinding(aPlint: TPlint; aPlintList: TPlintList);
var
  LBindedPlints: TPlintList;
begin
  fNodeList.AllPlints.CopyTo(aPlintList);
  //��������� aPlint
  aPlintList.Extract(aPlint);
  //��������� ������, � �������� ��� ���� �����
  LBindedPlints := TPlintList.Create(false);
  try
    PlintDirController.GetBindedPlintsFor(aPlint, LBindedPlints);
    aPlintList.ExtractList(LBindedPlints);
  finally
    LBindedPlints.Free;
  end;
  
end;



end.
