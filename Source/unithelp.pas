unit unitHelp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormHelp }

  TFormHelp = class(TForm)
    ComboBox1: TComboBox;
    Memo1: TMemo;
    procedure ComboBox1Select(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FormHelp: TFormHelp;

implementation

{$R *.lfm}

{ TFormHelp }

procedure TFormHelp.FormCreate(Sender: TObject);
begin
  Memo1.Align:=alClient;
  if ComboBox1.ItemIndex = -1 then
    ComboBox1.ItemIndex := 0;
  ComboBox1Select(nil);
end;


procedure TFormHelp.ComboBox1Select(Sender: TObject);
begin
  Memo1.Clear;
  if ComboBox1.ItemIndex = 0 then
  begin
    Memo1.Lines.Add(
      'WARNING'#13#10+
      '======'#13#10+
      ''#13#10+
      'Close and Save all documents before use this software. <<Be ready to force to shutdown your computer in case of bad configuration.>>'#13#10+
      ''#13#10+
      'HOW TO USE'#13#10+
      '========'#13#10+
      ''#13#10+
      'This software needs to see the screen.'#13#10+
      'It will check colors at the position specified. '#13#10+
      'And perform automatic click.'#13#10+
      ''#13#10+
      '-Press Button "Record"'#13#10+
      '-Move your mouse on the game window.'#13#10+
      '-Select a pixel color with the keyboard by pressing key "1".'#13#10+
      '-Repeat this action with a second color. And press key "2".'#13#10+
      '-Move your mouse where you want to automatic click (if these two colors are detected). And press key "3"'#13#10+
      '-If you don''t press the key "3", you can change the color1 and color2 by pressing again key "1" or "2" until your selection is correct.'#13#10+
      '-The key 3 will record this action. And you can select another action by repeting the steps "1", "2", "3".'#13#10+
      ''#13#10+
      '-When configuration is done. You can perform automatic clicks by pressing button "Play" or "Play and Hide".'#13#10+
      '-To stop automatic clicks, press again on button "Play".'#13#10
    );
  end;
  if ComboBox1.ItemIndex = 1 then
  begin
    Memo1.Lines.Add(
      'ATTENTION'#13#10+
      '========='#13#10+
      ''#13#10+
      'Fermez et sauvegardez vos documents avant d''utiliser ce logiciel. <<Soyez prêts à forcer votre ordinateur à s''éteindre en cas de mauvaise configuration.>>'#13#10+
      ''#13#10+
      'UTILISATION'#13#10+
      '========'#13#10+
      ''#13#10+
      'Ce logiciel a besoin de regarder l''écran.'#13#10+
      'Il va vérifier les couleurs à la position indiqué.'#13#10+
      'Et clique automatiquement.'#13#10+
      ''#13#10+
      '-Appuyez sur le bouton "Record"'#13#10+
      '-Bougez la souris sur la fenêtre du jeux-vidéo.'#13#10+
      '-Selectionnez un pixel, et memoriser sa couleur avec la touche "1" du clavier.'#13#10+
      '-Selectionnez un deuxième pixel, et memoriser avec la touche "2" du clavier.'#13#10+
      '-Selectionner enfin l''endroit où on veut que le programme clique, et memoriser avec la touche "3".'#13#10+
      '-Tant que la touche "3" n''a pas été appuyé, on peut changer la sélection des couleurs 1 et 2 en répètant les étapes précédantes.'#13#10+
      '-La touche "3" enregistre l''action. Et vous pouvez sélectionner d''autres couleurs et actions en répétants les étapes "1", "2", "3".'#13#10+
      ''#13#10+
      '-Une fois la configuration terminé. On peut lancer les clicks automatique avec le bouton "Play" ou "Play and Hide".'#13#10+
      '-Pour arrêter les clicks automatique. Appuyer une nouvelle fois sur "Play"'#13#10
    );
  end;
end;



end.

