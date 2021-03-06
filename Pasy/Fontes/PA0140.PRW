#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Pa0140    � Autor � Alexandro da Silva � Data �  24/09/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera��o do Arquivo Texto Padrao anfavea p/ AGCO/Valtra/CNH ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SigaFat                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Pa0140()

_lParar := .T.
ATUSX1()

Private _cPerg    := "PA0140"
Private _cString  := "SF2"
Private _lAGCO    := _lVALTRA := _lCNH  := .F.

Pergunte(_cPerg,.F.)

dbSelectArea("SF2")
dbSetOrder(5)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Geracao de ASN AGCO/CNH/VALTRA")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- " SIZE 160,7
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de " SIZE 160,7
@ 26,018 Say " Notas Fiscais de Venda. Programa PA0140.PRW                   " SIZE 160,7
@ 85,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 85,158 BMPBUTTON TYPE 01 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 02 ACTION oDlg:END()

Activate Dialog oDlg Centered

If _nOpc == 1
	PA140_A()
Endif

Return


Static Function PA140_A()

Private _cQtdItem
Private _cCfo

// Notas Fiscais de Venda

SF2->(dbSetOrder(1))
If !SF2->(dbSeek(xFilial("SF2")+MV_PAR01+MV_PAR02))
	Alert("Nota Fiscal Nao Encontrada!!!!!")
	Return
Endif

_cCgc2  := SM0->M0_CGC
_cData2 := GravaData(dDataBase,.f.,8)
_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
_lAGCO  := _lVALTRA := _lCNH  := .F.

If SF2->F2_CLIENTE == "000001"
	Private _cArqTxtV := "\\SERVER2\ERP\EDI\SAWLUZ\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
//	Private _cArqTxtV := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
	_lAGCO   := .T.
ElseIf SF2->F2_CLIENTE == "000053"
	Private _cArqTxtV := "\\SERVER2\ERP\EDI\SAWLUZ\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
//	Private _cArqTxtV := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
	_lVALTRA := .T.
ElseIf SF2->F2_CLIENTE == "000071"
	Private _cArqTxtV := "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\CNH\BRASIL\SAIDA\PASY_CNH_"+_cData2+"_"+_cHora2+"_00000.TXT"
	_lCNH    := .T.
Endif

Private _nHdlV    := MSfCreate(_cArqTxtV)

If _nHdlV == -1
	MsgAlert("O arquivo de nome "+_cArqTxtV+" 1 nao pode ser executado!","Atencao!")
	fClose(_nHdlV)
	Return
Endif

// - Notas Fiscais de Retorno

_cCgc2  := SM0->M0_CGC
_cData2 := GravaData(dDataBase,.f.,8)
_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + strzero(Val(Substr(Time(),7,2))+1,2)

If SF2->F2_CLIENTE == "000001"
	Private _cArqTxtR  := "\\SERVER2\ERP\EDI\SAWLUZ\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
//	Private _cArqTxtR  := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
ElseIf 	 SF2->F2_CLIENTE == "000053"
	Private _cArqTxtR  := "\\SERVER2\ERP\EDI\SAWLUZ\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
//	Private _cArqTxtR  := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
ElseIf 	 SF2->F2_CLIENTE == "000071"
	Private _cArqTxtR  := "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\CNH\BRASIL\SAIDA\PASY_CNH_"+_cData2+"_"+_cHora2+"_00000.TXT"
Endif

Private _nHdlR     := MSfCreate(_cArqTxtR)
Private _lEncontV  := .t.
Private _lEncontR  := .t.

If _nHdlR == -1
	MsgAlert("O arquivo de nome "+_cArqTxtR+" 2 nao pode ser executado!","Atencao!")
	fClose(_nHdlR)
	Return
Endif

Private _cEOL    := "CHR(13)+CHR(10)"

If Empty(_cEOL)
	_cEOL := CHR(13)+CHR(10)
Else
	_cEOL := Trim(_cEOL)
	_cEOL := &_cEOL
Endif

_cLin    := Space(128) + _cEOL

