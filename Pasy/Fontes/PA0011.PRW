#include "rwmake.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA235  � Autor � Marcelo B. Abe        � Data � 10.02.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fechar os PCs e AEs com residuos                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Edson   M.   �21/08/98�xxxxxx�Inclusao do PE MT235G1.                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Pa0011()


SetPrvt("NOPCA,ACRA,NATUAL,LMT235G1,CSALVABARRA,CCADASTRO")
SetPrvt("NRES")

nOpca   := 0
nQtdLib := 0
nQtdPed := 0
aCRA:={ "Confirma","Redigita","Abandona" }
nRes:=0
nAtual:=0
//lMT235G1 := FILE(NameInt("MT235G1"))

pergunte("MTA235",.F.)

_nOpc := 0
@ 250,330 TO 477,793 DIALOG oDlg TITLE "Elim de residuos dos Pedidos de Compras"
@ 8,10 TO 84,222             
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("MTA235")
//@ 91,168 BMPBUTTON TYPE 1 ACTION ca235OK()
//@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 91,168 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 91,196 BMPBUTTON TYPE 2 ACTION oDlg:END()

@ 23,14 SAY OemToAnsi("Este programa tem como objetivo fechar os Pedidos de Compra e/ou ")   	SIZE 200,7
@ 33,14 SAY OemToAnsi("Autorizacoes de Entrega, que possuam residuos e baixa-los baseado na")	SIZE 200,7
@ 43,14 SAY OemToAnsi("porcentagem digitada nos Parametros.")	                                SIZE 200,7
@ 53,14 SAY "Programa PA0011.PRW "	                                                            SIZE 200,7
                                   
ACTIVATE DIALOG oDlg Centered  //Valid Close(odlg)
                                        
If _nOpc == 1
	ca235OK()
Endif

Return


Static Function ca235Ok()

If (MsgYesNo(OemToAnsi("Confirma Elim. Res�duos ?"),OemToAnsi("Aten��o")))		
   nOpca := 1
Else
   nOpca := 0
Endif

//Close(oDlg)

If nOpca == 1
   
   If mv_par08 == 1
   	  Processa({|lEnd| FA235PC()})  
   Elseif mv_par08 == 2	
	  Processa({|lEnd| FA235AE()})  
   Else
  	  Processa({|lEnd| FA235PC()})  			
	  Processa({|lEnd| FA235AE()})  			
   EndIf
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA235PC		� Autor � Marcelo B. Abe     � Data � 10.02.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fechar os Pedidos de Compras com residuos.                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function FA235PC()

LOCAL nQtdLib, nQtdPed, lSomar
LOCAL nRes

dbSelectArea("SX2")
dbSeek("SC7") 
	
dbSelectArea("SC7")        
Set SoftSeek On
dbSeek(cFilial)
Set SoftSeek Off
	
ProcRegua(SC7->(RecCount())*5)
	
While !Eof() .And. C7_FILIAL == cFilial

	IncProc()

  	//��������������������������������������������������������������Ŀ
  	//� Filtra pelos Parametros.                                     �
  	//����������������������������������������������������������������		
	If  C7_EMISSAO < mv_par02 .Or. C7_EMISSAO > mv_par03 .Or. C7_NUM < mv_par04 .Or. C7_NUM > mv_par05;
		.Or. !Empty(C7_RESIDUO) .Or.;
		C7_PRODUTO < mv_par06 .Or. C7_PRODUTO > mv_par07 .Or. C7_FORNECE < MV_PAR09 .Or. C7_FORNECE > MV_PAR10
		dbSkip()
		Loop
	Endif
		
  	//��������������������������������������������������������������Ŀ
  	//� Calcular o Residuo maximo da Compra.                         �
  	//����������������������������������������������������������������	
	nRes := (C7_QUANT * mv_par01)/100
  	//��������������������������������������������������������������Ŀ
  	//� Verifica se o Pedido deve ser Encerrado.                     �
  	//����������������������������������������������������������������			
	If (C7_QUANT - C7_QUJE <= nRes) .And. (C7_QUANT - C7_QUJE > 0) 
	
	   dbSelectArea("SC7")
	   RecLock("SC7",.F.)
		  Replace C7_RESIDUO with "S"
	   MsUnlock() 
		
	   dbSelectArea("SB2")
	   dbSeek(cFilial+SC7->C7_PRODUTO)

       dbSelectArea("SB2")
	   RecLock("SB2",.F.)
	 	  Replace B2_SALPEDI With B2_SALPEDI - (SC7->C7_QUANT-SC7->C7_QUJE)
       MsUnlock()
		
	   dbSelectArea("SC7")
		
//	   If lMT235G1
//		  ExecBlock("MT235G1",.F.,.F.)
//	   EndIf

	Endif
	
	dbSelectArea("SC7")
	dbSkip()
	
EndDo

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA235AE		� Autor � Marcelo B. Abe     � Data � 10.02.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fechar as Autorizacoes de Entrega com residuos             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function FA235AE()

LOCAL nQtdLib, nQtdPed, lSomar
LOCAL nRes

dbSelectArea("SX2")
dbSeek("SC3") 
	
dbSelectArea("SC3")       
Set SoftSeek On
dbSeek(cFilial)
Set SoftSeek Off
	
ProcRegua(SC3->(RecCount())*5)
	
While !Eof() .And. C3_FILIAL == cFilial

	IncProc()

  	//��������������������������������������������������������������Ŀ
  	//� Filtra pelos Parametros.                                     �
  	//����������������������������������������������������������������		
	If C3_EMISSAO 	< mv_par02 .Or. C3_EMISSAO > mv_par03	.Or.;
		C3_NUM 		< mv_par04 .Or. C3_NUM 		> mv_par05	.Or.;
		!Empty(C3_RESIDUO)
		dbSkip()
		Loop
	Endif
		
  	//��������������������������������������������������������������Ŀ
  	//� Calcular o Residuo maximo da Compra.                         �
  	//����������������������������������������������������������������	
	nRes := (C3_QUANT * mv_par01)/100
  	//��������������������������������������������������������������Ŀ
  	//� Verifica se a Autorizacao deve ser Encerrada                 �
  	//����������������������������������������������������������������			
	If (C3_QUANT - C3_QUJE <= nRes) .And. (C3_QUANT - C3_QUJE > 0) 
	
       dDSelectArea("SC3")
	   RecLock("SC3",.F.)
		  Replace C3_RESIDUO with "S"
	   MsUnlock()
	   
	   dbSelectArea("SB2")
	   dbSeek(cFilial+SC3->C3_PRODUTO)
	   
	   dbSelectArea("SB2")
	   RecLock("SB2",.F.)
		  Replace B2_SALPEDI With B2_SALPEDI - (SC3->C3_QUANT-SC3->C3_QUJE)
       MsUnlock()

	   dbSelectArea("SC3")		
	Endif
	
	dbSkip()
	
EndDo

Return


