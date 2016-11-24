//Irei incluir algumas bibliotecas
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

//Iniciar a rotina
User Function MCFG0006I()
    //Declarar variáveis locais
    Local oColumn
    Local aCampos	:= {}
    Local aColumns	:= {}
    Local cArqTrb
    Local cIndice1, cIndice2, cIndice3,cIndice4 := ""
    Local nX
    Local lMarcar  	:= .F.
    Local aSeek   := {}
    Local bKeyF12	:= {||  U_MCFG006M(),oBrowse:SetInvert(.F.),oBrowse:Refresh(),oBrowse:GoTop(.T.) } //Programar a tecla F12

    //Declarar variáveis privadas
    Private oBrowse 	:= Nil
    Private cCadastro 	:= "Usuários do Sistema"
    Private aRotina	 	:= Menudef() //Se for criar menus via MenuDef
    
    //Criar a tabela temporária
    AAdd(aCampos,{"TR_OK"  	,"C",002,0}) //Este campo será usado para marcar/desmarcar
    AAdd(aCampos,{"TR_ST"  	,"C",001,0})
    AAdd(aCampos,{"TR_ID" 	,"C",006,0})
    AAdd(aCampos,{"TR_NOME" ,"C",050,0})
    AAdd(aCampos,{"TR_LOGIN","C",020,0})
    AAdd(aCampos,{"TR_CARGO","C",050,0})
    AAdd(aCampos,{"TR_DEPTO","C",050,0})
    AAdd(aCampos,{"TR_EMAIL","C",150,0})
    AAdd(aCampos,{"TR_SUPER","C",006,0})
    AAdd(aCampos,{"TR_POS"  ,"N",012,0})

    //Se o alias estiver aberto, fechar para evitar erros com alias aberto
    If (Select("TRB") &lt;&gt; 0)
        dbSelectArea("TRB")
        TRB-&gt;(dbCloseArea ())
    Endif

    //A função CriaTrab() retorna o nome de um arquivo de trabalho que ainda não existe e dependendo dos parâmetros passados, pode criar um novo arquivo de trabalho.
    cArqTrb   := CriaTrab(aCampos,.T.)
    
    //Criar indices
    cIndice1 := Alltrim(CriaTrab(,.F.))
    cIndice2 := cIndice1
    cIndice3 := cIndice1
    cIndice4 := cIndice1
    
    cIndice1 := Left(cIndice1,5) + Right(cIndice1,2) + "A"
    cIndice2 := Left(cIndice2,5) + Right(cIndice2,2) + "B"
    cIndice3 := Left(cIndice3,5) + Right(cIndice3,2) + "C"
    cIndice4 := Left(cIndice4,5) + Right(cIndice4,2) + "D"
    
    //Se indice existir excluir
    If File(cIndice1+OrdBagExt())
        FErase(cIndice1+OrdBagExt())
    EndIf
    If File(cIndice2+OrdBagExt())
        FErase(cIndice2+OrdBagExt())
    EndIf
    If File(cIndice3+OrdBagExt())
        FErase(cIndice3+OrdBagExt())
    EndIf
    If File(cIndice4+OrdBagExt())
        FErase(cIndice4+OrdBagExt())
    EndIf
    
    //A função dbUseArea abre uma tabela de dados na área de trabalho atual ou na primeira área de trabalho disponível
    dbUseArea(.T.,,cArqTrb,"TRB",Nil,.F.)

    //A função IndRegua cria um índice temporário para o alias especificado, podendo ou não ter um filtro
    IndRegua("TRB", cIndice1, "TR_NOME"	,,, "Indice Nome...")
    IndRegua("TRB", cIndice2, "TR_LOGIN",,, "Indice Login...")
    IndRegua("TRB", cIndice3, "TR_EMAIL",,, "Indice E-mail...")
    IndRegua("TRB", cIndice4, "TR_ID"	,,, "Indice ID...")
    
    //Fecha todos os índices da área de trabalho corrente.
    dbClearIndex()

    //Acrescenta uma ou mais ordens de determinado índice de ordens ativas da área de trabalho.
    dbSetIndex(cIndice1+OrdBagExt())
    dbSetIndex(cIndice2+OrdBagExt())
    dbSetIndex(cIndice3+OrdBagExt())
    dbSetIndex(cIndice4+OrdBagExt())
    
    //Popular tabela temporária, irei colocar apenas um unico registro
    If RecLock("TRB",.t.)
        TRB-&gt;TR_OK    := "  "
        TRB-&gt;TR_ST    := "S" //situação
        TRB-&gt;TR_ID 	  := "000000"
        TRB-&gt;TR_NOME  := "Administrador"
        TRB-&gt;TR_LOGIN := "Admin"
        TRB-&gt;TR_CARGO := "Administrador"
        TRB-&gt;TR_DEPTO := "Depto TI"
        TRB-&gt;TR_EMAIL := "administrador@empresa.com"
        TRB-&gt;TR_SUPER := ""
        TRB-&gt;TR_POS   := 1
        MsUnLock()
    Endif
    
    TRB-&gt;(DbGoTop())
    
    If TRB-&gt;(!Eof())
        //Irei criar a pesquisa que será apresentada na tela
        aAdd(aSeek,{"Nome"	,{{"","C",050,0,"Nome"	,"@!"}} } )
        aAdd(aSeek,{"Login"	,{{"","C",006,0,"Login"	,"@!"}} } )
        aAdd(aSeek,{"E-mail",{{"","C",100,0,"E-mail",""}} } )
        aAdd(aSeek,{"ID"	,{{"","C",006,0,"ID"	,"@!"}} } )
        
        //Agora iremos usar a classe FWMarkBrowse
        oBrowse:= FWMarkBrowse():New()
        oBrowse:SetDescription(cCadastro) //Titulo da Janela
        oBrowse:SetParam(bKeyF12) // Seta tecla F12
        oBrowse:SetAlias("TRB") //Indica o alias da tabela que será utilizada no Browse
        oBrowse:SetFieldMark("TR_OK") //Indica o campo que deverá ser atualizado com a marca no registro
        oBrowse:oBrowse:SetDBFFilter(.T.)
        oBrowse:oBrowse:SetUseFilter(.T.) //Habilita a utilização do filtro no Browse
        oBrowse:oBrowse:SetFixedBrowse(.T.)
        oBrowse:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
        oBrowse:SetAmbiente(.T.) //Habilita a utilização da funcionalidade Ambiente no Browse
        oBrowse:SetTemporary() //Indica que o Browse utiliza tabela temporária
        oBrowse:oBrowse:SetSeek(.T.,aSeek) //Habilita a utilização da pesquisa de registros no Browse
        oBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padrão do Browse
        
        //Permite adicionar legendas no Browse
        oBrowse:AddLegend("TR_ST=='N'","GREEN" 	,"Usuários Liberados")
        oBrowse:AddLegend("TR_ST=='S'","RED"   	,"Usuários Bloqueados")

        //Adiciona uma coluna no Browse em tempo de execução
        oBrowse:SetColumns(MCFG006TIT("TR_ID"	,"ID"		,03,"@!",0,010,0))
        oBrowse:SetColumns(MCFG006TIT("TR_NOME"	,"Nome"		,04,"@!",1,080,0))
        oBrowse:SetColumns(MCFG006TIT("TR_LOGIN","Login"	,05,"@!",1,040,0))
        oBrowse:SetColumns(MCFG006TIT("TR_CARGO","Cargo"	,06,"@!",1,050,0))
        oBrowse:SetColumns(MCFG006TIT("TR_DEPTO","Depto"	,07,"@!",1,100,0))
        oBrowse:SetColumns(MCFG006TIT("TR_EMAIL","E-mail"	,08,"",1,100,0))
        oBrowse:SetColumns(MCFG006TIT("TR_SUPER","Superior"	,09,"@!",1,020,0))
        oBrowse:SetColumns(MCFG006TIT("TR_POS"	,"RECNO"	,11,"@E9999999",2,20,0))
        
        //Adiciona botoes na janela
        oBrowse:AddButton("Enviar Mensagem"	, { || U_MCFG006M()},,,, .F., 2 )
        oBrowse:AddButton("Detalhes"		, { || MsgRun('Coletando dados de usuário(s)','Relatório',{|| U_RCFG0005() }) },,,, .F., 2 )
        oBrowse:AddButton("Legenda"			, { || MCFG006LEG()},,,, .F., 2 )
        
        //Indica o Code-Block executado no clique do header da coluna de marca/desmarca
        oBrowse:bAllMark := { || MCFG6Invert(oBrowse:Mark(),lMarcar := !lMarcar ), oBrowse:Refresh(.T.)  }

        //Método de ativação da classe
        oBrowse:Activate()
        
        oBrowse:oBrowse:Setfocus() //Seta o foco na grade
    Else
        Return
    EndIf
    
    //Limpar o arquivo temporário
    If !Empty(cArqTrb)
        Ferase(cArqTrb+GetDBExtension())
        Ferase(cArqTrb+OrdBagExt())
        cArqTrb := ""
        TRB-&gt;(DbCloseArea())
    Endif