Private _cLin, _cCpo, _cCGCPasy,_cCGCCli,_cUM, _cIdenti,_cTpForn,_cIdent,_lFerr
Private _cIdenti    := "000"
Private _cSeqv      := "00000"
Private _cSeqR      := "00000"
Private _dVencto    := "000000"
Private _cDescCFO   := space(15)
Private _cClasFis   := space(10)
Private _nTamLin    := 128
Private _nItem, _cDescCFO,_cRev,_nContLiV, _nContLiR, _nSomaTot
Private _cRev       := "0000"
Private _cItemOri   := space(3)
Private _cDtori     := space(6)
Private _cCodFab    := space(3)
Private _aDirLoc 	:= DIRECTORY( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\CNH\BRASIL\SAIDA\PASY_CNH_*.TXT",  )
Private _cServer 	:= "ftp.gmdlogistica.com.br"
Private _nPorta  	:= 21
Private _cUser   	:= "pasy"
Private _cPass   	:= "pasygmd"

_lAchouV  := .F.
_lAchouR  := .F.
_nContLiV := 0
_nContLiR := 0
_nSomaTot := 0

_lFerr := .F.

dbSelectArea("SD2")
dbOrderNickName("INDSD24")
If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cChavSD2    := SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	_nQtdItem    := 0
	_lRetorno    := .F.
	_lVenda      := .F.
	While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		
		_nQtdItem ++
		_cCfo     := SD2->D2_CF                           // Codigo de Opera�ao           (5) M
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SD2->D2_COD)
			If SB1->B1_TIPO == "FR"
				_lFerr := .T.
			Endif
		Endif
		
		If SD2->D2_TIPO == "D"
			_lRetorno := .T.
			_lAchouR  := .T.
		Else
			dbSelectArea("SF4")
			dbSetOrder(1)
			If dbSeek(xFilial("SF4")+SD2->D2_TES)
				If SF4->F4_PODER3 == "D"
					_lRetorno := .T.
					_lAchouR  := .T.
				Else
					_lVenda  := .T.
					_lAchouV := .T.
				Endif
			Endif
		Endif
		_cCfo1 := SD2->D2_CF                           // Codigo de Opera�ao           (4) M
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif
_cQtdItem    := strZero(_nQtdItem,3)                             // Qtde de itens a N.F.         (3) M

If !_lFerr
	If _lVenda
		GeraVenda2()
	Else
		GeraRet2()
	Endif
Endif

