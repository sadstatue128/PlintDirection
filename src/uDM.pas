unit uDM;

interface

uses
  SysUtils, Classes, PlintDef;

type
  TDM = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fNodeList: TNodeList;
  public
    property NodeList: TNodeList read fNodeList;
    procedure AddTestNodes(aNodeCount: Integer);
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  fNodeList := TNodeList.Create(true);
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  fNodeList.Free;
end;

procedure TDM.AddTestNodes(aNodeCount: Integer);
begin
  fNodeList.FillRandomValues(aNodeCount);
end;



end.
