unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Windows, UnitHelp;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonHelp: TButton;
    ButtonPlayHide: TButton;
    ButtonErase: TButton;
    ButtonPlay: TButton;
    ButtonRecord: TButton;
    EditA1: TEdit;
    EditA2: TEdit;
    EditA3: TEdit;
    ListBox1: TListBox;
    TimerPlay: TTimer;
    TimerRecord: TTimer;
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonPlayHideClick(Sender: TObject);
    procedure ButtonEraseClick(Sender: TObject);
    procedure ButtonPlayClick(Sender: TObject);
    procedure ButtonRecordClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: char);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure TimerPlayTimer(Sender: TObject);
    procedure TimerRecordTimer(Sender: TObject);
  private
  public
  end;

  TPixelColor = class
    position: TPoint;
    color: COLORREF;
  end;

  Actions = class
    class function getColorHexPositionPix(x,y: Integer):String;
    class function getPositionPix(x,y: Integer):TPixelColor;
    class function getMousePix():TPixelColor;
    class procedure MouseClick(x,y: Integer);
    class function IsControlKeyPressed(): Boolean;
    class function IsKeyPressed(key:longint): Boolean;
  end;

  Game = class
    class function play(x1,y1: Integer; c1:String; x2,y2: Integer; c2:String; x,y:Integer):Boolean;
  end;

var
  Form1: TForm1;
  FormHelp: TFormHelp;

implementation

{$R *.lfm}

{ TForm1 }
        
procedure TForm1.FormCreate(Sender: TObject);
begin
  if FileExists('actions.txt') then
    ListBox1.Items.LoadFromFile('actions.txt');
  EditA1.Clear;
  EditA2.Clear;
  EditA3.Clear;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  //ButtonErase.Enabled := ListBox1.ItemIndex <> -1;
  //ShowMessage(IntToStr(ListBox1.ItemIndex));
end;

procedure TForm1.ListBox1KeyPress(Sender: TObject; var Key: char);
begin
  //ButtonErase.Enabled := ListBox1.ItemIndex <> -1;
end;

procedure TForm1.ListBox1SelectionChange(Sender: TObject; User: boolean);
begin
  ButtonErase.Enabled := ListBox1.ItemIndex <> -1;
end;

procedure SplitStr(const Source, Delimiter: String; var DelimitedList: TStringList);
var
  s: PChar;
  DelimiterIndex: Integer;
  Item: String;
begin
  s:=PChar(Source);
  repeat
    DelimiterIndex:=Pos(Delimiter, s);
    if DelimiterIndex=0 then Break;
    Item:=Copy(s, 1, DelimiterIndex-1);
    DelimitedList.Add(Item);
    inc(s, DelimiterIndex + Length(Delimiter)-1);
  until DelimiterIndex = 0;
  DelimitedList.Add(s);
end;

class function Actions.getPositionPix(x,y: Integer):TPixelColor;
begin
  if (GetDC(0) = 0) then Exit;  
  result := TPixelColor.Create;
  result.position := TPoint.Create(x, y);
  result.color:= GetPixel(GetDC(0), x, y);
  result.position.x := x;
  result.position.y := y;
end;

class function Actions.getMousePix():TPixelColor;
var
  CursorPos: TPoint;
begin                                         
  if (GetDC(0) = 0) then Exit;
  if not GetCursorPos(CursorPos) then Exit;
  result := TPixelColor.Create;
  result.position := TPoint.Create(0,0);
  result := Actions.getPositionPix(CursorPos.x, CursorPos.y);
end;

class procedure Actions.MouseClick(x,y: Integer);
begin
  SetCursorPos(x, y);
  Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
  Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
end;

class function Actions.IsControlKeyPressed(): Boolean;
begin
  Result := GetKeyState(VK_SHIFT) < 0;
end;

class function Actions.IsKeyPressed(key:longint): Boolean;
begin
  Result := GetKeyState(key) < 0;
end;

class function Actions.getColorHexPositionPix(x,y: Integer):String;
var DC: HDC;
begin
  DC := GetDC(0);
  if (DC = 0) then Exit;
  result := GetPixel(DC, x, y).ToHexString;
  ReleaseDC(0, DC);
end;