If _lAchouV
	_nContLiV++
	_cContLI  := StrZero(_nContLiV,9)                           // Numero de Controle             (9)  M
	_cSomaTot := StrZero(Int(_nSomaTot *100),17)                // Soma Total das N.Fiscais       (12) M
	_cCpo     := "FTP"+ _cSeqv + _cContLi + _cSomaTot + "D" + sPace(93)
	
	_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	
	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	fClose(_nHdlV)
	
	If _lCNH
		fClose(_nHdlR)
		_aDirLoc := DIRECTORY( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\CNH\BRASIL\SAIDA\PASY_CNH_*.TXT",  )
		_cServer := "ftp.gmdlogistica.com.br"
		_nPorta  := 21
		_cUser   := "pasy"
		_cPass   := "pasygmd"
		
		If FTPConnect( _cServer, _nPorta, _cUser, _cPass )
			For I:=1 to Len(_aDirLoc)
				_cArq   := "\CNH\BRASIL\SAIDA\"+_aDirLoc[I][1]
				_nHdl   := fOpen(_cArq,129)
				_nTamF  := fSeek(_nHdl,0,2)	
				If _nTamF > 0
					If FTPUpLoad( "\CNH\BRASIL\SAIDA\" + _aDirLoc[I][1], _aDirLoc[I][1] )
						Conout('UpLoad Ok! '+ _aDirLoc[I][1])
						_cArqNew := "\CNH\BRASIL\SAIDA\BACKUP\BACK_"+_aDirLoc[I][1]
						__CopyFile(_cArq,_cArqNew)
						fClose(_nHdl)
						FErase(_cArq)
					Else
						Conout('Falha UpLoad!'+aDirLoc[I][1])
						fClose(_nHdl)						
					EndIf
				Else
					fClose(_nHdl)
					FErase(_cArq)			
				Endif
			Next I
			
			MsgInfo("Nota Fiscal Enviada!!!")
		Endif
	Endif
Else
	fClose(_nHdlV)
	FErase(_cArqTxtV)
Endif

If _lAchouR
	_nContLiR++
	_cContLI  := StrZero(_nContLiR,9)                           // Numero de Controle             (9)  M
	_cSomaTot := StrZero(Int(_nSomaTot *100),17)               // Soma Total das N.Fiscais        (12) M
	_cCpo     := "FTP"+ _cSeqR + _cContLi + _cSomaTot + "D" + sPace(93)
	
	_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	
	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif
Else
	fClose(_nHdlR)
	FErase(_cArqTxtR)
Endif

Return


Static Function GeraVenda2()

If _lEncontV
	_lEncontV := .F.
	_cLin     := Space(128) + _cEOL
	
	If _lAGCO
		_cSeqv    := GetMv("MV_NUMAGCO")
	ElseIf _lVALTRA
		_cSeqv    := GetMv("MV_NUMVALT")
	ElseIf _lCNH
		_cSeqv    := GetMv("MV_NUMCNH")
	Endif
	
	dbSelectArea("SX6")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := SOMA1(_cSeqV)
	MsUnlock()
	
	_cData     := GravaData(dDataBase,.f.,4)
	_cHora     := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	_cCgcPasy  := SM0->M0_CGC
	_cNomPasy  := Substr(SM0->M0_NOMECOM,1,25)

	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
		_cCGCCli  := SA1->A1_CGC
		_cNomCli  := Substr(SA1->A1_NOME,1,25)
	Endif
	
	_cTpForn := "P"

	If _lCNH
		_cIdent    := "ITP00417"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		_cCodTra   := Space(8)             // Codigo Interno do Transmissor          08 - (54 a 61)
		If SA1->A1_LOJA = "13'
			_cTpForn := "R"
		Endif	
	Else
		_cIdent    := "ITP00421"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
//		_cIdent    := "ITP00415"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		_cCodTra   := "00013456"           // Codigo Interno do Transmissor          08 - (54 a 61)
		If (SA1->A1_COD = "000001" .AND. SA1->A1_LOJA = "04") .Or.;
			(SA1->A1_COD = "000053" .AND. SA1->A1_LOJA = "02")
			_cTpForn := "R"
		Endif
	Endif

	_cSeqv     := _cSeqv               // Numero de Controle da Transa��o        05 - (09 a 13)
	_cDtHora   := _cData + _cHora      // Identificacao da Gera��o do Movimento  12 - (14 a 25)
	_cCgcPasy  := _cCgcPasy            // Ident. Transmissor na Comunica��o      14 - (26 a 39)
	_cCGCCli   := _cCGCCli             // Ident. Receptor na Comunica��o         14 - (40 a 53)
	_cCodRec   := Space(8)             // Codigo Interno do Receptor             08 - (62 a 69)
	_cNomPasy  := _cNomPasy            // Nome do Transmissor                    25 - (70 a 94)
	_cNomCli   := _cNomCli             // Nome do Receptor                       25 - (95 a 119)
	_cEspaco   := Space(9)             // Espa�o em branco                       09 - (120 a 128)
	
	_cCpo      := _cIdent + _cSeqv + _cDtHora + _cCgcPasy + _cCGCCli +_cCodTra + _cCodRec + _cNomPasy + _cNomCli + _cEspaco
	_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++
	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif
Endif

_cLin     := Space(128)+_cEOL
_cNf      := STRZERO(VAL(SF2->F2_DOC),6)
_cSer     := SF2->F2_SERIE + SPACE(1)
_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)
_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)
_nSomaTot += SF2->F2_VALBRUT
_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)

dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + "   NF ")
	_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)
Endif

_cEspecie := "02"
_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)

dbSelectArea("SX5")
dbSetOrder(1)
If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
	_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)
Endif

_dDtEmb   := GravaData(SF2->F2_EMISSAO,.f.,4)
_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)

_cTpReg   := "AE1"                  // Tipo de Registro          03 - (01 a 03)
_cNf      := _cNf                   // Numero da Nota Fiscal     06 - (04 a 09)
_cSer     := _cSer                  // Serie  da Nota Fiscal     03 - (10 a 13)
_cDataNf  := _dDataNf               // Data   da Nota Fiscal     06 - (14 a 19)
_cQtdItem := _cQtdItem              // Quantidade de Item da NF  03 - (20 a 22)
_cVlTotal := _cVlTotal              // Valor Total da N.Fiscal   17 - (23 a 39)
_cQtdCd   := "0"                    // Qtde Casas Decimais       01 - (40 a 40)
_cCfo     := StrZero(Val(_cCfo),5)  // Codigo Fiscal de Operacao 05 - (41 a 45)
_cVlICMS  := _cVlICMS               // Valor total ICMS Aplicado 17 - (46 a 62)
_cVencto  := _dVencto               // Data do Vencimento        06 - (63 a 68)
_cEspecie := _cEspecie              // Especie da Nota Fiscal    02 - (69 a 70)
_cVLIPI   := _cVlIPI                // Valor Total do IPI        17 - (71 a 87)
_cCodFab  := Space(3)               // Codigo da Fabrica         03 - (88 a 90)
_cDtPrev  := "000000"               // Data Previsao Entrega     06 - (91 a 96)
_cPerEnt  := space(4)               // Periodo da Entrega        04 - (97 a 100)
_cDescCfo := _cDescCfo              // Descricao da Nat.Operacao 15 - (101 a 115)
_cDtEmb   := _dDtEmb                // Data do Embarque          06 - (116 a 121)
_cHora    := _cHora                 // Hora do Embarque          04 - (122 a 125)
_cEspaco  := Space(3)               // Espaco em Branco          03 - (126 a 128)