Return(.T.)

//Função para marcar/desmarcar todos os registros do grid
Static Function MCFG6Invert(cMarca,lMarcar)
    Local cAliasSD1 := 'TRB'
    Local aAreaSD1  := (cAliasSD1)-&gt;( GetArea() )

    dbSelectArea(cAliasSD1)
    (cAliasSD1)-&gt;( dbGoTop() )
    While !(cAliasSD1)-&gt;( Eof() )
        RecLock( (cAliasSD1), .F. )
        (cAliasSD1)-&gt;TR_OK := IIf( lMarcar, cMarca, '  ' )
        MsUnlock()
        (cAliasSD1)-&gt;( dbSkip() )
    EndDo

    RestArea( aAreaSD1 )
Return .T.

//Caso crie os botões por função, abaixo seque um exemplo
Static Function MenuDef()
    Local aRot := {}
    
    ADD OPTION aRot TITLE "Enviar Mensagem" ACTION "U_MCFG006M()"  OPERATION 6 ACCESS 0
    ADD OPTION aRot TITLE "Detalhes"     	ACTION "MsgRun('Coletando dados de usuário(s)','Relatório',{|| U_RCFG0005() })"  OPERATION 6 ACCESS 0
    //ADD OPTION aRot TITLE "Legenda"     	ACTION ""  OPERATION 6 ACCESS 0

