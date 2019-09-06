#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	:	CR0068
Autor		:	Fabiano da Silva
Data		:	02/02/2015
Descri��o	:	Cadastro de Programa��o EDI - Tabela SZ4
*/


User Function CR0068()
	Private oBrowse 	:= FwMBrowse():New()				//Variavel de Browse

	//Alias do Browse
	oBrowse:SetAlias('SZ4')

	//Descri��o da Parte Superior Esquerda do Browse
	oBrowse:SetDescripton("Cadastro de Programa��o EDI")

	//Adiciona as Legendas no MarkBrowse
	oBrowse:AddLegend('Empty(Z4_INTEGR)', 'RED'		, 'N�o Integrado'     )
	oBrowse:AddLegend('Z4_INTEGR = "Y"' , 'ORANGE'	, 'N�o Integrado, com programa��o com release inferior.'     )
	oBrowse:AddLegend('Z4_INTEGR = "S"' , 'GREEN'	, 'Integrado com sucesso'     )

	//Desabilita os Detalhes da parte inferior do Browse
	//oBrowse:DisableDetails()

	//Ativa o Browse
	oBrowse:Activate()

Return



Static Function MenuDef()

	Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.CR0068'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.CR0068'	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.CR0068'	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.CR0068'	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.CR0068'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.CR0068'	OPERATION 9 ACCESS 0

Return(aMenu)


Static Function ModelDef()

	//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local oStruct	:=	FWFormStruct(1,"SZ4")
	Local oModel

	//Instancia do Objeto de Modelo de Dados
	oModel	:=	MpFormModel():New('CR068PE',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

	//Adiciona um modelo de Formulario de Cadastro Similar � Enchoice ou Msmget
	oModel:AddFields('MODEL_CR0068', /*cOwner*/, oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona Descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Dados do Cadastro de Programa��o EDI' )

	oModel:SetPrimaryKey({})

	//Adiciona Descricao do Componente do Modelo de Dados
	oModel:GetModel( 'MODEL_CR0068' ):SetDescription( 'Formulario de  Cadastro de Programa��o EDI' )

Return(oModel)



Static Function ViewDef()

	Local oStruct	:=	FWFormStruct(2,"SZ4") 	//Retorna a Estrutura do Alias passado

	// como Parametro (1=Model,2=View)
	Local oModel	:=	FwLoadModel('CR0068')	//Retorna o Objeto do Modelo de Dados
	Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualiza��o

	//Define o Modelo sobre qual a Visualizacao sera utilizada
	oView:SetModel(oModel)

	//Vincula o Objeto visual de Cadastro com o modelo
	oView:AddField( 'VIEW_CR0068', oStruct, 'MODEL_CR0068')

	//Define o Preenchimento da Janela
	oView:CreateHorizontalBox( 'ID_100'  , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_CR0068', 'ID_100' )

	Return(oView)

Return(Nil)