_cCpo    := _cTpReg + _cNf + _cSer + _cDataNF + _cQtdItem + _cVlTotal + _cQtdCD + _cCfo + _cVlICMS + _cVencto + _cEspecie + _cVlIPI + ;
_cCodFab + _cDtPrev + _cPerEnt + _cDescCFO + _cDtEmb + _cHora + _cEspaco

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif
        
/*
// - NF6 - Complemento dados NFe

_cTpReg   := "NF6"
_cChave   := SUBSTR(SF2->F2_CHVNFE,1,44)
_cAto     := Space(20)

_cTpReg    := _cTpReg                         // Tipo de Registro           03 - (01 a 03)
_cDespAce  := _cDespAce                       // CHAVE DE ACESSO NFE        44 - (04 a 47)
_cFrete    := _cFrete                         // ATO CONCESS�RIO            20 - (48 a 67)
_cBranco2  := Space(61)                       // Espaco em Branco           61 - (68 a 128)

_cCpo := _cTpReg+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cZero + _cBranco + _cCfo2 + _cBranco2

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF6). Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif
  */
// - NF2

_cTpReg   := "NF2"
_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)
_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)
_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)
_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)
_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)
_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)

_cTpReg    := _cTpReg                         // Tipo de Registro           03 - (01 a 03)
_cDespAce  := _cDespAce                       // Valor Despesas Acessorias  12 - (04 a 15)
_cFrete    := _cFrete                         // Valor do Frete             12 - (16 a 27)
_cSeguro   := _cSeguro                        // Valor do Seguro            12 - (28 a 39)
_cDescon   := _cDescon                        // Valor do Desconto          12 - (40 a 51)
_cBaseICMS := _cBaseICMS                      // Base de Calculo do ICMS    12 - (52 a 63)
_cICMS     := _cICMS                          // Valor do ICMS              12 - (64 a 75)
_cZero     := "000000000000"                  // Numero,Data                06 - (76 a 87)
_cBranco   := Space(7)                        // Serie,Codigo da Fabrica    36 - (88 a 94)
_cCfo2     := StrZero(VaL(_cCFO),5)           // Codigo Fiscal Operacao     05 - (95 a 99)
_cBranco2  := Space(29)                       // Espaco em Branco           29 - (100 a 128)

_cCpo := _cTpReg+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cZero + _cBranco + _cCfo2 + _cBranco2

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif

_cPedCli := space(12)
_cProdCli:= space(30)
_cDest   := space(03)
//dbSelectArea("SD2")
//dbSetOrder(3)

dbSelectArea("SD2")
dbOrderNickName("INDSD24")
If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cChavSD2 :=SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	
	While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		
		_cLin   := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
		_cItem  := "0"+ SD2->D2_ITEM
		
		_cProdCli := SD2->D2_PROCLI + Space(15)
		If Empty(_cProdCli)
			_cProdCli := "S/CODIGO"+ Space(22)
		Endif

		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
			_cPedCli := Substr(SC6->C6_PEDCLI,1,12)
			_cDest   := SC6->C6_LOCDEST
		Endif
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
			If Empty(_cPedcli)
				_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)
			Endif
			_cRev    := ALLTRIM(SZ2->Z2_REVISAO)
		Endif
		
		_cQtde    := StrZero(Int(SD2->D2_QUANT),9)
		
		dbSelectArea("SAH")
		dbSetOrder(1)
		If dbSeek(xFilial("SAH")+ SD2->D2_UM)
			_cUm := "PC"//SAH->AH_CODANFA
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SD2->D2_COD)
			_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)
		Endif
		
		_cAliIPI := StrZero(Int(SD2->D2_IPI*100),4)
		_cVlItem := StrZero(Int(SD2->D2_PRCVEN*100000),12)
		
		If Len(_cRev) == 2
			_cRev := Space(2)+_cRev
		Else
			_cRev := Substr(_cRev,1,4)
		Endif
		
		_cTpReg    := "AE2"                               // Tipo de Registro           03 - (01 a 03)
		_cItem     := _cItem                              // NUmero do Item da N.Fiscal 03 - (04 a 06)
		_cPedCli   := _cPedCli                            // NUmero do Pedido de Compra 12 - (07 a 18)
		_cProdCli  := _cProdCli                           // Codigo do Item             30 - (19 a 48)
		_cQtde     := _cQtde                              // Qtde do Item na Nota Fiscal09 - (49 a 57)
		_cUM       := _cUm                                // Unidade Medida             02 - (58 a 59)
		_cClasFis  := _cClasFis                           // Classificacao Fiscal       10 - (60 a 69)
		_cAliIPI   := _cAliIPi                            // Aliq. do IPI               04 - (70 a 73)
		_cVlItem   := _cVlItem                            // Valor do Item              12 - (74 a 85)
		_cQtde     := _cQtde                              // Qtde do Item em Estoque    09 - (86 a 94)
		_cUM       := _cUm                                // Unidade Medida Estoque     02 - (95 a 96)
		_cQtde     := _cQtde                              // Qtde do Unidade de Compra  09 - (97 a 105)
		_cUM       := _cUm                                // Unidade Medida de Compra   02 - (106 a 107)