Return(Aclone(aRot))

//Função para criar as colunas do grid
Static Function MCFG006TIT(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
    Local aColumn
    Local bData 	:= {||}
    Default nAlign 	:= 1
    Default nSize 	:= 20
    Default nDecimal:= 0
    Default nArrData:= 0
    
    
    
    If nArrData &gt; 0
        bData := &amp;("{||" + cCampo +"}") //&amp;("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
    EndIf
    
    /* Array da coluna
    [n][01] Título da coluna
    [n][02] Code-Block de carga dos dados
    [n][03] Tipo de dados
    [n][04] Máscara
    [n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
    [n][06] Tamanho
    [n][07] Decimal
    [n][08] Indica se permite a edição
    [n][09] Code-Block de validação da coluna após a edição
    [n][10] Indica se exibe imagem
    [n][11] Code-Block de execução do duplo clique
    [n][12] Variável a ser utilizada na edição (ReadVar)
    [n][13] Code-Block de execução do clique no header
    [n][14] Indica se a coluna está deletada
    [n][15] Indica se a coluna será exibida nos detalhes do Browse
    [n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
    */
    aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}

//Função para criar a tela de legenda
Static Function MCFG006LEG()
    Local oLegenda  :=  FWLegend():New()

    oLegenda:Add( '', 'BR_VERDE'   , "Usuários Liberados" )
    oLegenda:Add( '', 'BR_VERMELHO', "Usuários Bloqueados")
    
    oLegenda:Activate()
    oLegenda:View()
    oLegenda:DeActivate()
Return Nil

//Na sua função, você poderia fazer assim:

    TRB-&gt;( DbSetOrder(1) )
    TRB-&gt;( DbGoTop() )
    nCont:=0
    While !TRB-&gt;(Eof())
        If !Empty(TRB-&gt;TR_OK) //Se diferente de vazio, é porque foi marcado
            cPara += Alltrim(TRB-&gt;TR_EMAIL)+";"
            nCont++
        Endif
        TRB-&gt;( dbSkip() )
    EndDo
   	
    if nCont == 0
        Alert("Selecione pelo menos um usuario!")
        return
    Endif