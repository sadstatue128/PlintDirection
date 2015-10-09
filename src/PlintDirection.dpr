program PlintDirection;

uses
  Vcl.Forms,
  fmMain in 'fmMain.pas' {Main},
  PlintDef in 'PlintDef.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