//		_cTpForn   := "P"                                 // Tipo de Fornecimento       01 - (108 a 108)
		_cTpForn   := _cTpForn                            // Tipo de Fornecimento       01 - (108 a 108)
		_cPerDesc  := StrZero(Int(SD2->D2_DESC*100),4)    // Percentual de Desconto     04 - (109 a 112)
		_cValDesc  := StrZero(Int(SD2->D2_DESCON*100),11) // Valor do Desconto          11 - (113 a 123)
		_cRev      := _cRev                               // Alteracao Tecnica do Item  04 - (124 a 127)
		_cBranco   := Space(1)                            // Espaco em branco           01 - (128 a 128)
		
		_cCpo := _cTpReg + _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
		_cQtde + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + _cBranco
		
		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiV++
		
		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE2). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
		
		_cAliICMS  := StrZero(Int(SD2->D2_PICM   *100),4)           // Percentual ICMS                (4)  O
		_cBaseICMS := StrZero(Int(SD2->D2_BASEICM*100),17)          // Base ICMS                      (17) O
		_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),17)          // Valor do ICMS                  (17) O
		_cVlIPI    := StrZero(Int(SD2->D2_VALIPI *100),17)          // Valor do ICMS                  (17) O
		_cVlTotal  := StrZero(Int(SD2->D2_TOTAL  *100),12)          // Valor Total do Item            (12) M
		
		_cCpo := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(5) + "1" +_cVlTotal +sPace(1)
		
		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiV++
		
		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE4). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

_cZeros    := Repl('0',28)
_cLocEnt   := ""

//If SF2->F2_CLIENTE == "000001"
If _lAGCO
	If SF2->F2_LOJA == "01"
		_cLocEnt := "CAN"
	ElseIf SF2->F2_LOJA == "02"
		_cLocEnt := "SRO"
	ElseIf SF2->F2_LOJA == "03"
		_cLocEnt := "SUM"
	Endif
ElseIf _lVALTRA // 000053
	_cLocEnt := _cDest
//	_cLocEnt := "MOG"
ElseIf _lCNH   // 000071
	_cLocEnt := _cCGCCli
Endif

_cLocEnt := Substr((_cLocEnt +Space(11)),1,14)

_cCpo := "AE3"+ _cZeros + _cLocEnt + Space(83)

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE3). Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif

Return



Static Function GeraRet2()

If _lEncontR
	_lEncontR := .F.
	_cLin     := Space(128) + _cEOL
	
	If _lAGCO
		_cSeqR := GetMv("MV_NUMAGCO")
	ElseIf _lVALTRA == "000053"
		_cSeqR := GetMv("MV_NUMVALT")
	ElseIf _lCNH    == "000071"
		_cSeqR := GetMv("MV_NUMCNH")
	Endif
	
	dbSelectArea("SX6")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := StrZero((Val(_cSeqR)+1),5)
	MsUnlock()
	
	_cData     := GravaData(dDataBase,.f.,4)
	_cHora     := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	_cCgcPasy  := SM0->M0_CGC
	_cNomPasy  := Substr(SM0->M0_NOMECOM,1,25)
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
		_cCGCCli := SA1->A1_CGC
		_cNomCli := Substr(SA1->A1_NOME,1,25)
	Endif
	
	_cCodCli := SF2->F2_CLIENTE+SF2->F2_LOJA
	
	_cTpForn := "P"

	If _lCNH
		_cIdent := "ITP00417"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		If SA1->A1_LOJA = "13'
			_cTpForn := "R"
		Endif	

	Else
