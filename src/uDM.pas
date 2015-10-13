unit uDM;

interface

uses
  SysUtils, Classes, PlintDef, DirectionDef;

const
  APPLICATION_NAME = '”паковка направлений';

type
  TDM = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fNodeList: TNodeList;
    fPlintDirController: TPlintDirectionController;
  public
    property NodeList: TNodeList read fNodeList;
    procedure AddTestNodes(aNodeCount: Integer);
    procedure GetPlintListForBinding(aPlint: TPlint; aPlintList: TPlintList);
    property PlintDirController: TPlintDirectionController read fPlintDirController;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  fNodeList := TNodeList.Create(true);
  fPlintDirController := TPlintDirectionController.Create;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  fNodeList.Free;
  fPlintDirController.Free;
end;

procedure TDM.AddTestNodes(aNodeCount: Integer);
begin
  fNodeList.FillRandomValues(aNodeCount);
end;

procedure TDM.GetPlintListForBinding(aPlint: TPlint; aPlintList: TPlintList);
begin
  fNodeList.AllPlints.CopyTo(aPlintList);
  //исключить aPlint
  aPlintList.Extract(aPlint);
  //исключить плинты, с которыми уже есть св€зь

  //записать в выходное значение
  
end;



end.
