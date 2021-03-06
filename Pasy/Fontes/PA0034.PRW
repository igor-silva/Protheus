#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PA0034   � Autor � Alexandro da Silva    � Data � 03.06.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza�ao tabela SZ4 ref. Programacao de Entrega         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Sigafat AGCO                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PA0034()

_aAliOri := GetArea()
_lAchou  := .F.

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Atualizar Programacao de Entrega")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Atualizar Progr.Entrega"     SIZE 160,7
@ 18,18 SAY "AGCO conforme Arquivo Recebido da AGCO.   "     SIZE 160,7
@ 26,18 SAY "Uso Automatico.                           "     SIZE 160,7
@ 34,18 SAY "Programa PA0034.PRW "                           SIZE 160,7

//@ 85,158 BMPBUTTON TYPE 1 ACTION Proces()
//@ 85,188 BMPBUTTON TYPE 2 ACTION Close(oDlg)
//ACTIVATE DIALOG oDlg Centered  Valid Close(odlg)

@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered  //Valid Close(odlg)
                                        
If _nOpc == 1
	Proces()
Endif


Return


Static Function Proces()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

If _lAchou
	MsgInfo("Arquivo Processado Com Sucesso!!!!","INFO")
Else
	MsgStop("Nao Existe Dados Para Processar!!!!","SEM PROGRAMACAO")
Endif

Return


Static Function Proc1(_lFim)

//_aArqTxt:=ARRAY(ADIR("\AGCO\RETORNO\AGCO*.TXT"))
//ADIR("\AGCO\RETORNO\AGCO*.TXT",_aArqTxt)

_aArqTxt:=ARRAY(ADIR("F:\AP7\AP_DATA\AGCO\ENTRADA\DE_AGCO*.TXT"))
//_aArqTxt:=ARRAY(ADIR("F:\AP7\AP_DATA\AGCO\ENTRADA\DESEN\DE_AGCO*.TXT"))
//ADIR("F:\AP7\AP_DATA\AGCO\ENTRADA\DESEN\DE_AGCO*.TXT",_aArqTxt)
ADIR("F:\AP7\AP_DATA\AGCO\ENTRADA\DE_AGCO*.TXT",_aArqTxt)

_cCont     := ""
_dDtMov    := Ctod("")
_cCliente  := ""
_cLoja     := ""
_cSemAtu   := ""
_dDtAtu    := Ctod("")
_cSemAnt   := ""
_cProdCli  := ""
_cProdPasy := ""
_cLocDest  := ""
_cContato  := ""
_cTipo     := ""
_cUltNf    := ""
_cSerNf    := ""
_dDtUltNf  := Ctod("")
_dDtEnt    := Ctod("")
_nQtEnt    := ""
_aDtEnt    := {}
_cPedido   := ""
_cDesenho  := ""

_cData2 := GravaData(dDataBase,.f.,8)
_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

For I:= 1 to Len(_aArqTxt)
	
	_lAchou   := .t.
//	_cArq2    := "F:\AP7\AP_DATA\AGCO\ENTRADA\DESEN\BKP_EM"+_cData2+_cHora2+"_"+Alltrim(_aArqTxt[i])
	_cArq2    := "F:\AP7\AP_DATA\AGCO\ENTRADA\BKP_EM"+_cData2+_cHora2+"_"+Alltrim(_aArqTxt[i])
	_cArq3    := "F:\AP7\AP_DATA\AGCO\ENTRADA\"+Alltrim(_aArqTxt[i])