//		_cIdent := "ITP00415"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		_cIdent := "ITP00421"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		If (SA1->A1_COD = "000001" .AND. SA1->A1_LOJA = "04") .Or.;
			(SA1->A1_COD = "000053" .AND. SA1->A1_LOJA = "02")
			_cTpForn := "R"
		Endif
	Endif
	
	_cSeqv     := _cSeqv               // Numero de Controle da Transa��o        05 - (09 a 13)
	_cDtHora   := _cData + _cHora      // Identificacao da Gera��o do Movimento  12 - (14 a 25)
	_cCgcPasy  := _cCgcPasy            // Ident. Transmissor na Comunica��o      14 - (26 a 39)
	_cCGCCli   := _cCGCCli             // Ident. Receptor na Comunica��o         14 - (40 a 53)
	If _lCNH
		_cCodTra   := "00000000"           // Codigo Interno do Transmissor          08 - (54 a 61)
	Else
		_cCodTra   := "00013456"           // Codigo Interno do Transmissor          08 - (54 a 61)
	Endif
	_cCodRec   := Space(8)             // Codigo Interno do Receptor             08 - (62 a 69)
	_cNomPasy  := _cNomPasy            // Nome do Transmissor                    25 - (70 a 94)
	_cNomCli   := _cNomCli             // Nome do Receptor                       25 - (95 a 119)
	_cEspaco   := Space(9)             // Espa�o em branco                       09 - (120 a 128)
	
	_cCpo      := _cIdent + _cSeqv + _cDtHora + _cCgcPasy + _cCGCCli +_cCodTra + _cCodRec + _cNomPasy + _cNomCli + _cEspaco
	_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++
	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif
Endif

_cLin     := Space(128)+_cEOL
_cNf      := STRZERO(val(SF2->F2_DOC),6)
_cSer     := SF2->F2_SERIE + SPACE(1)
_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)
_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)
_nQtdCD   := "0"
_nSomaTot += SF2->F2_VALBRUT
_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)

dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + "NF ")
	_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)
Endif

_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)

dbSelectArea("SX5")
dbSetOrder(1)
If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
	_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)
Endif

_dDtEmb   := GravaData(SF2->F2_EMISSAO,.f.,4)
_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)

_cTpReg   := "AE1"                  // Tipo de Registro          03 - (01 a 03)
_cNf      := _cNf                   // Numero da Nota Fiscal     06 - (04 a 09)
_cSer     := _cSer                  // Serie  da Nota Fiscal     03 - (10 a 13)
_cDataNf  := _dDataNf               // Data   da Nota Fiscal     06 - (14 a 19)
_cQtdItem := _cQtdItem              // Quantidade de Item da NF  03 - (20 a 22)
_cVlTotal := _cVlTotal              // Valor Total da N.Fiscal   17 - (23 a 39)
_cQtdCd   := "0"                    // Qtde Casas Decimais       01 - (40 a 40)
_cCfo     := StrZero(Val(_cCfo),5)  // Codigo Fiscal de Operacao 05 - (41 a 45)
_cVlICMS  := _cVlICMS               // Valor total ICMS Aplicado 17 - (46 a 62)
_cVencto  := _dVencto               // Data do Vencimento        06 - (63 a 68)
_cEspecie := "01"                   // Especie da Nota Fiscal    02 - (69 a 70)
_cVLIPI   := _cVlIPI                // Valor Total do IPI        17 - (71 a 87)
_cCodFab  := Space(3)               // Codigo da Fabrica         03 - (88 a 90)
_cDtPrev  := "000000"               // Data Previsao Entrega     06 - (91 a 96)
_cPerEnt  := space(4)               // Periodo da Entrega        04 - (97 a 100)
_cDescCfo := _cDescCfo              // Descricao da Nat.Operacao 15 - (101 a 115)
_cDtEmb   := _dDtEmb                // Data do Embarque          06 - (116 a 121)
_cHora    := _cHora                 // Hora do Embarque          04 - (122 a 125)
_cEspaco  := Space(3)               // Espaco em Branco          03 - (126 a 128)

_cCpo    := _cTpReg + _cNf + _cSer + _cDataNF + _cQtdItem + _cVlTotal + _cQtdCD + _cCfo + _cVlICMS + _cVencto + _cEspecie + _cVlIPI + ;
_cCodFab + _cDtPrev + _cPerEnt + _cDescCFO + _cDtEmb + _cHora + _cEspaco

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiR++

If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
		fClose(_nHdlR)
		Return
	Endif
Endif

// - NF2

_cTpReg   := "NF2"
_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)
_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)
_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)
_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)
_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)
_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)

