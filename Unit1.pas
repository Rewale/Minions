unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Unit2;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure OnCreate(Sender: TObject);
    procedure IncStealed();
    procedure ExtendListBox(ItemsCount: Int32);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var i: Integer;
    m: Minion;
    count: Integer;
begin
  if (Trim(Edit1.Text) = '') or (Trim(Edit2.Text) = '') then
  begin
    MessageBox(handle, PChar('Необходимо указать количество миньонов и объем корзины'),
                      PChar('Недостаточно данных!'), MB_OK);
    exit;
  end;

  if (StrToInt(Edit1.Text) <= 0) or (StrToInt(Edit2.Text) <= 0) then
  begin
    MessageBox(handle, PChar('Количество миньонов и объем корзины должны быть больше 0'),
                      PChar('Некорректные данные!'), MB_OK);
    exit;
  end;

  if ProgressBar1.Position <> ProgressBar1.Max then
  begin
    MessageBox(handle, PChar('Дождитесь выполнения потоков'),
                        PChar('Потоки уже запущены!'), MB_OK);
    exit;
  end;

  ProgressBar1.Position := 0;
  ProgressBar1.Max := StrToInt(Edit2.Text);
  ListBox1.Items.Clear();
  count := StrToInt(Edit1.Text);
  ExtendListBox(count);
  For i:= 1 to count do
  begin
    m := Minion.Create(True);
    m.Number := i;
    m.Speed := Random(5) + 1;
    Form1.ListBox1.Items.Add(Format('Миньон №%d начал работу со скоростью %d ед. в секунду', [m.Number, m.Speed]));
    m.Start;
  end;
end;
// Расширяем список, чтобы не было прокрутки
procedure TForm1.ExtendListBox(ItemsCount: Int32);
var lastHeight: Int64;
var nextHeight: Int64;
begin
  lastHeight := Form1.ListBox1.Height;
  nextHeight := Form1.ListBox1.ItemHeight*(ItemsCount+1);
  if nextHeight >= 750 then
    nextHeight := 750;

  Form1.ListBox1.Height:=nextHeight;
  Form1.Height := Form1.Height + Form1.ListBox1.Height - lastHeight;
end;

procedure TForm1.IncStealed;
begin
  Form1.ProgressBar1.Position := Form1.ProgressBar1.Position + 1;
  Form1.Label3.Caption := Format('Заполенность корзины: %d%%',[Trunc(Form1.ProgressBar1.Position/Form1.ProgressBar1.Max * 100)]);
end;

procedure TForm1.OnCreate(Sender: TObject);
begin
  ProgressBar1.Position := 0;
  ProgressBar1.Max := 0;
  ProgressBar1.Min := 0;
end;

end.