//	_cArq3    := "F:\AP7\AP_DATA\AGCO\ENTRADA\DESEN\"+Alltrim(_aArqTxt[i])
	
	_cArqNovo := fCreate(Alltrim(_cArq2),0)
	_cArq     := FOpen(_cArq3,0)
	
	While .T.
		
		cLinha := fReadStr(_cArq,130)
		
		If Len(cLinha) == 0
			Exit
		Endif
		
		If Subs(cLinha,1,3) == "ITP"
			_cCont   := Subst(cLinha,9,5)
			_dDTMov  := Ctod(Subst(cLinha,18,2)+"/"+Subst(cLinha,16,2)+"/20"+Subst(cLinha,14,2))
			
			dbSelectArea("SA1")
			dbSetOrder(3)
			If dbSeek(xFilial("SA1")+Subst(cLinha,26,14))
				_cCliente := SA1->A1_COD
				_cLoja    := SA1->A1_LOJA
			Endif
			
			dbSelectArea("SZ4")
			dbSetOrder(5)
			If dbSeek(xFilial("SZ4") + _cCliente + _cLoja )
				_cChavProg := SZ4->Z4_CODCLI + SZ4->Z4_LOJA
				
				While !eof() .And. _cChavProg == SZ4->Z4_CODCLI + SZ4->Z4_LOJA
					
					dbSelectArea("SZ4")
					RecLock("SZ4",.F.)
					dbDelete()
					MsUnlock()
					
					dbSelectArea("SZ4")
					dbSkip()
				EndDo
			Endif
		ElseIf Subs(cLinha,1,3) == "PE1"
			_nQt      := 0
			_cSemAtu  := Subs(cLinha,7,9)
			_dDtAtu   := Ctod(Subst(cLinha,20,2)+"/"+Subst(cLinha,18,2)+"/20"+Subst(cLinha,16,2))
			_cSemAnt  := Subs(cLinha,22,9)
			_cProdCli := Subs(cLinha,37,15)
			
			dbSelectArea("SZ2")
			dbSetOrder(6)
			If !dbSeek(xFilial("SZ2")+_cCliente + _cLOja + _cProdCli+"1")
				Alert("Produto Nao Cadastrado No Cadastro ProdutoxCliente : "+_cProdCli+" Cliente Loja"+_cCliente + _cLOja)
				fClose(_cArq2)
				If File(_cArq3)
					FClose(_cArq)
				Endif
				Exit
			Endif
			
			_cProdPasy := SZ2->Z2_PRODUTO
			_cLocDest := Subs(cLinha,109,5)
			_cContato := Subs(cLinha,114,11)
			_cTipo    := Subs(cLinha,128,1)
		ElseIf Subs(cLinha,1,3) == "PE2"
			_cUltNf   := Subs(cLinha,10,6)
			_cSerNf   := Subs(cLinha,16,4)
			_dDtUltNf := Ctod(Subst(cLinha,24,2)+"/"+Subst(cLinha,22,2)+"/20"+Subst(cLinha,20,2))
		ElseIf Subs(cLinha,1,3) == "PE3"
			_nQtDt := 4
			_nQt   := 12
			
			_aDtEnt := {}
			For A:= 1 to 7
				_dDtEnt := Ctod(Subst(cLinha,_nQtDt+4,2)+"/"+Subst(cLinha,_nQtDt+2,2)+"/20"+Subst(cLinha,_nQtDt,2))
				_nQtEnt := Val(Subs(cLinha,_nQt,9))
				
				If !Empty(_dDtEnt)
					AADD(_aDtEnt,{_dDtEnt,_nQtEnt})
					_nQtDt += 17
					_nQt   += 17
				Else
					A:= 7
				Endif
			Next A
		ElseIf Subs(cLinha,1,3) == "PE5"
			_nPed    := 10
			
			For B:= 1 To Len(_aDtEnt)
				_cPedido := Subs(cLinha,_nPed,9)

				_cTpPed    := Subs(cLinha,_nPed,1)			
				_nPed += 16

				dbSelectArea("SZ4")
				dbSetOrder(1)
				If !dbSeek(xFilial("SZ4") + _cCont + _cCliente + _cLoja + _cProdCli + Dtos(_aDtEnt[B,1])+_cPedido)
					dbSelectArea("SZ4")
					RecLock("SZ4",.T.)
					SZ4->Z4_FILIAL  := xFilial("SZ4")
					SZ4->Z4_CODCLI  := _cCliente
					SZ4->Z4_LOJA    := _cLoja
					SZ4->Z4_PRODPAS := _cProdPasy
					SZ4->Z4_PRODCLI := _cProdCli
					SZ4->Z4_DTMOV   := _dDtMov
					SZ4->Z4_CONTROL := _cCont
					SZ4->Z4_SEMATU  := _cSemAtu
					SZ4->Z4_DTATU   := _dDtAtu
					SZ4->Z4_SEMANT  := _cSemAnt
					SZ4->Z4_LOCDEST := _cLocDest
					SZ4->Z4_TIPO    := _cTipo
					SZ4->Z4_ULTNF   := _cUltNf
					SZ4->Z4_DTULTNF := _dDtUltNf
					SZ4->Z4_DTENT   := _aDTEnt[B,1]
					SZ4->Z4_QTENT   := _aDtEnt[B,2]
					SZ4->Z4_PEDIDO  := _cPedido
					SZ4->Z4_TPPED   := _cTpPed					
					SZ4->Z4_CONTATO := _cContato
					SZ4->Z4_DTDIGIT := dDataBase
					SZ4->Z4_NOMARQ  := Alltrim(_aArqTxt[i])
					MsUnlock()
				Endif
			Next B
		ElseIf Subs(cLinha,1,3) == "PE6"
			_cDesenho := Subs(cLinha,14,4)
			dbSelectArea("SZ4")
			If dbSeek(xFilial("SZ4") + _cCont + _cCliente + _cLoja + _cProdCli) //+ Dtos(_dDtEnt) )
				_cChavSZ4 :=  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
				While !Eof() .And.  _cChavSZ4 ==  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
					dbSelectArea("SZ4")
					RecLock("SZ4",.F.)
					SZ4->Z4_ALTTEC  := _cDesenho
					MsUnlock()
					
					dbSkip()
				EndDo
			Endif
		Endif
		
		FWrite(_cArqNovo,cLinha)
	EndDo
	
	fClose(_cArq2)
	If File(_cArq3)
		FClose(_cArq)
		FErase(_cArq3)
	Endif
Next I

Return