_cTpReg    := _cTpReg                         // Tipo de Registro           03 - (01 a 03)
_cDespAce  := _cDespAce                       // Valor Despesas Acessorias  12 - (04 a 15)
_cFrete    := _cFrete                         // Valor do Frete             12 - (16 a 27)
_cSeguro   := _cSeguro                        // Valor do Seguro            12 - (28 a 39)
_cDescon   := _cDescon                        // Valor do Desconto          12 - (40 a 51)
_cBaseICMS := _cBaseICMS                      // Base de Calculo do ICMS    12 - (52 a 63)
_cICMS     := _cICMS                          // Valor do ICMS              12 - (64 a 75)
_cZero     := "000000000000"                  // Numero,Data                06 - (76 a 87)
_cBranco   := Space(7)                        // Serie,Codigo da Fabrica    36 - (88 a 94)
_cCfo2     := StrZero(VaL(_cCFO),5)           // Codigo Fiscal Operacao     05 - (95 a 99)
_cBranco2  := Space(29)                       // Espaco em Branco           29 - (100 a 128)

_cCpo := _cTpReg+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cZero + _cBranco + _cCfo2 + _cBranco2

_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
_nContLiR++

If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
		fClose(_nHdlR)
		Return
	Endif
Endif


// - NF5

_cPedCli := ""
dbSelectArea("SD2")
dbOrderNickName("INDSD24")
If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

	_cChavSD2 :=SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	
	While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		
		_cLin    := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
		_cItem   := "0"+ SD2->D2_ITEM                     // Numero do Item               (3)  M
		_cPedCli := Space(12)
		_cDest   := Space(03)
		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
			_cPedCli := Substr(SC6->C6_PEDCLI,1,12)
			_cDest   := SC6->C6_LOCDEST
		Endif
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
			If Empty(_cPedCli)
				_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)               // Pedido de Compra do Cliente  (12) M
			Endif
			_cRev    := Substr(SZ2->Z2_REVISAO,1,4)
		Endif
		
		_cProdCli := SD2->D2_PROCLI + Space(15)                  // Codigo do Produto do Cliente (30) M
		_cQtde    := StrZero(Int(SD2->D2_QUANT),9)               // Qtde do Item                 (9)  M
		
		If Empty(_cProdCli)
			_cProdCli := "S/CODIGO"+ Space(22)
		Endif
		
		dbSelectArea("SAH")
		dbSetOrder(1)
		If dbSeek(xFilial("SAH")+ SD2->D2_UM)
			_cUm := "PC" //SAH->AH_CODANFA                                // Unidade de medida Anfavea    (2)  M
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SD2->D2_COD)
			_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)           // Classificacao Fiscal  Produto (10) M
		Endif
		
		_cAliIPI := StrZero(Int(SD2->D2_IPI*100),4)               // Aliquota do IPI                (4)  M
		_cVlItem := StrZero(Int(SD2->D2_PRCVEN*100000),12)        // Valor do Item                  (12) M
		
		If Len(Alltrim(_cRev)) == 2
			_cRev := Space(2)+Alltrim(_cRev)
		Else
			_cRev := Substr(_cRev,1,4)
		Endif
		
		_cTpReg    := "AE2"                               // Tipo de Registro           03 - (01 a 03)
		_cItem     := _cItem                              // NUmero do Item da N.Fiscal 03 - (04 a 06)
		_cPedCli   := _cPedCli                            // NUmero do Pedido de Compra 12 - (07 a 18)
		_cProdCli  := _cProdCli                           // Codigo do Item             30 - (19 a 48)
		_cQtde     := _cQtde                              // Qtde do Item na Nota Fiscal09 - (49 a 57)
		_cUM       := _cUm                                // Unidade Medida             02 - (58 a 59)
		_cClasFis  := _cClasFis                           // Classificacao Fiscal       10 - (60 a 69)
		_cAliIPI   := _cAliIPi                            // Aliq. do IPI               04 - (70 a 73)
		_cVlItem   := _cVlItem                            // Valor do Item              12 - (74 a 85)
		_cQtde     := _cQtde                              // Qtde do Item em Estoque    09 - (86 a 94)
		_cUM       := _cUm                                // Unidade Medida Estoque     02 - (95 a 96)
		_cQtde     := _cQtde                              // Qtde do Unidade de Compra  09 - (97 a 105)
		_cUM       := _cUm                                // Unidade Medida de Compra   02 - (106 a 107)
		_cTpForn   := _cTpForn                            // Tipo de Fornecimento       01 - (108 a 108)
