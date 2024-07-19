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



unit interfaces.arquivo;

interface

uses
  Horse,
  VCL.Graphics;

type
  iArquivo = interface
    function id (Value : Integer) : iArquivo; overload;
    function id : Integer; overload;

    function nome (Value : String) : iArquivo; overload;
    function nome : String; overload;

    function arquivo (Value : String   {oid}) : iArquivo; overload;
    function arquivo : String   {oid}; overload;

    function Insert(out erro : String) : iArquivo; overload;

    function &End : iArquivo;

  end;

implementation

end.
