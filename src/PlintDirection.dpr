program PlintDirection;

uses
  Forms,
  PlintDef in 'PlintDef.pas',
  uStructure in 'uStructure.pas' {frmStructure: TFrame},
  uDM in 'uDM.pas' {DM: TDataModule},
  uMain in 'uMain.pas' {fmMain},
  uPlintDirection in 'uPlintDirection.pas' {frmPlintDirection: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