//		_cTpForn   := "P"                                 // Tipo de Fornecimento       01 - (108 a 108)
		_cPerDesc  := StrZero(Int(SD2->D2_DESC*100),4)    // Percentual de Desconto     04 - (109 a 112)
		_cValDesc  := StrZero(Int(SD2->D2_DESCON*100),11) // Valor do Desconto          11 - (113 a 123)
		_cRev      := _cRev                               // Alteracao Tecnica do Item  04 - (124 a 127)
		_cBranco   := Space(1)                            // Espaco em branco           01 - (128 a 128)
		
		_cCpo      := _cTpReg + _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
		_cQtde     + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + _cBranco
		_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		
		_nContLiR++
		
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE2). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
		
		_cAliICMS  := StrZero(Int(SD2->D2_PICM   *100),4)           // Percentual ICMS                (4)  O
		_cBaseICMS := StrZero(Int(SD2->D2_BASEICM*100),17)          // Base ICMS                      (17) O
		_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),17)          // Valor do ICMS                  (17) O
		_cVlIPI    := StrZero(Int(SD2->D2_VALIPI *100),17)          // Valor do ICMS                  (17) O
		_cVlTotal  := StrZero(Int(SD2->D2_TOTAL  *100),12)          // Valor Total do Item            (12) M
		
		_cCpo      := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(6) + _cVlTotal +sPace(1)
		_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		
		_nContLiR++
		
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE4). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
		
		_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),12)          // Valor do ICMS                   (17) O
		_cCfo      := SD2->D2_CF                        // Codigo de Opera�ao              (3)  M
		_cVlBaTrib := Repl("0",17)                                  // Valor Base do ICMS Tributario   (17) M
		_cVlICMTri := Repl("0",17)                                  // Valor do ICMS Tributario        (17) M
		_cQtdeEmb  := Repl("0",14)                                   // Quantidade Entregue             (9)  O
		_cCpo      := "AE7"+ _cVlICMS + STRZERO(VAL(_cCFO),5) + _cVlBaTrib + _cVlICMTRI + _cQtdeEmb + Space(60)
		_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		
		_nContLiR++
		
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE7). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
		
		_cNfOri    := STRZERO(val(SD2->D2_NFORI),6)                 // Nota Fiscal Original            (6)  M
		_cSerOri   := SD2->D2_SERIORI + space(1)                     // Serie Nota Fiscal Original      (4)  M
		
		dbSelectArea("SD1")
		dbSetOrder(4)
		If dbSeek(xFilial("SD2")+SD2->D2_IDENTB6)
			_cItemOri := STRZERO(val(SD1->D1_ITEM),3)                // Numero do Item Nota Fiscal Original (3)  M
			_cDtOri   := GravaData(SD1->D1_EMISSAO,.f.,4)            // Data Original                       (6)  M
		Endif
		
		_cCorrida := sPace(16)
		_cChassi  := Space(17)
		_cAutor   := Space(10)
		_cCpo     := "AE8" + _cNfOri + _cSerOri + _cDtOri + _cItemOri + _cCorrida + _cChassi + _cAutor + space(63)
		_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		
		_nContLiR++
		
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE8). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

_cZeros    := Repl('0',28)
_cLocEnt   := ""

If _lAGCO
	If SF2->F2_LOJA == "01"
		_cLocEnt := "CAN"
	ElseIf SF2->F2_LOJA == "02"
		_cLocEnt := "SRO"
	ElseIf SF2->F2_LOJA == "03"
		_cLocEnt := "SUM"
	Endif
ElseIf _lVALTRA
	_cLocEnt := _cDest
//	_cLocEnt := "MOG"
ElseIf _lCNH
	_cLocEnt := _cCGCCli
Endif

//_cLocEnt := _cLocEnt +Space(11)
_cLocEnt := Substr((_cLocEnt +Space(11)),1,14)

_cCpo    := "AE3"+ _cZeros + _cLocEnt + Space(83)
_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

_nContLiV++

If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE3). Continua?","Atencao!")
		fClose(_nHdlV)
		Return
	Endif
Endif

Return


Static Function AtuSX1()

cPerg := "PA0140"
aRegs := {}

/////////////////////////////////////
////   MV_PAR01  : Nota Fiscal ?  ///
////   MV_PAR02  : Serie       ?  ///
////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01/defspa1/defeng1/Cnt01/Var02/Def02/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Nota Fiscal           ?",""       ,""      ,"mv_ch1","C" ,09     ,0      ,0     ,"G",""        ,"MV_PAR01",""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Serie                 ?",""       ,""      ,"mv_ch2","C" ,03     ,0      ,0     ,"G",""        ,"MV_PAR02",""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return