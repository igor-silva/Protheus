#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

#Define Verde "#9AFF9A"
#Define Amarelo_Ouro "#FFD700"
#Define Amarelo "#FFFF00"
#Define Vermelho "#FF0000"
#Define Salmao "#FF8C69"
#Define Branco "#FFFAFA"
#Define Azul "#87CEEB"
#Define Preto "#000000"
#Define Cinza "#696969"
#Define Verde_Escuro "#006400"
#Define Azul_Escuro "#191970"
#Define Vermelho_Escuro "#8B0000"
#Define Amarelo_Escuro "#8B6914"
#Define Chocolate "#FF7F24"
#Define Roxo "#912CEE"
#Define Roxo_Escuro "#551A8B"

/*/{Protheus.doc} BRI115
//Reajuste de Tabela de Pre�o
@author Fabiano
@since 26/10/2018
@version 1.0
/*/
User Function BRI115()

    Private _oDlg
    Private _oFont1

    Private _cFilDe := cFilAnt
    Private _cFilAt := cFilAnt

    Private _cUFDe := Space(TAMSX3("A1_EST")[1])
    Private _cUFAt := Replicate('Z',TAMSX3("A1_EST")[1])

    Private _cCliDe := Space(TAMSX3("A1_COD")[1])
    Private _cCliAt := Replicate('Z',TAMSX3("A1_COD")[1])

    Private _cLojDe := Space(TAMSX3("A1_LOJA")[1])
    Private _cLojAt := Replicate('Z',TAMSX3("A1_LOJA")[1])

    Private _cProDe := Space(TAMSX3("B1_COD")[1])
    Private _cProAt := Replicate('Z',TAMSX3("B1_COD")[1])

    Private _oPreco	:= Nil
    Private _nValor	:= 0

    Private _oBrowse:= Nil
    Private _aBrowse:= {{.F.,'','','','','','',0,0,0,0}}

    Private _oOK	:= LoadBitmap(GetResources(),'LBOK')
    Private _oNO	:= LoadBitmap(GetResources(),'LBNO')

    Private _aReaj	:= {"Valor","Percentual","Alinhamento"}
    Private _aTipo	:= {"Acr�scimo","Decr�scimo"}

    Private _oRad1	:= Nil
    Private _oRad2	:= Nil

    Private _nReaj	:= 1
    Private _nTipo	:= 1

    Private _oTFont1		:= TFont():New('Courier new',,-14,,.T.,,,,,.T.)
    Private _oTFont2		:= TFont():New('Calibri',,-14,,.T.,,,,,.F.)

    _oSize := FwDefSize():New( .F. )							// Com enchoicebar
    _oSize:AddObject( "P1", 100, 13, .T., .t. )
    _oSize:AddObject( "P2", 100, 15, .T., .t. )
    _oSize:AddObject( "P3", 100, 64, .T., .T. )
    _oSize:AddObject( "P4", 100, 08, .T., .T. )
    _oSize:lProp 	:= .T.
    _oSize:lLateral := .F.  									// Calculo vertical
    _oSize:Process()

    DEFINE MSDIALOG _oDlg TITLE OemToAnsi("Reajuste Tabela de Pre�o") FROM _oSize:aWindSize[1],_oSize:aWindSize[2] TO ;
        _oSize:aWindSize[3],_oSize:aWindSize[4] OF _oDlg PIXEL  Style DS_MODALFRAME

    _oDlg:lEscClose := .F. //N�o permite fechar a janela pelo bot�o "ESC"

    DEFINE FONT _oFont1 NAME "Arial" BOLD SIZE 0,16 OF _oDlg

    Panel01()

    Panel02()

    Panel03()

    Panel04()

    ACTIVATE MSDIALOG _oDlg CENTERED

Return(Nil)



