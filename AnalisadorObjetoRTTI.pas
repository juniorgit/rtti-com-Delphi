program AnalisadorObjetoRTTI;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Rtti, System.TypInfo;

type
  TUmaClasseMinha = class
  private
    Id: Integer;
  public
    Usuario      : string;
    Empresa      : Integer;
    DataExpiracao: TDateTime;
    Salario      : Currency;
  end;

procedure MostrarPropriedades(Obj: TObject);
var
  ctx                       : TRttiContext;
  objType                   : TRttiType;
  //Prop                    : TRttiProperty;
  Field                     : TRttiField;
  Visibilidade, Valor, Texto: string;
begin
  ctx     := TRttiContext.Create;
  objType := ctx.GetType(Obj.ClassInfo);
  Texto   := '';

  // percorre os Fields do objeto
  for Field in objType.GetFields do
  begin
    // vamos guardar a visibilidade numa variável
    case Field.Visibility of
      mvPrivate:
        Visibilidade := 'private';
      mvProtected:
        Visibilidade := 'protected';
      mvPublic:
        Visibilidade := 'public';
      mvPublished:
        Visibilidade := 'published';
    end;

    // conforme o tipo acessamos o valor de forma diferente
    case Field.FieldType.TypeKind of
      tkInteger:
        Valor := IntToStr(Field.GetValue(Obj).AsInteger) + ': integer';
      tkString, tkUString:
        Valor := Field.GetValue(Obj).AsString + ': string';
      tkFloat:
        begin
          // data e float internamente são os mesmos por isso vamos diferenciar pelo "nome" do tipo
          if Field.FieldType.ToString = 'TDateTime' then
            Valor := DateToStr(Field.GetValue(Obj).AsExtended) + ': TDateTime'
          else
            Valor := FloatToStr(Field.GetValue(Obj).AsCurrency) + ': Float';
        end;
    else
      Valor := 'Tipo não analisado';
    end;

    // acumula no Texto
    Writeln(Field.Name + ': ' + Visibilidade + ', Valor = ' + Valor);
  end;
end;

// projeto principal
var
  UmaClasseMinha: TUmaClasseMinha;

begin

  // instanciamos a class UmaClasseMinha
  UmaClasseMinha := TUmaClasseMinha.Create;

  // atribuimos os valores, inclusive nos private
  UmaClasseMinha.Id            := 2;
  UmaClasseMinha.Empresa       := 10;
  UmaClasseMinha.Usuario       := 'Maria Josefina';
  UmaClasseMinha.DataExpiracao := Date;
  UmaClasseMinha.Salario       := 100.5;

  MostrarPropriedades(UmaClasseMinha);

  UmaClasseMinha.Free;

  ReadLn;
end.