class function Game.play(x1,y1: Integer; c1:String; x2,y2: Integer; c2:String; x,y:Integer):Boolean;
begin
  result := False;
  if (Actions.getColorHexPositionPix(x1, y1)  = c1)
  and (Actions.getColorHexPositionPix(x2, y2)  = c2) then
  begin
    Actions.MouseClick(x,y);
    result := True;
  end;
end;

procedure TForm1.ButtonRecordClick(Sender: TObject);
begin
  if TimerPlay.Enabled then
    ButtonPlayClick(nil);
  TimerRecord.Enabled := not TimerRecord.Enabled;
  if TimerRecord.Enabled then
    ButtonRecord.Caption:= 'Record ON'
  else
    ButtonRecord.Caption:= 'Record OFF';
end;

procedure TForm1.ButtonPlayClick(Sender: TObject);
begin
  if TimerRecord.Enabled then
    ButtonRecordClick(nil);
  TimerPlay.Interval:= 1000;
  TimerPlay.Enabled := not TimerPlay.Enabled;
  if TimerPlay.Enabled then
    ButtonPlay.Caption:= 'Play ON'
  else
    ButtonPlay.Caption:= 'Play OFF';
end;

procedure TForm1.ButtonEraseClick(Sender: TObject);
begin
  ListBox1.DeleteSelected;
  ListBox1.Items.SaveToFile('actions.txt');
end;

procedure TForm1.ButtonPlayHideClick(Sender: TObject);
begin
  ButtonPlayClick(nil);
  Form1.WindowState:= wsMinimized;
end;

procedure TForm1.ButtonHelpClick(Sender: TObject);
begin
  if FormHelp = nil then FormHelp := TFormHelp.Create(nil);
  FormHelp.Top:=Top;
  FormHelp.Left:=Left + 100;
  FormHelp.Show;
  FormHelp.BringToFront;
end;

procedure TForm1.TimerPlayTimer(Sender: TObject);
var
  a: TStringList;
  i: Integer;
begin
  TTimer(Sender).Enabled:=False;
  for i := 0 to ListBox1.Items.Count - 1 do
  begin
    if ListBox1.Items.Strings[i] <> '' then
    begin
      a:=TStringList.Create;
      SplitStr(ListBox1.Items.Strings[i],';',a);
      if a.Count >= 8 then
      begin
        Game.play(StrToInt(a.Strings[0]),StrToInt(a.Strings[1]), a.Strings[2], StrToInt(a.Strings[3]), StrToInt(a.Strings[4]), a.Strings[5], StrToInt(a.Strings[6]), StrToInt(a.Strings[7]));
      end;
      a.Free;
    end;
  end;
  TTimer(Sender).Interval:=5000;
  TTimer(Sender).Enabled:=True;
end;

var VK_Pressed: Boolean = False;

procedure TForm1.TimerRecordTimer(Sender: TObject);
var
  p: TPixelColor;
begin
  TTimer(Sender).Enabled:=False;
  if Actions.IsKeyPressed(VK_1) then
  begin
    p := Actions.getMousePix();
    EditA1.Color := p.color;
    EditA1.Text := ''+IntToStr(p.position.x)+';'+IntToStr(p.position.y)+';'+p.color.ToHexString;
    p.Free;
  end;
  if Actions.IsKeyPressed(VK_2) then
  begin
    p := Actions.getMousePix();
    EditA2.Color := p.color;
    EditA2.Text := ''+IntToStr(p.position.x)+';'+IntToStr(p.position.y)+';'+p.color.ToHexString;
    p.Free;
  end;
  if Actions.IsKeyPressed(VK_3) and not VK_Pressed then
  begin
    VK_Pressed := True;
    p := Actions.getMousePix();
    EditA3.Text := ''+IntToStr(p.position.x)+';'+IntToStr(p.position.y);
    p.Free;
    ListBox1.Items.Add(EditA1.Text+';'+EditA2.Text+';'+EditA3.Text);
    ListBox1.Items.SaveToFile('actions.txt');
    EditA1.Text:= '';
    EditA1.Color:=clDefault;
    EditA2.Text:= '';
    EditA2.Color:=clDefault;
    EditA3.Text:= '';
    EditA3.Color:=clDefault;
  end else begin
    VK_Pressed := False;
  end;
  TTimer(Sender).Enabled:=True;
end;

end.