Static Function Panel01()

    Local _oGroup1	:= TGroup():New(_oSize:GetDimension( "P1","LININI"),_oSize:GetDimension( "P1", "COLINI"),;
        _oSize:GetDimension( "P1", "LINEND"),_oSize:GetDimension( "P1", "COLEND" ),"Par�metros",_oDlg,CLR_GREEN,,.T.)

    Local _nLiI1	:= _oSize:GetDimension( "P1", "LININI" )+3
    Local _nCol		:= 8
    Local _oCor		:= CLR_CYAN

    _nTmCol	:= 20

    _oSay3	:= TSay():New(_nLiI1+005,_nCol,{||' Filial de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay3:lTransparent := .F.
    @ _nLiI1+005, _nCol+52  MsGet _cFilDe	Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

    _oSay4:= TSay():New(_nLiI1+020,_nCol,{||' Filial At� ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay4:lTransparent := .F.
    @ _nLiI1+020, _nCol+52  MsGet _cFilAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

    //	_nCol += 115
    _nCol	+= (50 + _nTmCol  + 15)
    _nTmCol	:= 20

    _oSay3:= TSay():New(_nLiI1+005,_nCol,{||' UF de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay3:lTransparent := .F.
    @ _nLiI1+005, _nCol+52  MsGet _cUFDe	Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

    _oSay4:= TSay():New(_nLiI1+020,_nCol,{||' UF At� ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay4:lTransparent := .F.
    @ _nLiI1+020, _nCol+52  MsGet _cUFAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

    _nCol	+= (50 + _nTmCol  + 15)
    _nTmCol	:= 40

    _oSay3:= TSay():New(_nLiI1+005,_nCol,{||' Cliente de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay3:lTransparent := .F.
    @ _nLiI1+005, _nCol+52  MsGet _cCliDe	Picture '@!' F3 'SA1' Size _nTmCol,08 Pixel Of _oDlg

    _oSay4:= TSay():New(_nLiI1+020,_nCol,{||' Cliente At� ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay4:lTransparent := .F.
    @ _nLiI1+020, _nCol+52  MsGet _cCliAt	Picture '@!' F3 'SA1' Size _nTmCol,08 Pixel Of _oDlg

    _nCol	+= (50 + _nTmCol  + 15)
    _nTmCol	:= 20

    _oSay3:= TSay():New(_nLiI1+005,_nCol,{||' Loja de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay3:lTransparent := .F.
    @ _nLiI1+005, _nCol+52  MsGet _cLojDe	Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

    _oSay4:= TSay():New(_nLiI1+020,_nCol,{||' Loja At� ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay4:lTransparent := .F.
    @ _nLiI1+020, _nCol+52  MsGet _cLojAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

    _nCol	+= (50 + _nTmCol  + 15)
    _nTmCol	:= 70

    _oSay3:= TSay():New(_nLiI1+005,_nCol,{||' Produto de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay3:lTransparent := .F.
    @ _nLiI1+005, _nCol+52  MsGet _cProDe	Picture '@!' F3 'SB1' Size _nTmCol,08 Pixel Of _oDlg

    _oSay4:= TSay():New(_nLiI1+020,_nCol,{||' Produto At� ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
    _oSay4:lTransparent := .F.
    @ _nLiI1+020, _nCol+52  MsGet _cProAt	Picture '@!' F3 'SB1' Size _nTmCol,08 Pixel Of _oDlg

    _nCol	+= (50 + _nTmCol  + 15)

    _oTBut1	:= TButton():New( _nLiI1+005, _nCol, "Consultar" ,_oDlg,{||LjMsgRun("Consultando Tabelas de Pre�o, aguarde...","Tabela de Pre�o",{||Consulta()})}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut1 :cTooltip = "Consultar"
    _oTBut1:SetCss(+;
        "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Verde+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Verde_Escuro+" }"+;
        "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Verde+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Verde_Escuro+"}")

Return(Nil)



Static Function Panel02()

    Local _oGroup2 := TGroup():New(_oSize:GetDimension( "P2","LININI"),_oSize:GetDimension( "P2", "COLINI"),;
        _oSize:GetDimension( "P2", "LINEND"),_oSize:GetDimension( "P2", "COLEND" ),"Dados para Reajuste",_oDlg,CLR_BLUE,,.T.)

    Local _nLiI1	:= _oSize:GetDimension( "P2", "LININI" )+5
    Local _nCol		:= 8
    Local _oCor		:= CLR_BLUE
    Local _nTmCol	:= 40

    _oRad1		:= TRadMenu():New(_nLiI1+005,_nCol,_aReaj,{|u| If(PCount() > 0, _nReaj := u, _nReaj) },_oDlg,,{|| ChangeRadio()},,,;
        "Tipo de Reajuste",,,60,10,,,,.T.)

    _nCol += 65

    _oRad2		:= TRadMenu():New(_nLiI1+010,_nCol,_aTipo,{|u| If(PCount() > 0, _nTipo := u, _nTipo) },_oDlg,,{||},,,;
        "Tipo de Reajuste",,,60,10,,,,.T.)

    _nCol += 65

    _oSay3	:= TSay():New(_nLiI1+015,_nCol,{||' Reajuste ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,40,10,,,,,.T.)
    _oSay3:lTransparent := .F.

    _nCol += 42

    _oPreco	:= TGet():New(_nLiI1+015,_nCol,{|u| If(PCount() > 0, _nValor := u, _nValor) },_oDlg,_nTmCol,08,'@<E 99,999.99',;
        ,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cValtoChar(_nValor),,,,)

    _nCol	+= ( _nTmCol  + 40)

    _oTBut1	:= TButton():New( _nLiI1+007, _nCol, "Calcular" ,_oDlg,{||LjMsgRun("Calculando Reajuste, aguarde...","Tabela de Pre�o",{||Calcular()})}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut1 :cTooltip = "Calcular"
    _oTBut1:SetCss(+;
        "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Azul+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Azul_Escuro+"}"+;
        "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Azul+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Azul_Escuro+"}")

Return(Nil)



Static Function Panel03()

    _oGroup3 := TGroup():New(_oSize:GetDimension( "P3","LININI"),_oSize:GetDimension( "P3", "COLINI"),;
        _oSize:GetDimension( "P3", "LINEND"),_oSize:GetDimension( "P3", "COLEND" ),"Tabelas de Pre�o",_oDlg,CLR_RED,,.T.)

    _nLiI3 := _oSize:GetDimension( "P3", "LININI" )
    _nCoI3 := _oSize:GetDimension( "P3", "COLINI" )
    _nLiF3 := _oSize:GetDimension( "P3", "LINEND" )
    _nCoF3 := _oSize:GetDimension( "P3", "COLEND" )
    _nYSi3 := _oSize:GetDimension( "P3", "YSIZE" )

    _aCampos := {'','Filial','Cliente','Loja','Nome','UF','Produto','Pre�o Atual','Pre�o Calculado','Diferen�a'}

    _oBrowse := TwBrowse():New( _nLiI3+10, _nCoI3+5,_nCoF3-13,_nYSi3-13,,_aCampos,,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

    _oBrowse:SetArray(_aBrowse)

    AtuGrid()

    // Troca a imagem no duplo click do mouse
    _oBrowse:bLDblClick := {|| If(!Empty(_aBrowse[_oBrowse:nAt][2]),;
        If(_aBrowse[_oBrowse:nAt][1],;
            If(_oBrowse:ColPos==9,lEditCell( _aBrowse, _oBrowse, '@<E 999,999.99', _oBrowse:ColPos ) .And. VldCpo(),;
                _aBrowse[_oBrowse:nAt][1] := !_aBrowse[_oBrowse:nAt][1]),;
                _aBrowse[_oBrowse:nAt][1] := !_aBrowse[_oBrowse:nAt][1]),Nil),;
                _oBrowse:Refresh()}

            _oBrowse:bHeaderClick := {|o, _nCol| If(_nCol = 1,MarkAll(_aBrowse,_oBrowse),Nil) }

            _oBrowse:nAt := 1
            _oBrowse:Refresh()

            Return(Nil)



Static Function Panel04()

    Local _oGroup2 := TGroup():New(_oSize:GetDimension( "P4","LININI"),_oSize:GetDimension( "P4", "COLINI"),;
        _oSize:GetDimension( "P4", "LINEND"),_oSize:GetDimension( "P4", "COLEND" ),"A��es",_oDlg,CLR_MAGENTA,CLR_YELLOW,.T.)

    Local _nLiI4 		:= _oSize:GetDimension( "P4", "LININI" )+6
    Local _nColI		:= _oSize:GetDimension( "P4", "COLINI")
    Local _nColF		:= _oSize:GetDimension( "P4", "COLEND")
    Local _nTmBut		:= 60
    Local _oTBut1		:= Nil
    Local _oTBut2		:= Nil
    Local _oTBut3		:= Nil
    Local _nCol1		:= _nColI+100
    Local _nFiC1		:= _nCol1+_nTmBut
    Local _nCol3		:= _nColF-100-_nTmBut
    Local _nCol2		:= _nFiC1 + ((_nCol3 - _nFiC1)/2) - (_nTmBut /2)
    Local _cStyle		:= ''

    _oTBut1	:= TButton():New( _nLiI4, _nColI+100, "Reajustar" ,_oDlg,{||LjMsgRun("Processando Reajuste, aguarde...","Tabela de Pre�o",{||Reajustar()})},;
        _nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut1 :cTooltip = "Reajustar"
    _cStyle := GetStyle(Branco,Amarelo_Ouro,Amarelo_Escuro,Preto)
    _oTBut1:SetCss(_cStyle)

    //	_oTBut2	:= TButton():New( _nLiI4, _nCol2, "Desfazer" ,_oDlg,{||LjMsgRun("Processando Reajuste, aguarde...","Tabela de Pre�o",{||Desfazer()})},;
        _oTBut2	:= TButton():New( _nLiI4, _nCol2, "Desfazer" ,_oDlg,{||Desfazer()},;
        _nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut2 :cTooltip = "Desfazer Reajuste das tabelas Bloqueadas"
    _cStyle := GetStyle(Preto,Branco,Cinza,Amarelo)
    _oTBut2:SetCss(_cStyle)

    _oTBut3	:= TButton():New( _nLiI4, _nCol3, "Cancelar/Sair" ,_oDlg,{||_oDlg:End()},;
        _nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut3 :cTooltip = "Cancelar"
    _cStyle := GetStyle(Branco,Salmao,Vermelho_Escuro,Preto)
    _oTBut3:SetCss(_cStyle)

Return(Nil)



Static Function GetStyle(_cCor1,_cCor2,_cCor3,_cCor4)

    Local _cMod := ''

    _cMod := "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor1+", stop: 1 "+_cCor2+");"
    _cMod += "border-style: outset;border-width: 2px;
        _cMod += "border-radius: 10px;border-color: "+_cCor3+";"
    _cMod += "color: "+_cCor4+"};"
    _cMod += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor2+", stop: 1 "+_cCor1+");"
    _cMod += "border-style: outset;border-width: 2px;"
    _cMod += "border-radius: 10px;"
    _cMod += "border-color: "+_cCor3+" }"

Return(_cMod)



Static Function Consulta()

    Local _cQuery := ""

    If Select("TRB") > 0
        TRB->(dbCloseArea())
    Endif

    _cQuery := " SELECT SZ2.R_E_C_N_O_ AS Z2RECNO,* FROM "+RetSqlName("SZ2")+" SZ2 " + CRLF
    _cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = Z2_CLIENTE AND A1_LOJA = Z2_LOJA " + CRLF
    _cQuery += " WHERE SZ2.D_E_L_E_T_ = '' " + CRLF
    _cQuery += " AND Z2_FILIAL	BETWEEN '"+_cFilDe+"' AND '"+_cFilAt+"' " + CRLF
    _cQuery += " AND Z2_CLIENTE	BETWEEN '"+_cCliDe+"' AND '"+_cCliAt+"' " + CRLF
    _cQuery += " AND Z2_LOJA	BETWEEN '"+_cLojDe+"' AND '"+_cLojAt+"' " + CRLF
    _cQuery += " AND A1_EST		BETWEEN '"+_cUFDe+"'  AND '"+_cUFAt+"' " + CRLF
    _cQuery += " AND Z2_PRODUTO	BETWEEN '"+_cProDe+"' AND '"+_cProAt+"' " + CRLF
    _cQuery += " AND Z2_PRECO > 0 " + CRLF
    _cQuery += " AND Z2_LIBERAD = 'L' " + CRLF
    _cQuery += " ORDER BY Z2_FILIAL, Z2_CLIENTE,Z2_LOJA,Z2_PRODUTO "	+ CRLF

    TcQuery _cQuery New Alias "TRB"

    Count to _nTRB

    If _nTRB = 0
        MsgAlert("N�o foi encontrado Tabela de Pre�o com os par�metros informados!")
        TRB->(dbCloseArea())
        Return(Nil)
    Endif

    TRB->(dbGoTop())

    _aBrowse := {}

    While TRB->(!EOF())

        AADD(_aBrowse,{;
            .F.				,; //01
        TRB->Z2_FILIAL	,; //02
        TRB->Z2_CLIENTE	,; //03
        TRB->Z2_LOJA	,; //04
        TRB->Z2_NOME	,; //05
        TRB->A1_EST		,; //06
        TRB->Z2_PRODUTO	,; //07
        TRB->Z2_PRECO	,; //08
        0	,; //09
        0	,; //10
        TRB->Z2RECNO	}) //11

        TRB->(dbSkip())
    EndDo

    TRB->(dbCloseArea())

    _oBrowse:SetArray(_aBrowse)

    _oBrowse:bLine := {||{If(_aBrowse[_oBrowse:nAt,1],_oOk,_oNo ),; //1 - Marcador
    _aBrowse[_oBrowse:nAt,2],;
        _aBrowse[_oBrowse:nAt,3],;
        _aBrowse[_oBrowse:nAt,4],;
        _aBrowse[_oBrowse:nAt,5],;
        _aBrowse[_oBrowse:nAt,6],;
        _aBrowse[_oBrowse:nAt,7],;
        Transform(_aBrowse[_oBrowse:nAt,8],"@E 9,999,999.99"),;
        Transform(_aBrowse[_oBrowse:nAt,9],"@E 9,999,999.99"),;
        Transform(_aBrowse[_oBrowse:nAt,10],"@E 9,999,999.99")}}

    _oBrowse:nAt := 1
    _oBrowse:Refresh()

    _oDlg:Refresh()

Return(Nil)



//Marca��o de todos os Cheques
Static Function MarkAll(_aList,_oList)

    Local _nInd		:= 1 	// Conteudo de retorno
    Local _lMark	:= !_aList[_oList:nAt][1]

    For _nInd := 1 To Len(_aList)
        _aList[_nInd][1] := _lMark
    Next

    _oBrowse:Refresh()
    _oDlg:Refresh()

Return(Nil)



Static Function Calcular()

    Local _nInd		:= 1
    Local _lOK		:= .F.

    If _nValor > 0
        For _nInd := 1 To Len(_aBrowse)
            If _aBrowse[_nInd][1]

                If _nReaj == 1
                    If _nTipo == 1
                        _aBrowse[_nInd][9] := _aBrowse[_nInd][8] + _nValor
                    Else
                        _aBrowse[_nInd][9] := _aBrowse[_nInd][8] - _nValor
                    Endif
                ElseIf _nReaj == 2
                    If _nTipo == 1
                        _aBrowse[_nInd][9] := _aBrowse[_nInd][8] + (_aBrowse[_nInd][8] * (_nValor / 100))
                    Else
                        _aBrowse[_nInd][9] := _aBrowse[_nInd][8] - (_aBrowse[_nInd][8] * (_nValor / 100))
                    Endif
                ElseIf _nReaj == 3
                    _aBrowse[_nInd][9] := _nValor
                Endif

                _aBrowse[_nInd][10]:= _aBrowse[_nInd][9] - _aBrowse[_nInd][8]
                _lOK := .T.
            Endif
        Next
    Else
        ShowHelpDlg('BRI115_1',{'Preencha o campo "Valor" para realizar o c�lculo'},1,{'N�o se aplica.'},2)
        _lOK := .T.
    Endif

    If !_lOK
        ShowHelpDlg('BRI115_2',{'Nenhum registro marcado.'},1,{'N�o se aplica.'},2)
    Endif

    _oBrowse:Refresh()
    _oDlg:Refresh()

Return(Nil)



Static Function Reajustar()

    Local _nInd		:= 1
    Local _cProcLib	:= ''
    Local _cCodBlq	:= '03' // Tabela de Pre�o
    Local _cFil		:= ''
    Local _cCli		:= ''
    Local _cLoja	:= ''
    Local _cNome	:= ''
    Local _cProd	:= ''
    Local _nPrcAt	:= 0
    Local _nPCalc	:= 0
    Local _nDif		:= 0
    Local _cChavSCR	:= ''
    Local _lProc	:= .F.
    Local _nZ2Recno := 0

    Begin Transaction
        For _nInd := 1 To Len(_aBrowse)
            If _aBrowse[_nInd][1]

                _cProcLib	:= GetSxeNum('ZF1','ZF1_PROCES')
                _cFil		:= Alltrim(_aBrowse[_nInd][2])
                _cCli		:= Alltrim(_aBrowse[_nInd][3])
                _cLoja		:= Alltrim(_aBrowse[_nInd][4])
                _cProd		:= Alltrim(_aBrowse[_nInd][7])
                _nPrcAt		:= _aBrowse[_nInd][8]
                _nPCalc		:= _aBrowse[_nInd][9]
                _nDif		:= _aBrowse[_nInd][10]
                _cNome		:= Alltrim(_aBrowse[_nInd][5])
                _nZ2Recno	:= _aBrowse[_nInd][11]

                If _nDif < 0

                    SCR->(dbSetOrder(1))
                    If SCR->(dbSeek(xFilial("SCR")+ _cCodBlq + _cFil + _cCli + _cLoja + _cProd))

                        _cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

                        ZAH->(dbSetOrder(1))
                        If ZAH->(dbSeek(SCR->CR_FILIAL + _cChavSCR  ))

                            _cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+SCR->CR_FILIAL+"' AND ZAH_NUM = '"+SCR->CR_NUM+"' AND ZAH_TIPO = '"+SCR->CR_TIPO+"' "
                            TcSqlExec(_cCq)
                        Endif

                        While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

                            SCR->(RecLock("SCR",.F.))
                            SCR->(dbDelete())
                            SCR->(MsUnlock())

                            SCR->(dbSkip())
                        EndDo
                    Endif

                    _cGrAprov:= SuperGetMV("ASC_GRPRPV",.F.,'')

                    SAL->(dbSetOrder(2))
                    If SAL->(!dbSeek(xFilial() + _cGrAprov))
                        MSGSTOP("Grupo Nao Cadastrado, Favor Contatar o Administrador do Sistema!")
                        Return
                    EndIf

                    lFirstNiv   := .T.
                    cAuxNivel   := ""
                    _lLibera    := .T.

                    SAL->(dbSetOrder(2))
                    If SAL->(dbSeek(xFilial() + _cGrAprov))

                        While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

                            If lFirstNiv
                                cAuxNivel := SAL->AL_NIVEL
                                lFirstNiv := .F.
                            EndIf

                            SCR->(Reclock("SCR",.T.))
                            SCR->CR_FILIAL	:= xFilial("SCR")
                            //						SCR->CR_NUM		:= _cFil + _cCli + _cLoja + _cProd
                            SCR->CR_NUM		:= _cFil + _cCli + _cLoja + _cProcLib + Alltrim(_cProd)
                            SCR->CR_TIPO	:= _cCodBlq
                            SCR->CR_NIVEL	:= SAL->AL_NIVEL
                            SCR->CR_USER	:= SAL->AL_USER
                            SCR->CR_APROV	:= SAL->AL_APROV
                            SCR->CR_STATUS	:= "02"
                            SCR->CR_EMISSAO := dDataBase
                            SCR->CR_MOEDA	:= 1
                            SCR->CR_TXMOEDA := 1
                            SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - TABELA DE PRE�O"
                            SCR->CR_TOTAL	:= _nPCalc
                            //						SCR->CR_YCLIENT	:= _cCli
                            //						SCR->CR_YLOJA	:= _cLoja
                            SCR->(MsUnlock())

                            ZAH->(RecLock("ZAH",.T.))
                            ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
                            ZAH->ZAH_NUM   := SCR->CR_NUM
                            ZAH->ZAH_TIPO  := SCR->CR_TIPO
                            ZAH->ZAH_NIVEL := SCR->CR_NIVEL
                            ZAH->ZAH_USER  := SCR->CR_USER
                            ZAH->ZAH_APROV := SCR->CR_APROV
                            ZAH->ZAH_STATUS:= SCR->CR_STATUS
                            ZAH->ZAH_TOTAL := SCR->CR_TOTAL
                            ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
                            ZAH->ZAH_MOEDA := SCR->CR_MOEDA
                            ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
                            ZAH->ZAH_OBS   := SCR->CR_OBS
                            ZAH->ZAH_TOTAL := SCR->CR_TOTAL
                            ZAH->(MsUnlock())

                            SAL->(dbSkip())
                        EndDo
                    EndIf

                    ShowHelpDlg("BRI115_3", {'Tabela de Pre�o Bloqueada, pois o valor calculado � menor que o valor em vig�ncia.',;
                        'Filial+Cliente+Loja: '+_cFil+"-"+_cCli +"-"+_cLoja,;
                        'Produto: '+_cProd,;
                        'Pre�o Calculado: '+Alltrim(Transform(_nPCalc,"@e 999,999.99")),;
                        'Pre�o Vigente: '+Alltrim(Transform(_nPrcAt,"@e 999,999.99"))},5,;
                        {'Solicite a libera��o junto ao setor respons�vel.'},1)

                EndIf

                ZF1->(RecLock("ZF1",.T.))
                ZF1->ZF1_FILIAL	:= _cFil
                ZF1->ZF1_CLIENT	:= _cCli
                ZF1->ZF1_LOJA	:= _cLoja
                ZF1->ZF1_NOME	:= _cNome
                ZF1->ZF1_PRODUT	:= _cProd
                ZF1->ZF1_PROCES	:= _cProcLib
                ZF1->ZF1_DTEMIS	:= dDataBase
                ZF1->ZF1_PRCANT	:= _nPrcAt
                ZF1->ZF1_PRCATU	:= _nPCalc
                ZF1->ZF1_STATUS	:= If(_nDif < 0,"P","L")
                ZF1->ZF1_USUARI	:= UsrRetName(RetCodUsr())
                ZF1->(MsUnLock())

                ConfirmSX8()

                SZ2->(dbgoto(_nZ2Recno))

                SZ2->(RecLock("SZ2",.F.))
                If _nDif < 0
                    SZ2->Z2_PRCBLQ := _nPCalc
                Else
                    SZ2->Z2_PRECO  := _nPCalc
                    SZ2->Z2_PRCBLQ := _nPCalc
                Endif
                SZ2->Z2_PROCES := _cProcLib
                SZ2->(MsUnlock())

                _lProc := .T.

            Endif
        Next
    End Transaction

    _aBrowse:= {{.F.,'','','','','','',0,0,0}}

    _oBrowse:SetArray(_aBrowse)

    AtuGrid()

    If _lProc
        MsgInfo("Reajuste realizado com sucesso!")
    Else
        MsgAlert("N�o foi encontrado itens para Reajustar.")
    Endif

Return(Nil)



Static Function AtuGrid()

    _oBrowse:bLine := {||{If(_aBrowse[_oBrowse:nAt,1],_oOk,_oNo ),; //1 - Marcador
    _aBrowse[_oBrowse:nAt,2],;
        _aBrowse[_oBrowse:nAt,3],;
        _aBrowse[_oBrowse:nAt,4],;
        _aBrowse[_oBrowse:nAt,5],;
        _aBrowse[_oBrowse:nAt,6],;
        _aBrowse[_oBrowse:nAt,7],;
        Transform(_aBrowse[_oBrowse:nAt,8],"@E 9,999,999.99"),;
        Transform(_aBrowse[_oBrowse:nAt,9],"@E 9,999,999.99"),;
        Transform(_aBrowse[_oBrowse:nAt,10],"@E 9,999,999.99")}}

    _oBrowse:Refresh()
    _oDlg:Refresh()

Return(Nil)




Static Function ChangeRadio()

    Local _cMasc   := ""

    If _nReaj == 1
        _cMasc := '@<E 999,999.99'
        _oRad2:Enable()
    ElseIf _nReaj == 2
        _cMasc := '@<E 999.99%'
        _oRad2:Enable()
    ElseIf _nreaj == 3
        _cMasc := '@<E 999,999.99'
        _oRad2:Disable()
    Endif

    _oPreco:oGet:Picture	:= _cMasc
    _nValor := 1
    _oPreco:CtrlRefresh()
    _nValor := 0
    _oPreco:CtrlRefresh()

    _oDlg:Refresh()

Return(Nil)



Static Function VldCpo()

    _aBrowse[_oBrowse:nAt][10]:= _aBrowse[_oBrowse:nAt][9] - _aBrowse[_oBrowse:nAt][8]

    _oBrowse:Refresh()

Return(Nil)




Static Function Desfazer()

    Local _oDlg1	:= Nil
    Local _cQry		:= ''
    Local _oFont2	:= Nil
    Local _oTBut5	:= Nil

    If Select("TSB") > 0
        TSB->(dbCloseArea())
    Endif

    _cQry := " SELECT ZF1.R_E_C_N_O_ AS ZF1RECNO,* FROM "+RetSqlName("ZF1")+" ZF1 " + CRLF
    _cQry += " WHERE ZF1.D_E_L_E_T_ = '' " + CRLF
    _cQry += " AND ZF1_STATUS = 'P' " + CRLF
    //	_cQry += " AND ZF1_USUARI = '"+Alltrim(UsrRetName(RetCodUsr()))+"' " + CRLF
    _cQry += " ORDER BY ZF1_FILIAL, ZF1_CLIENT,ZF1_LOJA,ZF1_PRODUT,ZF1_DTEMIS "	+ CRLF

    TcQuery _cQry New Alias "TSB"

    Count to _nTSB

    If _nTSB = 0
        MsgAlert("N�o foi encontrado Tabela de Pre�o Bloqueada para desfazer o reajuste!")
        TSB->(dbCloseArea())
        Return(Nil)
    Endif

    TcSetField("TSB","ZF1_DTEMIS","D")

    TSB->(dbGoTop())

    _aBlq := {}

    While TSB->(!EOF())

        AADD(_aBlq,{;
            .F.				,; //01
        TSB->ZF1_FILIAL	,; //02
        TSB->ZF1_CLIENT	,; //03
        TSB->ZF1_LOJA	,; //04
        TSB->ZF1_NOME	,; //05
        TSB->ZF1_PRODUT	,; //06
        TSB->ZF1_DTEMIS	,; //07
        TSB->ZF1_PRCANT	,; //08
        TSB->ZF1_PRCATU	,; //09
        TSB->ZF1_PRCATU - TSB->ZF1_PRCANT ,; //10
        TSB->ZF1_USUARI	,; //11
        TSB->ZF1RECNO	,; //12
        TSB->ZF1_PROCES	}) //13

        TSB->(dbSkip())
    EndDo

    TSB->(dbCloseArea())

    DEFINE MSDIALOG _oDlg1 TITLE OemToAnsi("Desfazer Reajuste") FROM 0,0 TO 300,1000 OF _oDlg1 PIXEL

    DEFINE FONT _oFont2 NAME "Arial" BOLD SIZE 0,16 OF _oDlg

    _oSay1	:= TSay():New(05,05,{||'Selecione abaixo os itens que deseja excluir o Reajuste.'},_oDlg1,,_oTFont2,,,,.T.,CLR_HRED,CLR_WHITE,400,10,,,,,.T.)
    _oSay1:lTransparent := .F.

    _oTBut5	:= TButton():New( 05, 400, "Processar" ,_oDlg1,{||LjMsgRun("Processando, aguarde...","Tabela de Pre�o",{||Processar(_aBlq)} ,_oDlg1:End() )},;
        60,12,,_oTFont2,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut5 :cTooltip = "Processar"
    _cStyle := GetStyle(Branco,Roxo,Roxo_Escuro,Preto)

    _oTBut5:SetCss(_cStyle)


    _aFields := {'','Filial','Cliente','Loja','Nome','Produto','Emiss�o','Pre�o Atual','Pre�o Calculado','Diferen�a','Usu�rio','Processo'}

    _oBlq := TwBrowse():New( 20, 05,490,125,,_aFields,,_oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

    _oBlq:SetArray(_aBlq)

    _oBlq:bLine := {||{If(_aBlq[_oBlq:nAt,1],_oOk,_oNo ),; //1 - Marcador
    _aBlq[_oBlq:nAt,2],;
        _aBlq[_oBlq:nAt,3],;
        _aBlq[_oBlq:nAt,4],;
        _aBlq[_oBlq:nAt,5],;
        _aBlq[_oBlq:nAt,6],;
        _aBlq[_oBlq:nAt,7],;
        Transform(_aBlq[_oBlq:nAt,8],"@E 9,999,999.99"),;
        Transform(_aBlq[_oBlq:nAt,9],"@E 9,999,999.99"),;
        Transform(_aBlq[_oBlq:nAt,10],"@E 9,999,999.99"),;
        _aBlq[_oBlq:nAt,11],;
        _aBlq[_oBlq:nAt,13]}}

    _oBlq:bLDblClick := {|| _aBlq[_oBlq:nAt][1] := !_aBlq[_oBlq:nAt][1]}

    _oBlq:nAt := 1
    _oBlq:Refresh()

    ACTIVATE MSDIALOG _oDlg1 CENTERED

Return(Nil)



Static Function Processar(_aBlq)

    Local _nFor  := 1
    Local _cType := "03"
    Local _cUpd  := ''

    BEGIN TRANSACTION

        For _nFor := 1 To Len(_aBlq)
            If _aBlq[_nFor][1]

                _cFil		:= Alltrim(_aBlq[_nFor][2])
                _cCli		:= Alltrim(_aBlq[_nFor][3])
                _cLoja		:= Alltrim(_aBlq[_nFor][4])
                _cProd		:= Alltrim(_aBlq[_nFor][6])
                _cUser		:= Alltrim(_aBlq[_nFor][11])
                _cProc		:= Alltrim(_aBlq[_nFor][13])
                _cNum		:= _cFil + _cCli + _cLoja + Alltrim(_cProc)+ Alltrim(_cProd)

                If Alltrim(_cUser) <> Alltrim(UsrRetName(RetCodUsr()))
                    ShowHelpDlg('BRI115_4',{'Usu�rio n�o � o mesmo que realizou o Reajuste!'},1,{'Solicite a exclus�o ao usu�rio que realizou o Reajuste.'},1)
                Endif

                ZF1->(dbGoTo(_aBlq[_nFor][12]))

                ZF1->(RecLock("ZF1",.F.))
                ZF1->(dbDelete())
                ZF1->(MsUnLock())

                //			_cUpd := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFil+"' AND ZAH_NUM = '"+_cNum+"' AND ZAH_TIPO = '"+_cType+"' "
                _cUpd := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cNum+"' AND ZAH_TIPO = '"+_cType+"' AND D_E_L_E_T_ = '' "
                TcSqlExec(_cUpd)

                _cUpd := "DELETE "+RetSqlName("SCR")+ " WHERE CR_NUM = '"+_cNum+"' AND CR_TIPO = '"+_cType+"'  AND D_E_L_E_T_ = '' "
                TcSqlExec(_cUpd)

                SZ2->(dbSetOrder(4))
                If SZ2->(Msseek(_cFil+_cCli+_cLoja+_cProd+'L'))
                    SZ2->(RecLock("SZ2",.F.))
                    SZ2->Z2_PRCBLQ := SZ2->Z2_PRECO
                    SZ2->Z2_PROCES := ''
                    SZ2->(MsUnlock())
                Endif
            Endif
        Next _nFor
    END TRANSACTION

Return(Nil)
