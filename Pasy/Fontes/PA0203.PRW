#INCLUDE "rwmake.ch"
#include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PA0203   � Autor � Fabiano da Silva � Data �    02/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Trocar n�mero do pedido do Cliente                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PA0203()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Trocar Pedido")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina utilizada para trocar o n�mero do pedido de  "     SIZE 160,7
@ 18,18 SAY "uma NF j� faturada.                                 "     SIZE 160,7
@ 34,18 SAY "Programa PA0203.PRW                                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0203")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	
	Pergunte("PA0203",.F.)
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PA203_A(@_lFim) }
	Private _cTitulo01 := 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return


Static Function PA203_A(_lFim)
               
_lEnt := .F.

_cQ1 := " SELECT * FROM "+RetsqlName("SD2")+" D2 "
_cQ1 += " WHERE D2.D_E_L_E_T_ = '' "
_cQ1 += " AND D2_SERIE = '"+MV_PAR01+"'  AND D2_DOC     = '"+MV_PAR02+"' "
_cQ1 += " AND D2_COD   = '"+MV_PAR03+"'  AND D2_PEDCLI  = '"+MV_PAR04+"' "

TCQUERY _cQ1 NEW ALIAS "ZZ"

ZZ->(dbGotop())

While ZZ->(!EOF())
	
	_cChav := ZZ->D2_PEDIDO+ZZ->D2_ITEMPV+ZZ->D2_COD+ZZ->D2_PEDCLI
	
	_cQ2 := " UPDATE "+RetsqlName("SC6")+" SET C6_PEDCLI = '"+MV_PAR05+"' "
	_cQ2 += " WHERE C6_NUM+C6_ITEM+C6_PRODUTO+C6_PEDCLI = '"+_cChav+"' AND D_E_L_E_T_ = '' "
	
	TCSQLEXEC(_cQ2)
	
	_cChav1 := ZZ->D2_SERIE+ZZ->D2_DOC+ZZ->D2_COD+ZZ->D2_PEDCLI

	_cQ := " UPDATE "+RetsqlName("SD2")+" SET D2_PEDCLI = '"+MV_PAR05+"' "
	_cQ += " WHERE D2_SERIE+D2_DOC+D2_COD+D2_PEDCLI  = '"+_cChav1+"' AND D_E_L_E_T_ = '' "

	TCSQLEXEC(_cQ)


	_lEnt := .T.
	
	ZZ->(DBSKIP())
EndDo
    
ZZ->(dbCloseArea())
    

If _lEnt
    Msginfo("Altera��o Realizada com sucesso!")
Else
 	Alert("Nota Fiscal, Produto ou Pedido n�o encontrado!")
Endif
	
Return (Nil)


Static Function AtuSX1()

cPerg := "PA0203"
aRegs := {}

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Serie NF           ?",""       ,""      ,"mv_ch1","C" ,03     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Nota Fiscal        ?",""       ,""      ,"mv_ch2","C" ,09     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SF2")
U_CRIASX1(cPerg,"03","Produto Pasy       ?",""       ,""      ,"mv_ch3","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"04","Pedido De          ?",""       ,""      ,"mv_ch4","C" ,20     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"05","Pedido Para        ?",""       ,""      ,"mv_ch5","C" ,20     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
