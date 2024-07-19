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



unit model.arquivo;

interface

uses
  Horse,
  Data.DB,
  FireDAC.Comp.Client,
  System.SysUtils,
  interfaces.arquivo,
  model.connection,
  System.Classes,
  System.NetEncoding;

type
  TArquivo = class(TInterfacedObject, iArquivo)
    private
      Fid : Integer;
      Fnome : string;
      Farquivo : String   {oid};
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iArquivo;

      function id (Value : Integer) : iArquivo; overload;
      function id : Integer; overload;

      function nome (Value : String) : iArquivo; overload;
      function nome : String; overload;

      function arquivo (Value : String   {oid}) : iArquivo; overload;
      function arquivo : String   {oid}; overload;

      function Insert(out erro : String) : iArquivo; overload;
      function Select(out erro : string) : TFDquery; overload;

      function &End : iArquivo;

      function ConvertBase64ToFile(const Base64Text: string) : string;

  end;

implementation

function TArquivo.ConvertBase64ToFile(const Base64Text: string) : string;
var
  lPathApp,
  lPathAppSub : string;
  FileName: string;
  Bytes: TBytes;
  FileStream: TFileStream;
  Decoder: TBase64Encoding;
begin
  // caminho das pastas gerais
  lPathApp := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));

  // caminho da pasta certificado
  lPathAppSub := IncludeTrailingPathDelimiter(lPathApp + 'Arquivo');

  ForceDirectories(lPathAppSub);

  // Caminho e nome do arquivo onde será salvo o conteúdo decodificado
  FileName := lPathAppSub + nome;

  // Inicializa o decodificador Base64
  Decoder := TBase64Encoding.Create;

  try
    // Converte o texto Base64 em bytes
    Bytes := Decoder.DecodeStringToBytes(Base64Text);

    // Cria um FileStream para salvar o arquivo
    FileStream := TFileStream.Create(FileName, fmCreate);
    try
      // Escreve os bytes decodificados no arquivo
      FileStream.WriteBuffer(Bytes[0], Length(Bytes));
    finally
      FileStream.Free;
    end;

    Result := FileName;
  finally
    Decoder.Free;
  end;
end;

constructor TArquivo.Create;
begin
  model.connection.Connect;
end;

destructor TArquivo.Destroy;
begin
  model.connection.Disconect;
end;

class function TArquivo.New: iArquivo;
begin
  Result := Self.Create;
end;

function TArquivo.&End: iArquivo;
begin
  Result := Self;
end;

function TArquivo.Insert(out erro: String): iArquivo;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('insert into arquivo(');
    qry.SQL.Add('    nome,');
    qry.SQL.Add('    arquivo');
    qry.SQL.Add(') values (');
    qry.SQL.Add('    :nome,');
    qry.SQL.Add('    :arquivo');
    qry.SQL.Add(')');
    qry.ParamByName('nome').Value := Fnome;
    qry.ParamByName('arquivo').LoadFromFile(ConvertBase64ToFile(Farquivo), ftBlob);
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao inserir arquivo: ' + ex.Message;
    end;
  end;
end;

function TArquivo.Select(out erro : string) : TFDquery;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('select * from arquivo');
    qry.Active := True;
    erro := '';
    Result := qry;
  except on ex:exception do
    begin
      erro := 'Erro ao consultar Arquivo: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TArquivo.id (Value : Integer) : iArquivo;
begin
  Result := Self;
  Fid := Value;
end;

function TArquivo.id : Integer;
begin
  Result := Fid;
end;

function TArquivo.nome (Value : string) : iArquivo;
begin
  Result := Self;
  Fnome := Value;
end;

function TArquivo.nome : string;
begin
  Result := Fnome;
end;

function TArquivo.arquivo (Value : String   {oid}) : iArquivo;
begin
  Result := Self;
  Farquivo := Value;
end;

function TArquivo.arquivo : String   {oid};
begin
  Result := Farquivo;
end;

end.
