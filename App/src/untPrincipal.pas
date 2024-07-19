{*******************************************************************************}
{                                                                               }
{ Projeto: ExemploUploadFotoHorse - HorseAndRESTRequest4Delphi                  }
{                                                                               }
{*******************************************************************************}
{                                                                               }
{ Desenvolvido por JANDERSON APARECIDO DA SILVA                                 }
{ Email: janderson_rm@hotmail.com                                               }
{                                                                               }
{*******************************************************************************}



unit untPrincipal;

interface

uses
  Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.NetEncoding,
  unt.interfaces.arquivo,
  unt.model.arquivo, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  DataSet.Serialize;

type
  TfrmPrincipal = class(TForm)
    Panel3: TPanel;
    pnlListarArquivos: TPanel;
    pnlEnviarArquivo: TPanel;
    pnlExportar: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDMemTable1: TFDMemTable;
    FDMemTable1id: TIntegerField;
    FDMemTable1nome: TStringField;
    OpenDialog1: TOpenDialog;
    FDMemTable1arquivo: TBlobField;
    procedure pnlEnviarArquivoClick(Sender: TObject);
    procedure pnlListarArquivosClick(Sender: TObject);
  private
    function ConvertFileToBase64(AInFileName: string): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

function TfrmPrincipal.ConvertFileToBase64(AInFileName: string): String;
var
  inStream    : TStream;
  outStream   : TStream;
  vFile       : String;
  vStringList : TStringList;
begin
  inStream    := TFileStream.Create(AInFileName, fmOpenRead);
  vStringList := TStringList.Create;
  try
    vFile := FormatDateTime('hhmmss',Now);
    outStream := TFileStream.Create(vFile, fmCreate);
    try
      TNetEncoding.Base64.Encode(inStream, outStream);
    finally
      outStream.Free;
    end;

    vStringList.LoadFromFile(vFile);

    Result := vStringList.Text;
  finally
    DeleteFile(Pchar(vFile));
    inStream.Free;
  end;
end;

procedure TfrmPrincipal.pnlEnviarArquivoClick(Sender: TObject);
var
  FArquivo : iArquivo;
begin
  OpenDialog1.FileName := '';
  if OpenDialog1.Execute then
    if OpenDialog1.FileName <> '' then
    begin
      FArquivo := TArquivo.New;
      try
        FArquivo
            .nome(ExtractFileName(OpenDialog1.FileName))
            .arquivo(ConvertFileToBase64(OpenDialog1.FileName))
          .Insert;
      finally

      end;
    end;
end;

procedure TfrmPrincipal.pnlListarArquivosClick(Sender: TObject);
var
  FArquivo : iArquivo;
begin
  FArquivo := TArquivo.New;
  try
    //carrega o MemTable com os dados do JSON
    FDMemTable1.Close;
    FDMemTable1.LoadFromJSON(FArquivo
                               .Select);
    FDMemTable1.Open;
    FDMemTable1.First;
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

end.
