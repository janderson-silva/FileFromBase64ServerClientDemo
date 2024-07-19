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



unit controller.arquivo;

interface

uses
  Horse,
  Soap.EncdDecd,
  System.Classes,
  System.JSON,
  System.SysUtils,
  VCL.Graphics,
  interfaces.arquivo,
  model.arquivo;

procedure Registry;

implementation

procedure InsertArquivo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FArquivo : iArquivo;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FArquivo := TArquivo.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

    FArquivo
        .nome(body.GetValue<string>('nome',''))
        .arquivo(body.GetValue<string>('arquivo',''))
      .Insert(erro);

    body.Free;
    if erro <> '' then
      raise Exception.Create(erro)
    else
      res.Send('{ salvo com sucesso }').Status(200);
  except on E : Exception do
    begin
      res.Send('{ "erro": "'+E.Message+'" }').Status(400);
      Exit;
    end;
  end;
end;

procedure Registry;
begin
    THorse.Group.Prefix('v1')
      .Post('/arquivo', InsertArquivo);
end;

end.
