unit Unit2;

interface

uses
  System.Classes;

type
  Minion = class(TThread)

    // ���������� ��. � �������
    Speed: Integer;
    // ����� �������
    Number: Integer;
    // ���������� �����������
    StolenCount: Integer;
    // ���������� ��� �������������
    KeepStealing: Boolean;
  private
    { Private declarations }
    procedure Stole;
  protected
    procedure Execute; override;
  end;

implementation

uses unit1, SysUtils;

procedure Minion.Execute;
begin
  StolenCount:=0;
  KeepStealing:=True;

  while KeepStealing do
  begin
    Sleep(Round(1000/Speed));
    Synchronize(Stole);
  end;
  Terminate;
end;

procedure Minion.Stole;
var M: string;
var Max: Int64;
begin
  Max := Form1.ProgressBar1.Max;
  if Max <= Form1.ProgressBar1.Position  then
  begin
    KeepStealing:=False;
    exit;
  end;
  Form1.IncStealed;
  StolenCount := StolenCount + 1;
  M := Format('������ �%d �������� %d ��.', [Number, StolenCount]);
  Form1.ListBox1.Items.Strings[Number-1] := M;
end;
end.

